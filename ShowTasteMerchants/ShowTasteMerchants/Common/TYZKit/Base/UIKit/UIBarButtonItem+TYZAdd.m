//
//  UIBarButtonItem+TYZAdd.m
//  YYStudyDemo
//
//  Created by 唐斌 on 16/3/2.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "UIBarButtonItem+TYZAdd.h"
#import "TYZKitMacro.h"
#import <objc/runtime.h>

TYZSYNTH_DUMMY_CLASS(UIBarButtonItem_TYZAdd)

static const int block_key;

@interface _TYZUIBarButtonItemBlockTarget : NSObject

@property (nonatomic, copy) void (^block)(id sender);

- (id)initWithBlock:(void (^)(id sender))block;

- (void)invoke:(id)sender;

@end

@implementation _TYZUIBarButtonItemBlockTarget

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

@implementation UIBarButtonItem (TYZAdd)

- (void)setActionBlock:(void (^)(id))actionBlock
{
    _TYZUIBarButtonItemBlockTarget *target = [[_TYZUIBarButtonItemBlockTarget alloc] initWithBlock:actionBlock];
    objc_setAssociatedObject(self, &block_key, target, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setTarget:target];
    [self setAction:@selector(invoke:)];
}

- (void (^)(id))actionBlock
{
    _TYZUIBarButtonItemBlockTarget *target = objc_getAssociatedObject(self, &block_key);
    return target.block;
}

@end




























