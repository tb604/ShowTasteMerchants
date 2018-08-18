//
//  ShopFinishOrderViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/19.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopFinishOrderViewCell.h"
#import "LocalCommon.h"
#import "OrderDataEntity.h"

@interface ShopFinishOrderViewCell ()
{
    /**
     *  桌号(大厅 | 桌号)
     */
    UILabel *_tableNoLabel;
    
    /**
     *  订单状态类型
     */
    UILabel *_orderStateLabel;
    
    /**
     *  订单号(预订 | 订单号)
     */
    UILabel *_orderNoLabel;
    
    /**
     *  姓名
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
     *  结算日期
     */
    UILabel *_settlementDateLabel;
    
    /**
     *  查看订单
     */
    UIButton *_btnLookOrder;
}

@property (nonatomic, strong) OrderDataEntity *orderEntity;

/**
 * 桌号(大厅 | 桌号)
 */
- (void)initWithTableNoLabel;

/**
 * 订单状态类型
 */
- (void)initWithOrderStateLabel;

/**
 * 订单号(预订 | 订单号)
 */
- (void)initWithOrderNoLabel;

/**
 * 姓名
 */
- (void)initWithNameLabel;

/**
 * 到店时间
 */
- (void)initWithArriveDateLabel;

/**
 * 餐桌类型
 */
- (void)initWithTableTypeLabel;

/**
 *  结算日期
 */
- (void)initWithSettlementDateLabel;

/**
 * 查看订单
 */
- (void)initWithBtnLookOrder;


@end

@implementation ShopFinishOrderViewCell

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    // 桌号(大厅 | 桌号)
//    [self initWithTableNoLabel];
    
//    // 订单状态类型
//    [self initWithOrderStateLabel];
    
    // 订单号(预订 | 订单号)
//    [self initWithOrderNoLabel];
    
    // 姓名
//    [self initWithNameLabel];
    
    // 到店时间
//    [self initWithArriveDateLabel];
    
    // 餐桌类型
//    [self initWithTableTypeLabel];
    
    // 结算日期
//    [self initWithSettlementDateLabel];
    
    // 查看订单
//    [self initWithBtnLookOrder];
}

/**
 * 桌号(大厅 | 桌号)
 */
- (void)initWithTableNoLabel
{
    if (!_tableNoLabel)
    {
        CGRect frame = CGRectMake(15, 10, [[UIScreen mainScreen] screenWidth] / 2, 20);
        _tableNoLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE(20) labelTag:0 alignment:NSTextAlignmentLeft];
//        _tableNoLabel.backgroundColor = [UIColor lightGrayColor];
    }
    
    NSMutableString *mutStr = [NSMutableString new];
    if (![objectNull(_orderEntity.seat_type_name) isEqualToString:@""])
    {
        [mutStr appendFormat:@"%@ | ", _orderEntity.seat_type_name];
    }
    [mutStr appendString:@"桌号："];
    NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] init];
    UIColor *color = [UIColor colorWithHexString:@"#323232"];
    NSAttributedString *bTitle = [[NSAttributedString alloc] initWithString:mutStr attributes:@{NSFontAttributeName: FONTSIZE(18), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:bTitle];
    
    color = [UIColor colorWithHexString:@"#ff5100"];
    NSAttributedString *bValue = [[NSAttributedString alloc] initWithString:objectNull(_orderEntity.seat_number) attributes:@{NSFontAttributeName: FONTSIZE(16), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:bValue];
    _tableNoLabel.attributedText = mas;
}

/**
 * 订单状态类型
 */
- (void)initWithOrderStateLabel
{
    /*NSString *str = @"未下单";
    CGFloat width = [str widthForFont:FONTSIZE_16];
    CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - 15 - width, 0, width, 20);
    _orderStateLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#00ce68"] fontSize:FONTSIZE_16 labelTag:0 alignment:NSTextAlignmentRight];
    _orderStateLabel.centerY = _tableNoLabel.centerY;
    //    _orderStateLabel.backgroundColor = [UIColor lightGrayColor];
     */
    if (!_orderStateLabel)
    {
        NSString *str = @"未下单";
        CGFloat width = [str widthForFont:FONTSIZE_16];
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - 15 - width, 0, width, 20);
        _orderStateLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#00ce68"] fontSize:FONTSIZE_16 labelTag:0 alignment:NSTextAlignmentRight];
        _orderStateLabel.centerY = _tableNoLabel.centerY;
//        _orderStateLabel.backgroundColor = [UIColor lightGrayColor];
    }
    
    // 订单状态类型
    CGFloat width = [_orderEntity.status_remark widthForFont:FONTSIZE_16];
//    debugLog(@"remar=%@", _orderEntity.status_remark);
    if (_orderEntity.status == NS_ORDER_ORDER_COMPLETE_STATE)
    {
        if (_orderEntity.comment_status == 0)
        {
            _orderStateLabel.text = @"未评论";
        }
        else
        {
            _orderStateLabel.text = @"已评论";
        }
    }
    else
    {
        _orderStateLabel.text = _orderEntity.status_remark;
    }
    /*
     NS_ORDER_ORDER_ONLINE_COMPLETE_STATE = 201, ///< 订单已完成(线上支付)
     NS_ORDER_ORDER_OFFLINE_COMPLETE_STATE
     */
    _orderStateLabel.width = width;
    _orderStateLabel.right = [[UIScreen mainScreen] screenWidth] - 15;
}

