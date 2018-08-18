//
//  TYZDiskCache.m
//  YYStudyDemo
//
//  Created by 唐斌 on 16/3/2.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZDiskCache.h"
#import "TYZKVStorage.h"
#import "NSString+TYZAdd.h"
#import "UIDevice+TYZAdd.h"
#import <objc/runtime.h>
#import <time.h>


#define Lock() dispatch_semaphore_wait(self->_lock, DISPATCH_TIME_FOREVER)
#define Unlock() dispatch_semaphore_signal(self->_lock)

/// 扩展数据的键
static const int extended_data_key;

/**
 *  Free disk space in bytes.
 *
 *  @return
 */
static int64_t _TYZDiskSpaceFree()
{
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error)
    {
        return -1;
    }
    int64_t space = [[attrs objectForKey:NSFileSystemFreeSize] longLongValue];
    if (space < 0)
    {
        return -1;
    }
    return space;
}

/**
 *  weak reference for all instances
 */
static NSMapTable *_globalInstances;

/*
 dispatch_semaphore 是信号量，但当信号总量设为 1 时也可以当作锁来。在没有等待情况出现时，它的性能比 pthread_mutex 还要高，但一旦有等待情况出现时，性能就会下降许多。相对于 OSSpinLock 来说，它的优势在于等待时不会消耗 CPU 资源。对磁盘缓存来说，它比较合适。
 */
/// 全局对象锁
static dispatch_semaphore_t _globalInstancesLock;

/// 磁盘缓存全局初始化
static void _TYZDiskCacheInitGlobal()
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _globalInstancesLock = dispatch_semaphore_create(1);
        _globalInstances = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsWeakMemory capacity:0];
    });
}

/**
 *  从全局根据路径得到磁盘缓存的对象
 *
 */
static TYZDiskCache *_TYZDiskCacheGetGlobal(NSString *path)
{
    if (path.length == 0)
    {
        return nil;
    }
    _TYZDiskCacheInitGlobal();
    dispatch_semaphore_wait(_globalInstancesLock, DISPATCH_TIME_FOREVER);
    id cache = [_globalInstances objectForKey:path];
    dispatch_semaphore_signal(_globalInstancesLock);
    return cache;
}

/*
 *  把磁盘缓存对象放入 _globalInstances中
 *
 */
static void _TYZDiskCacheSetGlobal(TYZDiskCache *cache)
{
    if (cache.path.length == 0)
    {
        return;
    }
    _TYZDiskCacheInitGlobal();
    dispatch_semaphore_wait(_globalInstancesLock, DISPATCH_TIME_FOREVER);
    [_globalInstances setObject:cache forKey:cache.path];
    dispatch_semaphore_signal(_globalInstancesLock);
}

@implementation TYZDiskCache
{
    /// 键值存储
    TYZKVStorage *_kv;
    
    /// 定义一个信号量
    dispatch_semaphore_t _lock;
    
    /// queue
    dispatch_queue_t _queue;
}

/**
 *  递归地修剪
 */
- (void)_trimRecursively
{
    __weak typeof(self) _self = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_autoTrimInterval * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        __strong typeof(_self) self = _self;
        if (!self)
        {
            return;
        }
        [self _trimInBackground];
        [self _trimRecursively];
    });
}

- (void)_trimInBackground
{
    __weak typeof(self) _self = self;
    dispatch_async(_queue, ^{
        __strong typeof(_self) self = _self;
        if (!self)
        {
            return;
        }
        Lock();
//        dispatch_semaphore_wait(self->_lock, DISPATCH_TIME_FOREVER);
        [self _trimToCost:self.costLimit];
        [self _trimToCount:self.countLimit];
        [self _trimToAge:self.ageLimit];
        [self _trimToFreeDiskSpace:self.freeDiskSpaceLimit];
        Unlock();
//        dispatch_semaphore_signal(self->_lock);
    });
}

- (void)_trimToCost:(NSUInteger)costLimit
{
    if (costLimit >= INT_MAX)
    {
        return;
    }
    [_kv removeItemsToFitSize:(int)costLimit];
}

- (void)_trimToCount:(NSUInteger)countLimit
{
    if (countLimit >= INT_MAX)
    {
        return;
    }
    [_kv removeItemsToFitCount:(int)countLimit];
}

- (void)_trimToAge:(NSTimeInterval)ageLimit
{
    if (ageLimit <= 0)
    {
        [_kv removeAllItems];
        return;
    }
    long timestamp = time(NULL);
    if (timestamp <= ageLimit)
    {
        return;
    }
    long age = timestamp - ageLimit;
    if (age >= INT_MAX)
    {
        return;
    }
    [_kv removeItemsEarlierThanTime:(int)age];
}

