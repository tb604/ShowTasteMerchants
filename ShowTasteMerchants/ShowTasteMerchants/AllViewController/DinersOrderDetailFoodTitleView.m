//
//  DinersOrderDetailFoodTitleView.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/29.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DinersOrderDetailFoodTitleView.h"
#import "LocalCommon.h"

@interface DinersOrderDetailFoodTitleView ()
{
    /**
     *  金额
     */
    UILabel *_amountLabel;
    
    /**
     *  单价
     */
    UILabel *_unitPriceLabel;
    
    /**
     *  规格
     */
    UILabel *_unitLabel;
    
    /**
     *  数量
     */
    UILabel *_numberLabel;
    
    UIImageView *_thanImgView;
    
    /**
     *  菜名
     */
    UILabel *_nameLabel;
}

@property (nonatomic, strong) UIColor *titleColor;

/**
 *  金额
 */
- (void)initWithAmountLabel;

/**
 *  单价
 */
- (void)initWithUnitPriceLabel;

/**
 *  规格
 */
- (void)initWithUnitLabel;

/**
 *  数量
 */
- (void)initWithNumberLabel;

- (void)initWithThanImgView;

/**
 *  菜名
 */
- (void)initWithNameLabel;
@end

@implementation DinersOrderDetailFoodTitleView


- (id)initWithFrame:(CGRect)frame titleColor:(UIColor *)titleColor
{
    self.titleColor = titleColor;
    return [self initWithFrame:frame];
}

- (void)initWithSubView
{
    [super initWithSubView];
    self.backgroundColor = [UIColor colorWithHexString:@"#fedecc"];
    
    // 金额
    [self initWithAmountLabel];
    
    // 规格
    [self initWithUnitLabel];
    
    // 数量
    [self initWithNumberLabel];
    
    // 单价
    [self initWithUnitPriceLabel];
    
    // 菜名
    [self initWithNameLabel];
    
}

/**
 *  金额
 */
- (void)initWithAmountLabel
{
    if (!_titleColor)
    {
        _titleColor = [UIColor colorWithHexString:@"#ff5500"];
    }
    UIImage *image = [UIImage imageNamed:@"hall-order_menu_icon_yishangcai"];
    NSString *str = @"22225";
    if (kiPhone6Plus || kiPhone6)
    {
        str = @"2222225";
    }
    CGFloat width = [str widthForFont:FONTSIZE_15];
    CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - 15 - image.size.width - 5 - 5 - width, (kDinersOrderDetailFoodTitleViewHeight- 20)/2, width, 20);
    _amountLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:_titleColor fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentRight];
//    _amountLabel.backgroundColor = [UIColor lightGrayColor];
    _amountLabel.text = @"金额";
}

/**
 *  规格
 */
- (void)initWithUnitLabel
{
    if (!_titleColor)
    {
        _titleColor = [UIColor colorWithHexString:@"#ff5500"];
    }
    CGRect frame = _amountLabel.frame;
    frame.size.width = frame.size.width - 10;
    frame.origin.x = _amountLabel.left - frame.size.width - 5;
    _unitLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:_titleColor fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentRight];
//    _unitLabel.backgroundColor = [UIColor lightGrayColor];
    _unitLabel.text = @"规格";
}

/**
 *  数量
 */
- (void)initWithNumberLabel
{
    if (!_titleColor)
    {
        _titleColor = [UIColor colorWithHexString:@"#ff5500"];
    }
    CGRect frame = _unitLabel.frame;
    frame.origin.x = _unitLabel.left - frame.size.width - 5;
    _numberLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:_titleColor fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentRight];
//    _numberLabel.backgroundColor = [UIColor lightGrayColor];
    _numberLabel.text = @"数量";
}

/**
 *  单价
 */
- (void)initWithUnitPriceLabel
{
    if (!_titleColor)
    {
        _titleColor = [UIColor colorWithHexString:@"#ff5500"];
    }
    CGRect frame = _numberLabel.frame;
    frame.origin.x = _numberLabel.left - frame.size.width - 5;
    
    _unitPriceLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:_titleColor fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentRight];
//        _unitPriceLabel.backgroundColor = [UIColor lightGrayColor];
    _unitPriceLabel.text = @"单价";
}

// menu_icon_xiala

- (void)initWithThanImgView
{
    if (!_thanImgView)
    {
        
    }
}

/**
 *  菜名
 */
- (void)initWithNameLabel
{
    if (!_titleColor)
    {
        _titleColor = [UIColor colorWithHexString:@"#ff5500"];
    }
    UIImage *image = [UIImage imageNamed:@"menu_icon_xiala"];
    
    CGRect frame = CGRectMake(15 + image.size.width + 5, (kDinersOrderDetailFoodTitleViewHeight- 20)/2, _unitPriceLabel.left - 15 - 5 - 15 - image.size.width, 20);
    _nameLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:_titleColor fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
//    _nameLabel.backgroundColor = [UIColor purpleColor];
    _nameLabel.text = @"菜品";
}

@end
