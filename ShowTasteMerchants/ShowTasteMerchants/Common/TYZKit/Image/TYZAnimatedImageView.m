//
//  TYZAnimatedImageView.m
//  51tourGuide
//
//  Created by 唐斌 on 16/3/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZAnimatedImageView.h"
#import "TYZWeakProxy.h"
#import "UIDevice+TYZAdd.h"
#import "TYZImageCoder.h"
#import "TYZKitMacro.h"

#define BUFFER_SIZE (10 * 1024 * 1024) // 10MB (minimum memory buffer size)

#define LOCK(...) dispatch_semaphore_wait(self->_lock, DISPATCH_TIME_FOREVER); \
__VA_ARGS__; \
dispatch_semaphore_signal(self->_lock);

#define LOCK_VIEW(...) dispatch_semaphore_wait(view->_lock, DISPATCH_TIME_FOREVER); \
__VA_ARGS__; \
dispatch_semaphore_signal(view->_lock);






typedef NS_ENUM(NSUInteger, TYZAnimatedImageType)
{
    TYZAnimatedImageTypeNone = 0,
    TYZAnimatedImageTypeImage,
    TYZAnimatedImageTypeHighlightedImage,
    TYZAnimatedImageTypeImages,
    TYZAnimatedImageTypeHighlightedImages,
};


@interface TYZAnimatedImageView ()
{
    @package // 表示framework 内部使用，外部无法调用
    UIImage <TYZAnimatedImage> *_curAnimatedImage;
    
    dispatch_once_t _onceToken;
    dispatch_semaphore_t _lock; ///< lock for _buffer
    NSOperationQueue *_requestQueue; ///< image request queue, serial
    
    // 是一个能让我们以和屏幕刷新率相同的频率将内容画到屏幕上的定时器。
    CADisplayLink *_link; ///< ticker for change frame
    NSTimeInterval _time; ///< time after last frame
    
    UIImage *_curFrame; ///< current frame to display(当前贴的图片)
    NSUInteger _curIndex; ///< current frame index (from 0)当前贴的index
    NSUInteger _totalFrameCount; ///< total frame count(总贴数量)
    
    BOOL _loopEnd; ///< whether the loop is end.
    NSUInteger _curLoop; ///< current loop count (from 0)(当前循环数)
    NSUInteger _totalLoop; ///< total loop count, 0 means infinity
    
    NSMutableDictionary *_buffer; ///< frame buffer(贴缓存)
    BOOL _bufferMiss; ///< whether miss frame on last opportunity
    NSUInteger _maxBufferCount; ///< maximum buffer count
    NSInteger _incrBufferCount; ///< current allowed buffer count (will increase by step)当前允许缓存的数量，将逐步增加
    
    CGRect _curContentsRect;
    BOOL _curImageHasContentsRect; ///< image has implemented "animatedImageContentRectAtIndex:"
    
}
@property (nonatomic, assign, readwrite) BOOL currentIsPlayingAnimation;
- (void)calcMaxBufferCount;
@end

@interface _TYZAnimatedImageViewFetchOperation : NSOperation
@property (nonatomic, weak) TYZAnimatedImageView *view;
@property (nonatomic, assign) NSUInteger nextIndex;
@property (nonatomic, strong) UIImage <TYZAnimatedImage> *curImage;
@end

@implementation _TYZAnimatedImageViewFetchOperation