- (void)_trimToFreeDiskSpace:(NSUInteger)targetFreeDiskSpace
{
    if (targetFreeDiskSpace == 0)
    {
        return;
    }
    int64_t totalBytes = [_kv getItemsSize];
    if (totalBytes <= 0)
    {
        return;
    }
    int64_t diskFreeBytes = _TYZDiskSpaceFree();
    if (diskFreeBytes <= 0)
    {
        return;
    }
    int64_t needTrimBytes = targetFreeDiskSpace - diskFreeBytes;
    if (needTrimBytes <= 0)
    {
        return;
    }
    int64_t costLimit = totalBytes - needTrimBytes;
    if (costLimit < 0)
    {
        costLimit = 0;
    }
    [self _trimToCost:(int)costLimit];
}

- (NSString *)_filenameForKey:(NSString *)key
{
    NSString *filename = nil;
    if (_customFilenameBlock)
    {
        filename = _customFilenameBlock(key);
    }
    if (!filename)
    {
        filename = key.md5String;
    }
    return filename;
}

- (void)_appWillBeTerminated
{
    Lock();
    _kv = nil;
    Unlock();
}

#pragma mark - public

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"TYZDiskCache init error" reason:@"TYZDiskCache must be initialized with a path. Use 'initWithPath:' or 'initWithPath:inlineThreshold:' instead." userInfo:nil];
    return [self initWithPath:nil inlineThreshold:0];
}

- (instancetype)initWithPath:(NSString *)path
{
    return [self initWithPath:path inlineThreshold:1024 * 20]; // 20KB
}

- (instancetype)initWithPath:(NSString *)path inlineThreshold:(NSUInteger)threshold
{
    self = [super init];
    if (!self)
    {
        return nil;
    }
    
    TYZDiskCache *globalCache = _TYZDiskCacheGetGlobal(path);
    if (globalCache)
    {
        return globalCache;
    }
    
    TYZKVStorageType type;
    if (threshold == 0)
    {
        type = TYZKVStorageTypeFile;
    }
    else if (threshold == NSUIntegerMax)
    {
        type = TYZKVStorageTypeSQLite;
    }
    else
    {
        type = TYZKVStorageTypeMixed;
    }
    TYZKVStorage *kv = [[TYZKVStorage alloc] initWithPath:path type:type];
    if (!kv)
    {
        return nil;
    }
    
    _kv = kv;
    _path = path;
    _lock = dispatch_semaphore_create(1);
    _queue = dispatch_queue_create("com.tangbin.cache.disk", DISPATCH_QUEUE_CONCURRENT);
    _inlineThreshold = threshold;
    _countLimit = NSUIntegerMax;
    _costLimit = NSUIntegerMax;
    _ageLimit = DBL_MAX;
    _freeDiskSpaceLimit = 0;
    _autoTrimInterval = 60;
    
    [self _trimRecursively];
    _TYZDiskCacheSetGlobal(self);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_appWillBeTerminated) name:UIApplicationWillTerminateNotification object:nil];
    
    return self;
}

- (BOOL)containsObjectForKey:(NSString *)key
{
    if (!key)
    {
        return NO;
    }
    Lock();
    BOOL contains = [_kv itemExistsForKey:key];
    Unlock();
    return contains;
}

- (void)containsObjectForKey:(NSString *)key withBlock:(void (^)(NSString *key, BOOL contains))block
{
    if (!block)
    {
        return;
    }
    __weak typeof(self) _self = self;
    dispatch_async(_queue, ^{
        __strong typeof(_self) self = _self;
        BOOL contains = [self containsObjectForKey:key];
        block(key, contains);
    });
}

