//
//  TYZDiskCache.h
//  YYStudyDemo
//
//  Created by 唐斌 on 16/3/2.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 TYZDiskCache is a thread-safe cache that stores key-value pairs backed by SQLite
 and file system (similar to NSURLCache's disk cache).(TYZDiskCache是线程安全的缓存键值存储由SQLite和文件系统(类似于NSURLCache磁盘高速缓存)。)
 
 TYZDiskCache has these features:(有以下功能)
 
 * It use LRU (least-recently-used) to remove objects.(它使用LRU(最近最少使用)删除对象。)
 * It can be controlled by cost, count, and age.(它可以控制成本,统计,和年龄。)
 * It can be configured to automatically evict objects when there's no free disk space.(它可以配置为自动驱逐对象没有空闲磁盘空间。)
 * It can automatically decide the storage type (sqlite/file) for each object to get
 better performance.(它可以自动决定存储类型(sqlite /文件)为每一个对象来获得更好的性能。)
 
 You may compile the latest version of sqlite and ignore the libsqlite3.dylib in
 iOS system to get 2x~4x speed up.(你可以编译sqlite的最新版本和忽视libsqlite3.dylib在iOS系统得到2 ~ 4 x加速。)
 */
@interface TYZDiskCache : NSObject

#pragma mark - Attribute

/**
 *  The name of the cache. Default is nil.
 */
@property (atomic, copy) NSString *name;

/**
 *  The path of the cache (read-only).
 */
@property (atomic, assign, readonly) NSString *path;

/**
 If the object's data size (in bytes) is larger than this value, then object will
 be stored as a file, otherwise the object will be stored in sqlite.
 
 0 means all objects will be stored as separated files, NSUIntegerMax means all
 objects will be stored in sqlite.
 
 The default value is 20480 (20KB).
 
 (
 如果对象的数据大小(以字节为单位)大于这个值,然后将对象
 　　是存储为文件,否则对象将存储在sqlite。
 　　
 　　0意味着所有对象将被存储为文件分离,NSUIntegerMax意味着所有
 　　对象将被存储在sqlite。
 　　
 　　默认值为20480(20 kb)。
 )
 */
@property (atomic, assign, readonly) NSUInteger inlineThreshold;// 内联阀值

/**
 If this block is not nil, then the block will be used to archive object instead
 of NSKeyedArchiver. You can use this block to support the objects which do not
 conform to the `NSCoding` protocol.
 
 The default value is nil.
 (
 　　如果这个块不是零,那么块将被用于归档对象
 　　NSKeyedArchiver。您可以使用此块不支持对象
 　　符合“NSCoding”协议。
 　　
 　　默认值是零。)
 */
@property (atomic, copy) NSData *(^customArchiveBlock)(id object);

/**
 If this block is not nil, then the block will be used to unarchive object instead
 of NSKeyedUnarchiver. You can use this block to support the objects which do not
 conform to the `NSCoding` protocol.
 
 The default value is nil.
 (
 如果这个块不是零,那么将使用块unarchive对象
 　　NSKeyedUnarchiver。您可以使用此块不支持对象
 　　符合“NSCoding”协议。
 　　
 　　默认值是零。
 )
 */
@property (atomic, copy) id (^customUnarchiveBlock)(NSData *data);

/**
 When an object needs to be saved as a file, this block will be invoked to generate
 a file name for a specified key. If the block is nil, the cache use md5(key) as
 default file name.
 
 The default value is nil.
 (当一个对象需要被保存为一个文件,这将调用块生成
 　　指定的文件名关键。如果块nil,缓存使用md5(关键)
 　　默认的文件名。
 　　
 　　默认值是零)
 */
@property (atomic, copy) NSString *(^customFilenameBlock)(NSString *key);


#pragma mark - Limit

/**
 The maximum number of objects the cache should hold.(对象缓存应持有的最大数量。)
 
 @discussion The default value is NSUIntegerMax, which means no limit.
 This is not a strict limit — if the cache goes over the limit, some objects in the
 cache could be evicted later in background queue.
 */
@property (assign) NSUInteger countLimit;

/**
 The maximum total cost that the cache can hold before it starts evicting objects.(缓存可以容纳的最大总成本之前,开始驱逐对象。)
 
 @discussion The default value is NSUIntegerMax, which means no limit.
 This is not a strict limit — if the cache goes over the limit, some objects in the
 cache could be evicted later in background queue.(默认值是NSUIntegerMax,这意味着没有限制。这不是一个严格的限制——如果缓存超过限制,一些缓存中对象可能被驱逐后在后台队列。)
 */
@property (assign) NSUInteger costLimit;

/**
 The maximum expiry time of objects in cache.(在缓存中，最大的过期时间)
 
 @discussion The default value is DBL_MAX, which means no limit.
 This is not a strict limit — if an object goes over the limit, the objects could
 be evicted later in background queue.(默认值是DBL_MAX,这意味着没有限制。这并不是一个严格的限制——如果一个对象超过极限,对象可能被驱逐后在后台队列。)
 */
@property (assign) NSTimeInterval ageLimit;

/**
 The minimum free disk space (in bytes) which the cache should kept.(最小空闲磁盘空间(字节)的缓存应该保持。)
 
 @discussion The default value is 0, which means no limit.
 If the free disk space is lower than this value, the cache will remove objects
 to free some disk space. This is not a strict limit—if the free disk space goes
 over the limit, the objects could be evicted later in background queue.(默认值为0,这意味着没有限制。如果空闲磁盘空间低于这个值,缓存会删除对象释放一些磁盘空间。这不是一个严格的限制一旦空闲磁盘空间超过极限,对象可能被驱逐后在后台队列。)
 */
@property (assign) NSUInteger freeDiskSpaceLimit;

/**
 The auto trim check time interval in seconds. Default is 60 (1 minute).
 
 @discussion The cache holds an internal timer to check whether the cache reaches
 its limits, and if the limit is reached, it begins to evict objects.(缓存包含一个内部定时器来检查缓存是否达到极限,如果达到极限,开始驱逐对象。)
 */
@property (assign) NSTimeInterval autoTrimInterval;

/// Set 'YES' to enable error logs for debug.
@property BOOL errorLogsEnabled;


#pragma mark - Initializer
- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

/**
 Create a new cache based on the specified path.
 
 @param path Full path of a directory in which the cache will write data.
 Once initialized you should not read and write to this directory.
 
 @return A new cache object, or nil if an error occurs.
 
 @warning If the cache instance for the specified path already exists in memory,
 this method will return it directly, instead of creating a new instance.
 */
- (nullable instancetype)initWithPath:(NSString *)path;

/**
 The designated initializer.
 
 @param path       Full path of a directory in which the cache will write data.
 Once initialized you should not read and write to this directory.
 
 @param threshold(阀值)  The data store inline threshold in bytes. If the object's data
 size (in bytes) is larger than this value, then object will be stored as a
 file, otherwise the object will be stored in sqlite. 0 means all objects will
 be stored as separated files, NSUIntegerMax means all objects will be stored
 in sqlite. If you don't know your object's size, 20480 is a good choice.
 After first initialized you should not change this value of the specified path.
 
 @return A new cache object, or nil if an error occurs.
 
 @warning If the cache instance for the specified path already exists in memory,
 this method will return it directly, instead of creating a new instance.
 */
- (nullable instancetype)initWithPath:(NSString *)path
             inlineThreshold:(NSUInteger)threshold NS_DESIGNATED_INITIALIZER;


#pragma mark - Access Methods(访问方法)

/**
 Returns a boolean value that indicates whether a given key is in cache.
 This method may blocks the calling thread until file read finished.
 
 @param key A string identifying the value. If nil, just return NO.
 @return Whether the key is in cache.
 */
- (BOOL)containsObjectForKey:(NSString *)key;

/**
 Returns a boolean value with the block that indicates whether a given key is in cache.
 This method returns immediately and invoke the passed block in background queue
 when the operation finished.
 
 @param key   A string identifying the value. If nil, just return NO.
 @param block A block which will be invoked in background queue when finished.
 */
- (void)containsObjectForKey:(NSString *)key withBlock:(void(^)(NSString *key, BOOL contains))block;

/**
 Returns the value associated with a given key.
 This method may blocks the calling thread until file read finished.
 
 @param key A string identifying the value. If nil, just return nil.
 @return The value associated with key, or nil if no value is associated with key.
 */
- (nullable id<NSCoding>)objectForKey:(NSString *)key;

/**
 Returns the value associated with a given key.
 This method returns immediately and invoke the passed block in background queue
 when the operation finished.
 
 @param key A string identifying the value. If nil, just return nil.
 @param block A block which will be invoked in background queue when finished.
 */
- (void)objectForKey:(NSString *)key withBlock:(void(^)(NSString *key, id<NSCoding> _Nullable object))block;

/**
 Sets the value of the specified key in the cache.
 This method may blocks the calling thread until file write finished.
 
 @param object The object to be stored in the cache. If nil, it calls `removeObjectForKey:`.
 @param key    The key with which to associate the value. If nil, this method has no effect.
 */
- (void)setObject:(nullable id<NSCoding>)object forKey:(NSString *)key;

/**
 Sets the value of the specified key in the cache.
 This method returns immediately and invoke the passed block in background queue
 when the operation finished.
 
 @param object The object to be stored in the cache. If nil, it calls `removeObjectForKey:`.
 @param block  A block which will be invoked in background queue when finished.
 */
- (void)setObject:(nullable id<NSCoding>)object forKey:(NSString *)key withBlock:(void(^)(void))block;

/**
 Removes the value of the specified key in the cache.
 This method may blocks the calling thread until file delete finished.
 
 @param key The key identifying the value to be removed. If nil, this method has no effect.
 */
- (void)removeObjectForKey:(NSString *)key;

/**
 Removes the value of the specified key in the cache.
 This method returns immediately and invoke the passed block in background queue
 when the operation finished.
 
 @param key The key identifying the value to be removed. If nil, this method has no effect.
 @param block  A block which will be invoked in background queue when finished.
 */
- (void)removeObjectForKey:(NSString *)key withBlock:(void(^)(NSString *key))block;

/**
 Empties the cache.
 This method may blocks the calling thread until file delete finished.
 */
- (void)removeAllObjects;

/**
 Empties the cache.
 This method returns immediately and invoke the passed block in background queue
 when the operation finished.
 
 @param block  A block which will be invoked in background queue when finished.
 */
- (void)removeAllObjectsWithBlock:(void(^)(void))block;

/**
 Empties the cache with block.
 This method returns immediately and executes the clear operation with block in background.
 
 @warning You should not send message to this instance in these blocks.
 @param progress This block will be invoked during removing, pass nil to ignore.
 @param end      This block will be invoked at the end, pass nil to ignore.
 */
- (void)removeAllObjectsWithProgressBlock:(nullable void(^)(int removedCount, int totalCount))progress
                                 endBlock:(nullable void(^)(BOOL error))end;


/**
 Returns the number of objects in this cache.
 This method may blocks the calling thread until file read finished.
 
 @return The total objects count.
 */
- (NSInteger)totalCount;

/**
 Get the number of objects in this cache.
 This method returns immediately and invoke the passed block in background queue
 when the operation finished.
 
 @param block  A block which will be invoked in background queue when finished.
 */
- (void)totalCountWithBlock:(void(^)(NSInteger totalCount))block;

/**
 Returns the total cost (in bytes) of objects in this cache.
 This method may blocks the calling thread until file read finished.
 
 @return The total objects cost in bytes.
 */
- (NSInteger)totalCost;

/**
 Get the total cost (in bytes) of objects in this cache.
 This method returns immediately and invoke the passed block in background queue
 when the operation finished.
 
 @param block  A block which will be invoked in background queue when finished.
 */
- (void)totalCostWithBlock:(void(^)(NSInteger totalCost))block;


#pragma mark - Trim
/**
 Removes objects from the cache use LRU, until the `totalCount` is below the specified value.
 This method may blocks the calling thread until operation finished.
 
 @param count  The total count allowed to remain after the cache has been trimmed.
 */
- (void)trimToCount:(NSUInteger)count;

/**
 Removes objects from the cache use LRU, until the `totalCount` is below the specified value.
 This method returns immediately and invoke the passed block in background queue
 when the operation finished.
 
 @param count  The total count allowed to remain after the cache has been trimmed.
 @param block  A block which will be invoked in background queue when finished.
 */
- (void)trimToCount:(NSUInteger)count withBlock:(void(^)(void))block;

/**
 Removes objects from the cache use LRU, until the `totalCost` is below the specified value.
 This method may blocks the calling thread until operation finished.
 
 @param cost The total cost allowed to remain after the cache has been trimmed.
 */
- (void)trimToCost:(NSUInteger)cost;

/**
 Removes objects from the cache use LRU, until the `totalCost` is below the specified value.
 This method returns immediately and invoke the passed block in background queue
 when the operation finished.
 
 @param cost The total cost allowed to remain after the cache has been trimmed.
 @param block  A block which will be invoked in background queue when finished.
 */
- (void)trimToCost:(NSUInteger)cost withBlock:(void(^)(void))block;

/**
 Removes objects from the cache use LRU, until all expiry objects removed by the specified value.
 This method may blocks the calling thread until operation finished.
 
 @param age  The maximum age of the object.
 */
- (void)trimToAge:(NSTimeInterval)age;

/**
 Removes objects from the cache use LRU, until all expiry objects removed by the specified value.
 This method returns immediately and invoke the passed block in background queue
 when the operation finished.
 
 @param age  The maximum age of the object.
 @param block  A block which will be invoked in background queue when finished.
 */
- (void)trimToAge:(NSTimeInterval)age withBlock:(void(^)(void))block;


#pragma mark - Extended Data(扩展数据)

/**
 Get extended data from an object.
 
 @discussion See 'setExtendedData:toObject:' for more information.
 
 @param object An object.
 @return The extended data.
 */
+ (NSData *)getExtendedDataFromObject:(id)object;

/**
 Set extended data to an object.
 
 @discussion You can set any extended data to an object before you save the object
 to disk cache. The extended data will also be saved with this object. You can get
 the extended data later with "getExtendedDataFromObject:".
 
 @param extendedData The extended data (pass nil to remove).
 @param object       The object.
 */
+ (void)setExtendedData:(nullable NSData *)extendedData toObject:(id)object;

@end

NS_ASSUME_NONNULL_END


