- (void)main
{
    __strong TYZAnimatedImageView *view = _view;
    if (!view)
    {
        return;
    }
    if ([self isCancelled])
    {
        return;
    }
    view->_incrBufferCount++;
    if (view->_incrBufferCount == 0)
    {
        [view calcMaxBufferCount];
    }
    if (view->_incrBufferCount > (NSInteger)view->_maxBufferCount)
    {
        view->_incrBufferCount = view->_maxBufferCount;
    }
    NSUInteger idx = _nextIndex;
    NSUInteger max = view->_incrBufferCount < 1 ? 1 : view->_incrBufferCount;
    NSUInteger total = view->_totalFrameCount;
    view = nil;
    
    for (int i=0; i<max; i++, idx++)
    {
        @autoreleasepool {
            if (idx >= total)
            {
                idx = 0;
            }
            if ([self isCancelled])
            {
                break;
            }
            __strong TYZAnimatedImageView *view = _view;
            if (!view)
            {
                break;
            }
            LOCK_VIEW(BOOL miss = (view->_buffer[@(idx)] == nil));
            if (miss)
            {
                UIImage *img = [_curImage animatedImageFrameAtIndex:idx];
                img = img.imageByDecoded;
                if ([self isCancelled])
                {
                    break;
                }
                LOCK_VIEW(view->_buffer[@(idx)] = img ? img : [NSNull null]);
                view = nil;
            }
        }
    }
}
@end

@implementation TYZAnimatedImageView

- (void)dealloc
{
    [_requestQueue cancelAllOperations];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [_link invalidate];
}

- (instancetype)init
{
    self = [super init];
    _runloopMode = NSRunLoopCommonModes;
    _autoPlayAnimatedImage = YES;
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    _runloopMode = NSRunLoopCommonModes;
    _autoPlayAnimatedImage = YES;
    return self;
}

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super init];
    _runloopMode = NSRunLoopCommonModes;
    _autoPlayAnimatedImage = YES;
    self.frame = (CGRect) {CGPointZero, image.size};
    self.image = image;
    return self;
}

- (instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage
{
    self = [super init];
    _runloopMode = NSRunLoopCommonModes;
    _autoPlayAnimatedImage = YES;
    CGSize size = image ? image.size : highlightedImage.size;
    self.frame = (CGRect) {CGPointZero, size};
    self.image = image;
    self.highlightedImage = highlightedImage;
    return self;
}

#pragma mark - private methods
// init the animated params.
- (void)resetAnimated
{
    dispatch_once(&_onceToken, ^{
        _lock = dispatch_semaphore_create(1);
        _buffer = [NSMutableDictionary new];
        _requestQueue = [[NSOperationQueue alloc] init];
        _requestQueue.maxConcurrentOperationCount = 1;
        _link = [CADisplayLink displayLinkWithTarget:[TYZWeakProxy proxyWithTarget:self] selector:@selector(step:)];
        if (_runloopMode)
        {
            [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:_runloopMode];
        }
        _link.paused = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    });
    [_requestQueue cancelAllOperations];
    LOCK(
        if (_buffer.count)
         {
             NSMutableDictionary *holder = _buffer;
             _buffer = [NSMutableDictionary new];
             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                 // capture the dictionary to global queue, release these images in background to avoid blocking UI thead.
                 [holder class];
             });
         }
    );
    _link.paused = YES;
    _time = 0;
    if (_curIndex != 0)
    {
        [self willChangeValueForKey:@"currentAnimatedImageIndex"];
        _curIndex = 0;
        [self didChangeValueForKey:@"currentAnimatedImageIndex"];
    }
    _curAnimatedImage = nil;
    _curFrame = nil;
    _curLoop = 0;
    _totalLoop = 0;
    _totalFrameCount = 1;
    _loopEnd = NO;
    _bufferMiss = NO;
    _incrBufferCount = 0;
}

- (void)setImage:(UIImage *)image
{
    if (self.image == image)
    {
        return;
    }
    [self setImage:image withType:TYZAnimatedImageTypeImage];
}

- (void)setHighlightedImage:(UIImage *)highlightedImage
{
    if (self.highlightedImage == highlightedImage)
    {
        return;
    }
    [self setImage:highlightedImage withType:TYZAnimatedImageTypeHighlightedImage];
}

- (void)setAnimationImages:(NSArray<UIImage *> *)animationImages
{
    if (self.animationImages == animationImages)
    {
        return;
    }
    [self setImage:animationImages withType:TYZAnimatedImageTypeImages];
}

