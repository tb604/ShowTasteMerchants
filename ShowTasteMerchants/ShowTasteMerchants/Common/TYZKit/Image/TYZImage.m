//
//  TYZImage.m
//  51tourGuide
//
//  Created by 唐斌 on 16/3/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZImage.h"
#import "NSString+TYZAdd.h"
#import "NSBundle+TYZAdd.h"

@interface TYZImage ()
{
    TYZImageDecoder *_decoder; ///< 图像解码器
    
    NSArray *_preloadedFrames; ///< 预加载贴数组
    
    dispatch_semaphore_t _preloadedLock; ///< 锁
    
    NSUInteger _bytesPerFrame;
}
@end

@implementation TYZImage


#pragma mark private methods

#pragma mark public methods
+ (TYZImage *)imageNamed:(NSString *)name
{
    if ([name length] == 0)
    {
        return nil;
    }
    
    if ([name hasSuffix:@"/"])
    {
        return nil;
    }
    
    NSString *res = [name stringByDeletingPathExtension]; // 文件名
    NSString *ext = [name pathExtension]; // 扩展名
    NSString *path = nil;
    CGFloat scale = 1;
//    NSLog(@"res=%@; ext=%@; ", res, ext);
    
    // If no extension, guess by system supported (same as UIImage).  如果没有扩展,想由系统支持(用户界面图像一样)。
    NSArray *exts = ([ext length] > 0 ? @[ext] : @[@"", @"png", @"jpeg", @"jpg", @"gif", @"webp", @"apng"]);
    // @[@2,@3,@1]
    NSArray *scales = [NSBundle preferredScales];
    for (int s=0; s<[scales count]; s++)
    {
        scale = ((NSNumber *)scales[s]).floatValue;
        // wall@3x
        NSString *scaledName = [res stringByAppendingNameScale:scale];
        for (NSString *e in exts)
        {
            path = [[NSBundle mainBundle] pathForResource:scaledName ofType:e];
            if (path)
            {
                break;
            }
        }
        if (path)
        {
            break;
        }
    }
    if ([path length] == 0)
    {
        return nil;
    }
    
//    UIImage *tmpImg = [UIImage imageNamed:@"pia"];
//    NSData *empData = UIImagePNGRepresentation(tmpImg);
//    NSLog(@"empd.len=%lld", (long long)empData.length);
    
    NSData *data = [NSData dataWithContentsOfFile:path];
//    NSLog(@"path=%@", path);
//    NSLog(@"len=%lld", (long long)data.length);
    if ([data length] == 0)
    {
        return nil;
    }
    return [[self alloc] initWithData:data scale:scale];
}
+ (TYZImage *)imageWithContentsOfFile:(NSString *)path
{
    return [[self alloc] initWithContentsOfFile:path];
}
+ (TYZImage *)imageWithData:(NSData *)data
{
    return [[self alloc] initWithData:data];
}
+ (TYZImage *)imageWithData:(NSData *)data scale:(CGFloat)scale
{
    return [[self alloc] initWithData:data scale:scale];
}

- (NSData *)animatedImageData
{
    return _decoder.data;
}

- (void)setPreloadAllAnimatedImageFrames:(BOOL)preloadAllAnimatedImageFrames
{
    if (_preloadAllAnimatedImageFrames != preloadAllAnimatedImageFrames)
    {
        if (preloadAllAnimatedImageFrames && _decoder.frameCount > 0)
        {
            NSMutableArray *frames = [NSMutableArray new];
            for (NSUInteger i = 0, max = _decoder.frameCount; i < max; i++)
            {
                UIImage *img = [self animatedImageFrameAtIndex:i];
                if (img)
                {
                    [frames addObject:img];
                }
                else
                {
                    [frames addObject:[NSNull null]];
                }
            }
            dispatch_semaphore_wait(_preloadedLock, DISPATCH_TIME_FOREVER);
            _preloadedFrames = frames;
            dispatch_semaphore_signal(_preloadedLock);
        }
        else
        {
            dispatch_semaphore_wait(_preloadedLock, DISPATCH_TIME_FOREVER);
            _preloadedFrames = nil;
            dispatch_semaphore_signal(_preloadedLock);
        }
    }
}