- (id<NSCoding>)objectForKey:(NSString *)key
{
    if (!key)
    {
        return nil;
    }
    Lock();
    TYZKVStorageItem *item = [_kv getItemForKey:key];
    Unlock();
    if (!item.value)
    {
        return nil;
    }
    id object = nil;
    if (_customUnarchiveBlock)
    {
        object = _customUnarchiveBlock(item.value);
    }
    else
    {
        @try {
            object = [NSKeyedUnarchiver unarchiveObjectWithData:item.value];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    if (object && item.extendedData)
    {
        [TYZDiskCache setExtendedData:item.extendedData toObject:object];
    }
    return object;
}

- (void)objectForKey:(NSString *)key withBlock:(void (^)(NSString *key, id<NSCoding> object))block
{
    if (!block)
    {
        return;
    }
    __weak typeof(self) _self = self;
    dispatch_async(_queue, ^{
        __strong typeof(_self) self = _self;
        id<NSCoding> object = [self objectForKey:key];
        block(key, object);
    });
}

- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key
{
    if (!key) return;
    if (!object)
    {
        [self removeObjectForKey:key];
        return;
    }
    
    NSData *extendedData = [TYZDiskCache getExtendedDataFromObject:object];
    NSData *value = nil;
    if (_customArchiveBlock)
    {
        value = _customArchiveBlock(object);
    }
    else
    {
        @try {
            value = [NSKeyedArchiver archivedDataWithRootObject:object];
        }
        @catch (NSException *exception) {
            // nothing to do...
        }
    }
    if (!value) return;
    NSString *filename = nil;
    if (_kv.type != TYZKVStorageTypeSQLite)
    {
        if (value.length > _inlineThreshold)
        {
            filename = [self _filenameForKey:key];
        }
    }
    
    Lock();
    [_kv saveItemWithKey:key value:value filename:filename extendedData:extendedData];
    Unlock();
}

- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key withBlock:(void(^)(void))block
{
    __weak typeof(self) _self = self;
    dispatch_async(_queue, ^{
        __strong typeof(_self) self = _self;
        [self setObject:object forKey:key];
        if (block) block();
    });
}

- (void)removeObjectForKey:(NSString *)key
{
    if (!key) return;
    Lock();
    [_kv removeItemForKey:key];
    Unlock();
}

- (void)removeObjectForKey:(NSString *)key withBlock:(void(^)(NSString *key))block
{
    __weak typeof(self) _self = self;
    dispatch_async(_queue, ^{
        __strong typeof(_self) self = _self;
        [self removeObjectForKey:key];
        if (block) block(key);
    });
}

- (void)removeAllObjects
{
    Lock();
    [_kv removeAllItems];
    Unlock();
}

- (void)removeAllObjectsWithBlock:(void(^)(void))block
{
    __weak typeof(self) _self = self;
    dispatch_async(_queue, ^{
        __strong typeof(_self) self = _self;
        [self removeAllObjects];
        if (block) block();
    });
}

- (void)removeAllObjectsWithProgressBlock:(void(^)(int removedCount, int totalCount))progress
                                 endBlock:(void(^)(BOOL error))end
{
    __weak typeof(self) _self = self;
    dispatch_async(_queue, ^{
        __strong typeof(_self) self = _self;
        if (!self)
        {
            if (end)
            {
                end(YES);
            }
            return;
        }
        Lock();
        [_kv removeAllItemsWithProgressBlock:progress endBlock:end];
        Unlock();
    });
}

- (NSInteger)totalCount
{
    Lock();
    int count = [_kv getItemsCount];
    Unlock();
    return count;
}

- (void)totalCountWithBlock:(void(^)(NSInteger totalCount))block
{
    if (!block) return;
    __weak typeof(self) _self = self;
    dispatch_async(_queue, ^{
        __strong typeof(_self) self = _self;
        NSInteger totalCount = [self totalCount];
        block(totalCount);
    });
}

- (NSInteger)totalCost
{
    Lock();
    int count = [_kv getItemsSize];
    Unlock();
    return count;
}

- (void)totalCostWithBlock:(void(^)(NSInteger totalCost))block
{
    if (!block) return;
    __weak typeof(self) _self = self;
    dispatch_async(_queue, ^{
        __strong typeof(_self) self = _self;
        NSInteger totalCost = [self totalCost];
        block(totalCost);
    });
}

- (void)trimToCount:(NSUInteger)count
{
    Lock();
    [self _trimToCount:count];
    Unlock();
}

- (void)trimToCount:(NSUInteger)count withBlock:(void(^)(void))block
{
    __weak typeof(self) _self = self;
    dispatch_async(_queue, ^{
        __strong typeof(_self) self = _self;
        [self trimToCount:count];
        if (block) block();
    });
}

- (void)trimToCost:(NSUInteger)cost
{
    Lock();
    [self _trimToCost:cost];
    Unlock();
}

- (void)trimToCost:(NSUInteger)cost withBlock:(void(^)(void))block
{
    __weak typeof(self) _self = self;
    dispatch_async(_queue, ^{
        __strong typeof(_self) self = _self;
        [self trimToCost:cost];
        if (block) block();
    });
}

- (void)trimToAge:(NSTimeInterval)age
{
    Lock();
    [self _trimToAge:age];
    Unlock();
}

- (void)trimToAge:(NSTimeInterval)age withBlock:(void(^)(void))block
{
    __weak typeof(self) _self = self;
    dispatch_async(_queue, ^{
        __strong typeof(_self) self = _self;
        [self trimToAge:age];
        if (block) block();
    });
}

+ (NSData *)getExtendedDataFromObject:(id)object
{
    if (!object) return nil;
    return (NSData *)objc_getAssociatedObject(object, &extended_data_key);
}

+ (void)setExtendedData:(NSData *)extendedData toObject:(id)object
{
    if (!object) return;
    objc_setAssociatedObject(object, &extended_data_key, extendedData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)description
{
    if (_name) return [NSString stringWithFormat:@"<%@: %p> (%@:%@)", self.class, self, _name, _path];
    else return [NSString stringWithFormat:@"<%@: %p> (%@)", self.class, self, _path];
}


@end



























