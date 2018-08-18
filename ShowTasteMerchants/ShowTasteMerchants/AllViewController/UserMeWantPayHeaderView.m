//
//  UserMeWantPayHeaderView.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "UserMeWantPayHeaderView.h"
#import "LocalCommon.h"

@interface UserMeWantPayHeaderView ()
{
    /**
     *  金额
     */
    UILabel *_amountLabel;
    
    /**
     *  规格
     */
    UILabel *_unitLabel;
    
    /**
     *  数量
     */
    UILabel *_numberLabel;
    
    /**
     *  单价
     */
    UILabel *_unitPriceLabel;
    
    /**
     *  菜名
     */
    UILabel *_nameLabel;
}

/**
 *  金额
 */
- (void)initWithAmountLabel;

/**
 *  规格
 */
- (void)initWithUnitLabel;

/**
 *  数量
 */
- (void)initWithNumberLabel;

/**
 *  单价
 */
- (void)initWithUnitPriceLabel;

/**
 *  菜名
 */
- (void)initWithNameLabel;
@end


@implementation UserMeWantPayHeaderView

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
    NSString *str = @"22222";
    if (kiPhone6Plus)
    {
        str = @"22222222";
    }
    else if (kiPhone6)
    {
        str = @"222222";
    }

    CGFloat width = [str widthForFont:FONTSIZE_15];
    CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - 15 - 5 - width, (kUserMeWantPayHeaderViewHeight- 20)/2, width, 20);
    _amountLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentRight];
    //    _amountLabel.backgroundColor = [UIColor lightGrayColor];
    _amountLabel.text = @"金额";
}

/**
 *  规格
 */
- (void)initWithUnitLabel
{
    if (!_unitLabel)
    {
        CGRect frame = _amountLabel.frame;
        frame.origin.x = _amountLabel.left - frame.size.width - 5;
        _unitLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentRight];
        //    _unitLabel.backgroundColor = [UIColor lightGrayColor];
        _unitLabel.text = @"规格";
    }
}

/**
 *  数量
 */
- (void)initWithNumberLabel
{
    CGRect frame = _unitLabel.frame;
    frame.origin.x = _unitLabel.left - frame.size.width - 5;
    _numberLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentRight];
    //    _numberLabel.backgroundColor = [UIColor lightGrayColor];
    _numberLabel.text = @"数量";
}

/**
 *  单价
 */
- (void)initWithUnitPriceLabel
{
    CGRect frame =_numberLabel.frame;
    frame.origin.x = _numberLabel.left - frame.size.width - 5;
    _unitPriceLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentRight];
    //    _unitPriceLabel.backgroundColor = [UIColor lightGrayColor];
    _unitPriceLabel.text = @"单价";
}


/**
 *  菜名
 */
- (void)initWithNameLabel
{
    CGRect frame = CGRectMake(15, (kUserMeWantPayHeaderViewHeight- 20)/2, _unitPriceLabel.left - 15, 20);
    _nameLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
    //    _nameLabel.backgroundColor = [UIColor purpleColor];
    _nameLabel.text = @"菜品";
}


@end
