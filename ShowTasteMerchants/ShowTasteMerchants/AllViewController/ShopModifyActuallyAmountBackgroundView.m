//
//  ShopModifyActuallyAmountBackgroundView.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/7.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopModifyActuallyAmountBackgroundView.h"
#import "LocalCommon.h"
#import "ShopModifyActuallyAmountView.h"

@interface ShopModifyActuallyAmountBackgroundView ()
{
    /**
     *  修改实付金额视图
     */
    ShopModifyActuallyAmountView *_modifyAmountView;
}

- (void)initWithSubView;

- (void)initWithModifyAmountView;

@end

@implementation ShopModifyActuallyAmountBackgroundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initWithSubView];
    }
    
    return self;
}

- (void)initWithSubView
{
    self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.7];
    [self initWithModifyAmountView];
    
    // top
    CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], _modifyAmountView.top);
    UIView *view = [[UIView alloc] initWithFrame:frame];
    [self addSubview:view];
    
    // bottom
    frame = CGRectMake(0, _modifyAmountView.bottom, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight] - _modifyAmountView.bottom);
    UIView *bottom = [[UIView alloc] initWithFrame:frame];
    [self addSubview:bottom];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagGesture:)];
    [view addGestureRecognizer:tap];
    [bottom addGestureRecognizer:tap];

    
}

- (void)initWithModifyAmountView
{
    if (!_modifyAmountView)
    {
        CGRect frame = CGRectMake(15, ([[UIScreen mainScreen] screenHeight] - 252) / 2 - 50, [[UIScreen mainScreen] screenWidth] - 30, 252);
        _modifyAmountView = [[ShopModifyActuallyAmountView alloc] initWithFrame:frame];
        _modifyAmountView.layer.masksToBounds = YES;
        _modifyAmountView.layer.cornerRadius = 4;
        [self addSubview:_modifyAmountView];
    }
    __weak typeof(self)weakSelf = self;
    _modifyAmountView.viewCommonBlock = ^(id data)
    {
        if (weakSelf.modifyAmountBlock)
        {
            weakSelf.modifyAmountBlock(data);
        }
    };
    
}

- (void)tagGesture:(UITapGestureRecognizer *)tap
{
//    if (self.modifyAmountBlock)
//    {
//        _modifyAmountBlock(nil);
//    }
    [self endEditing:YES];
}


- (void)updateWithData:(id)data
{
    [_modifyAmountView updateViewData:data];
}

@end





















