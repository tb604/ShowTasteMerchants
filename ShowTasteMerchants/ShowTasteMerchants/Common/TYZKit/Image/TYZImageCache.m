//
//  TYZImageCache.m
//  51tourGuide
//
//  Created by 唐斌 on 16/4/25.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZImageCache.h"
#import "TYZMemoryCache.h"
#import "TYZDiskCache.h"
#import "UIImage+TYZAdd.h"
#import "NSObject+TYZAdd.h"
#import "TYZImage.h"
#import "TYZDispatchQueuePool.h"

static inline dispatch_queue_t TYZImageCacheIOQueue()
{
#ifdef TYZDispatchQueuePool_h
    return TYZDispatchQueueGetForQOS(NSQualityOfServiceDefault);
#else
    return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
#endif
}

static inline dispatch_queue_t TYZImageCacheDecodeQueue()
{
#ifdef TYZDispatchQueuePool_h
    return TYZDispatchQueueGetForQOS(NSQualityOfServiceUtility);
#else
    return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
#endif
}

@interface TYZImageCache ()

- (NSUInteger)imageCost:(UIImage *)image;
- (UIImage *)imageFromData:(NSData *)data;

@end

@implementation TYZImageCache

- (NSUInteger)imageCost:(UIImage *)image
{
    CGImageRef cgImage = image.CGImage;
    if (!cgImage)
    {
        return 1;
    }
    // 获取高度像素
    CGFloat height = CGImageGetHeight(cgImage);
    // 每一行占用的字节数，注意这里的单位是字节
    size_t bytesPerRow = CGImageGetBytesPerRow(cgImage);
    NSUInteger cost = bytesPerRow * height;
    if (cost == 0)
    {
        cost = 1;
    }
    return cost;
}

- (UIImage *)imageFromData:(NSData *)data
{
    NSData *scaleData = [TYZDiskCache getExtendedDataFromObject:data];
    CGFloat scale = 0;
    if (scaleData)
    {
        scale = ((NSNumber *)[NSKeyedUnarchiver unarchiveObjectWithData:scaleData]).doubleValue;
    }
    if (scale <= 0)
    {
        scale = [UIScreen mainScreen].scale;
    }
    UIImage *image = nil;
    if (_allowAnimatedImage)
    {
        image = [[TYZImage alloc] initWithData:data scale:scale];
        if (_decodeForDisplay)
        {
            image = [image imageByDecoded];
        }
    }
    else
    {
        TYZImageDecoder *decoder = [TYZImageDecoder decoderWithData:data scale:scale];
        image = [decoder frameAtIndex:0 decodeForDisplay:_decodeForDisplay].image;
    }
    return image;
}

#pragma mark public 


+ (instancetype)sharedCache
{
    static TYZImageCache *cache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        cachePath = [cachePath stringByAppendingPathComponent:@"com.tyzmym.tyzkit"];
        cachePath = [cachePath stringByAppendingPathComponent:@"images"];
        cache = [[self alloc] initWithPath:cachePath];
    });
    return cache;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"TYZImageCache init error" reason:@"TYZImageCache must be initialized with a path. Use 'initWithPath:' instead." userInfo:nil];
    return [self initWithPath:@""];
}

