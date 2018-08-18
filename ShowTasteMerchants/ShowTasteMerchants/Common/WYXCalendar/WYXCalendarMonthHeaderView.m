//
//  WYXCalendarMonthHeaderView.m
//  51tour
//
//  Created by 唐斌 on 15/12/31.
//  Copyright © 2015年 51tour. All rights reserved.
//

#import "WYXCalendarMonthHeaderView.h"
#import "WYXCalendarColor.h"


#define CATDayLabelWidth  60.0f
#define CATDayLabelHeight 20.0f

@interface WYXCalendarMonthHeaderView ()
//@property (nonatomic, strong) UILabel *day1OfTheWeekLabel;
//@property (nonatomic, strong) UILabel *day2OfTheWeekLabel;
//@property (nonatomic, strong) UILabel *day3OfTheWeekLabel;
//@property (nonatomic, strong) UILabel *day4OfTheWeekLabel;
//@property (nonatomic, strong) UILabel *day5OfTheWeekLabel;
//@property (nonatomic, strong) UILabel *day6OfTheWeekLabel;
//@property (nonatomic, strong) UILabel *day7OfTheWeekLabel;

@property (nonatomic, strong) NSArray *dayNames;

@property (nonatomic, strong) NSMutableArray *dayLabels;

- (void)initWithVar;

- (void)initWithSubView;

@end

@implementation WYXCalendarMonthHeaderView

- (void)dealloc
{
//    NSLog(@"%s", __func__);
#if !__has_feature(objc_arc)
    [_masterLabel release], _masterLabel = nil;
    [_dayNames release], _dayNames = nil;
    [_dayLabels release], _dayLabels = nil;
    
    [super dealloc];
#endif
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initWithVar];
        [self initWithSubView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initWithVar];
        [self initWithSubView];
    }
    return self;
}

- (void)initWithVar
{
    _dayNames = [[NSArray alloc] initWithObjects:@"日", @"一", @"二", @"三", @"四", @"五", @"六", nil];
    _dayLabels = [[NSMutableArray alloc] initWithCapacity:[_dayNames count]];
}

- (void)initWithSubView
{
    
    // 决定了子视图的显示范围。具体的说，就是当取值为YES时，剪裁超出父视图范围的子视图部分；当取值为NO时，不剪裁子视图。默认值为NO。
    self.clipsToBounds = YES;
    // 月份(2015年1月份)
    _masterLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.bounds.size.width - 10 * 2, 30)];
    [_masterLabel setBackgroundColor:[UIColor clearColor]];
    [_masterLabel setTextAlignment:NSTextAlignmentCenter];
    [_masterLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
    _masterLabel.textColor = COLOR_THEME;
    [self addSubview:_masterLabel];
    
    // 初始化  日、一、二、三、四、五、六
    NSInteger count = [_dayNames count];
    CGFloat xOffset = 0;//(self.bounds.size.width - CATDayLabelWidth * 7 - 5 * (7-1)) / 2;
    float width = self.bounds.size.width / 7;
    CGFloat yOffset = 45.0f;
    CGRect frame = CGRectMake(0, yOffset, width, CATDayLabelHeight);
    for (NSInteger i=0; i<count; i++)
    {
        frame.origin.x = xOffset + (width + 0)*i;
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f]];
        [label setTextAlignment:NSTextAlignmentCenter];
        label.text = _dayNames[i];
        if (i == 0 || (i == (count-1)))
        {
            label.textColor = COLOR_THEME1;
        }
        else
        {
            label.textColor = COLOR_THEME;
        }
        
        
//        float red = 255*rand();
//        float green = 255 *rand();
//        float blue = 255 * rand();
//        label.backgroundColor = [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:1];
        
        [self addSubview:label];
        [_dayLabels addObject:label];
#if !__has_feature(objc_arc)
        [label release], label = nil;
#endif
    }
}

@end





























