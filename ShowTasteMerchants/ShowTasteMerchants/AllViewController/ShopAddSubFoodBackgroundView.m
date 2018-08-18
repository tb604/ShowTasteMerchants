//
//  ShopAddSubFoodBackgroundView.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/5.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopAddSubFoodBackgroundView.h"
#import "LocalCommon.h"


@interface ShopAddSubFoodBackgroundView ()
{
    ShopAddSubFoodView *_shopAddSubFoodView;
}

- (void)initWithSubView;

- (void)initWithShopAddSubFoodView;

@end

@implementation ShopAddSubFoodBackgroundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initWithSubView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initWithSubView];
    }
    return self;
}

- (void)initWithSubView
{
    self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    
    [self initWithShopAddSubFoodView];
    
    
    // top
    CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], _shopAddSubFoodView.top);
    UIView *view = [[UIView alloc] initWithFrame:frame];
    [self addSubview:view];
    
    // bottom
    frame = CGRectMake(0, _shopAddSubFoodView.bottom, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight] - _shopAddSubFoodView.bottom);
    UIView *bottom = [[UIView alloc] initWithFrame:frame];
    [self addSubview:bottom];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagGesture:)];
    [view addGestureRecognizer:tap];
    [bottom addGestureRecognizer:tap];

}

- (void)initWithShopAddSubFoodView
{
    if (!_shopAddSubFoodView)
    {
        CGRect frame = CGRectMake(([[UIScreen mainScreen] screenWidth] - 300)/2, 0, 300, 150);
        _shopAddSubFoodView = [[ShopAddSubFoodView alloc] initWithFrame:frame];
        [self addSubview:_shopAddSubFoodView];
        _shopAddSubFoodView.centerY = [[UIScreen mainScreen] screenHeight] / 2 - 50;
        _shopAddSubFoodView.layer.cornerRadius = 4;
        _shopAddSubFoodView.layer.masksToBounds = YES;
    }
    __weak typeof(self)weakSelf = self;
    _shopAddSubFoodView.viewCommonBlock = ^(id data)
    {
        if (weakSelf.touchAddSubFoodBlock)
        {
            weakSelf.touchAddSubFoodBlock(data);
        }
    };
}

- (void)updateWithData:(id)data addSubType:(NSInteger)addSubType operateFood:(NSInteger)operateFood
{
    [_shopAddSubFoodView updateViewData:data addSubType:addSubType operateFood:operateFood];
}

- (void)tagGesture:(UITapGestureRecognizer *)tap
{
    if (_touchAddSubFoodBlock)
    {
        _touchAddSubFoodBlock(nil);
    }
}

@end













