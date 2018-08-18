//
//  WaitingNoticeOrderViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/15.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "WaitingNoticeOrderViewCell.h"
#import "LocalCommon.h"
#import "OrderDataEntity.h"

@interface WaitingNoticeOrderViewCell ()
{
    UILabel *_stateLabel;
    
    /**
     *  订单编号
     */
    UILabel *_orderNoLabel;
    
    /**
     *  下单时间
     */
    UILabel *_placeOrderDateLabel;
    
    /**
     *  食客姓名
     */
    UILabel *_dinersNameLabel;
    
    /**
     *  食客手机号码
     */
    UILabel *_dinersMobileLabel;
    
    /**
     *  备注
     */
    UILabel *_noteLabel;
    
    UIButton *_btnLookOrder;
}

@property (nonatomic, strong) OrderDataEntity *orderEntity;

@property (nonatomic, strong) CALayer *line;

/**
 *
 */
- (void)initWithStateLabel;

/**
 *  订单编号
 */
- (void)initWithOrderNoLabel;

/**
 *  下单时间
 */
- (void)initWithPlaceOrderDateLabel;

/**
 *  食客姓名
 */
- (void)initWithDinersNameLabel;

/**
 *  食客姓名
 */
- (void)initWithDinersMobileLabel;

- (void)initWithNoteLabel;

@end

@implementation WaitingNoticeOrderViewCell

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    CALayer *line = [CALayer drawLine:self.contentView frame:CGRectMake(15, kWaitingNoticeOrderViewCellHeight - 44, [[UIScreen mainScreen] screenWidth] - 30, 0.6) lineColor:[UIColor colorWithHexString:@"#e0e0e0"]];
    self.line = line;
    
    
}

/**
 *
 */
- (void)initWithStateLabel
{
    if (!_stateLabel)
    {
        CGRect frame = CGRectMake(10, 10, [[UIScreen mainScreen] screenWidth] - 30, 20);
        _stateLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE_16 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    _stateLabel.text = [UtilityObject dinersWithOrderState:_orderEntity.status];//_orderEntity.status_remark;
}

/**
 *  订单编号
 */
- (void)initWithOrderNoLabel
{
    if (!_orderNoLabel)
    {
        CGRect frame = _stateLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _orderNoLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE_16 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    _orderNoLabel.attributedText = [self attributedTextTitle:@"订单编号：" value:objectNull(_orderEntity.order_id)];
}

/**
 *  下单时间
 */
- (void)initWithPlaceOrderDateLabel
{
    if (!_placeOrderDateLabel)
    {
//        NSString *str = @"下单时间：2015-12-13 12:32";
//        CGFloat width = [str widthForFont:FONTSIZE(14)] + 5;
        CGRect frame = _orderNoLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _placeOrderDateLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
    }
    
    // 下单时间
    NSString *date = [NSDate stringWithDateInOut:_orderEntity.dining_date inFormat:@"yyyy-MM-dd HH:mm:ss" outFormat:@"yyyy-MM-dd HH:mm"];
    _placeOrderDateLabel.attributedText = [self attributedTextTitle:@"下单时间：" value:date];
}

/**
 *  食客姓名
 */
- (void)initWithDinersNameLabel
{
    if (!_dinersNameLabel)
    {
        CGRect frame = CGRectMake(15, _placeOrderDateLabel.bottom + 4, [[UIScreen mainScreen] screenWidth]/2, 20);
        _dinersNameLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
    }
    _dinersNameLabel.attributedText = [self attributedTextTitle:@"食客姓名：" value:objectNull(_orderEntity.customer_name)];
}

/**
 *  食客手机
 */
- (void)initWithDinersMobileLabel
{
    if (!_dinersMobileLabel)
    {
        CGRect frame = CGRectMake(15, _dinersNameLabel.bottom + 4, [[UIScreen mainScreen] screenWidth]/3*3 - 20, 20);
        _dinersMobileLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
    }
    _dinersMobileLabel.attributedText = [self attributedTextTitle:@"食客手机：" value:objectNull(_orderEntity.mobile)];
}

- (void)initWithNoteLabel
{
    if (!_noteLabel)
    {
        CGRect frame = CGRectMake(15, _line.bottom + 12, [[UIScreen mainScreen] screenWidth] - 30, 20);
        _noteLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_14 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    _noteLabel.text = _orderEntity.remark;
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
    _btnLookOrder.bottom = _dinersMobileLabel.bottom;
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
    
    //
    [self initWithStateLabel];
    
    // 订单编号
    [self initWithOrderNoLabel];
    
    // 下单时间
    [self initWithPlaceOrderDateLabel];
    
    // 食客姓名
    [self initWithDinersNameLabel];
    
    // 食客姓名
    [self initWithDinersMobileLabel];
    
    [self initWithNoteLabel];
    
    [self initWithBtnLookOrder];
}


@end
