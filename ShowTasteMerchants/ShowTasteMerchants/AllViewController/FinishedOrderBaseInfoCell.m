//
//  FinishedOrderBaseInfoCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/13.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "FinishedOrderBaseInfoCell.h"
#import "LocalCommon.h"


@interface FinishedOrderBaseInfoCell ()
{
    /// 包间、房号
    UILabel *_seatTableLabel;
    
    /// 订单来源 “服”、“客”
    UILabel *_orderSourceLabel;
    
    /**
     *  订单编号
     */
    UILabel *_orderNoLabel;
    
    /// 下单时间
    UILabel *_placeOrderTimeLabel;
    
    /**
     *  就餐人数
     */
    UILabel *_numberLabel;
    
    /// 账单金额
    UILabel *_billAmountLabel;
    
    /**
     *  实付金额
     */
    UILabel *_amountLabel;
    
    /**
     *  支付方式
     */
    UILabel *_payTypeLabel;
    
    /// 备注
    UILabel *_noteLabel;
}



@property (nonatomic, strong) CTCOrderDetailEntity *orderEntity;

@property (nonatomic, strong) CALayer *line;

/**
 *  包间房号
 */
- (void)initWithSeatTableLabel;

/***
 *  订单来源 “服”、“客”
 */
- (void)initWithOrderSourceLabel;

/**
 *  订单编号
 */
- (void)initWithOrderNoLabel;

/**
 *  下单时间
 */
- (void)initWithPlaceOrderTimeLabel;

/**
 *  就餐人数
 */
- (void)initWithNumberLabel;

/**
 *  账单金额
 */
- (void)initWithBillAmountLabel;

/**
 *  实付金额
 */
- (void)initWithAmountLabel;

/**
 *  支付方式
 */
- (void)initWithPayTypeLabel;

/**
 *  备注
 */
- (void)initWithNoteLabel;

@end

@implementation FinishedOrderBaseInfoCell

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
    
    self.backgroundView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    self.contentView.backgroundColor =  [UIColor colorWithHexString:@"#ffffff"];
    self.backgroundColor =  [UIColor colorWithHexString:@"#ffffff"];
    
    
    CALayer *line = [CALayer drawLine:self.contentView frame:CGRectMake(0, 50.0, [[UIScreen mainScreen] screenWidth], 0.5) lineColor:[UIColor colorWithHexString:@"#cdcdcd"]];
    self.line = line;
    
}


- (NSAttributedString *)attributedTextTitle:(NSString *)title value:(NSString *)value valueColor:(UIColor *)valueColor
{
    NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] init];
    UIColor *color = [UIColor colorWithHexString:@"#646464"];
    NSAttributedString *bTitle = [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName: FONTSIZE(13), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:bTitle];
    
    if (valueColor)
    {
        color = valueColor;
    }
    else
    {
        color = [UIColor colorWithHexString:@"#323232"];
    }
    NSAttributedString *bValue = [[NSAttributedString alloc] initWithString:value attributes:@{NSFontAttributeName: FONTSIZE(13), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:bValue];
    
    return mas;
}

/**
 *  订单编号
 */
/*- (void)initWithOrderNoLabel
{
    if (!_orderNoLabel)
    {
        CGRect frame = _shopNameLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _orderNoLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    
    _orderNoLabel.attributedText = [self attributedTextTitle:@"订单编号：" value:objectNull(_orderEntity.order_id) valueColor:nil];
}*/

/**
 *  到店时间
 */
/*- (void)initWithArriveDateLabel
{
    if (!_arriveDateLabel)
    {
        CGRect frame = _orderNoLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _arriveDateLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    NSString *date = [NSDate stringWithDateInOut:_orderEntity.dining_date inFormat:@"yyyy-MM-dd HH:mm:ss" outFormat:@"yyyy-MM-dd HH:mm"];
    _arriveDateLabel.attributedText = [self attributedTextTitle:@"到店时间：" value:objectNull(date) valueColor:nil];
}*/

/**
 *  餐桌类型
 */
/*- (void)initWithTableTypeLabel
{
    if (!_tableTypeLabel)
    {
        CGRect frame = _arriveDateLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _tableTypeLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    NSString *strNum = [NSString stringWithFormat:@"%ld人桌", _orderEntity.number];
    _tableTypeLabel.attributedText = [self attributedTextTitle:@"餐桌类型：" value:objectNull(strNum) valueColor:nil];
}*/

