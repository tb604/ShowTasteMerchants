//
//  TYZAsyncLayer.m
//  YYStudyDemo
//
//  Created by 唐斌 on 16/2/25.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZAsyncLayer.h"
#import "TYZSentinel.h"
#import <libkern/OSAtomic.h>
#import <UIKit/UIKit.h>

/**
 *  Global display queue, used for content rendering.(全球显示队列,用于呈现内容。)
 *
 *  @return return value description
 */
static dispatch_queue_t TYZAsyncLayerGetDisplayQueue()
{
#define MAX_QUEUE_COUNT 16
    static int queueCount;
    static dispatch_queue_t queues[MAX_QUEUE_COUNT];
    static int32_t counter = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 处理器数量
        queueCount = (int)[NSProcessInfo processInfo].activeProcessorCount;
        queueCount = queueCount < 1 ? 1 : queueCount > MAX_QUEUE_COUNT ? MAX_QUEUE_COUNT : queueCount;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            for (NSUInteger i=0; i<queueCount; i++)
            {
                dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INITIATED, 0);
                queues[i] = dispatch_queue_create("com.tb604.tyzkit.render", attr);
            }
        }
        else
        {
            for (NSUInteger i=0; i<queueCount; i++)
            {
                queues[i] = dispatch_queue_create("com.tb604.tyzkit.render", DISPATCH_QUEUE_SERIAL);
                dispatch_set_target_queue(queues[i], dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
            }
        }
    });
    int32_t cur = OSAtomicIncrement32(&counter);
    if (cur < 0)
    {
        cur = -cur;
    }
    return queues[(cur) % queueCount];
    
#undef MAX_QUEUE_COUNT
}

static dispatch_queue_t TYZAsyncLayerGetReleaseQueue()
{
    return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
}


@implementation TYZAsyncLayer
{
    TYZSentinel *_sentinel;
}

#pragma mark - Override

+ (id)defaultValueForKey:(NSString *)key
{
    if ([key isEqualToString:@"displaysAsynchronously"])
    {
        return @(YES);
    }
    else
    {
        return [super defaultValueForKey:key];
    }
}

- (instancetype)init
{
    self = [super init];
    static CGFloat scale; // global
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scale = [UIScreen mainScreen].scale;
    });
    // contentsScale默认为1
    self.contentsScale = scale;
    _sentinel = [[TYZSentinel alloc] init];
    _displayAsynchronously = YES;
    
    return self;
}

- (void)dealloc
{
    [_sentinel increase];
    
//    NSLog(@"%s--value=%d", __func__, _sentinel.value);
}

- (void)setNeedsDisplay
{
//    NSLog(@"%s", __func__);
    [self _cancelAsyncDisplay];
    [super setNeedsDisplay];
}

- (void)display
{
//    NSLog(@"%s", __func__);
    super.contents = super.contents;
    [self _displayAsync:_displayAsynchronously];
}

#pragma mark - private

- (void)_displayAsync:(BOOL)async
{
    __strong id<TYZAsyncLayerDelegate> delegate = (id)self.delegate;
    TYZAsyncLayerDisplayTask *task = [delegate newAsyncDisplayTask];
    if (!task.display)
    {
        if (task.willDisplay)
        {
            task.willDisplay(self);
        }
        self.contents = nil;
        if (task.didDisplay)
        {
            task.didDisplay(self, YES);
        }
        return;
    }
    
    if (async)
    {// 异步
        if (task.willDisplay) task.willDisplay(self);
        TYZSentinel *sentinel = _sentinel;
        int32_t value = sentinel.value;
        BOOL (^isCancelled)() = ^BOOL() {
            return value != sentinel.value;
        };
        CGSize size = self.bounds.size;
        BOOL opaque = self.opaque;
        CGFloat scale = self.contentsScale;
        if (size.width < 1 || size.height < 1)
        {
            CGImageRef image = (__bridge_retained CGImageRef)(self.contents);
            self.contents = nil;
            if (image)
            {
                dispatch_async(TYZAsyncLayerGetReleaseQueue(), ^{
                    CFRelease(image);
                });
            }
            if (task.didDisplay) task.didDisplay(self, YES);
            return;
        }
        
        dispatch_async(TYZAsyncLayerGetDisplayQueue(), ^{
            if (isCancelled()) return;
            UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
            CGContextRef context = UIGraphicsGetCurrentContext();
            task.display(context, size, isCancelled);
            if (isCancelled())
            {
                UIGraphicsEndImageContext();
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (task.didDisplay) task.didDisplay(self, NO);
                });
                return;
            }
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            if (isCancelled())
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (task.didDisplay) task.didDisplay(self, NO);
                });
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (isCancelled())
                {
                    if (task.didDisplay) task.didDisplay(self, NO);
                }
                else
                {
                    self.contents = (__bridge id)(image.CGImage);
                    if (task.didDisplay) task.didDisplay(self, YES);
                }
            });
        });
    }
    else
    {// 同步
        [_sentinel increase];
        if (task.willDisplay)
        {
            task.willDisplay(self);
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, self.contentsScale);
            CGContextRef context = UIGraphicsGetCurrentContext();
            if (task.display)
            {
                task.display(context, self.bounds.size, ^{return  NO;});
            }
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            self.contents = (__bridge id)(image.CGImage);
            if (task.didDisplay)
            {
                task.didDisplay(self, YES);
            }
            
        }
    }
}

- (void)_cancelAsyncDisplay
{
    [_sentinel increase];
}

@end

@implementation TYZAsyncLayerDisplayTask
@end




























