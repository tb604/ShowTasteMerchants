//
//  TYZDropDownMenuIndexPath.m
//  51tourGuide
//
//  Created by 唐斌 on 16/3/16.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZDropDownMenuIndexPath.h"

@implementation TYZDropDownMenuIndexPath

- (instancetype)initWithColumn:(NSInteger)column row:(NSInteger)row
{
    return [self initWithColumn:column row:row item:-1];
}

- (instancetype)initWithColumn:(NSInteger)column row:(NSInteger)row item:(NSInteger)item
{
    self = [super init];
    if (self)
    {
        _column = column;
        _row = row;
        _item = item;
    }
    return self;
}

+ (instancetype)indexPathWithColumn:(NSInteger)column row:(NSInteger)row
{
    return [[self alloc] initWithColumn:column row:row];
}

+ (instancetype)indexPathWithColumn:(NSInteger)column row:(NSInteger)row item:(NSInteger)item
{
    return [[self alloc] initWithColumn:column row:row item:item];
}

@end
























