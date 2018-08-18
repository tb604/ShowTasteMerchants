//
//  MyFinanceWeekOrderChartViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/7.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyFinanceWeekOrderChartViewCell.h"
#import "LocalCommon.h"
//#import "XWPieChartView.h"
#import "TYZPieChart.h"

@interface MyFinanceWeekOrderChartViewCell ()
{
    
    UILabel *_titleLabel;
    
    /**
     *  午餐、晚餐、其它
     */
    TYZPieChart *_lunchDinnerChartView;
    
    /**
     *  预订、即时、其它
     */
    TYZPieChart *_diningTypeChartView;
    
    /**
     *  订单的几种状态
     */
    TYZPieChart *_orderStateChartView;
}

- (void)initWithTitleLabel;

/**
 * 午餐、晚餐、其它
 */
- (void)initWithLunchDinnerChartView;

/**
 * 预订、即时、其它
 */
- (void)initWithDiningTypeChartView;

/**
 * 订单的几种状态
 */
- (void)initWithOrderStateChartView;

@end

@implementation MyFinanceWeekOrderChartViewCell

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
    
    [self initWithTitleLabel];
    
    // 午餐、晚餐、其它
    [self initWithLunchDinnerChartView];
    
    // 预订、即时、其它
    [self initWithDiningTypeChartView];
    
    // 订单的几种状态
    [self initWithOrderStateChartView];
    
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        CGRect frame = CGRectMake(15, 10, [[UIScreen mainScreen] screenWidth] - 30, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
        _titleLabel.text = @"本周订单数据";
    }
}

/**
 * 午餐、晚餐、其它
 */
- (void)initWithLunchDinnerChartView
{
    if (!_lunchDinnerChartView)
    {
//        XWPieChartTitleView
        CGFloat width = [XWPieChartTitleView getWithWidth];
        CGFloat pathWidth = [[UIScreen mainScreen] screenWidth] / 2 - 15 - 10 - 10 - width;
        CGRect frame = CGRectMake(0, _titleLabel.bottom + 5, [[UIScreen mainScreen] screenWidth] / 2, pathWidth);
        _lunchDinnerChartView = [[TYZPieChart alloc] initWithFrame:frame];
        _lunchDinnerChartView.isShadow = NO;
//        _lunchDinnerChartView.backgroundColor = [UIColor lightGrayColor];
        _lunchDinnerChartView.valueArray = [NSMutableArray arrayWithObjects:@"280", @"255", @"308", nil];
        _lunchDinnerChartView.nameArray = [NSMutableArray arrayWithObjects:@"午餐", @"晚餐", @"其他", nil];
        _lunchDinnerChartView.colorArray = [NSMutableArray arrayWithObjects:[UIColor colorWithHexString:@"#f8b651"], [UIColor colorWithHexString:@"#438ac9"], [UIColor colorWithHexString:@"#c391bf"], nil];
        
        _lunchDinnerChartView.percentType = kPercentTypeInteger;
        [self.contentView addSubview:_lunchDinnerChartView];
        [_lunchDinnerChartView strokePath];
    }
}

/*
 ZFPieChart * pieChart = [[ZFPieChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
 pieChart.title = @"xx小学各年级人数占比";
 //    pieChart.valueArray = [NSMutableArray arrayWithObjects:@"280", @"255", @"308", @"273", @"236", @"267", nil];
 //    pieChart.nameArray = [NSMutableArray arrayWithObjects:@"一年级", @"二年级", @"三年级", @"四年级", @"五年级", @"六年级", nil];
 //    pieChart.colorArray = [NSMutableArray arrayWithObjects:ZFColor(71, 204, 255, 1), ZFColor(253, 203, 76, 1), ZFColor(214, 205, 153, 1), ZFColor(78, 250, 188, 1), ZFColor(16, 140, 39, 1), ZFColor(45, 92, 34, 1), nil];
 
 pieChart.valueArray = [NSMutableArray arrayWithObjects:@"280", @"255", @"308", nil];
 pieChart.nameArray = [NSMutableArray arrayWithObjects:@"一年级", @"二年级", @"三年级", nil];
 pieChart.colorArray = [NSMutableArray arrayWithObjects:ZFColor(71, 204, 255, 1), ZFColor(253, 203, 76, 1), ZFColor(214, 205, 153, 1), nil];
 
 pieChart.percentType = kPercentTypeInteger;
 [self.view addSubview:pieChart];
 [pieChart strokePath];
 */

/**
 * 预订、即时、其它
 */
- (void)initWithDiningTypeChartView
{
    if (!_diningTypeChartView)
    {
        CGRect frame = _lunchDinnerChartView.frame;
        frame.origin.x = [[UIScreen mainScreen] screenWidth] / 2;
        _diningTypeChartView = [[TYZPieChart alloc] initWithFrame:frame];
        _diningTypeChartView.isShadow = NO;
//        _diningTypeChartView.backgroundColor = [UIColor grayColor];
        _diningTypeChartView.valueArray = [NSMutableArray arrayWithObjects:@"280", @"130", @"40", nil];
        _diningTypeChartView.nameArray = [NSMutableArray arrayWithObjects:@"预订", @"即时", @"其他", nil];
        _diningTypeChartView.colorArray = [NSMutableArray arrayWithObjects:[UIColor colorWithHexString:@"#00b8ef"], [UIColor colorWithHexString:@"#ff0196"], [UIColor colorWithHexString:@"#c391bf"], nil];
        
        _diningTypeChartView.percentType = kPercentTypeInteger;
        [self.contentView addSubview:_diningTypeChartView];
        [_diningTypeChartView strokePath];
    }
}

/**
 * 订单的几种状态
 */
- (void)initWithOrderStateChartView
{
    if (!_orderStateChartView)
    {
        CGRect frame = _lunchDinnerChartView.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 10;
        _orderStateChartView = [[TYZPieChart alloc] initWithFrame:frame];
        _orderStateChartView.isShadow = NO;
//        _orderStateChartView.backgroundColor = [UIColor grayColor];
        _orderStateChartView.valueArray = [NSMutableArray arrayWithObjects:@"280", @"160", @"80", nil];
        _orderStateChartView.nameArray = [NSMutableArray arrayWithObjects:@"完成", @"未完成", @"异常", nil];
        _orderStateChartView.colorArray = [NSMutableArray arrayWithObjects:[UIColor colorWithHexString:@"#90c41f"], [UIColor colorWithHexString:@"#13b6b0"], [UIColor colorWithHexString:@"#e86e38"], nil];
        
        _orderStateChartView.percentType = kPercentTypeInteger;
        [self.contentView addSubview:_orderStateChartView];
        [_orderStateChartView strokePath];
    }
}

+ (NSInteger)getWithCellHeight
{
    CGFloat width = [XWPieChartTitleView getWithWidth];
    CGFloat height = [[UIScreen mainScreen] screenWidth] / 2 - 15 - 10 - 10 - width;
    
    return 10 + 20 + 5 +height*2 + 10 + 15;
}

- (void)updateCellData:(id)cellEntity title:(NSString *)title
{
    _titleLabel.text = title;
}

@end

