- (void)setHighlightedAnimationImages:(NSArray<UIImage *> *)highlightedAnimationImages
{
    if (self.highlightedAnimationImages == highlightedAnimationImages)
    {
        return;
    }
    [self setImage:highlightedAnimationImages withType:TYZAnimatedImageTypeHighlightedImages];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (_link)
    {
        [self resetAnimated];
    }
    [self imageChanged];
}

- (id)imageForType:(TYZAnimatedImageType)type
{
    switch (type)
    {
        case TYZAnimatedImageTypeNone:
            return nil;
        case TYZAnimatedImageTypeImage:
            return self.image;
        case TYZAnimatedImageTypeHighlightedImage:
            return self.highlightedImage;
        case TYZAnimatedImageTypeHighlightedImages:
            return self.highlightedAnimationImages;
        default:
            break;
    }
    return nil;
}

- (TYZAnimatedImageType)currentImageType
{
    TYZAnimatedImageType curType = TYZAnimatedImageTypeNone;
    if (self.highlighted)
    {
        if ([self.highlightedAnimationImages count] != 0)
        {
            curType = TYZAnimatedImageTypeHighlightedImages;
        }
        else if (self.highlightedImage)
        {
            curType = TYZAnimatedImageTypeHighlightedImage;
        }
    }
    if (curType == TYZAnimatedImageTypeNone)
    {
        if ([self.animationImages count] != 0)
        {
            curType = TYZAnimatedImageTypeImages;
        }
        else if (self.image)
        {
            curType = TYZAnimatedImageTypeImage;
        }
    }
    return curType;
}

- (void)setImage:(id)image withType:(TYZAnimatedImageType)type
{
    [self stopAnimating];
    if (_link)
    {
        [self resetAnimated];
    }
    _curFrame = nil;
    switch (type)
    {
        case TYZAnimatedImageTypeNone:
            break;
        case TYZAnimatedImageTypeImage:
            super.image = image;
            break;
        case TYZAnimatedImageTypeHighlightedImage:
            super.highlightedImage = image;
            break;
        case TYZAnimatedImageTypeImages:
            super.animationImages = image;
            break;
        case TYZAnimatedImageTypeHighlightedImages:
            super.highlightedAnimationImages = image;
            break;
        default:
            break;
    }
    [self imageChanged];
}

- (void)imageChanged
{
    TYZAnimatedImageType newType = [self currentImageType];
    id newVisibleImage = [self imageForType:newType];
    NSUInteger newImageFrameCount = 0;
    BOOL hasContentsRect = NO;
    if ([newVisibleImage isKindOfClass:[UIImage class]] && [newVisibleImage conformsToProtocol:@protocol(TYZAnimatedImage)])
    {
        newImageFrameCount = ((UIImage<TYZAnimatedImage> *)newVisibleImage).animatedImageFrameCount;
        if (newImageFrameCount > 1)
        {
            hasContentsRect = [((UIImage<TYZAnimatedImage> *) newVisibleImage) respondsToSelector:@selector(animatedImageContentsRectAtIndex:)];
        }
    }
    if (!hasContentsRect && _curImageHasContentsRect)
    {
        if (!CGRectEqualToRect(self.layer.contentsRect, CGRectMake(0, 0, 1, 1)))
        {
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            self.layer.contentsRect = CGRectMake(0, 0, 1, 1);
            [CATransaction commit];
        }
    }
    _curImageHasContentsRect = hasContentsRect;
    if (hasContentsRect)
    {
        CGRect rect = [((UIImage<TYZAnimatedImage> *) newVisibleImage) animatedImageContentsRectAtIndex:0];
        [self setContentsRect:rect forImage:newVisibleImage];
    }
    
    if (newImageFrameCount > 1)
    {
        [self resetAnimated];
        _curAnimatedImage = newVisibleImage;
        _curFrame = newVisibleImage;
        _totalLoop = _curAnimatedImage.animatedImageLoopCount;
        _totalFrameCount = _curAnimatedImage.animatedImageFrameCount;
        [self calcMaxBufferCount];
    }
    [self setNeedsDisplay];
    [self didMoved];
}

