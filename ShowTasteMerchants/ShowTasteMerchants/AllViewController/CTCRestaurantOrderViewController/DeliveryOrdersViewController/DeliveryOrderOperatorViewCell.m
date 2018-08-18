//
//  DeliveryOrderOperatorViewCell.m
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/17.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DeliveryOrderOperatorViewCell.h"
#import "LocalCommon.h"
#import "HungryOrderDetailEntity.h"

@interface DeliveryOrderOperatorViewCell ()

@property (nonatomic, strong) UIButton *btnCancel;

@property (nonatomic, strong) UIButton *btnSubmit;

/// 配送成本
@property (nonatomic, strong) UILabel *shippingCostLabel;

@property (nonatomic, assign) NSInteger orderType;

@property (nonatomic, strong) HungryOrderDetailEntity *orderDetailEntity;


- (void)initWithBtnSubmit;

- (void)initWithBtnCancel;

/**
 *  配送成本
 */
- (void)initWithShippingCostLabel;

@end

@implementation DeliveryOrderOperatorViewCell

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

- (void)initWithBtnSubmit
{
    if (!_btnSubmit)
    {
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - 10 - 75, (kDeliveryOrderOperatorViewCellHeight-25)/2., 75, 25);
        
        _btnSubmit = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"确认订单" titleColor:[UIColor colorWithHexString:@"#ff5500"] titleFont:FONTSIZE_12 targetSel:@selector(clickedWithButton:)];
        _btnSubmit.frame = frame;
        _btnSubmit.layer.borderColor = [UIColor colorWithHexString:@"#ff5500"].CGColor;
        _btnSubmit.layer.borderWidth = 1;
        [self.contentView addSubview:_btnSubmit];
    }
    _btnSubmit.hidden = YES;
    if (_orderType == EN_TM_ORDER_WAIT_ORDER)
    {// 待接单
        _btnSubmit.hidden = NO;
        [_btnSubmit setTitle:@"确认订单" forState:UIControlStateNormal];
        [_btnSubmit setTitleColor:[UIColor colorWithHexString:@"#ff5500"] forState:UIControlStateNormal];
        _btnSubmit.layer.borderColor = [UIColor colorWithHexString:@"#ff5500"].CGColor;
    }
    else if (_orderType == EN_TM_ORDER_RECEIVE_ORDER)
    {// 已接单
        _btnSubmit.hidden = NO;
        [_btnSubmit setTitle:@"呼叫达达" forState:UIControlStateNormal];
        [_btnSubmit setTitleColor:[UIColor colorWithHexString:@"#ff5500"] forState:UIControlStateNormal];
        _btnSubmit.layer.borderColor = [UIColor colorWithHexString:@"#ff5500"].CGColor;
    }
    else if (_orderType == EN_TM_ORDER_SHIP_NOT_ORDER)
    {// 配送未接单
        _btnSubmit.hidden = NO;
        [_btnSubmit setTitle:@"增加小费" forState:UIControlStateNormal];
        [_btnSubmit setTitleColor:[UIColor colorWithHexString:@"#646464"] forState:UIControlStateNormal];
        _btnSubmit.layer.borderColor = [UIColor colorWithHexString:@"#646464"].CGColor;
    }
    else if (_orderType == EN_TM_ORDER_EXCEPTION_ORDER)
    {// 异常订单
        if (_orderDetailEntity.refund_code == REFUND_STATUS_LATER_REFUND_REQUEST)
        {// 用户申请退单
            _btnSubmit.hidden = NO;
            [_btnSubmit setTitle:@"确认退款" forState:UIControlStateNormal];
            [_btnSubmit setTitleColor:[UIColor colorWithHexString:@"#646464"] forState:UIControlStateNormal];
            _btnSubmit.layer.borderColor = [UIColor colorWithHexString:@"#646464"].CGColor;
        }
        else if (_orderDetailEntity.refund_code == REFUND_STATUS_LATER_REFUND_SUCCESS && _orderDetailEntity.deliver_status != 0)
        {// 退款成功、有配送
            _btnSubmit.hidden = NO;
            [_btnSubmit setTitle:@"取消配送" forState:UIControlStateNormal];
            [_btnSubmit setTitleColor:[UIColor colorWithHexString:@"#646464"] forState:UIControlStateNormal];
            _btnSubmit.layer.borderColor = [UIColor colorWithHexString:@"#646464"].CGColor;
        }
        
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


- (void)initWithBtnCancel
{
    if (!_btnCancel)
    {
        CGRect frame = _btnSubmit.frame;
        frame.origin.x = _btnSubmit.left - 15 - frame.size.width;
        _btnCancel = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"取消订单" titleColor:[UIColor colorWithHexString:@"#646464"] titleFont:FONTSIZE_12 targetSel:@selector(clickedWithButton:)];
        _btnCancel.frame = frame;
        _btnCancel.layer.borderColor = [UIColor colorWithHexString:@"#646464"].CGColor;
        _btnCancel.layer.borderWidth = 1;
        [self.contentView addSubview:_btnCancel];
    }
    _btnCancel.hidden = YES;
    if (_orderType == EN_TM_ORDER_WAIT_ORDER)
    {// 待接单
        _btnCancel.hidden = NO;
        [_btnCancel setTitle:@"取消订单" forState:UIControlStateNormal];
    }
    else if (_orderType == EN_TM_ORDER_SHIP_NOT_ORDER)
    {// 配送未接单
        _btnCancel.hidden = NO;
        [_btnCancel setTitle:@"取消达达" forState:UIControlStateNormal];
    }
}

/**
 *  配送成本
 */
- (void)initWithShippingCostLabel
{
    if (!_shippingCostLabel)
    {
        CGRect frame = CGRectMake(10, (kDeliveryOrderOperatorViewCellHeight - 16)/2., _btnCancel.left - 20, 16);
        _shippingCostLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    
    _shippingCostLabel.hidden = YES;
    if (_orderType == EN_TM_ORDER_SHIP_NOT_ORDER)
    {// 配送未接单
        _shippingCostLabel.hidden = NO;
        _shippingCostLabel.text = [NSString stringWithFormat:@"配送成本：￥%.2f", _orderDetailEntity.deliver_fee];
    }
    else if (_orderType == EN_TM_ORDER_EXCEPTION_ORDER && _orderDetailEntity.refund_code == REFUND_STATUS_LATER_REFUND_REQUEST)
    {// 用户申请退单
        _shippingCostLabel.hidden = NO;
        _shippingCostLabel.text = [NSString stringWithFormat:@"配送成本：￥%.2f", _orderDetailEntity.deliver_fee];
    }
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
    
    [self initWithBtnSubmit];
    
    [self initWithBtnCancel];
    
    // 配送成本
    [self initWithShippingCostLabel];
}

@end















