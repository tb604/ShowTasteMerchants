//
//  ShopImmediateOrderViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/4.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopImmediateOrderViewCell.h"
#import "LocalCommon.h"
#import "OrderDataEntity.h"

@interface ShopImmediateOrderViewCell ()
{
    /**
     *  下单时间
     */
    UILabel *_placeOrderDateLabel;
    
    /**
     *  订单状态类型
     */
    UILabel *_orderStateLabel;
    
    /**
     *  订单编号
     */
    UILabel *_orderNoLabel;
    
    /**
     *  食客姓名
     */
    UILabel *_nameLabel;
    
    /**
     *  食客电话
     */
    UILabel *_phoneLabel;
    
    /**
     *  查看订单
     */
    UIButton *_btnLookOrder;

}

@property (nonatomic, strong) OrderDataEntity *orderEntity;

/**
 *  下单时间
 */
- (void)initWithPlaceOrderDateLabel;

/**
 *  订单状态类型
 */
- (void)initWithOrderStateLabel;

/**
 *  订单编号
 */
- (void)initWithOrderNoLabel;

/**
 *  食客姓名
 */
- (void)initWithNameLabel;

/**
 *  食客电话
 */
- (void)initWithPhoneLabel;

@end

@implementation ShopImmediateOrderViewCell

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    // 下单时间
    [self initWithPlaceOrderDateLabel];
    
    // 订单状态类型
    [self initWithOrderStateLabel];
    
    // 订单编号
    [self initWithOrderNoLabel];
    
    // 食客姓名
    [self initWithNameLabel];
    
    // 食客电话
    [self initWithPhoneLabel];
    
    // 查看订单
    [self initWithBtnLookOrder];

}

/**
 *  下单时间
 */
- (void)initWithPlaceOrderDateLabel
{
    NSString *str = @"下单时间：2015-12-13 12:32";
    CGFloat width = [str widthForFont:FONTSIZE(14)] + 5;
    CGRect frame = CGRectMake(15, 10, width + 5, 20);
    _placeOrderDateLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
    //    _placeOrderDateLabel.backgroundColor = [UIColor lightGrayColor];
}

/**
 *  订单状态类型
 */
- (void)initWithOrderStateLabel
{
    NSString *str = @"已接单";
    CGFloat width = [str widthForFont:FONTSIZE_16];
    CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - 15 - width, 0, width, 20);
    _orderStateLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#00ce68"] fontSize:FONTSIZE_16 labelTag:0 alignment:NSTextAlignmentRight];
    _orderStateLabel.centerY = _placeOrderDateLabel.centerY;
}

/**
 *  订单编号
 */
- (void)initWithOrderNoLabel
{
    CGRect frame = CGRectMake(15, _placeOrderDateLabel.bottom + 4, [[UIScreen mainScreen] screenWidth] - 30, 20);
    _orderNoLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
    //    _orderNoLabel.backgroundColor = [UIColor lightGrayColor];
}

/**
 *  食客姓名
 */
- (void)initWithNameLabel
{
    CGRect frame = CGRectMake(15, _orderNoLabel.bottom + 4, [[UIScreen mainScreen] screenWidth] - 30, 20);
    _nameLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
    //    _nameLabel.backgroundColor = [UIColor lightGrayColor];
}

/**
 *  食客电话
 */
- (void)initWithPhoneLabel
{
    if (!_phoneLabel)
    {
        CGRect frame = CGRectMake(15, _nameLabel.bottom + 4, [[UIScreen mainScreen] screenWidth] - 30 - 75 - 10, 20);
        _phoneLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
    }
}

/**
 *  查看订单
 */
- (void)initWithBtnLookOrder
{
    /*CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - 15 - 75, 0, 75, 25);
    _btnLookOrder = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"查看订单" titleColor:[UIColor colorWithHexString:@"#ff5100"] titleFont:FONTSIZE_13 targetSel:@selector(clickedLook:)];
    _btnLookOrder.frame = frame;
    _btnLookOrder.layer.masksToBounds = YES;
    _btnLookOrder.layer.cornerRadius = 3.0;
    _btnLookOrder.layer.borderWidth = 1;
    _btnLookOrder.layer.borderColor = [UIColor colorWithHexString:@"#ff5100"].CGColor;
    _btnLookOrder.bottom = _phoneLabel.bottom;
    [self.contentView addSubview:_btnLookOrder];
     */
}

- (void)clickedLook:(id)sender
{
    if (self.baseTableViewCellBlock)
    {
        self.baseTableViewCellBlock(_orderEntity);
    }
}

- (NSAttributedString *)attributedTextTitle:(NSString *)title value:(NSString *)value
{
    NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] init];
    UIColor *color = [UIColor colorWithHexString:@"#666666"];
    NSAttributedString *bTitle = [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName: FONTSIZE(14), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:bTitle];
    
    color = [UIColor colorWithHexString:@"#323232"];
    NSAttributedString *bValue = [[NSAttributedString alloc] initWithString:value attributes:@{NSFontAttributeName: FONTSIZE(14), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:bValue];
    
    return mas;
}

- (void)updateCellData:(id)cellEntity
{
    self.orderEntity = cellEntity;
    _orderEntity.status_remark = [UtilityObject dinersWithOrderState:_orderEntity.status];
//    return;
    CGFloat width = [_orderEntity.status_remark widthForFont:FONTSIZE_16];
    
    // _orderEntity.dining_date
    NSString *date = [NSDate stringWithDateInOut:_orderEntity.dining_date inFormat:@"yyyy-MM-dd HH:mm:ss" outFormat:@"yyyy-MM-dd HH:mm"];
    _placeOrderDateLabel.width = [[UIScreen mainScreen] screenWidth] - 30 - 10 - width;
    _placeOrderDateLabel.attributedText = [self attributedTextTitle:@"下单时间：" value:date];
    
    // 订单状态类型
    _orderStateLabel.text = _orderEntity.status_remark;
    _orderStateLabel.width = width;
    _orderStateLabel.right = [[UIScreen mainScreen] screenWidth] - 15;
    
    // 订单编号
    NSString *str = @"即时 | ";
    NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] init];
    UIColor *color = [UIColor colorWithHexString:@"#ff5500"];
    NSAttributedString *bTitle = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: FONTSIZE(14), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:bTitle];
    NSAttributedString *value = [self attributedTextTitle:@"订单编号：" value:objectNull(_orderEntity.order_id)];
    [mas appendAttributedString:value];
    _orderNoLabel.attributedText = mas;
    
    // 食客姓名
    _nameLabel.attributedText = [self attributedTextTitle:@"食客姓名：" value:objectNull(_orderEntity.customer_name)];
    
    // 食客电话
    _phoneLabel.attributedText =  [self attributedTextTitle:@"食客电话：" value:objectNull(_orderEntity.mobile)];
}

@end
