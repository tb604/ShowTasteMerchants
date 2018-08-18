//
//  ShopAccountStatementHeaderView.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/6.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopAccountStatementHeaderView.h"
#import "LocalCommon.h"
#import "OrderDataEntity.h"
#import "CTCMealOrderDetailsEntity.h"

@interface ShopAccountStatementHeaderView ()
{
    /**
     *  取消
     */
    UIButton *_btnCancel;
    
    /**
     *  餐厅名称
     */
    UILabel *_shopNameLabel;
    
    /**
     *  订单编号
     */
    UILabel *_orderNoLabel;
    
    /**
     *  餐桌位置
     */
    UILabel *_locationLabel;
    
    /**
     *  餐桌类型
     */
    UILabel *_numberLabel;
    
    /**
     *  食客姓名
     */
    UILabel *_nameLabel;
    
    /**
     *  结账时间
     */
    UILabel *_invoicDateLabel;
}

@property (nonatomic, strong) CTCMealOrderDetailsEntity *orderEntity;

/**
 *  取消按钮
 */
- (void)initWithBtnCancel;

/**
 *  餐厅名称
 */
- (void)initWithShopNameLabel;

/**
 *  订单编号
 */
- (void)initWithOrderNoLabel;

/**
 *  餐厅位置
 */
- (void)initWithLocationLabel;

/**
 *  餐厅类型
 */
- (void)initWithNumberLabel;

/**
 *  食客姓名
 */
- (void)initWithNameLabel;

/**
 *  支付时间
 */
- (void)initWithInvoicDateLabel;

@end

@implementation ShopAccountStatementHeaderView

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    
}

/**
 *  1表示预订；2表示即时
 *
 *  @param type <#type description#>
 *
 *  @return <#return value description#>
 */
+ (CGFloat)getWithViewHeight:(NSInteger)type
{
    CGFloat height = 0;
    if (type == 1)
    {
        height = 10 + 20 + 120 + 10;
    }
    else
    {
        height = 10 + 8 + 60 + 10;
    }
    return height;
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

/**
 *  取消按钮
 */
- (void)initWithBtnCancel
{
    if (!_btnCancel)
    {
        NSString *str = @"取消";
        CGFloat width = [str widthForFont:FONTSIZE_15] + 20;
        CGRect frame = CGRectMake(self.width - 15 - width, 15, width, 25);
        
        _btnCancel = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"取消" titleColor:[UIColor colorWithHexString:@"#ff5500"] titleFont:FONTSIZE_15 targetSel:@selector(clickedWithButton:)];
        _btnCancel.frame = frame;
        _btnCancel.layer.borderColor = [UIColor colorWithHexString:@"#ff5500"].CGColor;
        _btnCancel.layer.borderWidth = 1;
        _btnCancel.layer.cornerRadius = 2;
        _btnCancel.layer.masksToBounds = YES;
        [self addSubview:_btnCancel];
    }
}

/**
 *  餐厅名称
 */
- (void)initWithShopNameLabel
{
    if (!_shopNameLabel)
    {
        CGRect frame = CGRectMake(15, 10, _btnCancel.left - 15 - 10, 20);
        _shopNameLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#1a1a1a"] fontSize:FONTSIZE_16 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    _shopNameLabel.text = objectNull(_orderEntity.shop_name);
}

/**
 *  订单编号
 */
- (void)initWithOrderNoLabel
{
    if (!_orderNoLabel)
    {
        CGRect frame = _shopNameLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _orderNoLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    NSString *str = [NSString stringWithFormat:@"订单编号：%@", objectNull(_orderEntity.order_id)];
    _orderNoLabel.text = str;
}

/**
 *  餐厅位置
 */
- (void)initWithLocationLabel
{
    if (!_locationLabel)
    {
        CGRect frame = _orderNoLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _locationLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    NSString *str = [NSString stringWithFormat:@"订单编号：%@(%@)", objectNull(_orderEntity.seat_type_desc), objectNull(_orderEntity.seat_number)];
    _locationLabel.text = str;

}

/**
 *  餐厅类型
 */
- (void)initWithNumberLabel
{
    if (!_numberLabel)
    {
        CGRect frame = _locationLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _numberLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
    }
//    _orderEntity.eater_count
    NSString *str = [NSString stringWithFormat:@"餐桌类型：%d人桌", (int)_orderEntity.eater_count];
    _numberLabel.text = str;
}

/**
 *  食客姓名
 */
- (void)initWithNameLabel
{
    if (!_nameLabel)
    {
        CGRect frame = _numberLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _nameLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
    }
//    _orderEntity.
//    NSString *str = [NSString stringWithFormat:@"食客姓名：%@", objectNull(_orderEntity.userna)];
//    _nameLabel.text = str;
}

/**
 *  支付时间
 */
- (void)initWithInvoicDateLabel
{
    if (!_invoicDateLabel)
    {
        CGRect frame = _nameLabel.frame;
        if (_orderEntity.type == 2)
        {
            frame = _orderNoLabel.frame;
        }
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _invoicDateLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    NSDate *date = [NSDate date];
    NSString *strDate = [date stringWithFormat:@"yyyy-MM-dd HH:mm"];
    NSString *str = [NSString stringWithFormat:@"结算时间：%@", objectNull(strDate)];
    _invoicDateLabel.text = str;
}

- (void)clickedWithButton:(id)sender
{
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(nil);
    }
}

- (void)updateViewData:(id)entity
{
    self.orderEntity = entity;
    
    // 取消按钮
    [self initWithBtnCancel];
    
    // 餐厅名称
    [self initWithShopNameLabel];
    
    // 订单编号
    [self initWithOrderNoLabel];
    
    if (_orderEntity.type == 1)
    {
        // 餐厅位置
        [self initWithLocationLabel];
        
        // 餐厅类型
        [self initWithNumberLabel];
        
        // 食客姓名
        [self initWithNameLabel];
    }
    
    // 支付时间
    [self initWithInvoicDateLabel];
    
}


@end
