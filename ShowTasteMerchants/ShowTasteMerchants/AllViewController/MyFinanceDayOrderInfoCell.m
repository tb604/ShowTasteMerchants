//
//  MyFinanceDayOrderInfoCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/7.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyFinanceDayOrderInfoCell.h"
#import "LocalCommon.h"

@interface MyFinanceDayOrderInfoCell ()
{
    /**
     *  ”进入订单“
     */
    UILabel *_dayOrderLabel;
    
    
    // btn_tiaozhuan
    
    UIImageView *_thanImgView;
    
    /**
     *  今日订单数量
     */
    UILabel *_dayOrderNumLabel;
    
    /**
     *  白天的图片
     */
    UIImageView *_duringDayImgView;
    
    /**
     *  午餐段总的订单量标题
     */
    UILabel *_lunchOrderNumLabel;
    
    /**
     *  午餐段已完成的订单量标题
     */
    UILabel *_lunchOrderFinishNumLabel;
    
    /**
     *  午餐段处理中标题
     */
    UILabel *_lunchOrderProcessNumLabel;
    
    /**
     *  午餐端异常的订单量标题
     */
    UILabel *_lunchOrderAbnormalNumLabel;
    
    /**
     *  午餐段总的订单量
     */
    UILabel *_lunchOrderNumsLabel;
    
    /**
     *  午餐段已完成的订单量
     */
    UILabel *_lunchOrderFinishNumsLabel;
    
    /**
     *  午餐段处理中的订单数量
     */
    UILabel *_lunchOrderProcessNumsLabel;
    
    /**
     *  午餐端异常的订单量
     */
    UILabel *_lunchOrderAbnormalNumsLabel;
    
    /**
     *  晚上的图片
     */
    UIImageView *_eveningImgView;
    // ABNORMAL
    
    // dinner
    /**
     *  晚餐段总的订单量标题
     */
    UILabel *_dinnerOrderNumLabel;
    
    /**
     *  晚餐段已完成的订单量标题
     */
    UILabel *_dinnerOrderFinishNumLabel;
    
    /**
     *  晚餐端处理中标题
     */
    UILabel *_dinnerOrderProcessNumLabel;
    
    /**
     *  晚餐端异常的订单量标题
     */
    UILabel *_dinnerOrderAbnormalNumLabel;
    
    /**
     *  晚餐段总的订单量
     */
    UILabel *_dinnerOrderNumsLabel;
    
    /**
     *  晚餐段已完成的订单量
     */
    UILabel *_dinnerOrderFinishNumsLabel;
    
    /**
     *  晚餐段处理中的订单数量
     */
    UILabel *_dinnerOrderProcessNumsLabel;
    
    /**
     *  晚餐端异常的订单量
     */
    UILabel *_dinnerOrderAbnormalNumsLabel;
}
@property (nonatomic, strong) CALayer *lineOne;

@property (nonatomic, strong) CALayer *middleLine;

@property (nonatomic, strong) CALayer *lineLeft;

@property (nonatomic, strong) CALayer *lineRight;

/**
 *  ”今日订单“
 */
- (void)initWithDayOrderLabel;

/**
 *  大于号
 */
- (void)initWithThanImgView;

/**
 *  今日订单的数量
 */
- (void)initWithDayOrderNumLabel;

/**
 *  初始化白天的图片
 */
- (void)initWithDuringDayImgView;

/**
 *  初始化晚上的图片
 */
- (void)initWithEveningImgView;

/**
 * 午餐段总的订单量标题
 */
- (void)initWithLunchOrderNumLabel;

/**
 * 午餐段已完成的订单量标题
 */
- (void)initWithLunchOrderFinishNumLabel;

/**
 *  晚餐端处理中标题
 */
- (void)initWithDinnerOrderProcessNumLabel;

/**
 *  午餐段处理中标题
 */
- (void)initWithlunchOrderProcessNumLabel;

/**
 * 午餐端异常的订单量标题
 */
- (void)initWithLunchOrderAbnormalNumLabel;

/**
 *  午餐段总的订单量
 */
- (void)initWithLunchOrderNumsLabel;

/**
 * 午餐段已完成的订单量
 */