/**
 *  餐厅位置
 */
/*- (void)initWithShopLocationLabel
{
    if (!_shopLocationLabel)
    {
        CGRect frame = _tableTypeLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _shopLocationLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    NSString *lo = [NSString stringWithFormat:@"%@（%@）", _orderEntity.seat_type_desc, _orderEntity.seat_number];
    _shopLocationLabel.attributedText = [self attributedTextTitle:@"餐厅位置：" value:lo valueColor:nil];
}*/

/**
 *  订金支付
 */
/*- (void)initWithDepositPayLabel
{
    if (!_depositPayLabel)
    {
        CGRect frame = _shopLocationLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _depositPayLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    
    NSString *am = [NSString stringWithFormat:@"%.2f元", _orderEntity.book_deposit_amount];
    _depositPayLabel.attributedText = [self attributedTextTitle:@"订金支付：" value:am valueColor:[UIColor colorWithHexString:@"#ff5500"]];
}*/

/**
 *  支付金额
 */
/*- (void)initWithAmountLabel
{
    if (!_amountLabel)
    {
        CGRect frame = _depositPayLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _amountLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    NSString *am = [NSString stringWithFormat:@"%.2f元", _orderEntity.pay_actually];
    _amountLabel.attributedText = [self attributedTextTitle:@"实付金额：" value:am valueColor:[UIColor colorWithHexString:@"#ff5500"]];
}*/

/**
 *  本次消费
 */
/*- (void)initWithConsumeAmountLabel
{
    if (!_consumeAmountLabel)
    {
        CGRect frame = _amountLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _consumeAmountLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    
    NSString *am = [NSString stringWithFormat:@"%.2f元", (_orderEntity.book_deposit_amount+_orderEntity.pay_actually)];
    _consumeAmountLabel.attributedText = [self attributedTextTitle:@"本次消费：" value:am valueColor:[UIColor colorWithHexString:@"#ff5500"]];
}*/

/**
 *  支付方式
 */
/*- (void)initWithPayTypeLabel
{
    if (!_payTypeLabel)
    {
        CGRect frame = _consumeAmountLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _payTypeLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    }
//    _orderEntity.pay_channel_desc
    _payTypeLabel.attributedText = [self attributedTextTitle:@"支付方式：" value:objectNull(_orderEntity.pay_channel_desc) valueColor:nil];
}*/

/**
 *  支付时间
 */
/*- (void)initWithPayDateLabel
{
    if (!_payDateLabel)
    {
        CGRect frame = _payTypeLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _payDateLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    NSString *payDate = [NSDate stringWithDateInOut:_orderEntity.pay_date inFormat:@"yyyy-MM-dd HH:mm:ss" outFormat:@"yyyy-MM-dd HH:mm"];
    _payDateLabel.attributedText = [self attributedTextTitle:@"支付时间：" value:objectNull(payDate) valueColor:nil];
}*/

/**
 *  包间房号
 */
- (void)initWithSeatTableLabel
{
    if (!_seatTableLabel)
    {
        CGRect frame = CGRectMake(15, (_line.top - 20)/2., 0, 20);
        _seatTableLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE(18) labelTag:0 alignment:NSTextAlignmentLeft];
    }
    NSString *str = [NSString stringWithFormat:@"%@ | %@", objectNull(_orderEntity.seat_type_desc), objectNull(_orderEntity.seat_number)];
    float width = [str widthForFont:FONTSIZE(18)];
    _seatTableLabel.width = width;
    _seatTableLabel.text = str;
}

/***
 *  订单来源 “服”、“客”
 */
- (void)initWithOrderSourceLabel
{
    if (!_orderSourceLabel)
    {
        CGRect frame = CGRectMake(0, (_line.top - 20)/2., 20, 20);
        _orderSourceLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#ffffff"] fontSize:FONTSIZE(12) labelTag:0 alignment:NSTextAlignmentCenter];
    }
    
    _orderSourceLabel.left = _seatTableLabel.right + 10;
    if (_orderEntity.type == 3)
    {// 餐厅
        _orderSourceLabel.text = @"服";
        _orderSourceLabel.backgroundColor = [UIColor colorWithHexString:@"#83cdc9"];
    }
    else
    {// 用户
        _orderSourceLabel.text = @"客";
        _orderSourceLabel.backgroundColor = [UIColor colorWithHexString:@"#83cdc9"];
    }
}

