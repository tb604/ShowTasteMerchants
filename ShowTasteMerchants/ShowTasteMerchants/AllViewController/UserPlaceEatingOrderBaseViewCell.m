//
//  UserPlaceEatingOrderBaseViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "UserPlaceEatingOrderBaseViewCell.h"
#import "LocalCommon.h"
#import "OrderDataEntity.h"

@interface UserPlaceEatingOrderBaseViewCell ()
{
    /**
     *  餐厅名字
     */
    UILabel *_shopNameLabel;
    
    /**
     *  订单编号
     */
    UILabel *_orderNoLabel;
    
    /**
     *  餐厅位置
     */
    UILabel *_shopLocationLabel;
    
    /**
     *  餐桌类型
     */
    UILabel *_tableTypeLabel;

    /**
     *  食客姓名
     */
    UILabel *_userNameLabel;

    /**
     *  结账时间
     */
    UILabel *_billingDateLabel;
}

@property (nonatomic, strong) OrderDataEntity *orderEntity;

/**
 * 餐厅名字
 */
- (void)initWithShopNameLabel;

/**
 * 订单编号
 */
- (void)initWithOrderNoLabel;

/**
 * 餐厅位置
 */
- (void)initWithShopLocationLabel;

/**
 * 餐桌类型
 */
- (void)initWithTableTypeLabel;

/**
 * 食客姓名
 */
- (void)initWithUserNameLabel;

/**
 * 结账时间
 */
- (void)initWithBillingDateLabel;

@end

@implementation UserPlaceEatingOrderBaseViewCell


- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
}

/**
 * 餐厅名字
 */
- (void)initWithShopNameLabel
{
    if (!_shopNameLabel)
    {
        CGRect frame = CGRectMake(15, 10, [[UIScreen mainScreen] screenWidth] - 30, 20);
        _shopNameLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE(18) labelTag:0 alignment:NSTextAlignmentLeft];
    }
    _shopNameLabel.text = objectNull(_orderEntity.shop_name);
}

/**
 * 订单编号
 */
- (void)initWithOrderNoLabel
{
    if (!_orderNoLabel)
    {
        CGRect frame = _shopNameLabel.frame;
        frame.origin.y = _shopNameLabel.bottom + 8;
        _orderNoLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
    }
    _orderNoLabel.attributedText = [self attributedTextTitle:@"订单编号：" value:objectNull(_orderEntity.order_id) valueColor:nil];
}

/**
 * 餐厅位置
 */
- (void)initWithShopLocationLabel
{
    if (!_shopLocationLabel)
    {
        CGRect frame = _orderNoLabel.frame;
        frame.origin.y = _orderNoLabel.bottom + 4;
        _shopLocationLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
    }
    _shopLocationLabel.attributedText = [self attributedTextTitle:@"餐厅位置：" value:objectNull(_orderEntity.seat_type_name) valueColor:nil];
}

/**
 * 餐桌类型
 */
- (void)initWithTableTypeLabel
{
    if (!_tableTypeLabel)
    {
        CGRect frame = _orderNoLabel.frame;
        frame.origin.y = _shopLocationLabel.bottom + 4;
        _tableTypeLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
    }
    NSString *str = [NSString stringWithFormat:@"%d人桌", (int)_orderEntity.number];
    _tableTypeLabel.attributedText = [self attributedTextTitle:@"餐桌类型：" value:str valueColor:nil];
}

/**
 * 食客姓名
 */
- (void)initWithUserNameLabel
{
    if (!_userNameLabel)
    {
        CGRect frame = _orderNoLabel.frame;
        if (_orderEntity.type == 1)
        {// 预定
            frame.origin.y = _tableTypeLabel.bottom + 4;
        }
        else
        {
            frame.origin.y = _orderNoLabel.bottom + 4;
        }
        _userNameLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
    }
    _userNameLabel.attributedText = [self attributedTextTitle:@"食客姓名：" value:objectNull(_orderEntity.name) valueColor:nil];
}

/**
 * 结账时间
 */
- (void)initWithBillingDateLabel
{
    if (!_billingDateLabel)
    {
        CGRect frame = _orderNoLabel.frame;
        frame.origin.y = _userNameLabel.bottom + 4;
        _billingDateLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
    }
    if ([objectNull(_orderEntity.settle_date) isEqualToString:@""])
    {
        _orderEntity.settle_date = [[NSDate date] stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    NSString *date = [NSDate stringWithDateInOut:_orderEntity.settle_date inFormat:@"yyyy-MM-dd HH:mm:ss" outFormat:@"yyyy-MM-dd HH:mm"];
    _billingDateLabel.attributedText = [self attributedTextTitle:@"结算时间：" value:objectNull(date) valueColor:nil];
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

+ (CGFloat)getWithCellHeight:(NSInteger)type
{
    CGFloat height = 0;
    if (type == 1)
    {// 预定
        height = 164;
    }
    else
    {
        height = 10 + 12 + 80 + 10;
    }
    return height;
}


- (void)updateCellData:(id)cellEntity
{
//    OrderDataEntity *orderEntity = cellEntity;
    self.orderEntity = cellEntity;
    
    
    // 餐厅名字
    [self initWithShopNameLabel];
    
    // 订单编号
    [self initWithOrderNoLabel];
    
    if (_orderEntity.type == 1)
    {
        // 餐厅位置
        [self initWithShopLocationLabel];
        
        // 餐桌类型
        [self initWithTableTypeLabel];
    }

    
    // 食客姓名
    [self initWithUserNameLabel];
    
    // 结账时间
    [self initWithBillingDateLabel];
}


@end