// dynamically adjust buffer size for current memory.
- (void)calcMaxBufferCount
{
    int64_t bytes = (int64_t)_curAnimatedImage.animatedImageBytesPerFrame;
    if (bytes == 0)
    {
        bytes = 1024;
    }
    
    // 总的物理内存,字节
    int64_t total = [UIDevice currentDevice].memoryTotal;
    int64_t free = [UIDevice currentDevice].memoryFree;
    int64_t max = MIN(total * 0.2, free * 0.6);
    max = MAX(max, BUFFER_SIZE);
    if (_maxBufferSize)
    {
        max = (max > _maxBufferSize ? _maxBufferSize : max);
    }
    double maxBufferCount = (double)max / (double) bytes;
    maxBufferCount = TYZ_CLAMP(maxBufferCount, 1, 512);
    _maxBufferCount = maxBufferCount;
}

- (BOOL)isAnimating
{
    return self.currentIsPlayingAnimation;
}

- (void)stopAnimating
{
    [super stopAnimating];
    [_requestQueue cancelAllOperations];
    _link.paused = YES;
    self.currentIsPlayingAnimation = NO;
}

- (void)startAnimating
{
    TYZAnimatedImageType type = [self currentImageType];
    if (type == TYZAnimatedImageTypeImages || type == TYZAnimatedImageTypeImages)
    {
        NSArray *images = [self imageForType:type];
        if ([images count] > 0)
        {
            [super startAnimating];
            self.currentIsPlayingAnimation = YES;
        }
    }
    else
    {
        if (_curAnimatedImage && _link.paused)
        {
            _curLoop = 0;
            _loopEnd = NO;
            _link.paused = NO;
            self.currentIsPlayingAnimation = YES;
        }
    }
}

- (void)didReceiveMemoryWarning:(NSNotification *)notification
{
    [_requestQueue cancelAllOperations];
    [_requestQueue addOperationWithBlock:^{
        _incrBufferCount = -60 - (int)(arc4random() % 120); // about 1~3 seconds to grow back.
        NSNumber *next = @((_curIndex + 1) % _totalFrameCount);
        LOCK(
             NSArray *keys = _buffer.allKeys;
             for (NSNumber *key in keys)
             {
                 if (![key isEqualToNumber:next])
                 {// keep the next frame for smoothly animation
                     [_buffer removeObjectForKey:key];
                 }
             }
        )
    }];
}

- (void)didEnterBackground:(NSNotification *)notification
{
    [_requestQueue cancelAllOperations];
    NSNumber *next = @((_curIndex + 1) % _totalFrameCount);
    LOCK(
         NSArray * keys = _buffer.allKeys;
         for (NSNumber * key in keys)
         {
             if (![key isEqualToNumber:next])
             { // keep the next frame for smoothly animation
                 [_buffer removeObjectForKey:key];
             }
         }
    )//LOCK
}

