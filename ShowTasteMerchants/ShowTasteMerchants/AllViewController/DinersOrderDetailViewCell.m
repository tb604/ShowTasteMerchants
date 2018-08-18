//
//  DinersOrderDetailViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/29.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DinersOrderDetailViewCell.h"
#import "LocalCommon.h"
#import "OrderDataEntity.h"

@interface DinersOrderDetailViewCell ()
{
    /**
     *  类型（“预订 | 包间 | 321”）
     */
    UILabel *_typeLabel;
    
    /**
     *  订单id
     */
    UILabel *_orderNoLabel;
    
    /**
     *  下单时间
     */
    UILabel *_placeOrderLabel;
    
    /**
     *  预订时间
     */
    UILabel *_reserveDateLabel;
    
    /**
     *  就餐人数
     */
    UILabel *_numberLabel;
    
    /**
     *  预约空间
     */
    UILabel *_locationLabel;
    
    /**
     *  备注信息
     */
    UILabel *_noteLabel;
}

@property (nonatomic, strong) OrderDataEntity *orderEntity;

/**
 * 类型（“预订 | 包间 | 321”）
 */
- (void)initWithTypeLabel;

/**
 * 订单id
 */
- (void)initWithOrderNoLabel;

/**
 *  下单时间
 */
- (void)initWithPlaceOrderLabel;

/**
 * 预订时间
 */
- (void)initWithReserveDateLabel;

/**
 * 就餐人数
 */
- (void)initWithNumberLabel;

/**
 * 预约空间
 */
- (void)initWithLocationLabel;

/**
 * 备注信息
 */
- (void)initWithNoteLabel;


@end

@implementation DinersOrderDetailViewCell

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
}

/**
 * 类型（“预订 | 包间 | 321”）
 */
- (void)initWithTypeLabel
{
    if (!_typeLabel)
    {
        CGRect frame = CGRectMake(15, 10, [[UIScreen mainScreen] screenWidth] - 30, 20);
        _typeLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
//        _typeLabel.backgroundColor = [UIColor lightGrayColor];
    }
    
    NSString *str = @"";
    if (_orderEntity.type == 1)
    {
        str = @"预订";
    }
    else if (_orderEntity.type == 2)
    {
        str =@"即时";
    }
    
    NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] init];
    UIColor *color = [UIColor colorWithHexString:@"#323232"];
    NSAttributedString *bTitle = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: FONTSIZE(18), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:bTitle];
    if (![objectNull(_orderEntity.seat_type_name) isEqualToString:@""])
    {
        if (_orderEntity.type == 1)
        {
            color = [UIColor colorWithHexString:@"#ff5500"];
            str = [NSString stringWithFormat:@" | %@", _orderEntity.seat_type_name];
            bTitle = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: FONTSIZE(18), NSForegroundColorAttributeName: color}];
            [mas appendAttributedString:bTitle];
        }
    }
    
    if (![objectNull(_orderEntity.seat_number) isEqualToString:@""])
    {
        color = [UIColor colorWithHexString:@"#ff5500"];
        str = [NSString stringWithFormat:@" | %@", _orderEntity.seat_number];
        bTitle = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: FONTSIZE(18), NSForegroundColorAttributeName: color}];
        [mas appendAttributedString:bTitle];
    }
    
    _typeLabel.attributedText = mas;
}

/**
 * 订单id
 */
- (void)initWithOrderNoLabel
{
    if (!_orderNoLabel)
    {
        CGRect frame = _typeLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _orderNoLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
//        _orderNoLabel.backgroundColor = [UIColor lightGrayColor];
    }
    _orderNoLabel.attributedText = [self attributedTextTitle:@"订单编号：" value:objectNull(_orderEntity.order_id) valueColor:nil];
}

/**
 *  下单时间
 */
- (void)initWithPlaceOrderLabel
{
    if (!_placeOrderLabel)
    {
        CGRect frame = _orderNoLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _placeOrderLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
//        _placeOrderLabel.backgroundColor = [UIColor lightGrayColor];
    }
    NSDate *date = [NSDate dateWithString:_orderEntity.create_date format:@"yyyy-MM-dd HH:mm:ss"];
    NSString *str = [date stringWithFormat:@"yyyy-MM-dd HH:mm"];
    _placeOrderLabel.attributedText = [self attributedTextTitle:@"下单时间：" value:objectNull(str) valueColor:nil];
}

/**
 * 预订时间
 */
- (void)initWithReserveDateLabel
{
    if (!_reserveDateLabel)
    {
        CGRect frame = _placeOrderLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _reserveDateLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
//        _reserveDateLabel.backgroundColor = [UIColor lightGrayColor];
    }
    
//    NSDate *date = [NSDate dateWithString:_orderEntity.dining_date format:@"yyyy-MM-dd HH:mm:ss"];
    NSString *str = [NSDate stringWithDateInOut:_orderEntity.dining_date inFormat:@"yyyy-MM-dd HH:mm:ss" outFormat:@"yyyy-MM-dd HH:mm"];//[date stringWithFormat:@"yyyy-MM-dd HH:mm"];
    _reserveDateLabel.attributedText = [self attributedTextTitle:@"预约时间：" value:objectNull(str) valueColor:nil];
}

/**
 * 就餐人数
 */
- (void)initWithNumberLabel
{
    if (!_numberLabel)
    {
        CGRect frame = _reserveDateLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _numberLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
//        _numberLabel.backgroundColor = [UIColor lightGrayColor];
    }
    NSString *str = [NSString stringWithFormat:@"%d", (int)_orderEntity.number];
    _numberLabel.attributedText = [self attributedTextTitle:@"就餐人数：" value:str valueColor:nil];
}

/**
 * 预约空间
 */
- (void)initWithLocationLabel
{
    if (!_locationLabel)
    {
        CGRect frame = _numberLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _locationLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
//        _locationLabel.backgroundColor = [UIColor lightGrayColor];
    }
    
    _locationLabel.attributedText = [self attributedTextTitle:@"预约空间：" value:objectNull(_orderEntity.seat_type_name) valueColor:nil];
}

/**
 * 备注信息
 */
- (void)initWithNoteLabel
{
    if (!_noteLabel)
    {
        CGRect frame = _locationLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _noteLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
//        _noteLabel.backgroundColor = [UIColor lightGrayColor];
    }
    
    _noteLabel.attributedText = [self attributedTextTitle:@"备注信息：" value:objectNull(_orderEntity.remark) valueColor:nil];
}

+ (CGFloat)getWithCellHeight:(NSInteger)type
{
    if (type == 1)
    {// 预订
        return 10 + 24 + 140 + 10;
    }
    else
    {// 即时
        return 10 + 8 + 60 + 10;
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
    // 类型（“预订 | 包间 | 321”）
    [self initWithTypeLabel];
    
    // 订单id
    [self initWithOrderNoLabel];
    
    // 下单时间
    [self initWithPlaceOrderLabel];
    
    if (_orderEntity.type == 1)
    {
        // 预订时间
        [self initWithReserveDateLabel];
        
        // 就餐人数
        [self initWithNumberLabel];
        
        // 预约空间
        [self initWithLocationLabel];
        
        // 备注信息
        [self initWithNoteLabel];
    }
}

@end
