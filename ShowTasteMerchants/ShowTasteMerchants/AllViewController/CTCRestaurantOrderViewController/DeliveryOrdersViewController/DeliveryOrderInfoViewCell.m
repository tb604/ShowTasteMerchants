//
//  DeliveryOrderInfoViewCell.m
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/17.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DeliveryOrderInfoViewCell.h"
#import "LocalCommon.h"
#import "HungryOrderDetailEntity.h"
#import "DeliveryOrderInfoChargeView.h"

@interface DeliveryOrderInfoViewCell ()
{
    /// 展开、收取
    DeliveryOrderInfoChargeView *_chargeButton;
    
    /// 下单时间
    UILabel *_placeOrderTimeLabel;
    
    /// 期望时间
    UILabel *_deliverTimeLabel;
    
    /// 订单总计
    UILabel *_totalPriceLabel;
    
    NSInteger _orderType;
}

@property (nonatomic, strong) HungryOrderDetailEntity *orderDetailEntity;

/**
 *  收取、展开
 */
- (void)initWithChargeButton;

/**
 *  下单时间
 */
- (void)initWithPlaceOrderTimeLabel;

/**
 *  期望时间
 */
- (void)initWithDeliverTimeLabel;

/**
 *  订单总计
 */
- (void)initWithTotalPriceLabel;

@end

@implementation DeliveryOrderInfoViewCell

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
    
    // 收取、展开
    [self initWithChargeButton];
}

/**
 *  收取、展开
 */
- (void)initWithChargeButton
{
    if (!_chargeButton)
    {
        UIImage *image = [UIImage imageWithContentsOfFileName:@"btn_takeout_sprend.png"];
        NSString *str = @"展开";
        float width = [str widthForFont:FONTSIZE_12] + image.size.width + 5;
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - 10 - width, 0, width, 30);
        _chargeButton = [[DeliveryOrderInfoChargeView alloc] initWithFrame:frame];
        [self.contentView addSubview:_chargeButton];
    }
    __weak typeof(self)weakSelf = self;
    _chargeButton.touchChargeBlock = ^()
    {
        if (weakSelf.touchChargeBlock)
        {
            weakSelf.touchChargeBlock();
        }
    };
    _chargeButton.hidden = NO;
    if (_orderType == EN_TM_ORDER_EXCEPTION_ORDER)
    {
        _chargeButton.hidden = YES;
    }
}

/**
 *  下单时间
 */
- (void)initWithPlaceOrderTimeLabel
{
    if (!_placeOrderTimeLabel)
    {
        CGRect frame = CGRectMake(10, 8, [[UIScreen mainScreen] screenWidth] - 20, 16);
        _placeOrderTimeLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    NSString *payDate = [NSDate stringWithDateInOut:objectNull(_orderDetailEntity.created_at) inFormat:@"yyyy-MM-dd HH:mm:ss" outFormat:@"yyyy-MM-dd HH:mm"];
    _placeOrderTimeLabel.text = [NSString stringWithFormat:@"下单时间：%@", payDate];
}

/**
 *  期望时间
 */
- (void)initWithDeliverTimeLabel
{
    if (!_deliverTimeLabel)
    {
        CGRect frame = _placeOrderTimeLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _deliverTimeLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    NSString *payDate = objectNull([NSDate stringWithDateInOut:objectNull(_orderDetailEntity.deliver_time) inFormat:@"yyyy-MM-dd HH:mm:ss" outFormat:@"yyyy-MM-dd HH:mm"]);
    _deliverTimeLabel.text = [NSString stringWithFormat:@"期望时间：%@", payDate];
    _deliverTimeLabel.hidden = NO;
    if (_orderDetailEntity.invalid_type == TYPE_SYSTEM_AUTO_CANCEL)
    {// 系统自动取消订单
        _deliverTimeLabel.hidden = YES;
    }
    
    if (_orderDetailEntity.refund_code == REFUND_STATUS_LATER_REFUND_REQUEST)
    {// 用户申请退单
        // 取消时间
        // 没有取消时间字段
        _deliverTimeLabel.text = [NSString stringWithFormat:@"取消时间：%@", @"没有取消时间"];
    }
    
    if (_orderDetailEntity.refund_code == REFUND_STATUS_LATER_REFUND_SUCCESS && _orderDetailEntity.deliver_status != 0)
    {// 退款成功、有配送
        _deliverTimeLabel.text = [NSString stringWithFormat:@"取消时间：%@", @"没有取消时间"];
    }
}

/**
 *  订单总计
 */
- (void)initWithTotalPriceLabel
{
    if (!_totalPriceLabel)
    {
        CGRect frame = _deliverTimeLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _totalPriceLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    
    CGRect frame = CGRectZero;
    if (_orderDetailEntity.invalid_type == TYPE_SYSTEM_AUTO_CANCEL)
    {// 系统自动取消订单
        frame = _placeOrderTimeLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
    }
    else
    {
        frame = _deliverTimeLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
    }
    _totalPriceLabel.frame = frame;
    
    if (_orderDetailEntity.refund_code == REFUND_STATUS_LATER_REFUND_SUCCESS && _orderDetailEntity.deliver_status != 0)
    {// 退款成功、有配送
        _totalPriceLabel.text = [NSString stringWithFormat:@"退款款金额：%.2f", _orderDetailEntity.total_price];
    }
    
    if (_orderDetailEntity.refund_code == REFUND_STATUS_LATER_REFUND_REQUEST)
    {// 用户申请退单
        // 没有退款金额字段
        _totalPriceLabel.text = [NSString stringWithFormat:@"退款款金额：%.2f", _orderDetailEntity.total_price];
    }
    else
    {
        _totalPriceLabel.text = [NSString stringWithFormat:@"订单总计：%.2f", _orderDetailEntity.total_price];
    }
}


- (void)updateCellData:(id)cellEntity
{
    self.orderDetailEntity = cellEntity;
    
    [self initWithChargeButton];
    
    // 下单时间
    [self initWithPlaceOrderTimeLabel];
    
    // 期望时间
    [self initWithDeliverTimeLabel];
    
    // 订单总计
    [self initWithTotalPriceLabel];
    
    [_chargeButton updateWithCharge:_orderDetailEntity.isCharge];
    
}

- (void)updateCellData:(id)cellEntity orderType:(NSInteger)orderType
{
    _orderType = orderType;
    [self updateCellData:cellEntity];
}

@end
