//
//  CTCRestaurantReserveOrderCell.m
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/14.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "CTCRestaurantReserveOrderCell.h"
#import "LocalCommon.h"

@interface CTCRestaurantReserveOrderCell ()
{
    /// 订单类型，预定还是即时
    UILabel *_orderTypelabel;
    
    /// 食客电话
    UILabel *_dinersPhoneLabel;
    
    /// 人数
    UILabel *_numberLabel;
    
    /// 餐位
    UILabel *_seatLabel;
    
    /// 类型
    UILabel *_typeLabel;
    
    /// 时间
    UILabel *_timeLabel;
    
    /// 备注
    UILabel *_noteLabel;
}
@property (nonatomic, strong) CALayer *line;

/**
 *  订单类型，预定还是即时
 */
- (void)initWithOrderTypeLabel;

/**
 *  食客电话
 */
- (void)initWithDinersPhoneLabel;

/**
 *  就餐人数
 */
- (void)initWithNumberLabel;

/**
 *  餐位
 */
- (void)initWithSeatLabel;

/**
 *  类型
 */
- (void)initWithTypeLabel;

/**
 *  时间
 */
- (void)initWithTimeLabel;

/**
 *  备注
 */
- (void)initWithNoteLabel;

@end

@implementation CTCRestaurantReserveOrderCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kCTCRestaurantReserveOrderCellHeight - 5, [[UIScreen mainScreen] screenWidth], 5)];
    bottomView.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    [self.contentView addSubview:bottomView];
    
    CALayer *line = [CALayer drawLine:self.contentView frame:CGRectMake(0, 30, [[UIScreen mainScreen] screenWidth], 0.5) lineColor:[UIColor colorWithHexString:@"#e0e0e0"]];
    self.line = line;
}

/**
 *  订单类型，预定还是即时
 */
- (void)initWithOrderTypeLabel
{
    if (!_orderTypelabel)
    {
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - 10 - 15, (_line.top - 15.0)/2., 15, 15);
        _orderTypelabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor whiteColor] fontSize:FONTSIZE_11 labelTag:0 alignment:NSTextAlignmentCenter];
    }
    
    _orderTypelabel.text = @"预";
    _orderTypelabel.backgroundColor = [UIColor colorWithHexString:@"#85addb"];
    
    // “预” #85addb   “即” #f09f9b
}

/**
 *  食客电话
 */
- (void)initWithDinersPhoneLabel
{
    if (!_dinersPhoneLabel)
    {
        CGRect frame = CGRectMake(10, (_line.top - 20)/2., _orderTypelabel.left - 10 - 10, 20);
        _dinersPhoneLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor whiteColor] fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
    }
    
    NSString *str = [NSString stringWithFormat:@"食客电话：%@", @"18261929604"];
    NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] init];
    UIColor *color = [UIColor colorWithHexString:@"#323232"];
    NSAttributedString *bTitle = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: FONTSIZE(13), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:bTitle];
    
    str = [NSString stringWithFormat:@"（%@）", @"唐先生"];
    color = [UIColor colorWithHexString:@"#999999"];
    bTitle = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: FONTSIZE(13), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:bTitle];
    _dinersPhoneLabel.attributedText = mas;
}

/**
 *  就餐人数
 */
- (void)initWithNumberLabel
{
    if (!_numberLabel)
    {
        CGRect frame = CGRectMake(10, _line.bottom + 8, [[UIScreen mainScreen] screenWidth] / 2 - 20, 16);
        _numberLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    NSString *str = [NSString stringWithFormat:@"人数：%d", 15];
    _numberLabel.text = str;
}

/**
 *  餐位
 */
- (void)initWithSeatLabel
{
    if (!_seatLabel)
    {
        CGRect frame = CGRectMake(_numberLabel.right + 20, _line.bottom + 10, _numberLabel.width, 16);
        _seatLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    NSString *str = [NSString stringWithFormat:@"餐位：%@", @"大厅"];
    _seatLabel.text = str;
}

/**
 *  类型
 */
- (void)initWithTypeLabel
{
    if (!_typeLabel)
    {
        CGRect frame = _numberLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 5;
        _typeLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    NSString *str = [NSString stringWithFormat:@"类型：%@", @"餐位预定"];
    _typeLabel.text = str;
}

/**
 *  时间
 */
- (void)initWithTimeLabel
{
    if (!_timeLabel)
    {
        CGRect frame = _typeLabel.frame;
        frame.origin.x = _seatLabel.x;
        _timeLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    NSString *str = [NSString stringWithFormat:@"时间：%@", @"2016/10/24 12:30"];
    _timeLabel.text = str;
}

/**
 *  备注
 */
- (void)initWithNoteLabel
{
    if (!_noteLabel)
    {
        CGRect frame = _typeLabel.frame;
        frame.size.width = [[UIScreen mainScreen] screenWidth] - 20;
        frame.origin.y = frame.origin.y + frame.size.height + 5;
        _noteLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    
    NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] init];
    UIColor *color = [UIColor colorWithHexString:@"#646464"];
    NSAttributedString *bTitle = [[NSAttributedString alloc] initWithString:@"备注：" attributes:@{NSFontAttributeName: FONTSIZE(12), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:bTitle];
    [UIColor colorWithHexString:@"#cccccc"];
    bTitle = [[NSAttributedString alloc] initWithString:@"无" attributes:@{NSFontAttributeName: FONTSIZE(12), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:bTitle];
    _noteLabel.attributedText = mas;
}

- (void)updateCellData:(id)cellEntity
{
    
    // 订单类型，预定还是即时
    [self initWithOrderTypeLabel];
    
    // 食客电话
    [self initWithDinersPhoneLabel];
    
    // 就餐人数
    [self initWithNumberLabel];
    
    // 餐位
    [self initWithSeatLabel];
    
    // 类型
    [self initWithTypeLabel];
    
    // 时间
    [self initWithTimeLabel];
    
    // 备注
    [self initWithNoteLabel];
}

@end














