//
//  TYZTextTransaction.m
//  51tourGuide
//
//  Created by 唐斌 on 16/3/18.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZTextTransaction.h"

@interface TYZTextTransaction ()
@property (nonatomic, strong) id target;
@property (nonatomic, assign) SEL selector;
@end

static NSMutableSet *transactionSet = nil;

static void TYZRunLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    if ([transactionSet count] == 0)
    {
        return;
    }
    NSSet *currentSet = transactionSet;
    transactionSet = [NSMutableSet new];
    [currentSet enumerateObjectsUsingBlock:^(TYZTextTransaction *transaction, BOOL * _Nonnull stop) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [transaction.target performSelector:transaction.selector];
#pragma clang diagnostic pop
    }];
}

static void TYZTextTransactionSetup()
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        transactionSet = [NSMutableSet new];
        CFRunLoopRef runloop = CFRunLoopGetMain();
        CFRunLoopObserverRef observer;
        observer = CFRunLoopObserverCreate(CFAllocatorGetDefault(), kCFRunLoopBeforeWaiting | kCFRunLoopExit, true, 0xFFFFFF, TYZRunLoopObserverCallBack, NULL);
        CFRunLoopAddObserver(runloop, observer, kCFRunLoopCommonModes);
        CFRelease(observer);
    });
}

@implementation TYZTextTransaction

+ (TYZTextTransaction *)transactionWithTarget:(id)target selector:(SEL)selector
{
    if (!target || !selector)
    {
        return nil;
    }
    TYZTextTransaction *tran = [TYZTextTransaction new];
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
    TYZTextTransactionSetup();
    [transactionSet addObject:self];
}

@end

