- (void)step:(CADisplayLink *)link
{
    UIImage <TYZAnimatedImage> *image = _curAnimatedImage;
    NSMutableDictionary *buffer = _buffer;
    UIImage *bufferedImage = nil;
    NSUInteger nextIndex = (_curIndex + 1) % _totalFrameCount;
    BOOL bufferIsFull = NO;
    
    if (!image)
    {
        return;
    }
    if (_loopEnd)
    {// view will keep in last frame
        [self stopAnimating];
        return;
    }
    
    NSTimeInterval delay = 0;
    if (!_bufferMiss)
    {
        _time += link.duration;
        delay = [image animatedImageDurationAtIndex:_curIndex];
        if (_time < delay)
        {
            return;
        }
        _time -= delay;
        if (nextIndex == 0)
        {
            _curLoop++;
            if (_curLoop >= _totalLoop && _totalLoop != 0)
            {
                _loopEnd = YES;
                [self stopAnimating];
                [self.layer setNeedsDisplay]; // let system call 'displayLayer:' before runloop sleep
                return;// stop at last frame
            }
        }
        delay = [image animatedImageDurationAtIndex:nextIndex];
        if (_time > delay)
        {
            _time = delay; // do not jump over frame
        }
    }
    LOCK(
         bufferedImage = buffer[@(nextIndex)];
         if (bufferedImage) {
             if ((int)_incrBufferCount < _totalFrameCount)
             {
                 [buffer removeObjectForKey:@(nextIndex)];
             }
             [self willChangeValueForKey:@"currentAnimatedImageIndex"];
             _curIndex = nextIndex;
             [self didChangeValueForKey:@"currentAnimatedImageIndex"];
             _curFrame = bufferedImage == (id)[NSNull null] ? nil : bufferedImage;
             
             if (_curImageHasContentsRect)
             {
                 _curContentsRect = [image animatedImageContentsRectAtIndex:_curIndex];
                 [self setContentsRect:_curContentsRect forImage:_curFrame];
             }
             nextIndex = (_curIndex + 1) % _totalFrameCount;
             _bufferMiss = NO;
             if (buffer.count == _totalFrameCount)
             {
                 bufferIsFull = YES;
             }
         }
         else
         {
             _bufferMiss = YES;
         }
    )//LOCK
    
    if (!_bufferMiss)
    {
        [self.layer setNeedsDisplay]; // let system call 'displayLayer:' before runloop sleep
    }
    
    if (!bufferIsFull && _requestQueue.operationCount == 0)
    {// if some work not finished, wait for next opportunity
        _TYZAnimatedImageViewFetchOperation *operation = [_TYZAnimatedImageViewFetchOperation new];
        operation.view = self;
        operation.nextIndex = nextIndex;
        operation.curImage = image;
        [_requestQueue addOperation:operation];
    }
}

- (void)displayLayer:(CALayer *)layer
{
    if (_curFrame)
    {
        layer.contents = (__bridge id)_curFrame.CGImage;
    }
}


- (void)setContentsRect:(CGRect)rect forImage:(UIImage *)image
{
    CGRect layerRect = CGRectMake(0, 0, 1, 1);
    if (image)
    {
        CGSize imageSize = image.size;
        if (imageSize.width > 0.01 && imageSize.height > 0.01)
        {
            layerRect.origin.x = rect.origin.x / imageSize.width;
            layerRect.origin.y = rect.origin.y / imageSize.height;
            layerRect.size.width = rect.size.width / imageSize.width;
            layerRect.size.height = rect.size.height / imageSize.height;
            
            // 获取两个矩形相交处所的矩形，没有相交返回NULL，用CGRectIsNull来检测
            layerRect = CGRectIntersection(layerRect, CGRectMake(0, 0, 1, 1));
            if (CGRectIsNull(layerRect) || CGRectIsEmpty(layerRect))
            {
                layerRect = CGRectMake(0, 0, 1, 1);
            }
        }
    }
    [CATransaction begin];
    // 设置变化动画过程是否显示，默认为YES不显示
    [CATransaction setDisableActions:YES];
    self.layer.contentsRect = layerRect;
    [CATransaction commit];
}

- (void)didMoved
{
    // 如果图片有多个贴，是否自动播放
    if (self.autoPlayAnimatedImage)
    {
        if (self.superview && self.window)
        {
            [self startAnimating];
        }
        else
        {
            [self stopAnimating];
        }
    }
}

// 当视图移动到新的WINDOW后调用
- (void)didMoveToWindow
{
    [super didMoveToWindow];
    [self didMoved];
}

// 当视图移动完成后调用
- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    [self didMoved];
}