/**
 * 订单号(预订 | 订单号)
 */
- (void)initWithOrderNoLabel
{
    /*CGRect frame = CGRectMake(15, _tableNoLabel.bottom + 4, [[UIScreen mainScreen] screenWidth] - 30, 20);
    _orderNoLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
    //    _orderNoLabel.backgroundColor = [UIColor lightGrayColor];
     */
    if (!_orderNoLabel)
    {
        CGRect frame = CGRectMake(15, _tableNoLabel.bottom + 4, [[UIScreen mainScreen] screenWidth] - 30, 20);
        _orderNoLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
        //    _orderNoLabel.backgroundColor = [UIColor lightGrayColor];
    }
    // 订单号(预订 | 订单号)
    NSMutableAttributedString *mas = [NSMutableAttributedString new];
    NSString *str = @"预订 | ";
    if (_orderEntity.type == 2)
    {
        str = @"即时 | ";
    }
    NSAttributedString *bTitle = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: FONTSIZE(14), NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#ff5500"]}];
    [mas appendAttributedString:bTitle];
    NSAttributedString *value =  [self attributedTextTitle:@"订单编号：" value:objectNull(_orderEntity.order_id)];
    [mas appendAttributedString:value];
    _orderNoLabel.attributedText = mas;//[self attributedTextTitle:@"订单编号：" value:objectNull(_orderEntity.order_id)];
}

/**
 * 姓名
 */
- (void)initWithNameLabel
{
    /*CGRect frame = CGRectMake(15, _orderNoLabel.bottom + 4, [[UIScreen mainScreen] screenWidth] - 30, 20);
    _nameLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
    //    _nameLabel.backgroundColor = [UIColor lightGrayColor];
    */
    
    if (!_nameLabel)
    {
        CGRect frame = CGRectMake(15, _orderNoLabel.bottom + 4, [[UIScreen mainScreen] screenWidth] - 30, 20);
        _nameLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
        //    _nameLabel.backgroundColor = [UIColor lightGrayColor];
    }
    // 姓名
    _nameLabel.attributedText = [self attributedTextTitle:@"食客姓名：" value:objectNull(_orderEntity.customer_name)];
}

/**
 * 到店时间
 */
- (void)initWithArriveDateLabel
{
    /*CGRect frame = CGRectMake(15, _nameLabel.bottom + 4, [[UIScreen mainScreen] screenWidth] - 30, 20);
    _arriveDateLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
    //    _arriveDateLabel.backgroundColor = [UIColor lightGrayColor];
     */
    if (!_arriveDateLabel)
    {
        CGRect frame = CGRectMake(15, _nameLabel.bottom + 4, [[UIScreen mainScreen] screenWidth] - 30, 20);
        _arriveDateLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
        //    _arriveDateLabel.backgroundColor = [UIColor lightGrayColor];
    }
    
    NSString *date = [NSDate stringWithDateInOut:_orderEntity.create_date inFormat:@"yyyy-MM-dd HH:mm:ss" outFormat:@"yyyy-MM-dd HH:mm"];
    _arriveDateLabel.attributedText = [self attributedTextTitle:@"到店时间：" value:date];
}

