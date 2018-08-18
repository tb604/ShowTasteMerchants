//
//  ShopOrderDetailFooterView.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/4.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopOrderDetailFooterView.h"
#import "LocalCommon.h"
#import "OrderDataEntity.h"
#import "CTCOrderDetailEntity.h"

@interface ShopOrderDetailFooterView ()
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
     *  描述
     */
    UILabel *_descLabel;
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

- (void)initWithDescLabel;

@end

@implementation ShopOrderDetailFooterView

- (void)initWithSubView
{
    [super initWithSubView];
    
    //  “共计”
    [self initWithTotalLabel];
    
    // 菜品总数量
    [self initWithNumberLabel];
    
    // 总金额
    [self initWithTotalPriceLabel];
    
    [self initWithDescLabel];
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
        _totalLabel.text = @"合计";
    }
}

/**
 *  菜品总数量
 */
- (void)initWithNumberLabel
{
    if (!_numberLabel)
    {
        UIImage *image = [UIImage imageNamed:@"hall-order_menu_icon_yishangcai"];
        NSString *str = @"22225";
        if (kiPhone6Plus || kiPhone6)
        {
            str = @"2222225";
        }

        
        
        CGFloat width = [str widthForFont:FONTSIZE_15];
        
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - image.size.width - width*3 - 20 - 5, 10, width, 18);
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
        UIImage *image = [UIImage imageNamed:@"pay_selected"];
        NSString *str = @"￥5555643";
        CGFloat width = [str widthForFont:FONTSIZE_15];
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - width - 15 - image.size.width - 5, 10, width, 18);
        _totalPriceLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentRight];
        //        _totalPriceLabel.backgroundColor = [UIColor lightGrayColor];
    }
}

- (void)initWithDescLabel
{
    if (!_descLabel)
    {
        CGRect frame = CGRectMake(15, _totalLabel.bottom + 5, [[UIScreen mainScreen] screenWidth] - 30, 20);
        _descLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
        _descLabel.numberOfLines = 0;
    }
}

- (void) updateViewData:(id)entity
{
    CTCOrderDetailEntity *orderEnt = entity;
    
    _numberLabel.text = [NSString stringWithFormat:@"%d", (int)orderEnt.totalCount];
    _totalPriceLabel.text = [NSString stringWithFormat:@"%.0f", orderEnt.total_price];
    
    _descLabel.text = orderEnt.foodTotalDesc;
    _descLabel.height = orderEnt.foodTotalDescHeight;
}


@end