/**
 *  订单编号
 */
- (void)initWithOrderNoLabel
{
    if (!_orderNoLabel)
    {
        CGRect frame = CGRectMake(15, _line.bottom + 8, [[UIScreen mainScreen] screenWidth] - 30, 16);
        _orderNoLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
//        _orderNoLabel.backgroundColor = [UIColor lightGrayColor];
    }
    
    _orderNoLabel.attributedText = [self attributedTextTitle:@"订单编号：" value:objectNull(_orderEntity.order_id) valueColor:nil];
}

/**
 *  下单时间
 */
- (void)initWithPlaceOrderTimeLabel
{
    if (!_placeOrderTimeLabel)
    {
        CGRect frame = _orderNoLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _placeOrderTimeLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    NSString *payDate = [NSDate stringWithDateInOut:_orderEntity.dining_date inFormat:@"yyyy-MM-dd HH:mm:ss" outFormat:@"yyyy-MM-dd HH:mm"];
    _placeOrderTimeLabel.attributedText = [self attributedTextTitle:@"下单时间：" value:objectNull(payDate) valueColor:nil];
}

/**
 *  就餐人数
 */
- (void)initWithNumberLabel
{
    if (!_numberLabel)
    {
        CGRect frame = _placeOrderTimeLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _numberLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    NSString *value = [NSString stringWithFormat:@"%d人", (int)_orderEntity.number];
    _numberLabel.attributedText = [self attributedTextTitle:@"就餐人数：" value:value valueColor:nil];
}

/**
 *  账单金额
 */
- (void)initWithBillAmountLabel
{
    if (!_billAmountLabel)
    {
        CGRect frame = _numberLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _billAmountLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    NSString *am = [NSString stringWithFormat:@"%.2f元", _orderEntity.total_price];
    _billAmountLabel.attributedText = [self attributedTextTitle:@"账单金额：" value:am valueColor:nil];
}

/**
 *  实付金额
 */
- (void)initWithAmountLabel
{
    if (!_amountLabel)
    {
        CGRect frame = _billAmountLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _amountLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    NSString *am = [NSString stringWithFormat:@"%.2f元", _orderEntity.pay_actually];
    _amountLabel.attributedText = [self attributedTextTitle:@"实付金额：" value:am valueColor:[UIColor colorWithHexString:@"#ff5500"]];
}

/**
 *  支付方式
 */
- (void)initWithPayTypeLabel
{
    if (!_payTypeLabel)
    {
        CGRect frame = _amountLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _payTypeLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    //    _orderEntity.pay_channel_desc
    NSString *payDate = [NSDate stringWithDateInOut:_orderEntity.pay_date inFormat:@"MM-dd HH:mm:ss" outFormat:@"yyyy-MM-dd HH:mm"];
    debugLog(@"payDate=%@", payDate);
    NSString *str = [NSString stringWithFormat:@"支付方式：%@", objectNull(_orderEntity.pay_channel_desc)];
    _payTypeLabel.attributedText = [self attributedTextTitle:@"支付方式：" value:str valueColor:nil];
}

/**
 *  备注
 */
- (void)initWithNoteLabel
{
    if (!_noteLabel)
    {
        CGRect frame = _payTypeLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _noteLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    // pay_modify_note
    _noteLabel.attributedText = [self attributedTextTitle:@"备注详情：" value:objectNull(_orderEntity.pay_modify_note) valueColor:nil];
}

- (void)updateCellData:(id)cellEntity
{
    self.orderEntity = cellEntity;
    
    // 包间房号
    [self initWithSeatTableLabel];
    
    // 订单来源 “服”、“客”
    [self initWithOrderSourceLabel];
    
    // 订单编号
    [self initWithOrderNoLabel];
    
    // 下单时间
    [self initWithPlaceOrderTimeLabel];
    
    // 就餐人数
    [self initWithNumberLabel];
    
    // 账单金额
    [self initWithBillAmountLabel];
    
    // 实付金额
    [self initWithAmountLabel];
    
    // 支付方式
    [self initWithPayTypeLabel];
    
    // 备注
    [self initWithNoteLabel];
}

@end
