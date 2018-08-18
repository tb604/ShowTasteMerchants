//
//  WYXCalendarDayModel.m
//  51tour
//
//  Created by 唐斌 on 15/12/30.
//  Copyright © 2015年 51tour. All rights reserved.
//

#import "WYXCalendarDayModel.h"

@implementation WYXCalendarDayModel

- (void)dealloc
{
//    NSLog(@"%s", __func__);
#if !__has_feature(objc_arc)
    [_chinese_calendar release], _chinese_calendar = nil;
    [_holiday release], _holiday = nil;
    [super dealloc];
#endif
}

- (id)initWithCalendarDayWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day
{
    if (self = [super init])
    {
        _year = year;
        _month = month;
        _day = day;
    }
    return self;
}

/*
+ (WYXCalendarDayModel *)calendarDayWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day
{
    // 初始化自身
    WYXCalendarDayModel *calendarDay = [[WYXCalendarDayModel alloc] init];
    calendarDay.year = year;
    calendarDay.month = month;
    calendarDay.day = day;
#if !__has_feature(objc_arc)
    return [calendarDay autorelease];
#else
    return calendarDay;
#endif
}*/

- (NSString *)description
{
    return [NSString stringWithFormat:@"year=%d; month=%d; day=%d; week=%d; 农历=%@; 节日=%@", (int)_year, (int)_month, (int)_day, (int)_week, _chinese_calendar, _holiday];
}

/**
 *  返回当前天的NSDate对象
 *
 *  @return 返回当前天的NSDate对象
 */
- (NSDate *)date
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps.year = _year;
    comps.month = _month;
    comps.day = _day;
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:comps];
#if !__has_feature(objc_arc)
    [comps release], comps = nil;
#endif
    return date;
}

/**
 *  当前天的NSString对象
 *
 *  @return 返回当前天的NSString对象
 */
- (NSString *)toString
{
    NSDate *date = [self date];
    NSString *str = [date stringFromDate:date];
    return str;
}

/**
 *  返回星期
 *
 *  @return
 */
- (NSString *)getWeek
{
    NSDate *date = [self date];
    NSString *weekStr = [date compareIfTodayWithDate];
    return weekStr;
}

// 判断是不是同一天
- (BOOL)isEqualTo:(WYXCalendarDayModel *)day
{
    BOOL isEqual = (_year == day.year) && (_month == day.month) && (_day == day.day);
    return isEqual;
}

@end





























