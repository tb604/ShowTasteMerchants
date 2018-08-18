//
//  UserPayWayPriceDescCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/29.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "UserPayWayPriceDescCell.h"
#import "LocalCommon.h"
#import "OrderDetailDataEntity.h"

@interface UserPayWayPriceDescCell ()
{
//    UILabel *_bookPriceLabel;
    
//    UILabel *_totalPriceLabel;
    
    UILabel *_priceLabel;
    
    UILabel *_descLabel;
}

//- (void)initWithBookPriceLabel;

//- (void)initWithTotalPriceLabel;

- (void)initWithPriceLabel;

- (void)initWithDescLabel;

@end

@implementation UserPayWayPriceDescCell

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
//    [self initWithBookPriceLabel];
    
//    [self initWithTotalPriceLabel];
    
    [self initWithPriceLabel];
    
    [self initWithDescLabel];
    
}

/*- (void)initWithBookPriceLabel
{
    if (!_bookPriceLabel)
    {
        CGRect frame = CGRectMake(15, (kUserPayWayPriceDescCellHeight - 20) / 2, [[UIScreen mainScreen] screenWidth] - 30, 20);
        _bookPriceLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_17 labelTag:0 alignment:NSTextAlignmentCenter];
    }
}

- (void)initWithTotalPriceLabel
{
    if (!_totalPriceLabel)
    {
        CGRect frame = _bookPriceLabel.frame;
        _totalPriceLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE(18) labelTag:0 alignment:NSTextAlignmentCenter];
        _totalPriceLabel.bottom = _bookPriceLabel.top - 10;
    }
}*/

- (void)initWithPriceLabel
{
    if (!_priceLabel)
    {
        CGRect frame = CGRectMake(20, (kUserPayWayPriceDescCellHeight - 20)/2, [[UIScreen mainScreen] screenWidth] - 40, 20);
        _priceLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_18 labelTag:0 alignment:NSTextAlignmentCenter];
    }
}

- (void)initWithDescLabel
{
    if (!_descLabel)
    {
        CGRect frame = CGRectMake(15, (kUserPayWayPriceDescCellHeight - 20)/2, [[UIScreen mainScreen] screenWidth] - 30, 20);
        _descLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE(12) labelTag:0 alignment:NSTextAlignmentCenter];
        _descLabel.top = _priceLabel.bottom + 5;
        _descLabel.text = @"预付订金为点菜总金额的20%";
    }
}

- (void)updateCellData:(id)cellEntity
{
    OrderDetailDataEntity *orderEnt = cellEntity;
    _descLabel.hidden = YES;
    if (orderEnt.order.type == 1)
    {// 预订
        if (orderEnt.order.status == NS_ORDER_WAITING_PAY_DEPOSIT_STATE)
        {// 支付订金
            _priceLabel.text = [NSString stringWithFormat:@"￥%.2f", orderEnt.order.book_deposit_amount];
            _descLabel.text = @"预付订金为点菜总金额的20%";
            _descLabel.hidden = NO;
        }
        else if (orderEnt.order.status == NS_ORDER_IN_CHECKOUT_STATE)
        {// 吃饭后支付
            _priceLabel.text = [NSString stringWithFormat:@"￥%.2f", orderEnt.order.pay_actually];
        }
    }
    else if (orderEnt.order.type == 2)
    {// 即时
        if (orderEnt.order.status == NS_ORDER_IN_CHECKOUT_STATE)
        {
            _priceLabel.text = [NSString stringWithFormat:@"￥%.2f", orderEnt.order.pay_actually];
        }
    }
}

@end
