- (void)setCurrentAnimatedImageIndex:(NSUInteger)currentAnimatedImageIndex
{
    if (!_curAnimatedImage)
    {
        return;
    }
    if (currentAnimatedImageIndex >= _curAnimatedImage.animatedImageFrameCount)
    {
        return;
    }
    if (_curIndex == currentAnimatedImageIndex)
    {
        return;
    }
    
    dispatch_async_on_main_queue(^{
        LOCK(
             [_requestQueue cancelAllOperations];
             [_buffer removeAllObjects];
             [self willChangeValueForKey:@"currentAnimatedImageIndex"];
             _curIndex = currentAnimatedImageIndex;
             [self didChangeValueForKey:@"currentAnimatedImageIndex"];
             _curFrame = [_curAnimatedImage animatedImageFrameAtIndex:_curIndex];
             if (_curImageHasContentsRect)
             {
                 _curContentsRect = [_curAnimatedImage animatedImageContentsRectAtIndex:_curIndex];
             }
             _time = 0;
             _loopEnd = NO;
             _bufferMiss = NO;
             [self.layer setNeedsDisplay];
             )//LOCK
    });
}

- (NSUInteger)currentAnimatedImageIndex
{
    return _curIndex;
}

- (void)setRunloopMode:(NSString *)runloopMode
{
    if ([_runloopMode isEqual:runloopMode])
    {
        return;
    }
    if (_link)
    {
        if (_runloopMode)
        {
            [_link removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:_runloopMode];
        }
        if (runloopMode.length)
        {
            [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:runloopMode];
        }
    }
    _runloopMode = runloopMode.copy;
}

#pragma mark -Override NSObject(NSKeyValueObservingCustomization)
+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key
{
    if ([key isEqualToString:@"currentAnimatedImageIndex"])
    {
        return NO;
    }
    return [super automaticallyNotifiesObserversForKey:key];
}



#pragma mark - NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    _runloopMode = [aDecoder decodeObjectForKey:@"runloopMode"];
    if (_runloopMode.length == 0)
    {
        _runloopMode = NSRunLoopCommonModes;
    }
    if ([aDecoder containsValueForKey:@"autoPlayAnimatedImage"])
    {
        _autoPlayAnimatedImage = [aDecoder decodeBoolForKey:@"autoPlayAnimatedImage"];
    }
    else
    {
        _autoPlayAnimatedImage = YES;
    }
    
    UIImage *image = [aDecoder decodeObjectForKey:@"TYZAnimatedImage"];
    UIImage *highlightedImage = [aDecoder decodeObjectForKey:@"TYZHighlightedAnimatedImage"];
    if (image)
    {
        self.image = image;
        [self setImage:image withType:TYZAnimatedImageTypeImage];
    }
    if (highlightedImage)
    {
        self.highlightedImage = highlightedImage;
        [self setImage:highlightedImage withType:TYZAnimatedImageTypeHighlightedImage];
    }
    return self;

}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_runloopMode forKey:@"runloopMode"];
    [aCoder encodeBool:_autoPlayAnimatedImage forKey:@"autoPlayAnimatedImage"];
    
    BOOL ani, multi;
    ani = [self.image conformsToProtocol:@protocol(TYZAnimatedImage)];
    multi = (ani && ((UIImage<TYZAnimatedImage> *)self.image).animatedImageFrameCount > 1);
    if (multi)
    {
        [aCoder encodeObject:self.image forKey:@"TYZAnimatedImage"];
    }
    
    ani = [self.highlightedImage conformsToProtocol:@protocol(TYZAnimatedImage)];
    multi = (ani && ((UIImage<TYZAnimatedImage> *)self.highlightedImage).animatedImageFrameCount > 0);
    if (multi)
    {
        [aCoder encodeObject:self.highlightedImage forKey:@"TYZHighlightedAnimatedImage"];
    }
}

@end

























