//
//  DinersCreateOrderInfoViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/28.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DinersCreateOrderInfoViewCell.h"
#import "LocalCommon.h"
#import "RestaurantReservationInputEntity.h"

@interface DinersCreateOrderInfoViewCell ()
{
    
    UILabel *_orderIdLabel;
    
    /**
     *  预约时间
     */
    UILabel *_dueDateLabel;
    
    /**
     *  就餐人数
     */
    UILabel *_numberLabel;
    
    /**
     *  预约空间
     */
    UILabel *_shopLocationLabel;
    
    /**
     *  备注
     */
    UILabel *_noteLabel;
}
@property (nonatomic, strong) CALayer *line;

@property (nonatomic, strong) RestaurantReservationInputEntity *orderEntity;

- (void)initWithOrderIdLabel;

/**
 * 预约时间
 */
- (void)initWithDueDateLabel;

/**
 *  就餐人数
 */
- (void)initWithNumberLabel;


- (void)initWithShopLocationLabel;

/**
 *  备注
 */
- (void)initWithNoteLabel;


@end

@implementation DinersCreateOrderInfoViewCell

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithLine];
    
    
}

- (void)initWithLine
{
    if (!_line)
    {
        CALayer *line = [CALayer layer];
        line.size = CGSizeMake([[UIScreen mainScreen] screenWidth], 0.6);
        line.left = 0;
        line.bottom = kDinersCreateOrderInfoViewCellHeight;
        line.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"].CGColor;
        [self.contentView.layer addSublayer:line];
        self.line = line;
    }
}

- (void)initWithOrderIdLabel
{
    if (!_orderIdLabel)
    {
        CGRect frame = CGRectMake(15, 10, [[UIScreen mainScreen] screenWidth] - 30, 20);
        _orderIdLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
    }
}

/**
 * 预约时间
 */
- (void)initWithDueDateLabel
{
    CGRect frame = CGRectMake(15, 10, [[UIScreen mainScreen] screenWidth] - 30, 20);
    if (![objectNull(_orderEntity.orderId) isEqualToString:@""])
    {
        frame.origin.y = _orderIdLabel.bottom + 4;
    }
    if (!_dueDateLabel)
    {
        _dueDateLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
    }
    _dueDateLabel.frame = frame;
}

/**
 *  就餐人数
 */
- (void)initWithNumberLabel
{
    CGRect frame = CGRectMake(15, _dueDateLabel.bottom + 4, [[UIScreen mainScreen] screenWidth] - 30, 20);
    if (!_numberLabel)
    {
        _numberLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
    }
    else
    {
        _numberLabel.frame = frame;
    }
}


- (void)initWithShopLocationLabel
{
    CGRect frame = CGRectMake(15, _numberLabel.bottom + 4, [[UIScreen mainScreen] screenWidth] - 30, 20);
    if (!_shopLocationLabel)
    {
        _shopLocationLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
    }
    else
    {
        _shopLocationLabel.frame = frame;
    }
}

/**
 *  备注
 */
- (void)initWithNoteLabel
{
    CGRect frame = CGRectMake(15, _shopLocationLabel.bottom + 4, [[UIScreen mainScreen] screenWidth] - 30, 20);
    if (!_noteLabel)
    {
        _noteLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
    }
    else
    {
        _noteLabel.frame = frame;
    }
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

- (void)updateCellData:(id)cellEntity
{
    self.orderEntity = cellEntity;
    
    CGFloat bottom = kDinersCreateOrderInfoViewCellHeight;
    _orderIdLabel.hidden = YES;
    if (![objectNull(_orderEntity.orderId) isEqualToString:@""])
    {
        bottom = kDinersCreateOrderInfoViewCellMaxHeight;
        [self initWithOrderIdLabel];
        _orderIdLabel.hidden = NO;
    }
    _line.bottom = bottom;
    
    // 预约时间
    [self initWithDueDateLabel];
    
    // 就餐人数
    [self initWithNumberLabel];
    
    
    [self initWithShopLocationLabel];
    
    // 备注
    [self initWithNoteLabel];
    // 订单id
    _orderIdLabel.attributedText = [self attributedTextTitle:@"订单编号：" value:objectNull(_orderEntity.orderId) valueColor:nil];
    
    // 预约时间
    _dueDateLabel.attributedText = [self attributedTextTitle:@"预约时间：" value:[NSString stringWithFormat:@"%@ %@", _orderEntity.dueDate, _orderEntity.arriveShopTime] valueColor:nil];
    
    // 就餐人数
    _numberLabel.attributedText = [self attributedTextTitle:@"就餐人数：" value:[NSString stringWithFormat:@"%d", (int)_orderEntity.number] valueColor:nil];
    
    _shopLocationLabel.attributedText = [self attributedTextTitle:@"预约空间：" value:objectNull(_orderEntity.shopLocationNote) valueColor:nil];
    
    // 备注
    _noteLabel.attributedText = [self attributedTextTitle:@"备注信息：" value:objectNull(_orderEntity.note) valueColor:nil];
    [self initWithNoteLabel];
    
}


@end














