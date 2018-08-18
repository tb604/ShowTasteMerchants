//
//  ShopingCartView.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/25.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopingCartView.h"
#import "LocalCommon.h"
#import "SYFireworksButton.h"
#import <objc/runtime.h>
#import "SYFireworksView.h"

@interface ShopingCartView ()
{
    UIImageView *_shopCartImgView;
    
    /**
     *  购物车里面的数量
     */
    UILabel *_numberLabel;
}

- (void)initWithShopCartImgView;

/**
 *  购物车里面的数量
 */
- (void)initWithNumberLabel;

- (void)tapGesture:(UITapGestureRecognizer *)tap;

@end

@implementation ShopingCartView

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithShopCartImgView];
    
    // 购物车里面的数量
    [self initWithNumberLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self addGestureRecognizer:tap];
    
}

- (void)initWithShopCartImgView
{
    // order_cart_disable
    // order_cart_clickable
    UIImage *image = [UIImage imageNamed:@"order_cart_clickable"];
    CGRect frame = CGRectMake(0, (self.height - image.size.height)/2, image.size.width, image.size.height);
    _shopCartImgView = [[UIImageView alloc] initWithFrame:frame];
    _shopCartImgView.image = image;
    _shopCartImgView.right = self.width / 2;
    [self addSubview:_shopCartImgView];
}

/**
 *  购物车里面的数量
 */
- (void)initWithNumberLabel
{
    CGRect frame = CGRectMake(_shopCartImgView.right + 5, (self.height - 20) / 2, self.width - _shopCartImgView.right - 5 - 10, 20);
    _numberLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
//    _numberLabel.backgroundColor = [UIColor lightGrayColor];
    _numberLabel.text = @"99";
}

- (void)tapGesture:(UITapGestureRecognizer *)tap
{
    if (_TouchShopingCartBlock)
    {
        _TouchShopingCartBlock();
    }
}

- (void)updateViewData:(id)entity
{
    // order_cart_disable
    // order_cart_clickable

    NSInteger num = [entity integerValue];
    if (num == 0)
    {
        _shopCartImgView.image = [UIImage imageNamed:@"order_cart_disable"];
    }
    else
    {
        _shopCartImgView.image = [UIImage imageNamed:@"order_cart_clickable"];
    }
    _numberLabel.text = [NSString stringWithFormat:@"%d", (int)num];
}

@end
