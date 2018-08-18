//
//  DinersOrderDetailFooterView.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/31.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DinersOrderDetailFooterView.h"
#import "LocalCommon.h"
#import "OrderDataEntity.h"

@interface DinersOrderDetailFooterView ()
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
     *  已支付的
     */
    UILabel *_payedLabel;
    
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

- (void)initWithPlayedLabel;

- (void)initWithDescLabel;

@end

@implementation DinersOrderDetailFooterView

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    
    //  “共计”
    [self initWithTotalLabel];
    
    // 菜品总数量
    [self initWithNumberLabel];
    
    // 总金额
    [self initWithTotalPriceLabel];
    
    [self initWithPlayedLabel];
    
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
        _totalLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
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
        
//        NSString *str = @"555";
//        CGFloat width = [str widthForFont:FONTSIZE_13];
        
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - image.size.width - width*3 - 20 - 15+10, 10, width, 18);
        debugLogFrame(frame);
//        CGRect frame = CGRectMake(([[UIScreen mainScreen] screenWidth] - width)/2, 10, width, 18);
        _numberLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentRight];
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
        NSString *str = @"5555643";
        CGFloat width = [str widthForFont:FONTSIZE_13];
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - width - 15 - image.size.width - 5, 10, width, 18);
        _totalPriceLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentRight];
//        _totalPriceLabel.backgroundColor = [UIColor lightGrayColor];
    }
}

- (void)initWithPlayedLabel
{
    if (!_payedLabel)
    {
        CGRect frame = CGRectMake(15, _totalLabel.bottom, [[UIScreen mainScreen] screenWidth] - 30, 16);
        _payedLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentRight];
        _payedLabel.right = _totalPriceLabel.right;
//        _payedLabel.backgroundColor = [UIColor redColor];
    }
}

- (void)initWithDescLabel
{
    if (!_descLabel)
    {
        CGRect frame = CGRectMake(15, _payedLabel.bottom, [[UIScreen mainScreen] screenWidth] - 30, 20);
        _descLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
        _descLabel.numberOfLines = 0;
//        _descLabel.backgroundColor = [UIColor lightGrayColor];
    }
}

- (void) updateViewData:(id)entity
{
    OrderDataEntity *orderEnt = entity;
    
    _numberLabel.text = [NSString stringWithFormat:@"%d", (int)orderEnt.totalCount];
    _totalPriceLabel.text = [NSString stringWithFormat:@"%.0f", orderEnt.total_price];
    
    _descLabel.text = orderEnt.foodTotalDesc;
    _descLabel.height = orderEnt.foodTotalDescHeight;
    
    _payedLabel.text = nil;
    if (orderEnt.type == 1)
    {// 预订就餐
        if (orderEnt.status == NS_ORDER_COMPLETED_BOOKING_STATE)
        {
            _payedLabel.text = [NSString stringWithFormat:@"已预付金额：%.2f", orderEnt.book_deposit_amount];
        }
        else if (orderEnt.status == NS_ORDER_PAY_COMPLETE_STATE)
        {// 支付完成
            _payedLabel.text = [NSString stringWithFormat:@"支付金额：%.0f", (orderEnt.book_deposit_amount+orderEnt.pay_amount)];
        }
    }
    else if (orderEnt.type == 2)
    {// 即时就餐
//        debugLog(@"order=%@", [orderEnt modelToJSONString]);
        _payedLabel.text = [NSString stringWithFormat:@"支付金额：%.0f", (orderEnt.book_deposit_amount+orderEnt.pay_amount)];
    }
    
    
    
}

@end


















