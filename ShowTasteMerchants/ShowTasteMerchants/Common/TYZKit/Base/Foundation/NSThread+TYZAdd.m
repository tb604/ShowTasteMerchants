//
//  NSThread+TYZAdd.m
//  YYStudyDemo
//
//  Created by 唐斌 on 16/3/1.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "NSThread+TYZAdd.h"
#import <CoreFoundation/CoreFoundation.h>

@interface NSThread_TYZAdd : NSObject
@end
@implementation NSThread_TYZAdd
@end

#if __has_feature(objc_arc)
#error This file must be compiled without ARC. Specify the -fno-objc-arc flag to this file.
#endif


static NSString *const TYZNSThreadAutoleasePoolKey = @"TYZNSThreadAutoleasePoolKey";
static NSString *const TYZNSThreadAutoleasePoolStackKey = @"TYZNSThreadAutoleasePoolStackKey";

static const void *PoolStackRetainCallBack(CFAllocatorRef allocator, const void *value)
{
    return value;
}

static void PoolStackReleaseCallBack(CFAllocatorRef allocator, const void *value)
{
    CFRelease((CFTypeRef)value);
}


static inline void TYZAutoreleasePoolPush()
{
    NSMutableDictionary *dic =  [NSThread currentThread].threadDictionary;
    NSMutableArray *poolStack = dic[TYZNSThreadAutoleasePoolStackKey];
    
    if (!poolStack)
    {
        /*
         do not retain pool on push,
         but release on pop to avoid memory analyze warning
         */
        CFArrayCallBacks callbacks = {0};
        callbacks.retain = PoolStackRetainCallBack;
        callbacks.release = PoolStackReleaseCallBack;
        poolStack = (id)CFArrayCreateMutable(CFAllocatorGetDefault(), 0, &callbacks);
        dic[TYZNSThreadAutoleasePoolStackKey] = poolStack;
        CFRelease(poolStack);
    }
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; //< create
    [poolStack addObject:pool]; // push
}

static inline void TYZAutoreleasePoolPop()
{
    NSMutableDictionary *dic =  [NSThread currentThread].threadDictionary;
    NSMutableArray *poolStack = dic[TYZNSThreadAutoleasePoolStackKey];
    [poolStack removeLastObject]; // pop
}

static void TYZRunLoopAutoreleasePoolObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    switch (activity)
    {
        case kCFRunLoopEntry:
        {
            TYZAutoreleasePoolPush();
        } break;
        case kCFRunLoopBeforeWaiting:
        {
            TYZAutoreleasePoolPop();
            TYZAutoreleasePoolPush();
        } break;
        case kCFRunLoopExit:
        {
            TYZAutoreleasePoolPop();
        } break;
        default: break;
    }
}

static void TYZRunloopAutoreleasePoolSetup()
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CFRunLoopRef runloop = CFRunLoopGetCurrent();
        
        CFRunLoopObserverRef pushObserver;
        pushObserver = CFRunLoopObserverCreate(CFAllocatorGetDefault(),
                                               kCFRunLoopEntry,
                                               true,         // repeat
                                               -0x7FFFFFFF,  // before other observers
                                               TYZRunLoopAutoreleasePoolObserverCallBack, NULL);
        CFRunLoopAddObserver(runloop, pushObserver, kCFRunLoopCommonModes);
        CFRelease(pushObserver);
        
        CFRunLoopObserverRef popObserver;
        popObserver = CFRunLoopObserverCreate(CFAllocatorGetDefault(),
                                              kCFRunLoopBeforeWaiting | kCFRunLoopExit,
                                              true,        // repeat
                                              0x7FFFFFFF,  // after other observers
                                              TYZRunLoopAutoreleasePoolObserverCallBack, NULL);
        CFRunLoopAddObserver(runloop, popObserver, kCFRunLoopCommonModes);
        CFRelease(popObserver);
    });
}


@implementation NSThread (TYZAdd)
+ (void)addAutoreleasePoolToCurrentRunloop
{
    if ([NSThread isMainThread]) return; // The main thread already has autorelease pool.
    NSThread *thread = [self currentThread];
    if (!thread) return;
    if (thread.threadDictionary[TYZNSThreadAutoleasePoolKey]) return; // already added
    TYZRunloopAutoreleasePoolSetup();
    thread.threadDictionary[TYZNSThreadAutoleasePoolKey] = TYZNSThreadAutoleasePoolKey; // mark the state
}

@end




























