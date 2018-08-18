//
//  DinersShopingCartTopView.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/26.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DinersShopingCartTopView.h"
#import "LocalCommon.h"

@interface DinersShopingCartTopView ()
{
    UILabel *_titleLabel;
    
    /**
     *  清除购物车
     */
    UIButton *_btnClearShopCart;
}

- (void)initWithTitleLabel;

/**
 *  清除购物车
 */
- (void)initWithBtnClearShopCart;

@end

@implementation DinersShopingCartTopView

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    
    [self initWithTitleLabel];
    
    // 清除购物车
    [self initWithBtnClearShopCart];
    
}

- (void)initWithTitleLabel
{
    CGRect frame = CGRectMake(15, 10, [[UIScreen mainScreen] screenWidth]/2 - 15 - 10, 20);
    _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
    _titleLabel.text = @"已点菜品";
}

/**
 *  清除购物车
 */
- (void)initWithBtnClearShopCart
{
    UIImage *image = [UIImage imageNamed:@"order_btn_clear"];
    CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - 15 - image.size.width, 5, image.size.width, 30);
    _btnClearShopCart = [TYZCreateCommonObject createWithButton:self imgNameNor:@"order_btn_clear" imgNameSel:@"order_btn_clear" targetSel:@selector(clickedWithClear:)];
    _btnClearShopCart.frame = frame;
    [self addSubview:_btnClearShopCart];
}

// 清除购物车
- (void)clickedWithClear:(id)sender
{
    if (_clearShoppingCartBlock)
    {
        _clearShoppingCartBlock();
    }
}

- (void)showWithSubView:(BOOL)show
{
    _titleLabel.hidden = !show;
    _btnClearShopCart.hidden = !show;
}

@end






















