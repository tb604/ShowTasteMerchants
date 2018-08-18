//
//  DeliveryOrderUserBaseInfoCell.m
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/17.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DeliveryOrderUserBaseInfoCell.h"
#import "LocalCommon.h"
#import "HungryOrderDetailEntity.h"

@interface DeliveryOrderUserBaseInfoCell ()
{
    /// 状态
    UILabel *_stateLabel;
    
    /// 图标(不同平台的图标)
    UIImageView *_thumalImgView;
    
    /// 订单id
    UILabel *_orderIdLabel;
    
    /// 姓名和电话号码
    UILabel *_namePhoneLabel;
    
    /// 送餐地址
    UILabel *_addressLabel;
}

@property (nonatomic, assign) NSInteger orderType;

@property (nonatomic, strong) CALayer *line;

@property (nonatomic, strong) HungryOrderDetailEntity *orderDetailEntity;

- (void)initWithStateLabel;

- (void)initWithThumalImgView;

- (void)initWithOrderIdLabel;

/**
 *  姓名和电话号码
 */
- (void)initWithNamePhoneLabel;

/**
 *  送餐地址
 */
- (void)initWithAddressLabel;


@end

@implementation DeliveryOrderUserBaseInfoCell

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
    
    CALayer *line = [CALayer drawLine:self.contentView frame:CGRectMake(0, 30, [[UIScreen mainScreen] screenWidth], 0.5) lineColor:[UIColor colorWithHexString:@"#cbcbcb"]];
    self.line = line;
    
    
}

- (void)initWithStateLabel
{
    if (!_stateLabel)
    {
        NSString *str = @"已付款待确认";
        float width = [str widthForFont:FONTSIZE_12];
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - 10 - width, (_line.top - 20)/2., width, 20);
        _stateLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentRight];
    }
//    _stateLabel.text = @"已付款待确认";
    
    if (_orderType == EN_TM_ORDER_WAIT_ORDER)
    {// 待接单
        _stateLabel.text = @"已付款待确认";
    }
    else if (_orderType == EN_TM_ORDER_RECEIVE_ORDER)
    {// 已接单
        _stateLabel.text = @"已确认接单";
    }
    else if (_orderType == EN_TM_ORDER_SHIP_NOT_ORDER)
    {// 配送未接单
        _stateLabel.text = @"接单中";
    }
    else if (_orderType == EN_TM_ORDER_PICKUP_ORDER)
    {// 取货中
        _stateLabel.text = @"取货中";
    }
    else if (_orderType == EN_TM_ORDER_DIST_RESULT_ORDER)
    {// 配送结果
        // state 配送中、配送完成
        
        if (_orderDetailEntity.cs_status_code == DELIVERY_STATUS_DELIVERING)
        {
            _stateLabel.text = @"配送中";
        }
        else if (_orderDetailEntity.cs_status_code == DELIVERY_STATUS_COMPLETED)
        {
            _stateLabel.text = @"配送完成";
        }
        else
        {
            _stateLabel.text = @"配送完成";
        }
    }
    else
    {
        if (_orderDetailEntity.invalid_type == TYPE_SYSTEM_AUTO_CANCEL)
        {// 系统自动取消订单
            _stateLabel.text = @"超时取消";
        }
        if (_orderDetailEntity.refund_code == REFUND_STATUS_LATER_REFUND_REQUEST)
        {
            _stateLabel.text = @"待退款";
        }
        if (_orderDetailEntity.refund_code == REFUND_STATUS_LATER_REFUND_SUCCESS && _orderDetailEntity.deliver_status != 0)
        {// 退单成功 有配送
            _stateLabel.text = @"待取消配送";
        }
    }
}

- (void)initWithThumalImgView
{
    if (!_thumalImgView)
    {
        CGRect frame = CGRectMake(10, (_line.top - 15)/2., 15, 15);
        _thumalImgView = [[UIImageView alloc] initWithFrame:frame];
        _thumalImgView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_thumalImgView];
    }
    
    // _thumalImgView
    UIImage *image = nil;
    if (_orderDetailEntity.provider == EN_ORDER_SOURCE_ELE)
    {// 饿了么
        image = [UIImage imageWithContentsOfFileName:@"icon_elm.png"];
    }
    else if (_orderDetailEntity.provider == EN_ORDER_SOURCE_MEITUAN)
    {// 美团
        image = [UIImage imageWithContentsOfFileName:@"icon_meituan.png"];
    }
    _thumalImgView.image = image;
    // icon_elm
    // icon_meituan
    
}

- (void)initWithOrderIdLabel
{
    if (!_orderIdLabel)
    {
        CGRect frame = CGRectMake(_thumalImgView.right + 5, (_line.top - 20)/2., _stateLabel.left - _thumalImgView.right - 5 - 10, 20);
        _orderIdLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    _orderIdLabel.text = [NSString stringWithFormat:@"%lld", (long long)_orderDetailEntity.order_id];
    // 101582797453145710
}

/**
 *  姓名和电话号码
 */
- (void)initWithNamePhoneLabel
{
    if (!_namePhoneLabel)
    {
        CGRect frame = CGRectMake(10, _line.bottom + 8, [[UIScreen mainScreen] screenWidth], 16);
        _namePhoneLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    
    NSString *phone = @"";
    for (NSString *mobile in _orderDetailEntity.phone_list)
    {
        phone = mobile;
    }
    
    _namePhoneLabel.text = [NSString stringWithFormat:@"%@，%@", _orderDetailEntity.consignee, phone];
    
}

/**
 *  送餐地址
 */
- (void)initWithAddressLabel
{
    if (!_addressLabel)
    {
        CGRect frame = _namePhoneLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _addressLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
        _addressLabel.numberOfLines = 0;
    }
    _addressLabel.height = _orderDetailEntity.addressHeight;
    _addressLabel.text = objectNull(_orderDetailEntity.address);
}

- (void)updateCellData:(id)cellEntity
{
    self.orderDetailEntity = cellEntity;
    
    [self initWithStateLabel];
    
    [self initWithThumalImgView];
    
    [self initWithOrderIdLabel];
    
    // 姓名和电话号码
    [self initWithNamePhoneLabel];
    
    // 送餐地址
    [self initWithAddressLabel];
}

- (void)updateCellData:(id)cellEntity orderType:(NSInteger)orderType
{
    self.orderType = orderType;
    
    [self updateCellData:cellEntity];
    
}

@end










