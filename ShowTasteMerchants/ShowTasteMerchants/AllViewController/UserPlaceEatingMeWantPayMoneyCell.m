//
//  UserPlaceEatingMeWantPayMoneyCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "UserPlaceEatingMeWantPayMoneyCell.h"
#import "LocalCommon.h"
#import "OrderDetailDataEntity.h"

@interface UserPlaceEatingMeWantPayMoneyCell ()
{
    /**
     *  “合计”
     */
    UILabel *_totalTitleLabel;
    
    /**
     *  总金额
     */
    UILabel *_totalPriceLabel;
    
    /**
     *  总数量
     */
    UILabel *_totalNumberLabel;
    
    /**
     *  “商家折扣（减预付款）”
     */
    UILabel *_shopTitleLabel;
    
    /**
     *  商家折扣
     */
    UILabel *_shopDiscountLabel;
    
    /**
     *  “App折扣”
     */
    UILabel *_appTitleLabel;
    
    /**
     *  App折扣
     */
    UILabel *_appDiscountLabel;
    
    /**
     *  “应付：”
     */
    UILabel *_payTitleLabel;
    
    /**
     *  应付金额
     */
    UILabel *_payPriceLabel;
}

/**
 *  “合计”
 */
- (void)initWithTotalTitleLabel;

/**
 * 总金额
 */
- (void)initWithTotalPriceLabel;

/**
 * 总数量
 */
- (void)initWithTotalNumberLabel;

/**
 *  “商家折扣（减预付款）”
 */
- (void)initWithShopTitleLabel;

/**
 *  商家折扣金额
 */
- (void)initWithShopDiscountLabel;

/**
 *  “App折扣”
 */
- (void)initWithAppTitleLabel;

/**
 *  App折扣金额
 */
- (void)initWithAppDiscountLabel;

/**
 *  “应付：”
 */
- (void)initWithPayTitleLabel;

/**
 *  应付金额
 */
- (void)initWithPayPriceLabel;

@end

@implementation UserPlaceEatingMeWantPayMoneyCell

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    // “合计”
    [self initWithTotalTitleLabel];
    
    // 总金额
    [self initWithTotalPriceLabel];
    
    // 总数量
    [self initWithTotalNumberLabel];
    
    // “商家折扣（减预付款）”
//    [self initWithShopTitleLabel];
    
    // 商家折扣金额
//    [self initWithShopDiscountLabel];
    
    // “App折扣”
//    [self initWithAppTitleLabel];
    
    // App折扣金额
//    [self initWithAppDiscountLabel];
    
    // “应付：”
    [self initWithPayTitleLabel];
    
    // 应付金额
    [self initWithPayPriceLabel];
}

/**
 *  “合计”
 */
- (void)initWithTotalTitleLabel
{
    NSString *str = @"合计：";
    CGFloat width = [str widthForFont:FONTSIZE_15];
    CGRect frame = CGRectMake(15, 10, width, 20);
    _totalTitleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
    _totalTitleLabel.text = str;
}

/**
 * 总金额
 */
- (void)initWithTotalPriceLabel
{
    NSString *str = @"22222";
    CGFloat width = [str widthForFont:FONTSIZE_15] * 3 + 15;
    CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - 15 - width, 10, width, 20);
    _totalPriceLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentRight];
//    _totalPriceLabel.backgroundColor = [UIColor lightGrayColor];
}

/**
 * 总数量
 */
- (void)initWithTotalNumberLabel
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
    
    CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - width * 3 - 15 - 15, 10, width, 20);
    _totalNumberLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentRight];
//    _totalNumberLabel.backgroundColor = [UIColor lightGrayColor];

}

/**
 *  “商家折扣（减预付款）”
 */
- (void)initWithShopTitleLabel
{
    NSString *str = @"商家折扣：";
    CGFloat width = [str widthForFont:FONTSIZE_15];
    CGRect frame = CGRectMake(15, _totalTitleLabel.bottom + 5, width, 20);
    _shopTitleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
    _shopTitleLabel.text = str;
}

/**
 *  商家折扣金额
 */
- (void)initWithShopDiscountLabel
{
    NSString *str = @"22222";
    CGFloat width = [str widthForFont:FONTSIZE_15]*2 + 10;
    CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - 15 - width, 0, width, 20);
    _shopDiscountLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentRight];
    _shopDiscountLabel.centerY = _shopTitleLabel.centerY;
}

/**
 *  “App折扣”
 */
- (void)initWithAppTitleLabel
{
    NSString *str = @"App折扣券：";
    CGFloat width = [str widthForFont:FONTSIZE_15];
    CGRect frame = CGRectMake(15, _shopTitleLabel.bottom + 5, width, 20);
    _appTitleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
    _appTitleLabel.text = str;
}

/**
 *  App折扣金额
 */
- (void)initWithAppDiscountLabel
{
    CGRect frame = _shopDiscountLabel.frame;
    _appDiscountLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentRight];
    _appDiscountLabel.centerY = _appTitleLabel.centerY;
}

/**
 *  “应付：”
 */
- (void)initWithPayTitleLabel
{
    NSString *str = @"应付：";
    CGFloat width = [str widthForFont:FONTSIZE_15];
    CGRect frame = CGRectMake(15, _totalTitleLabel.bottom + 5, width, 20);
    _payTitleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
    _payTitleLabel.text = str;
}

/**
 *  应付金额
 */
- (void)initWithPayPriceLabel
{
    CGRect frame = _totalPriceLabel.frame;
    _payPriceLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentRight];
    _payPriceLabel.centerY = _payTitleLabel.centerY;
}

- (void)updateCellData:(id)cellEntity
{
    OrderDetailDataEntity *orderEntity = cellEntity;
    
    
    // 总金额
    _totalPriceLabel.text = [NSString stringWithFormat:@"%.2f", orderEntity.order.total_price];
    
    // 总数量
    _totalNumberLabel.text = [NSString stringWithFormat:@"%d", (int)orderEntity.order.totalCount];
    
    // 商家折扣金额
    _shopDiscountLabel.text = [NSString stringWithFormat:@"%.2f", orderEntity.order.shop_discount];
    
    // App折扣金额
    _appDiscountLabel.text =  [NSString stringWithFormat:@"%.2f", orderEntity.order.xiuwei_discount];
    
    // 应付金额
    _payPriceLabel.text = [NSString stringWithFormat:@"%.2f", orderEntity.order.pay_actually];
}

@end
