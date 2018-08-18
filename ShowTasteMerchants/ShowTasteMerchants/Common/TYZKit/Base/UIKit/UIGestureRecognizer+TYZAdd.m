//
//  UIGestureRecognizer+TYZAdd.m
//  YYStudyDemo
//
//  Created by 唐斌 on 16/3/2.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "UIGestureRecognizer+TYZAdd.h"
#import "TYZKitMacro.h"
#import <objc/runtime.h>

static const int block_key;

@interface _TYZUIGestureRecognizerBlockTarget : NSObject
@property (nonatomic, copy) void (^block)(id sender);

- (id)initWithBlock:(void (^)(id sender))block;
- (void)invoke:(id)sender;
@end

@implementation _TYZUIGestureRecognizerBlockTarget

- (id)initWithBlock:(void (^)(id))block
{
    self = [super init];
    if (self)
    {
        _block = [block copy];
    }
    return self;
}

- (void)invoke:(id)sender
{
    if (_block)
    {
        _block(sender);
    }
}

@end

@implementation UIGestureRecognizer (TYZAdd)

- (instancetype)initWithActionBlock:(void (^)(id))block
{
    self = [self init];
    [self addActionBlock:block];
    return self;
}

- (void)addActionBlock:(void (^)(id))block
{
    _TYZUIGestureRecognizerBlockTarget *target = [[_TYZUIGestureRecognizerBlockTarget alloc] initWithBlock:block];
    [self addTarget:target action:@selector(invoke:)];
    NSMutableArray *targets = [self _tyz_allUIGestureRecognizerBlockTargets];
    [targets addObject:target];
}

- (void)removeAllActionBlocks
{
    NSMutableArray *targets = [self _tyz_allUIGestureRecognizerBlockTargets];
    [targets enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self removeTarget:obj action:@selector(invoke:)];
    }];
    [targets removeAllObjects];
}

- (NSMutableArray *)_tyz_allUIGestureRecognizerBlockTargets
{
    NSMutableArray *targets = objc_getAssociatedObject(self, &block_key);
    if (!targets)
    {
        targets = [NSMutableArray array];
        objc_setAssociatedObject(self, &block_key, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return targets;
}

@end




