- (void)initWithLunchOrderFinishNumsLabel;

/**
 *  午餐段处理中的订单数量
 */
- (void)initWithLunchOrderProcessNumsLabel;

/**
 * 午餐端异常的订单量
 */
- (void)initWithLunchOrderAbnormalNumsLabel;

/**
 * 晚餐段总的订单量标题
 */
- (void)initWithDinnerOrderNumLabel;

/**
 * 晚餐段已完成的订单量标题
 */
- (void)initWithDinnerOrderFinishNumLabel;

/**
 * 晚餐端异常的订单量标题
 */
- (void)initWithDinnerOrderAbnormalNumLabel;

/**
 * 晚餐段总的订单量
 */
- (void)initWithDinnerOrderNumsLabel;

/**
 * 晚餐段已完成的订单量
 */
- (void)initWithDinnerOrderFinishNumsLabel;

/**
 *  晚餐段处理中的订单数量
 */
- (void)initWithDinnerOrderProcessNumsLabel;

/**
 * 晚餐端异常的订单量
 */
- (void)initWithDinnerOrderAbnormalNumsLabel;

@end

@implementation MyFinanceDayOrderInfoCell

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
    
    self.backgroundView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    
    CALayer *layer = [CALayer drawLine:self.contentView frame:CGRectMake(0, 50, [[UIScreen mainScreen] screenWidth], 0.6) lineColor:[UIColor colorWithHexString:@"#e1e1e1"]];
    self.lineOne = layer;
    
    layer = [CALayer drawLine:self.contentView frame:CGRectMake([[UIScreen mainScreen] screenWidth] / 2, _lineOne.bottom, 0.6, kMyFinanceDayOrderInfoCellHeight - _lineOne.bottom) lineColor:[UIColor colorWithHexString:@"#e1e1e1"]];
    self.middleLine = layer;
    
    layer = [CALayer drawLine:self.contentView frame:CGRectMake([[UIScreen mainScreen] screenWidth] / 7.5, _lineOne.bottom + 10, 0.6, _middleLine.height - 20) lineColor:[UIColor colorWithHexString:@"#e1e1e1"]];
    self.lineLeft = layer;
    
    layer = [CALayer drawLine:self.contentView frame:CGRectMake(_middleLine.right + _lineLeft.left, _lineOne.bottom + 10, 0.6, _middleLine.height - 20) lineColor:[UIColor colorWithHexString:@"#e1e1e1"]];
    self.lineRight = layer;
    
    // ”今日订单“
    [self initWithDayOrderLabel];
    
    // 大于号
    [self initWithThanImgView];
    
    // 今日订单的数量
    [self initWithDayOrderNumLabel];
    
    // 初始化白天的图片
    [self initWithDuringDayImgView];
    
    // 午餐段已完成的订单量标题
    [self initWithLunchOrderFinishNumLabel];
    
    // 午餐段总的订单量标题
    [self initWithLunchOrderNumLabel];
    
    // 午餐段处理中标题
    [self initWithlunchOrderProcessNumLabel];
    
    // 午餐端异常的订单量标题
    [self initWithLunchOrderAbnormalNumLabel];
    
    // 午餐段总的订单量
    [self initWithLunchOrderNumsLabel];
    
    // 午餐段已完成的订单量
    [self initWithLunchOrderFinishNumsLabel];
    
    // 午餐段处理中的订单数量
    [self initWithLunchOrderProcessNumsLabel];
    
    // 午餐端异常的订单量
    [self initWithLunchOrderAbnormalNumsLabel];
    
    // 初始化晚上的图片
    [self initWithEveningImgView];
    
    // 晚餐段总的订单量标题
    [self initWithDinnerOrderNumLabel];
    
    // 晚餐段已完成的订单量标题
    [self initWithDinnerOrderFinishNumLabel];
    
    // 晚餐端处理中标题
    [self initWithDinnerOrderProcessNumLabel];
    
    // 晚餐端异常的订单量标题
    [self initWithDinnerOrderAbnormalNumLabel];
    
    // 晚餐段总的订单量
    [self initWithDinnerOrderNumsLabel];
    
    // 晚餐段已完成的订单量
    [self initWithDinnerOrderFinishNumsLabel];
    
    // 晚餐段处理中的订单数量
    [self initWithDinnerOrderProcessNumsLabel];
    
    // 晚餐端异常的订单量
    [self initWithDinnerOrderAbnormalNumsLabel];
}