#pragma mark override
- (instancetype)initWithContentsOfFile:(NSString *)path
{
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [self initWithData:data scale:path.pathScale];
}

- (instancetype)initWithData:(NSData *)data
{
    return [self initWithData:data scale:1];
}

- (instancetype)initWithData:(NSData *)data scale:(CGFloat)scale
{
    if ([data length] == 0)
    {
        return nil;
    }
    if (scale <= 0)
    {
        scale = [UIScreen mainScreen].scale;
    }
    _preloadedLock = dispatch_semaphore_create(1);
    @autoreleasepool {
        TYZImageDecoder *decoder = [TYZImageDecoder decoderWithData:data scale:scale];
        TYZImageFrame *frame = [decoder frameAtIndex:0 decodeForDisplay:YES];
//        if (!frame)
//        {
//            NSLog(@"frame is nil");
//        }
        UIImage *image = frame.image;
        if (!image)
        {
//            NSLog(@"image is nil");
            return nil;
        }
        self = [self initWithCGImage:image.CGImage scale:decoder.scale orientation:image.imageOrientation];
        if (!self)
        {
            return nil;
        }
        _animatedImageType = decoder.type;
        if (decoder.frameCount > 1)
        {
            _decoder = decoder;
            _bytesPerFrame = CGImageGetBytesPerRow(image.CGImage) * CGImageGetHeight(image.CGImage);
            _animatedImageMemorySize = _bytesPerFrame * decoder.frameCount;
        }
        self.isDecodedForDisplay = YES;
    }
    return self;
}


#pragma mark - protocol NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    NSNumber *scale = [aDecoder decodeObjectForKey:@"TYZImageScale"];
    NSData *data = [aDecoder decodeObjectForKey:@"TYZImageData"];
    if ([data length] != 0)
    {
        self = [self initWithData:data scale:[scale doubleValue]];
    }
    else
    {
        self = [super initWithCoder:aDecoder];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    if ([_decoder.data length] != 0)
    {
        [aCoder encodeObject:@(self.scale) forKey:@"TYZImageScale"];
        [aCoder encodeObject:_decoder.data forKey:@"TYZImageData"];
    }
    else
    {
        // apple use UIImagePNGRepresentation() to encode UIImage.
        [super encodeWithCoder:aCoder];
    }
}

#pragma mark - protocol TYZAnimatedImage

- (NSUInteger)animatedImageFrameCount
{
    return _decoder.frameCount;
}

- (NSUInteger)animatedImageLoopCount
{
    return _decoder.loopCount;
}

- (NSUInteger)animatedImageBytesPerFrame
{
    return _bytesPerFrame;
}

- (UIImage *)animatedImageFrameAtIndex:(NSUInteger)index
{
    if (index >= _decoder.frameCount) return nil;
    dispatch_semaphore_wait(_preloadedLock, DISPATCH_TIME_FOREVER);
    UIImage *image = _preloadedFrames[index];
    dispatch_semaphore_signal(_preloadedLock);
    if (image) return image == (id)[NSNull null] ? nil : image;
    return [_decoder frameAtIndex:index decodeForDisplay:YES].image;
}

- (NSTimeInterval)animatedImageDurationAtIndex:(NSUInteger)index
{
    NSTimeInterval duration = [_decoder frameDurationAtIndex:index];
    
    /*
     http://opensource.apple.com/source/WebCore/WebCore-7600.1.25/platform/graphics/cg/ImageSourceCG.cpp
     Many annoying ads specify a 0 duration to make an image flash as quickly as
     possible. We follow Safari and Firefox's behavior and use a duration of 100 ms
     for any frames that specify a duration of <= 10 ms.
     See <rdar://problem/7689300> and <http://webkit.org/b/36082> for more information.
     
     See also: http://nullsleep.tumblr.com/post/16524517190/animated-gif-minimum-frame-delay-browser.
     */
    if (duration < 0.011f) return 0.100f;
    return duration;
}
@end



























