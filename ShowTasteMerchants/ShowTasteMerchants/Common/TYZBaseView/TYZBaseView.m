//
//  TYZBaseView.m
//  51tourGuide
//
//  Created by 唐斌 on 16/3/14.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"


@implementation TYZBaseView

- (void)dealloc
{
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initWithVar];
        [self initWithSubView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initWithVar];
        [self initWithSubView];
    }
    return self;
}

/*
- (void)drawRect:(CGRect)rect
{
    
}*/

- (void)initWithVar
{
    
}

- (void)initWithSubView
{
    
}

- (void)updateViewData:(id)entity
{
    
}

@end





















