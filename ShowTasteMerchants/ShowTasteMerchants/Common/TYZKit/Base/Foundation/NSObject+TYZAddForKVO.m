//
//  NSObject+TYZAddForKVO.m
//  YYStudyDemo
//
//  Created by 唐斌 on 16/2/29.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "NSObject+TYZAddForKVO.h"
#import "TYZKitMacro.h"
#import <objc/objc.h>
#import <objc/runtime.h>

TYZSYNTH_DUMMY_CLASS(NSObject_TYZAddForKVO)


static const int block_key;

@interface _TYZNSObjectKVOBlockTarget : NSObject

@property (nonatomic, copy) void (^block)(__weak id obj, id oldVal, id newVal);

- (id)initWithBlock:(void (^)(__weak id obj, id oldVal, id newVal))block;

@end

@implementation _TYZNSObjectKVOBlockTarget

- (id)initWithBlock:(void (^)(__weak id obj, id oldVal, id newVal))block
{
    self = [super init];
    if (self)
    {
        self.block = block;
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (!self.block)
    {
        return;
    }
    
    // 更改前的通知
    BOOL isPrior = [[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] boolValue];
    if (isPrior)
    {
        return;
    }
    
    NSKeyValueChange changeKind = [[change objectForKey:NSKeyValueChangeKindKey] integerValue];
    if (changeKind != NSKeyValueChangeSetting)
    {
        return;
    }
    id oldVal = [change objectForKey:NSKeyValueChangeOldKey];
    if (oldVal == [NSNull null])
    {
        oldVal = nil;
    }
    
    id newVal = [change objectForKey:NSKeyValueChangeNewKey];
    if (newVal == [NSNull null])
    {
        newVal = nil;
    }
    if (_block)
    {
        _block(object, oldVal, newVal);
    }
}

@end


@implementation NSObject (TYZAddForKVO)

- (void)addObserverBlockForKeyPath:(NSString *)keyPath block:(void (^)(__weak id obj, id oldVal, id newVal))block
{
    if (!keyPath || !block)
    {
        return;
    }
    
    _TYZNSObjectKVOBlockTarget *target = [[_TYZNSObjectKVOBlockTarget alloc] initWithBlock:block];
    NSMutableDictionary *dic = [self _tyz_allNSObjectObserverBlocks];
    NSMutableArray *array = dic[keyPath];
    if (!array)
    {
        array = [NSMutableArray new];
        dic[keyPath] = array;
    }
    [array addObject:target];
    [self addObserver:target forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
}

- (void)removeObserverBlocksForKeyPath:(NSString *)keyPath
{
    if (!keyPath)
    {
        return;
    }
    NSMutableDictionary *dict = [self _tyz_allNSObjectObserverBlocks];
    NSMutableArray *array = dict[keyPath];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self removeObserver:obj forKeyPath:keyPath];
    }];
    [dict removeObjectForKey:keyPath];
}

- (void)removeObserverBlocks
{
    NSMutableDictionary *dict = [self _tyz_allNSObjectObserverBlocks];
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSArray *arr, BOOL * _Nonnull stop) {
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self removeObserver:obj forKeyPath:key];
        }];
    }];
    [dict removeAllObjects];
}


- (NSMutableDictionary *)_tyz_allNSObjectObserverBlocks
{
    NSMutableDictionary *targets = objc_getAssociatedObject(self, &block_key);
    if (!targets)
    {
        targets = [NSMutableDictionary new];
        objc_setAssociatedObject(self, &block_key, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return targets;
}

@end



























