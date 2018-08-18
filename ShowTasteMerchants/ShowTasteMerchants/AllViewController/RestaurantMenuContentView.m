//
//  RestaurantMenuContentView.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/27.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "RestaurantMenuContentView.h"
#import "LocalCommon.h"
#import "ShopFoodDataEntity.h"

@interface RestaurantMenuContentView ()
{
    /**
     *  菜的名称
     */
    UILabel *_foodNameLabel;
    
    /**
     *  菜的特性。“微辣”
     */
    UILabel *_foodFeaturesLabel;
    
    /**
     *  价格
     */
    UILabel *_priceLabel;
}

/**
 *  初始化菜的名称
 */
- (void)initWithFoodNameLabel;

/**
 *  初始化菜的特性
 */
- (void)initWithFoodFeaturesLabel;

/**
 *  初始化菜的价格
 */
- (void)initWithPriceLabel;

@end

@implementation RestaurantMenuContentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    // 初始化菜的名称
    [self initWithFoodNameLabel];
    
    // 初始化菜的特性
    [self initWithFoodFeaturesLabel];
    
    // 初始化菜的价格
    [self initWithPriceLabel];

    
}

/**
 *  初始化菜的名称
 */
- (void)initWithFoodNameLabel
{
    if (!_foodNameLabel)
    {
        CGRect frame = CGRectMake(10, 7, 80, 20);
        _foodNameLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_16 labelTag:0 alignment:NSTextAlignmentLeft];
    }
}

/**
 *  初始化菜的特性
 */
- (void)initWithFoodFeaturesLabel
{
    if (!_foodFeaturesLabel)
    {
        CGRect frame = CGRectMake(_foodNameLabel.right + 10, 10, 30, 16);
        _foodFeaturesLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#ffffff"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentCenter];
        _foodFeaturesLabel.centerY = _foodNameLabel.centerY;
        _foodFeaturesLabel.backgroundColor = [UIColor colorWithHexString:@"#ff5500"];
        _foodFeaturesLabel.layer.masksToBounds = YES;
        _foodFeaturesLabel.layer.cornerRadius = 2.0;
    }
}

/**
 *  初始化菜的价格
 */
- (void)initWithPriceLabel
{
    if (!_priceLabel)
    {
        CGRect frame = CGRectMake(10, _foodNameLabel.bottom + 5, self.width - 20 , 20);
        _priceLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
    }
}

- (void)updateViewData:(id)entity
{
    ShopFoodDataEntity *foodEntity = entity;
    NSString *str = objectNull(foodEntity.name);
    CGFloat width = [str widthForFont:_foodNameLabel.font height:20];
    _foodNameLabel.width = width;
    _foodNameLabel.text = str;
    
    _foodFeaturesLabel.left = _foodNameLabel.right + 8;
    _foodFeaturesLabel.text = @"微辣";
    
    // 价格
    NSString *price = [NSString stringWithFormat:@"%.0f", foodEntity.price];
    NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] init];
    UIColor *color = [UIColor colorWithHexString:@"#ff5500"];
    NSAttributedString *butedStr = [[NSAttributedString alloc] initWithString:price attributes:@{NSFontAttributeName: FONTSIZE(18), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:butedStr];
    color = [UIColor colorWithHexString:@"#ff5500"];
    butedStr = [[NSAttributedString alloc] initWithString:@"元" attributes:@{NSFontAttributeName: FONTSIZE(13), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:butedStr];
    _priceLabel.attributedText = mas;
}

@end













