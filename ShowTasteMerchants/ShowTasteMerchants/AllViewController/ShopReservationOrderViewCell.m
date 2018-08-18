//
//  ShopReservationOrderViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/18.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopReservationOrderViewCell.h"
#import "LocalCommon.h"
#import "OrderDataEntity.h"

@interface ShopReservationOrderViewCell ()
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
    UILabel *_restaurantLocationLabel;
    
    /**
     *  查看订单
     */
    UIButton *_btnLookOrder;
    
    /**
     *  备注
     */
    UILabel *_noteLabel;
    
}

@property (nonatomic, strong) OrderDataEntity *orderEntity;

@property (nonatomic, strong) CALayer *line;

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
- (void)initWithRestaurantLocationLabel;

/**
 *  查看订单
 */
- (void)initWithBtnLookOrder;

/**
 *  备注
 */
- (void)initWithNoteLabel;


@end

@implementation ShopReservationOrderViewCell


- (void)initWithVarCell
{
    [super initWithVarCell];
    
}

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithLine];
 
    // 下单时间
    [self initWithPlaceOrderDateLabel];
    
    // 订单状态类型
    [self initWithOrderStateLabel];
    
    // 订单编号
    [self initWithOrderNoLabel];
    
    // 食客姓名
    [self initWithNameLabel];
    
    // 到店时间
    [self initWithArriveDateLabel];
    
    // 餐桌类型
    [self initWithTableTypeLabel];
    
    // 餐厅位置
    [self initWithRestaurantLocationLabel];
    
    // 查看订单
    [self initWithBtnLookOrder];
    
    // 备注
    [self initWithNoteLabel];
    
}

- (void)initWithLine
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake([[UIScreen mainScreen] screenWidth], 0.8);
    line.left = 15;
    line.top = kShopReservationOrderViewCellHeight - 40;
    line.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"].CGColor;
    [self.layer addSublayer:line];
    self.line = line;
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
 *  到店时间
 */
- (void)initWithArriveDateLabel
{
    CGRect frame = CGRectMake(15, _nameLabel.bottom + 4, [[UIScreen mainScreen] screenWidth] - 30, 20);
    _arriveDateLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
//    _arriveDateLabel.backgroundColor = [UIColor lightGrayColor];
}

/**
 *  餐桌类型
 */
- (void)initWithTableTypeLabel
{
    CGRect frame = CGRectMake(15, _arriveDateLabel.bottom + 4, ([[UIScreen mainScreen] screenWidth] - 30) / 3 * 2, 20);
    _tableTypeLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
//    _tableTypeLabel.backgroundColor = [UIColor lightGrayColor];
}

/**
 *  餐厅位置
 */
- (void)initWithRestaurantLocationLabel
{
    CGRect frame = CGRectMake(15, _tableTypeLabel.bottom + 4, ([[UIScreen mainScreen] screenWidth] - 30) / 3 * 2, 20);
    _restaurantLocationLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
//    _restaurantLocationLabel.backgroundColor = [UIColor lightGrayColor];
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
    _btnLookOrder.bottom = _restaurantLocationLabel.bottom;
    [self.contentView addSubview:_btnLookOrder];
     */
}

/**
 *  备注
 */
- (void)initWithNoteLabel
{
    CGRect frame = CGRectMake(15, _line.bottom + (40-20)/2, [[UIScreen mainScreen] screenWidth] - 30, 20);

    _noteLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_16 labelTag:0 alignment:NSTextAlignmentLeft];
//    _noteLabel.backgroundColor = [UIColor lightGrayColor];
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

- (void)clickedLook:(id)sender
{
    if (self.baseTableViewCellBlock)
    {
        self.baseTableViewCellBlock(_orderEntity);
    }
}

- (void)updateCellData:(id)cellEntity
{
    self.orderEntity = cellEntity;
//    debugLog(@"orderEnt=%@", [_orderEntity modelToJSONString]);
    
    _orderEntity.status_remark = [UtilityObject dinersWithOrderState:_orderEntity.status];
    //    return;
    CGFloat width = [_orderEntity.status_remark widthForFont:FONTSIZE_16];
    
    // 下单时间
    NSString *date = [NSDate stringWithDateInOut:_orderEntity.dining_date inFormat:@"yyyy-MM-dd HH:mm:ss" outFormat:@"yyyy-MM-dd HH:mm"];
    _placeOrderDateLabel.width = [[UIScreen mainScreen] screenWidth] - 30 - 10 - width;
    _placeOrderDateLabel.attributedText = [self attributedTextTitle:@"下单时间：" value:date];
    
    // 订单状态类型
    _orderStateLabel.text = _orderEntity.status_remark;
    _orderStateLabel.width = width;
    _orderStateLabel.right = [[UIScreen mainScreen] screenWidth] - 15;
    
    // 订单编号
    NSString *str = @"预订 | ";
    NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] init];
    UIColor *color = [UIColor colorWithHexString:@"#ff5500"];
    NSAttributedString *bTitle = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: FONTSIZE(14), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:bTitle];
    NSAttributedString *value = [self attributedTextTitle:@"订单编号：" value:objectNull(_orderEntity.order_id)];
    [mas appendAttributedString:value];
    _orderNoLabel.attributedText = mas;
    
    // 食客姓名
    _nameLabel.attributedText = [self attributedTextTitle:@"食客姓名：" value:objectNull(_orderEntity.customer_name)];
    
    // 到店时间
    date = [NSDate stringWithDateInOut:_orderEntity.create_date inFormat:@"yyyy-MM-dd HH:mm:ss" outFormat:@"yyyy-MM-dd HH:mm"];
    _arriveDateLabel.attributedText = [self attributedTextTitle:@"到店时间：" value:date];
    
    // 餐桌类型
    NSString *num = [NSString stringWithFormat:@"%d人桌", (int)_orderEntity.number];
    _tableTypeLabel.attributedText = [self attributedTextTitle:@"餐桌类型：" value:num];
    
    // 餐厅位置
    _restaurantLocationLabel.attributedText = [self attributedTextTitle:@"餐厅位置：" value:objectNull(_orderEntity.seat_type_name)];
    
    // 备注
    NSString *note = objectNull(_orderEntity.remark);
    if ([note isEqualToString:@""])
    {
        note = @"暂无备注。";
    }
    _noteLabel.text = note;
}

@end
















