//
//  UserPaySuccessOrderViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "UserPaySuccessOrderViewCell.h"
#import "LocalCommon.h"
#import "OrderDetailDataEntity.h"

@interface UserPaySuccessOrderViewCell ()
{
    /**
     *  支付状态描述
     */
    UILabel *_payStateLabel;
    
    /**
     *  hall-order_pay_icon_succeed
     */
    UIImageView *_thumalImgView;
    
    /**
     *  餐厅名字
     */
    UILabel *_shopNameLabel;
    
    /**
     *  订单编号
     */
    UILabel *_orderNoLabel;
    
    /**
     *  到店时间
     */
    UILabel *_arriveDateLabel;
    
    /**
     *  餐桌类型
     */
    UILabel *_tableTypeLabel;
    
    /**
     *  餐厅位置
     */
    UILabel *_shopLocationLabel;
    
    /**
     *  订金支付
     */
    UILabel *_depositLabel;
    
    /**
     *  支付金额
     */
    UILabel *_payPriceLabel;
    
    /**
     *  本次消费
     */
    UILabel *_totalPriceLabel;
    
    /**
     *  支付方式
     */
    UILabel *_paymentLabel;
    
    /**
     *  支付时间
     */
    UILabel *_payDateLabel;
    
}
@property (nonatomic, strong) CALayer *line;

- (void)initWithPayStateLabel;

- (void)initWithThumalImgView;

/**
 *  餐厅名称
 */
- (void)initWithShopNameLabel;

/**
 *  订单编号
 */
- (void)initWithOrderNoLabel;

/**
 *  到店时间
 */
- (void)initWithArriveDateLabel;

/**
 *  餐桌类型
 */
- (void)initWithTableTypeLabel;

/**
 *  餐厅位置
 */
- (void)initWithShopLocationLabel;

/**
 * 订金支付
 */
- (void)initWithDepositLabel;

/**
 *  支付金额
 */
- (void)initWithPayPriceLabel;

/**
 *  本次消费
 */
- (void)initWithTotalPriceLabel;

/**
 *  支付方式
 */
- (void)initWithPaymentLabel;

/**
 *  支付时间
 */
- (void)initWithPayDateLabel;

@end

@implementation UserPaySuccessOrderViewCell

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithLine];
    
    [self initWithPayStateLabel];
    
    [self initWithThumalImgView];
    
    // 餐厅名称
    [self initWithShopNameLabel];
    
    // 订单编号
    [self initWithOrderNoLabel];
    
    // 到店时间
    [self initWithArriveDateLabel];
    
    // 餐桌类型
    [self initWithTableTypeLabel];
    
    // 餐厅位置
    [self initWithShopLocationLabel];
    
    // 订金支付
    [self initWithDepositLabel];
    
    // 支付金额
    [self initWithPayPriceLabel];
    
    // 本次消费
    [self initWithTotalPriceLabel];
    
    // 支付方式
    [self initWithPaymentLabel];
    
    // 支付时间
    [self initWithPayDateLabel];
}

- (void)initWithLine
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake([[UIScreen mainScreen] screenWidth], 0.8);
    line.left = 0;
    line.bottom = 50;
    line.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"].CGColor;
    [self.layer addSublayer:line];
    self.line = line;
}

- (void)initWithPayStateLabel
{
    UIImage *image = [UIImage imageNamed:@"hall-order_pay_icon_succeed"];
    
    NSString *str = @"支付成功";
    CGFloat width = [str widthForFont:FONTSIZE(24)];
    CGRect frame = CGRectMake(([[UIScreen mainScreen] screenWidth] - width)/2+image.size.width/2, (50-20)/2.0, width, 20);
    _payStateLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#00cc66"] fontSize:FONTSIZE(24) labelTag:0 alignment:NSTextAlignmentCenter];
    _payStateLabel.text = str;
}

- (void)initWithThumalImgView
{
    UIImage *image = [UIImage imageNamed:@"hall-order_pay_icon_succeed"];
    CGRect frame = CGRectMake(_payStateLabel.left - image.size.width-5, (50-image.size.height)/2.0, image.size.width, image.size.height);
    _thumalImgView = [[UIImageView alloc] initWithFrame:frame];
    _thumalImgView.image = image;
//    _thumalImgView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_thumalImgView];
}

/**
 *  餐厅名称
 */
- (void)initWithShopNameLabel
{
    CGRect frame = CGRectMake(15, _line.bottom + 10, [[UIScreen mainScreen] screenWidth] - 30, 20);
    _shopNameLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_18 labelTag:0 alignment:NSTextAlignmentLeft];
}

/**
 *  订单编号
 */
- (void)initWithOrderNoLabel
{
    CGRect frame = _shopNameLabel.frame;
    frame.origin.y = frame.origin.y + frame.size.height + 4;
    _orderNoLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
}

/**
 *  到店时间
 */