- (void)initWithDayOrderLabel
{
    if (!_dayOrderLabel)
    {
        NSString *str = @"今日订单";
        CGFloat width = [str widthForFont:FONTSIZE_15];
        CGRect frame = CGRectMake(15, (_lineOne.top - 20)/2, width + 10, 20);
        _dayOrderLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
        _dayOrderLabel.text = str;
    }
}

- (void)initWithThanImgView
{
    if (!_thanImgView)
    {// btn_tiaozhuan
        UIImage *image = [UIImage imageNamed:@"finance_btn_tiao"];
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - 15 - image.size.width, 0, image.size.width, image.size.height);
        _thanImgView = [[UIImageView alloc] initWithFrame:frame];
        _thanImgView.image = image;
        [self.contentView addSubview:_thanImgView];
        _thanImgView.centerY = _dayOrderLabel.centerY;
    }
}

// 今日订单总量
- (void)initWithDayOrderNumLabel
{
    if (!_dayOrderNumLabel)
    {
        CGRect frame = CGRectMake(_dayOrderLabel.right + 10, (50.0-20)/2, _thanImgView.left - 10 - _dayOrderLabel.right - 10, 20);
        _dayOrderNumLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_16 labelTag:0 alignment:NSTextAlignmentRight];
//        _dayOrderNumLabel.backgroundColor = [UIColor lightGrayColor];
    }
}

/**
 *  初始化白天的图片
 */
- (void)initWithDuringDayImgView
{
    if (!_duringDayImgView)
    {// finance_icon_day
        UIImage *image = [UIImage imageNamed:@"finance_icon_day"];
        CGRect frame = CGRectMake((_lineLeft.left - image.size.width)/2, 0, image.size.width, image.size.height);
        _duringDayImgView = [[UIImageView alloc] initWithFrame:frame];
        _duringDayImgView.image = image;
        _duringDayImgView.centerY = _lineLeft.centerY;
        [self.contentView addSubview:_duringDayImgView];
    }
}

/**
 *  初始化晚上的图片
 */
- (void)initWithEveningImgView
{
    if (!_eveningImgView)
    {// finance_icon_night
        UIImage *image = [UIImage imageNamed:@"finance_icon_night"];
        CGRect frame = CGRectMake((_lineRight.left - _middleLine.right - image.size.width)/2 + _middleLine.right, 0, image.size.width, image.size.height);
        _eveningImgView = [[UIImageView alloc] initWithFrame:frame];
        _eveningImgView.image = image;
        _eveningImgView.centerY = _lineLeft.centerY;
        [self.contentView addSubview:_eveningImgView];
    }
}

/**
 * 午餐段总的订单量
 */
- (void)initWithLunchOrderNumLabel
{
    if (!_lunchOrderNumLabel)
    {
        CGRect frame = _lunchOrderFinishNumLabel.frame;
        frame.origin.y = _lunchOrderFinishNumLabel.top - 5 - 20;
        _lunchOrderNumLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
        _lunchOrderNumLabel.text = @"午餐段";
    }
}

/**
 * 午餐段已完成的订单量
 */
- (void)initWithLunchOrderFinishNumLabel
{
    if (!_lunchOrderFinishNumLabel)
    {
        NSString *str = @"已完成";
        float width = [str widthForFont:FONTSIZE_13];
        CGRect frame = CGRectMake(_lineLeft.right + 15, (_middleLine.height - 20)/2 + _lineOne.bottom - 10, width, 20);
        _lunchOrderFinishNumLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
        _lunchOrderFinishNumLabel.text = str;
    }
}

/**
 *  午餐段处理中标题
 */
- (void)initWithlunchOrderProcessNumLabel
{
    if (!_lunchOrderProcessNumLabel)
    {
        CGRect frame = _lunchOrderFinishNumLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 5;
        _lunchOrderProcessNumLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
        _lunchOrderProcessNumLabel.text = @"处理中";
    }
}