- (instancetype)initWithPath:(NSString *)path
{
    TYZMemoryCache *memoryCache = [TYZMemoryCache new];
    memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
    memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = YES;
    memoryCache.countLimit = NSUIntegerMax;
    memoryCache.costLimit = NSUIntegerMax;
    memoryCache.ageLimit = 12 * 60 * 60; // 一天
    
    TYZDiskCache *diskCache = [[TYZDiskCache alloc] initWithPath:path];
    diskCache.customArchiveBlock = ^(id object) {return (NSData *)object;};
    diskCache.customUnarchiveBlock = ^(NSData *data) {return (id)data;};
    if (!memoryCache || !diskCache)
    {
        return nil;
    }
    
    self = [super init];
    
    _memoryCache = memoryCache;
    _diskCache = diskCache;
    _allowAnimatedImage = YES;
    _decodeForDisplay = YES;
    
    return self;
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key
{
    [self setImage:image imageData:nil forKey:key withType:TYZImageCacheTypeAll];
}

- (void)setImage:(UIImage *)image imageData:(NSData *)imageData forKey:(NSString *)key withType:(TYZImageCacheType)type
{
    if (!key || (!image && imageData.length == 0))
    {
        return;
    }
    
    __weak typeof(self) _self = self;
    if (type & TYZImageCacheTypeMemory)
    {// add to memory cache
        if (image)
        {
            if (image.isDecodedForDisplay)
            {
                [_memoryCache setObject:image forKey:key withCost:[_self imageCost:image]];
            }
            else
            {
                dispatch_async(TYZImageCacheDecodeQueue(), ^{
                    __strong typeof(_self) self = _self;
                    if (!self)
                    {
                        return;
                    }
                    [self.memoryCache setObject:[image imageByDecoded] forKey:key withCost:[self imageCost:image]];
                });
            }
        }
        else if (imageData)
        {
            dispatch_async(TYZImageCacheDecodeQueue(), ^{
                __strong typeof(_self) self = _self;
                if (!self)
                {
                    return;
                }
                UIImage *newImage = [self imageFromData:imageData];
                [self.memoryCache setObject:newImage forKey:key withCost:[self imageCost:newImage]];
            });
        }
    }
    
    if (type & TYZImageCacheTypeDisk)
    {// add to disk cache
        if (imageData)
        {
            if (image)
            {
                [TYZDiskCache setExtendedData:[NSKeyedArchiver archivedDataWithRootObject:@(image.scale)] toObject:imageData];
            }
            [_diskCache setObject:imageData forKey:key];
        }
        else if (image)
        {
            dispatch_async(TYZImageCacheIOQueue(), ^{
                __strong typeof(_self) self = _self;
                if (!self) return;
                NSData *data = [image imageDataRepresentation];
                [TYZDiskCache setExtendedData:[NSKeyedArchiver archivedDataWithRootObject:@(image.scale)] toObject:data];
                [self.diskCache setObject:data forKey:key];
            });
        }
    }
}

- (void)removeImageForKey:(NSString *)key
{
    [self removeImageForKey:key withType:TYZImageCacheTypeAll];
}

- (void)removeImageForKey:(NSString *)key withType:(TYZImageCacheType)type
{
    if (type & TYZImageCacheTypeMemory)
    {
        [_memoryCache removeObjectForKey:key];
    }
    if (type & TYZImageCacheTypeDisk)
    {
        [_diskCache removeObjectForKey:key];
    }
}

- (BOOL)containsImageForKey:(NSString *)key
{
    return [self containsImageForKey:key withType:TYZImageCacheTypeAll];
}

- (BOOL)containsImageForKey:(NSString *)key withType:(TYZImageCacheType)type
{
    if (type & TYZImageCacheTypeMemory)
    {
        if ([_memoryCache containsObjectForKey:key])
        {
            return YES;
        }
    }
    
    if (type & TYZImageCacheTypeDisk)
    {
        if ([_diskCache containsObjectForKey:key])
        {
            return YES;
        }
    }
    return NO;
}

- (UIImage *)getImageForKey:(NSString *)key
{
    return [self getImageForKey:key withType:TYZImageCacheTypeAll];
}

- (UIImage *)getImageForKey:(NSString *)key withType:(TYZImageCacheType)type
{
    if (!key)
    {
        return nil;
    }
    if (type & TYZImageCacheTypeMemory)
    {
        UIImage *image = [_memoryCache objectForKey:key];
        if (image)
        {
            return image;
        }
    }
    
    if (type & TYZImageCacheTypeDisk)
    {
        NSData *data = (id)[_diskCache objectForKey:key];
        UIImage *image = [self imageFromData:data];
        if (image && (type & TYZImageCacheTypeMemory))
        {
            [_memoryCache setObject:image forKey:key withCost:[self imageCost:image]];
        }
        return image;
    }
    
    return nil;
}

- (void)getImageForKey:(NSString *)key withType:(TYZImageCacheType)type withBlock:(void (^)(UIImage * _Nullable, TYZImageCacheType))block
{
    if (!block)
    {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = nil;
        if (type & TYZImageCacheTypeMemory)
        {
            image = [_memoryCache objectForKey:key];
            if (image)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(image, TYZImageCacheTypeMemory);
                });
                return;
            }
        }
        
        if (type & TYZImageCacheTypeDisk)
        {
            NSData *data = (id)[_diskCache objectForKey:key];
            image = [self imageFromData:data];
            if (image)
            {
                [_memoryCache setObject:image forKey:key];
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(image, TYZImageCacheTypeDisk);
                });
                return;
            }
        }
        
    });
}

- (NSData *)getImageDataForKey:(NSString *)key
{
    return (id)[_diskCache objectForKey:key];
}

- (void)getImageDataForKey:(NSString *)key withBlock:(void (^)(NSData * _Nullable))block
{
    if (!block)
    {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = (id)[_diskCache objectForKey:key];
        dispatch_async(dispatch_get_main_queue(), ^{
            block(data);
        });
    });
}

@end

























