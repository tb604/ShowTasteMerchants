//
//  TYZTransaction.m
//  YYStudyDemo
//
//  Created by 唐斌 on 16/2/25.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZTransaction.h"

@interface TYZTransaction ()
@property (nonatomic, strong) id target;
@property (nonatomic, assign) SEL selector;
@end

static NSMutableSet *transactionSet = nil;

static void TYZRunLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
//    NSLog(@"%s", __func__);
    if ([transactionSet count] == 0)
    {
        return;
    }
    
    /*switch (activity)
    {
        case kCFRunLoopEntry:
            NSLog(@"即将进入runloop");
            break;
        case kCFRunLoopBeforeTimers:
            NSLog(@"即将处理timer");
            break;
        case kCFRunLoopBeforeSources:
            NSLog(@"即将处理source");
            break;
        case kCFRunLoopBeforeWaiting:
            NSLog(@"即将进入睡眠");
            break;
        case kCFRunLoopAfterWaiting:
            NSLog(@"刚从睡眠中唤醒");
            break;
        case kCFRunLoopExit:
            NSLog(@"即将退出");
            break;
        default:
            break;
    }*/
    
    NSSet *currentSet = transactionSet;
    transactionSet = [NSMutableSet new];
    [currentSet enumerateObjectsUsingBlock:^(TYZTransaction *transaction, BOOL *stop) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [transaction.target performSelector:transaction.selector withObject:transaction];
#pragma clang diagnostic pop
    }];
}

static void TYZTransactionSetup()
{
//    NSLog(@"%s", __func__);
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        NSLog(@"eee");
        transactionSet = [NSMutableSet new];
        CFRunLoopRef runloop = CFRunLoopGetMain();
        CFRunLoopObserverRef observer;
        // true 表示repeat；0xFFFFFF 表示after CATransaction(2000000)
        observer = CFRunLoopObserverCreate(CFAllocatorGetDefault(), kCFRunLoopBeforeWaiting | kCFRunLoopExit, true, 0xFFFFFF, TYZRunLoopObserverCallBack, NULL);
        // kCFRunLoopCommonModes 在默认模式和追踪模式都能够运行
        // 给主线程的RunLoop添加一个观察者
        /*
         第1个参数: 需要给哪个RunLoop添加观察者
         第2个参数: 需要添加的Observer对象
         第3个参数: 在哪种模式下可以可以监听
         */
        CFRunLoopAddObserver(runloop, observer, kCFRunLoopCommonModes);
        CFRelease(observer);
        observer = NULL;
    });
}

@implementation TYZTransaction

+ (TYZTransaction *)transactionWithTarget:(id)target selector:(SEL)selector
{
    if (!target || !selector)
    {
        return nil;
    }
    TYZTransaction *tran = [TYZTransaction new];
    tran.target = target;
    tran.selector = selector;
    return tran;
}

- (void)commit
{
    if (!_target || !_selector)
    {
        return;
    }
    TYZTransactionSetup();
    [transactionSet addObject:self];
}

- (NSUInteger)hash
{
    long v1 = (long)((void *)_selector);
    long v2 = (long)_target;
    return  v1 ^ v2;
}

- (BOOL)isEqual:(id)object
{
    if (self == object)
    {
        return YES;
    }
    if (![object isMemberOfClass:self.class])
    {
        return NO;
    }
    TYZTransaction *other = object;
    return other.selector == _selector && other.target == _target;
}

@end


























