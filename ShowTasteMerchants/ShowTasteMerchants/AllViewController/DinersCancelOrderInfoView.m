//
//  DinersCancelOrderInfoView.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/31.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DinersCancelOrderInfoView.h"
#import "LocalCommon.h"
#import "OrderDataEntity.h"

@interface DinersCancelOrderInfoView ()
{
    /**
     *  餐厅名称
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
    UILabel *_locationLabel;
    
    /**
     *  预付订金
     */
    UILabel *_prepaidLabel;
}

@property (nonatomic, strong) OrderDataEntity *orderEntity;

/**
 * 餐厅名称
 */
- (void)initWithShopNameLabel;

/**
 * 订单编号
 */
- (void)initWithOrderNoLabel;

/**
 * 到店时间
 */
- (void)initWithArriveDateLabel;

/**
 * 餐桌类型
 */
- (void)initWithTableTypeLabel;

/**
 * 餐厅位置
 */
- (void)initWithLocationLabel;

/**
 * 预付订金
 */
- (void)initWithPrepaidLabel;


@end

@implementation DinersCancelOrderInfoView

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    // 餐厅名称
    [self initWithShopNameLabel];
    
    // 订单编号
    [self initWithOrderNoLabel];
    
    // 到店时间
    [self initWithArriveDateLabel];
    
    // 餐桌类型
    [self initWithTableTypeLabel];
    
    // 餐厅位置
    [self initWithLocationLabel];
    
    // 预付订金
    [self initWithPrepaidLabel];
    
}

/**
 * 餐厅名称
 */
- (void)initWithShopNameLabel
{
    if (!_shopNameLabel)
    {
        CGRect frame = CGRectMake(15, 10, [[UIScreen mainScreen] screenWidth] - 30, 20);
        _shopNameLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_16 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    _shopNameLabel.text = _orderEntity.shop_name;
}

/**
 * 订单编号
 */
- (void)initWithOrderNoLabel
{
    if (!_orderNoLabel)
    {
        CGRect frame = _shopNameLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _orderNoLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
    }
    _orderNoLabel.attributedText = [self attributedTextTitle:@"订单编号：" value:objectNull(_orderEntity.order_id) valueColor:nil];
}

/**
 * 到店时间
 */
- (void)initWithArriveDateLabel
{
    if (!_arriveDateLabel)
    {
        CGRect frame = _orderNoLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _arriveDateLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
    }
    
    NSString *str = [NSDate stringWithDateInOut:_orderEntity.dining_date inFormat:@"yyyy-MM-dd HH:mm:ss" outFormat:@"yyyy-MM-dd HH:mm"];
    _arriveDateLabel.attributedText = [self attributedTextTitle:@"到店时间：" value:objectNull(str) valueColor:nil];
}

/**
 * 餐桌类型
 */
- (void)initWithTableTypeLabel
{
    if (!_tableTypeLabel)
    {
        CGRect frame = _arriveDateLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _tableTypeLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
    }
    NSString *str = [NSString stringWithFormat:@"%d人桌", (int)_orderEntity.number];
    _tableTypeLabel.attributedText = [self attributedTextTitle:@"餐桌类型：" value:str valueColor:nil];
}

/**
 * 餐厅位置
 */
- (void)initWithLocationLabel
{
    if (!_locationLabel)
    {
        CGRect frame = _tableTypeLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _locationLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
    }
    _locationLabel.attributedText = [self attributedTextTitle:@"餐厅位置：" value:objectNull(_orderEntity.seat_type_name) valueColor:nil];
}

/**
 * 预付订金
 */
- (void)initWithPrepaidLabel
{
    if (!_prepaidLabel)
    {
        CGRect frame = _locationLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _prepaidLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
    }
    NSString *str = [NSString stringWithFormat:@"￥%.2f元", _orderEntity.book_deposit_amount];
    _prepaidLabel.attributedText = [self attributedTextTitle:@"预付订金：" value:str valueColor:[UIColor colorWithHexString:@"#ff5500"]];
}

- (NSAttributedString *)attributedTextTitle:(NSString *)title value:(NSString *)value valueColor:(UIColor *)valueColor
{
    NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] init];
    UIColor *color = [UIColor colorWithHexString:@"#646464"];
    NSAttributedString *bTitle = [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName: FONTSIZE(13), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:bTitle];
    
    color = [UIColor colorWithHexString:@"#323232"];
    if (!valueColor)
    {
        valueColor = color;
    }
    NSAttributedString *bValue = [[NSAttributedString alloc] initWithString:value attributes:@{NSFontAttributeName: FONTSIZE(13), NSForegroundColorAttributeName: valueColor}];
    [mas appendAttributedString:bValue];
    
    return mas;
}


- (void)updateViewData:(id)entity
{
    self.orderEntity = entity;
    // 餐厅名称
    [self initWithShopNameLabel];
    
    // 订单编号
    [self initWithOrderNoLabel];
    
    // 到店时间
    [self initWithArriveDateLabel];
    
    // 餐桌类型
    [self initWithTableTypeLabel];
    
    // 餐厅位置
    [self initWithLocationLabel];
    
    // 预付订金
    [self initWithPrepaidLabel];
}

@end















