//
//  ShopAccountStatementMoneyFooterView.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/7.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopAccountStatementMoneyFooterView.h"
#import "LocalCommon.h"
#import "OrderDataEntity.h"
#import "CTCMealOrderDetailsEntity.h"

@interface ShopAccountStatementMoneyFooterView ()
{
    /**
     *  “共计”
     */
    UILabel *_totalLabel;
    
    /**
     *  菜品总数量
     */
    UILabel *_numberLabel;
    
    /**
     *  总金额
     */
    UILabel *_totalPriceLabel;
    
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
 *  “共计”
 */
- (void)initWithTotalLabel;

/**
 *  菜品总数量
 */
- (void)initWithNumberLabel;

/**
 *  总金额
 */
- (void)initWithTotalPriceLabel;

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

@implementation ShopAccountStatementMoneyFooterView


- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    
    //  “共计”
    [self initWithTotalLabel];
    
    // 菜品总数量
    [self initWithNumberLabel];
    
    // 总金额
    [self initWithTotalPriceLabel];
    
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
 *  “共计”
 */
- (void)initWithTotalLabel
{
    if (!_totalLabel)
    {
        CGRect frame = CGRectMake(15, 10, 60, 18);
        _totalLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
        _totalLabel.text = @"合计：";
    }
}

/**
 *  菜品总数量
 */
- (void)initWithNumberLabel
{
    if (!_numberLabel)
    {
//        UIImage *image = [UIImage imageNamed:@"hall-order_menu_icon_yishangcai"];
//        NSString *str = @"22225";
//        if (kiPhone6Plus)
//        {
//            str = @"2222225";
//        }
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
        
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - width*3 - 15 - 15, 10, width, 18);
        _numberLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentRight];
    }
}

/**
 *  总金额
 */
- (void)initWithTotalPriceLabel
{
    if (!_totalPriceLabel)
    {
        NSString *str = @"￥5555643";
        CGFloat width = [str widthForFont:FONTSIZE_15];
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - width - 15, 10, width, 18);
        _totalPriceLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentRight];
        //        _totalPriceLabel.backgroundColor = [UIColor lightGrayColor];
    }
}

/**
 *  “商家折扣（减预付款）”
 */
- (void)initWithShopTitleLabel
{
    NSString *str = @"商家折扣：";
    CGFloat width = [str widthForFont:FONTSIZE_15];
    CGRect frame = CGRectMake(15, _totalLabel.bottom + 5, width, 20);
    _shopTitleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
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
    _shopDiscountLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentRight];
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
    _appTitleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
    _appTitleLabel.text = str;
}

/**
 *  App折扣金额
 */
- (void)initWithAppDiscountLabel
{
    CGRect frame = _shopDiscountLabel.frame;
    _appDiscountLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentRight];
    _appDiscountLabel.centerY = _appTitleLabel.centerY;
}

/**
 *  “应付：”
 */
- (void)initWithPayTitleLabel
{
    NSString *str = @"应付：";
    CGFloat width = [str widthForFont:FONTSIZE_15];
    CGRect frame = CGRectMake(15, _totalPriceLabel.bottom + 5, width, 20);
    _payTitleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
    _payTitleLabel.text = str;
}

/**
 *  应付金额
 */
- (void)initWithPayPriceLabel
{
    CGRect frame = _totalPriceLabel.frame;
    _payPriceLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentRight];
    _payPriceLabel.centerY = _payTitleLabel.centerY;
}


- (void) updateViewData:(id)entity
{
    CTCMealOrderDetailsEntity *orderEnt = entity;
    
    // 菜品总数量
//    _numberLabel.text = [NSString stringWithFormat:@"%d", (int)orderEnt.totalCount];
//    _totalPriceLabel.text = [NSString stringWithFormat:@"%.2f", orderEnt.total_price];
    
    // 商家折扣金额
//    _shopDiscountLabel.text = [NSString stringWithFormat:@"%.2f", orderEnt.shop_discount];
    
    // App折扣金额
//    _appDiscountLabel.text =  [NSString stringWithFormat:@"%.2f", orderEnt.xiuwei_discount];
    
    // 应付金额
//    _payPriceLabel.text = [NSString stringWithFormat:@"%.2f", orderEnt.pay_amount];
}



@end