- (void)initWithArriveDateLabel
{
    CGRect frame = _orderNoLabel.frame;
    frame.origin.y = frame.origin.y + frame.size.height + 4;
    _arriveDateLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
}

/**
 *  餐桌类型
 */
- (void)initWithTableTypeLabel
{
    CGRect frame = _arriveDateLabel.frame;
    frame.origin.y = frame.origin.y + frame.size.height + 4;
    _tableTypeLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
}

/**
 *  餐厅位置
 */
- (void)initWithShopLocationLabel
{
    CGRect frame = _tableTypeLabel.frame;
    frame.origin.y = frame.origin.y + frame.size.height + 4;
    _shopLocationLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
}

/**
 * 订金支付
 */
- (void)initWithDepositLabel
{
    CGRect frame = _shopLocationLabel.frame;
    frame.origin.y = frame.origin.y + frame.size.height + 4;
    _depositLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
}

/**
 *  支付金额
 */
- (void)initWithPayPriceLabel
{
    CGRect frame = _depositLabel.frame;
    frame.origin.y = frame.origin.y + frame.size.height + 4;
    _payPriceLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
}

/**
 *  本次消费
 */
- (void)initWithTotalPriceLabel
{
    CGRect frame = _payPriceLabel.frame;
    frame.origin.y = frame.origin.y + frame.size.height + 4;
    _totalPriceLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
}

/**
 *  支付方式
 */
- (void)initWithPaymentLabel
{
    CGRect frame = _totalPriceLabel.frame;
    frame.origin.y = frame.origin.y + frame.size.height + 4;
    _paymentLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
}

/**
 *  支付时间
 */
- (void)initWithPayDateLabel
{
    CGRect frame = _paymentLabel.frame;
    frame.origin.y = frame.origin.y + frame.size.height + 4;
    _payDateLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
}

- (NSAttributedString *)attributedTextTitle:(NSString *)title value:(NSString *)value valueColor:(UIColor *)valueColor
{
    NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] init];
    UIColor *color = [UIColor colorWithHexString:@"#646464"];
    NSAttributedString *bTitle = [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName: FONTSIZE(12), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:bTitle];
    
    color = [UIColor colorWithHexString:@"#323232"];
    if (!valueColor)
    {
        valueColor = color;
    }
    NSAttributedString *bValue = [[NSAttributedString alloc] initWithString:value attributes:@{NSFontAttributeName: FONTSIZE(12), NSForegroundColorAttributeName: valueColor}];
    [mas appendAttributedString:bValue];
    
    return mas;
}


- (void)updateCellData:(id)cellEntity
{
    OrderDetailDataEntity *orderEnt = cellEntity;
    
    // 餐厅名称
    _shopNameLabel.text = objectNull(orderEnt.order.shop_name);
    
    // 订单编号
    _orderNoLabel.attributedText = [self attributedTextTitle:@"订单编号：" value:objectNull(orderEnt.order.order_id) valueColor:nil];
    
    // 到店时间
    _arriveDateLabel.attributedText = [self attributedTextTitle:@"到店时间：" value:objectNull(orderEnt.order.dining_date) valueColor:nil];
    
    // 餐桌类型
    NSString *str = [NSString stringWithFormat:@"%d人桌", (int)orderEnt.order.number];
    _tableTypeLabel.attributedText = [self attributedTextTitle:@"餐桌类型：" value:str valueColor:nil];
    
    // 餐厅位置
    str = [NSString stringWithFormat:@"%@（%@）", orderEnt.order.seat_type_name, orderEnt.order.seat_number];
    _shopLocationLabel.attributedText = [self attributedTextTitle:@"餐厅位置：" value:str valueColor:nil];
    
    // 订金支付
    
    str = [NSString stringWithFormat:@"%.2f元", orderEnt.order.book_deposit_amount];
    _depositLabel.attributedText = [self attributedTextTitle:@"订金支付：" value:str valueColor:[UIColor colorWithHexString:@"#ff5500"]];
    
    // 支付金额
    str = [NSString stringWithFormat:@"%.2f元", orderEnt.order.pay_amount];
    _payPriceLabel.attributedText = [self attributedTextTitle:@"支付金额：" value:str valueColor:[UIColor colorWithHexString:@"#ff5500"]];
    
    // 本次消费
    str = [NSString stringWithFormat:@"%.2f元", orderEnt.order.total_price];
    _totalPriceLabel.attributedText = [self attributedTextTitle:@"本次消费：" value:str valueColor:[UIColor colorWithHexString:@"#ff5500"]];
    
    // 支付方式
    _paymentLabel.attributedText = [self attributedTextTitle:@"支付方式：" value:objectNull(orderEnt.order.pay_channel_desc) valueColor:nil];
    
    // 支付时间
    _payDateLabel.attributedText = [self attributedTextTitle:@"支付时间：" value:@"2015-02-01 12:12" valueColor:nil];
    
}

@end