/**
 * 餐桌类型
 */
- (void)initWithTableTypeLabel
{
    /*CGRect frame = CGRectMake(15, _arriveDateLabel.bottom + 4, ([[UIScreen mainScreen] screenWidth] - 30) / 3 * 2, 20);
    _tableTypeLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
    //    _tableTypeLabel.backgroundColor = [UIColor lightGrayColor];
     */
    if (!_tableTypeLabel)
    {
        CGRect frame = CGRectMake(15, _arriveDateLabel.bottom + 4, ([[UIScreen mainScreen] screenWidth] - 30) / 3 * 2, 20);
        _tableTypeLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
        //    _tableTypeLabel.backgroundColor = [UIColor lightGrayColor];
    }
    
    
    
    // 餐桌类型
    NSString *str = [NSString stringWithFormat:@"%d人桌", (int)_orderEntity.number];
    _tableTypeLabel.attributedText = [self attributedTextTitle:@"餐桌类型：" value:str];
}

/**
 *  结算日期
 */
- (void)initWithSettlementDateLabel
{
    if (!_settlementDateLabel)
    {
        CGRect frame = CGRectMake(15, _tableTypeLabel.bottom + 4, ([[UIScreen mainScreen] screenWidth] - 30) / 3 * 2, 20);
        _settlementDateLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
        //    _settlementDateLabel.backgroundColor = [UIColor lightGrayColor];
    }
    
    NSString *date = [NSDate stringWithDateInOut:_orderEntity.settle_date inFormat:@"yyyy-MM-dd HH:mm:ss" outFormat:@"yyyy-MM-dd HH:mm"];
    _settlementDateLabel.attributedText = [self attributedTextTitle:@"结算日期：" value:objectNull(date)];
}

/**
 * 查看订单
 */
- (void)initWithBtnLookOrder
{
    /*if (!_btnLookOrder)
    {
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - 15 - 75, 0, 75, 25);
        _btnLookOrder = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"查看订单" titleColor:[UIColor colorWithHexString:@"#ff5100"] titleFont:FONTSIZE_13 targetSel:@selector(clickedLook:)];
        _btnLookOrder.frame = frame;
        _btnLookOrder.layer.masksToBounds = YES;
        _btnLookOrder.layer.cornerRadius = 3.0;
        _btnLookOrder.layer.borderWidth = 1;
        _btnLookOrder.layer.borderColor = [UIColor colorWithHexString:@"#ff5100"].CGColor;
        _btnLookOrder.bottom = _settlementDateLabel.bottom;
        [self.contentView addSubview:_btnLookOrder];
    }*/
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
    
    // 桌号(大厅 | 桌号)
    [self initWithTableNoLabel];
    
    // 订单状态类型
    [self initWithOrderStateLabel];

    
    // 订单号(预订 | 订单号)
    [self initWithOrderNoLabel];
//    _orderNoLabel.attributedText = [self attributedTextTitle:@"预订 | 订单号" value:@"123456789"];
    
    // 姓名
    [self initWithNameLabel];
//    _nameLabel.attributedText = [self attributedTextTitle:@"食客姓名：" value:@"唐远震"];
    
    // 到店时间
    [self initWithArriveDateLabel];
//    _arriveDateLabel.attributedText = [self attributedTextTitle:@"到店时间：" value:@"2016-04-02 12:32"];
    
    // 餐桌类型
    [self initWithTableTypeLabel];
//    _tableTypeLabel.attributedText = [self attributedTextTitle:@"餐桌类型：" value:@"8人桌"];
    
    // 结算日期
    [self initWithSettlementDateLabel];
//    _settlementDateLabel.attributedText = [self attributedTextTitle:@"结算日期：" value:@"2016-04-02 12:32"];
    
    [self initWithBtnLookOrder];
}

@end