/**
 * 午餐端异常的订单量
 */
- (void)initWithLunchOrderAbnormalNumLabel
{
    if (!_lunchOrderAbnormalNumLabel)
    {
        CGRect frame = _lunchOrderProcessNumLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 5;
        _lunchOrderAbnormalNumLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
        _lunchOrderAbnormalNumLabel.text = @"异常";
    }
}

/**
 *  午餐段总的订单量
 */
- (void)initWithLunchOrderNumsLabel
{
    if (!_lunchOrderNumsLabel)
    {
        CGRect frame = _lunchOrderNumLabel.frame;
        frame.origin.x = frame.origin.x + frame.size.width + 5;
        frame.size.width = _middleLine.left - 15 - _lunchOrderNumLabel.right - 10;
        _lunchOrderNumsLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentRight];
//        _lunchOrderNumsLabel.backgroundColor = [UIColor lightGrayColor];
    }
}

/**
 * 午餐段已完成的订单量
 */
- (void)initWithLunchOrderFinishNumsLabel
{
    if (!_lunchOrderFinishNumsLabel)
    {
        CGRect frame = _lunchOrderNumsLabel.frame;
        frame.origin.y = _lunchOrderFinishNumLabel.top;
        _lunchOrderFinishNumsLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentRight];
        //        _lunchOrderFinishNumsLabel.backgroundColor = [UIColor lightGrayColor];
    }
}

/**
 *  午餐段处理中的订单数量
 */
- (void)initWithLunchOrderProcessNumsLabel
{
    if (!_lunchOrderProcessNumsLabel)
    {
        CGRect frame = _lunchOrderNumsLabel.frame;
        frame.origin.y = _lunchOrderProcessNumLabel.top;
        _lunchOrderProcessNumsLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentRight];
    }
}

/**
 * 午餐端异常的订单量
 */
- (void)initWithLunchOrderAbnormalNumsLabel
{
    if (!_lunchOrderAbnormalNumsLabel)
    {
        CGRect frame = _lunchOrderNumsLabel.frame;
        frame.origin.y = _lunchOrderAbnormalNumLabel.top;
        _lunchOrderAbnormalNumsLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentRight];
//        _lunchOrderAbnormalNumsLabel.backgroundColor = [UIColor lightGrayColor];
    }
}


/**
 * 晚餐段总的订单量标题
 */
- (void)initWithDinnerOrderNumLabel
{
    if (!_dinnerOrderNumLabel)
    {
        CGRect frame = _lunchOrderNumLabel.frame;
        frame.origin.x = _lineRight.right + 15;
        _dinnerOrderNumLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
        _dinnerOrderNumLabel.text = @"晚餐段";
    }
}

/**
 * 晚餐段已完成的订单量标题
 */
- (void)initWithDinnerOrderFinishNumLabel
{
    if (!_dinnerOrderFinishNumLabel)
    {
        CGRect frame = _lunchOrderFinishNumLabel.frame;
        frame.origin.x = _lineRight.right + 15;
        _dinnerOrderFinishNumLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
        _dinnerOrderFinishNumLabel.text = @"已完成";
    }
}

/**
 *  晚餐端处理中标题
 */
- (void)initWithDinnerOrderProcessNumLabel
{
    if (!_dinnerOrderProcessNumLabel)
    {
        CGRect frame = _lunchOrderProcessNumLabel.frame;
        frame.origin.x = _lineRight.right + 15;
        _dinnerOrderProcessNumLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
        _dinnerOrderProcessNumLabel.text = @"处理中";
    }
}

/**
 * 晚餐端异常的订单量标题
 */
- (void)initWithDinnerOrderAbnormalNumLabel
{
    if (!_dinnerOrderAbnormalNumLabel)
    {
        CGRect frame = _lunchOrderAbnormalNumLabel.frame;
        frame.origin.x = _lineRight.right + 15;
        _dinnerOrderAbnormalNumLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
        _dinnerOrderAbnormalNumLabel.text = @"异常";
    }
}

/**
 * 晚餐段总的订单量
 */
