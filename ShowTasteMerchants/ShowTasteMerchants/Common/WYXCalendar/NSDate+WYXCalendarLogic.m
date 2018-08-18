//
//  NSDate+WYXCalendarLogic.m
//  51tour
//
//  Created by 唐斌 on 15/12/30.
//  Copyright © 2015年 51tour. All rights reserved.
//

#import "NSDate+WYXCalendarLogic.h"

@implementation NSDate (WYXCalendarLogic)

/*
- (void)dealloc
{
    NSLog(@"%s", __func__);
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}*/

// 计算当前月份有多少天
- (NSUInteger)numberOfDaysInCurrentMonth
{
    // 频繁调用 可能存在性能问题
    return [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self].length;
}

- (NSUInteger)numberOfWeeksInCurrentMonth
{
//    NSUInteger weekday =
    return 0;
}

// 计算这个月的第一天是星期几
- (NSUInteger)weeklyOrdinality
{
    return [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSWeekCalendarUnit forDate:self];
}

// 计算当前月份最开始的一天
- (NSDate *)firstDayOfCurrentMonth
{
    NSDate *startDate = nil;
    BOOL ok = [[NSCalendar currentCalendar] rangeOfUnit:NSMonthCalendarUnit startDate:&startDate interval:NULL forDate:self];
    NSAssert1(ok, @"Failed to calculate the first day of the month based on %@", self);
    return startDate;
}

- (NSDate *)lastDayOfCurrentMonth
{
    NSCalendarUnit calendarUnit = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:calendarUnit fromDate:self];
    dateComponents.day = [self numberOfDaysInCurrentMonth];
    return [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
}

// 上一个月
- (NSDate *)dayInThePreviousMonth
{
    NSDateComponents *dateComponments = [[NSDateComponents alloc] init];
    dateComponments.month = -1;
    
    NSDate *date = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponments toDate:self options:0];
#if !__has_feature(objc_arc)
    [dateComponments release], dateComponments = nil;
#endif
    return date;
}

// 下一个月
- (NSDate *)dayInTheFollowingMonth
{
    NSDateComponents *dateComponments = [[NSDateComponents alloc] init];
    dateComponments.month = 1;
    
    NSDate *date = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponments toDate:self options:0];
#if !__has_feature(objc_arc)
    [dateComponments release], dateComponments = nil;
#endif
    return date;
}

// 获取当前日期只有的几个月
- (NSDate *)dayInTheFollowingMonth:(int)month
{
    NSDateComponents *dateComponments = [[NSDateComponents alloc] init];
    dateComponments.month = month;
    
    NSDate *date = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponments toDate:self options:0];
#if !__has_feature(objc_arc)
    [dateComponments release], dateComponments = nil;
#endif
    return date;
}

// 获取当前日期之后的几个天
- (NSDate *)dayInTheFollowingDay:(int)day
{
    NSDateComponents *dateComponments = [[NSDateComponents alloc] init];
    dateComponments.day = day;
    
    NSDate *date = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponments toDate:self options:0];
#if !__has_feature(objc_arc)
    [dateComponments release], dateComponments = nil;
#endif
    return date;
}

// 获取年月日对象
- (NSDateComponents *)YMDComponents
{
    return [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit fromDate:self];
}

// 将NSString转化为NSDate
- (NSDate *)dateFromString:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *destDate = [dateFormatter dateFromString:dateString];
#if !__has_feature(objc_arc)
    [dateFormatter release], dateFormatter = nil;
#endif
    return destDate;
}

// NSDate转化为NSString
- (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateStr = [dateFormatter stringFromDate:date];
#if !__has_feature(objc_arc)
    [dateFormatter release], dateFormatter = nil;
#endif
    return destDateStr;
}

+ (NSDate *)dateFromStringS:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *destDate = [dateFormatter dateFromString:dateString];
#if !__has_feature(objc_arc)
    [dateFormatter release], dateFormatter = nil;
#endif
    return destDate;
}

+ (NSString *)stringFromDateS:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateStr = [dateFormatter stringFromDate:date];
#if !__has_feature(objc_arc)
    [dateFormatter release], dateFormatter = nil;
#endif
    return destDateStr;
}

//  两个日期之间的天数
+ (NSInteger)getDayNumbertoDay:(NSDate *)today beforDay:(NSDate *)beforday
{
    // 日历控件对象
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSDayCalendarUnit fromDate:today toDate:beforday options:0];
    // 两个日历之间相差多少天
    NSInteger day = [components day];
#if !__has_feature(objc_arc)
    [calendar release], calendar = nil;
#endif
    return day;
}

// 周日是“1”，周一是“2”
- (NSInteger)getWeekIntValueWithDate
{
    NSInteger weekIntValue;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];// NSGregorianCalendar
    NSDateComponents *comps = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit) fromDate:self];
    
#if !__has_feature(objc_arc)
    [calendar release], calendar = nil;
#endif
    weekIntValue = [comps weekday];
    return weekIntValue;
}

/**
 *  判断日期是今天,明天,后天,周几
 *
 *  @return <#return value description#>
 */
- (NSString *)compareIfTodayWithDate
{
    // 今天
    NSDate *todate = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
    NSDateComponents *comps_today = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit) fromDate:todate];
    
    NSDateComponents *comps_other = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit) fromDate:self];
    
    // 获取星期对应的数字
    NSInteger weekIntValue = [self getWeekIntValueWithDate];
    NSString *dayStr = nil;
    if (comps_today.year == comps_other.year &&
        comps_today.month == comps_other.month &&
        comps_today.day == comps_other.day)
    {
        dayStr = @"今天";
        
    }
    else if (comps_today.year == comps_other.year &&
              comps_today.month == comps_other.month &&
              (comps_today.day - comps_other.day) == -1)
    {
        dayStr = @"明天";
        
    }
    else if (comps_today.year == comps_other.year &&
              comps_today.month == comps_other.month &&
              (comps_today.day - comps_other.day) == -2)
    {
        dayStr = @"后天";
        
    }
    else
    {
        //直接返回当时日期的字符串(这里让它返回空)
        dayStr = [NSDate getWeekStringFromInteger:weekIntValue];//周几
    }
//    NSLog(@"daystr=%@", dayStr);
#if !__has_feature(objc_arc)
    [calendar release], calendar = nil;
#endif
    return dayStr;
}

/**
 *  通过数字返回星期几
 *
 *  @param week <#week description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)getWeekStringFromInteger:(NSInteger)week
{
    NSString *strWeek = nil;
    
    switch (week)
    {
        case 1:
            strWeek = @"周日";
            break;
        case 2:
            strWeek = @"周一";
            break;
        case 3:
            strWeek = @"周二";
            break;
        case 4:
            strWeek = @"周三";
            break;
        case 5:
            strWeek = @"周四";
            break;
        case 6:
            strWeek = @"周五";
            break;
        case 7:
            strWeek = @"周六";
            break;
    }
    
    return strWeek;
}

@end































