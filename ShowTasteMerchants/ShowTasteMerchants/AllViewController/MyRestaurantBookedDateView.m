//
//  MyRestaurantBookedDateView.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/13.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantBookedDateView.h"
#import "LocalCommon.h"

@interface MyRestaurantBookedDateView ()
{
    /**
     *  日期
     */
    UILabel *_dateLabel;
    
    /**
     *  星期
     */
    UILabel *_weekLabel;
}

- (void)initWithDateLabel;

- (void)initWithWeekLabel;

@end

@implementation MyRestaurantBookedDateView

- (void)initWithVar
{
    [super initWithVar];
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithLine];
    
    [self initWithDateLabel];
    
    [self initWithWeekLabel];
}

- (void)initWithLine
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake(1.0, self.height);
    line.left = 0;
    line.right = self.width;
    line.backgroundColor = [UIColor colorWithHexString:@"#ff5500"].CGColor;
    [self.layer addSublayer:line];
}

- (void)initWithDateLabel
{
    CGRect frame = CGRectMake(8, 0, self.width - 16, 20);
    _dateLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentCenter];
    _dateLabel.bottom = self.height / 2;
}

- (void)initWithWeekLabel
{
    CGRect frame = _dateLabel.frame;
    frame.size.height = 30;
    _weekLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE(24) labelTag:0 alignment:NSTextAlignmentCenter];
    _weekLabel.top = self.height / 2;
}

- (void)updateViewData:(id)entity
{
    _dateLabel.text = @"2016-07-13";
    _weekLabel.text = @"星期三";
}


+ (CGFloat)getWithViewWidth
{
    NSString *str = @"2014-03-23";
    CGFloat width = [str widthForFont:FONTSIZE_13];
    return width + 16;
}

@end
