//
//  DeliveryOrderDistributionViewCell.m
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/17.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DeliveryOrderDistributionViewCell.h"
#import "LocalCommon.h"
#import "HungryOrderDetailEntity.h"

@interface DeliveryOrderDistributionViewCell ()
{
    /// 改发达达
    UIButton *_btnChange;
    
    /// (骑手接单时间)
    UILabel *_deliveryDateLabel;
    
    /// (骑手电话)
    UILabel *_deliveryPhoneLabel;
    
    /// 配送成本
    UILabel *_deliverFeeLabel;
}

@property (nonatomic, strong) HungryOrderDetailEntity *orderDetailEntity;

@property (nonatomic, assign) NSInteger orderType;

- (void)initWithBtnChange;

/**
 *  (骑手接单时间)
 */
- (void)initWithDeliveryDateLabel;

/**
 *  (骑手电话)
 */
- (void)initWithDeliveryPhoneLabel;


/**
 *  配送成本
 */
- (void)initWithDeliverFeeLabel;

@end

@implementation DeliveryOrderDistributionViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    [CALayer drawLine:self.contentView frame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], 0.5) lineColor:[UIColor colorWithHexString:@"#e1e1e1"]];
    
}

- (void)initWithBtnChange
{
    if (!_btnChange)
    {
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - 10 - 75, 0, 75, 25);
        _btnChange = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"改发达达" titleColor:[UIColor colorWithHexString:@"#646464"] titleFont:FONTSIZE_12 targetSel:@selector(clickedWithButton:)];
        _btnChange.frame = frame;
        _btnChange.layer.borderColor = [UIColor colorWithHexString:@"#646464"].CGColor;
        _btnChange.layer.borderWidth = 1;
        _btnChange.bottom = kDeliveryOrderDistributionViewCellHeight - 10;
        [self.contentView addSubview:_btnChange];
    }
    _btnChange.hidden = YES;
    if (_orderType == EN_TM_ORDER_PICKUP_ORDER)
    {// 取货中
        _btnChange.hidden = NO;
    }
}

/*
 EN_TM_ORDER_WAIT_ORDER = 0,     ///< 待接单
 EN_TM_ORDER_RECEIVE_ORDER,      ///< 已接单
 EN_TM_ORDER_SHIP_NOT_ORDER,     ///< 配送未接单
 EN_TM_ORDER_PICKUP_ORDER,       ///< 取货中
 EN_TM_ORDER_DIST_RESULT_ORDER,  ///< 配送结果
 EN_TM_ORDER_EXCEPTION_ORDER,    ///< 异常订单
 */

/**
 *  (骑手接单时间)
 */
- (void)initWithDeliveryDateLabel
{
    if (!_deliveryDateLabel)
    {
        CGRect frame = CGRectMake(10, 8, [[UIScreen mainScreen] screenWidth] - 20 , 16);
        _deliveryDateLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    _deliveryDateLabel.text = [NSString stringWithFormat:@"配送接单时间：%@", @"2016-11-12 15:32"];
}

/**
 *  (骑手电话)
 */
- (void)initWithDeliveryPhoneLabel
{
    if (!_deliveryPhoneLabel)
    {
        CGRect frame = _deliveryDateLabel.frame;
        frame.size.width = _btnChange.left - 20;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _deliveryPhoneLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    _deliveryPhoneLabel.text = [NSString stringWithFormat:@"配送接单电话：%@", @"18261929604"];
}


/**
 *  配送成本
 */
- (void)initWithDeliverFeeLabel
{
    if (!_deliverFeeLabel)
    {
        CGRect frame = _deliveryPhoneLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _deliverFeeLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    _deliverFeeLabel.text = [NSString stringWithFormat:@"配   送  成  本：￥%.2f", _orderDetailEntity.deliver_fee];
}


- (void)clickedWithButton:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSString *title = btn.titleLabel.text;
    if (self.baseTableViewCellBlock)
    {
        self.baseTableViewCellBlock(title);
    }
}

- (void)updateCellData:(id)cellEntity orderType:(NSInteger)orderType
{
    self.orderDetailEntity = cellEntity;
    self.orderType = orderType;
    
    [self initWithBtnChange];
    
    // (骑手接单时间)
    [self initWithDeliveryDateLabel];
    
    // (骑手电话)
    [self initWithDeliveryPhoneLabel];
    
    
    // 配送成本
    [self initWithDeliverFeeLabel];
}

@end