- (void)initWithDinnerOrderNumsLabel
{
    if (!_dinnerOrderNumsLabel)
    {
        CGRect frame = _lunchOrderNumsLabel.frame;
        frame.origin.x = _dinnerOrderNumLabel.right + 10;
        _dinnerOrderNumsLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentRight];
//        _dinnerOrderNumsLabel.backgroundColor = [UIColor lightGrayColor];
    }
}

/**
 * 晚餐段已完成的订单量
 */
- (void)initWithDinnerOrderFinishNumsLabel
{
    if (!_dinnerOrderFinishNumsLabel)
    {
        CGRect frame = _lunchOrderFinishNumsLabel.frame;
        frame.origin.x = _dinnerOrderNumLabel.right + 10;
        _dinnerOrderFinishNumsLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentRight];
//        _dinnerOrderFinishNumsLabel.backgroundColor = [UIColor lightGrayColor];
    }
}

/**
 *  晚餐段处理中的订单数量
 */
- (void)initWithDinnerOrderProcessNumsLabel
{
    if (!_dinnerOrderProcessNumsLabel)
    {
        CGRect frame = _lunchOrderProcessNumsLabel.frame;
        frame.origin.x = _dinnerOrderProcessNumLabel.right + 10;
        _dinnerOrderProcessNumsLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentRight];
    }
}

/**
 * 晚餐端异常的订单量
 */
- (void)initWithDinnerOrderAbnormalNumsLabel
{
    if (!_dinnerOrderAbnormalNumsLabel)
    {
        CGRect frame = _lunchOrderAbnormalNumsLabel.frame;
        frame.origin.x = _dinnerOrderAbnormalNumLabel.right + 10;
        _dinnerOrderAbnormalNumsLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentRight];
//        _dinnerOrderAbnormalNumsLabel.backgroundColor = [UIColor lightGrayColor];
    }
}


- (void)updateCellData:(id)cellEntity
{
    MyFinanceTodayDataEntity *todayEnt = cellEntity;
    // 今日订单的数量
    _dayOrderNumLabel.text = [NSString stringWithFormat:@"共%d单", (int)todayEnt.total_count];
    
    // 午餐段已完成的订单量
//    _lunchOrderFinishNumLabel.text = @"已完成";
    
    // 午餐段总的订单量
//    _lunchOrderNumLabel.text = @"午餐段";
    
    // 午餐端异常的订单量
//    _lunchOrderAbnormalNumLabel.text = @"异常";
    
    // 午餐段总的订单量
    _lunchOrderNumsLabel.text = [NSString stringWithFormat:@"%d", (int)todayEnt.am.count];
    
    // 午餐段已完成的订单量down_count
    _lunchOrderFinishNumsLabel.text = [NSString stringWithFormat:@"%d", (int)todayEnt.am.down_count];
    
    // 午餐段处理中的订单数量
    _lunchOrderProcessNumsLabel.text = [NSString stringWithFormat:@"%d", (int)todayEnt.am.proc_count];
    
    // 午餐端异常的订单量
    _lunchOrderAbnormalNumsLabel.text = [NSString stringWithFormat:@"%d", (int)todayEnt.am.exp_count];
    
    // 晚餐段总的订单量
//    _dinnerOrderNumLabel.text = @"晚餐段";
    
    // 晚餐段已完成的订单量
//    _dinnerOrderFinishNumLabel.text = @"已完成";
    
    // 晚餐端异常的订单量
//    _dinnerOrderAbnormalNumLabel.text = @"未完成";
    
    // 晚餐段总的订单量
    _dinnerOrderNumsLabel.text = [NSString stringWithFormat:@"%d", (int)todayEnt.pm.count];
    
    // 晚餐段已完成的订单量
    _dinnerOrderFinishNumsLabel.text = [NSString stringWithFormat:@"%d", (int)todayEnt.pm.down_count];
    
    // 晚餐段处理中的订单数量
    _dinnerOrderProcessNumsLabel.text = [NSString stringWithFormat:@"%d", (int)todayEnt.pm.proc_count];
    
    // 晚餐端异常的订单量
    _dinnerOrderAbnormalNumsLabel.text = [NSString stringWithFormat:@"%d", (int)todayEnt.pm.exp_count];
}

@end





















