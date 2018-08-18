//
//  NSDate+TYZAdd.m
//  YYStudyDemo
//
//  Created by 唐斌 on 16/2/29.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "NSDate+TYZAdd.h"
#import "TYZKitMacro.h"
#import <time.h>

TYZSYNTH_DUMMY_CLASS(NSDate_TYZAdd)


@implementation NSDate (TYZAdd)

- (NSInteger)year
{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self] year];
}

- (NSInteger)month
{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self] month];
}

- (NSInteger)day
{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self] day];
}

- (NSInteger)hour
{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:self] hour];
}

- (NSInteger)minute
{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:self] minute];
}

- (NSInteger)second
{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self] second];
}

- (NSInteger)nanosecond
{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self] nanosecond];
}

- (NSInteger)weekday
{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self] weekday];
}

- (NSInteger)weekdayOrdinal
{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekdayOrdinal fromDate:self] weekdayOrdinal];
}

- (NSInteger)weekOfMonth
{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfMonth fromDate:self] weekOfMonth];
}

- (NSInteger)weekOfYear
{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfYear fromDate:self] weekOfYear];
}

- (NSInteger)yearForWeekOfYear
{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitYearForWeekOfYear fromDate:self] yearForWeekOfYear];
}

- (NSInteger)quarter
{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitQuarter fromDate:self] quarter];
}

- (BOOL)isLeapMonth
{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitQuarter fromDate:self] isLeapMonth];
}

- (BOOL)isLeapYear
{
    NSUInteger year = self.year;
    return ((year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0)));
}

- (BOOL)isToday
{
    if (fabs(self.timeIntervalSinceNow) >= 60 * 60 * 24) return NO;
    return [NSDate new].day == self.day;
}

- (BOOL)isYesterday
{
    NSDate *added = [self dateByAddingDays:1];
    return [added isToday];
}

- (NSDate *)dateByAddingYears:(NSInteger)years
{
    NSCalendar *calendar =  [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:years];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateByAddingMonths:(NSInteger)months
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:months];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateByAddingWeeks:(NSInteger)weeks
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setWeekOfYear:weeks];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateByAddingDays:(NSInteger)days
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 86400 * days;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)dateByAddingHours:(NSInteger)hours
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 3600 * hours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)dateByAddingMinutes:(NSInteger)minutes
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 60 * minutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)dateByAddingSeconds:(NSInteger)seconds
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + seconds;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSString *)stringWithFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setLocale:[NSLocale currentLocale]];
    return [formatter stringFromDate:self];
}

- (NSString *)stringWithFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    if (timeZone) [formatter setTimeZone:timeZone];
    if (locale) [formatter setLocale:locale];
    return [formatter stringFromDate:self];
}

- (NSString *)stringWithISOFormat
{
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
    });
    return [formatter stringFromDate:self];
}

+ (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter dateFromString:dateString];
}

+ (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    if (timeZone) [formatter setTimeZone:timeZone];
    if (locale) [formatter setLocale:locale];
    return [formatter dateFromString:dateString];
}

+ (NSDate *)dateWithISOFormatString:(NSString *)dateString
{
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
    });
    return [formatter dateFromString:dateString];
}

/**
 *  将时间转化为相应格式的时间戳
 *
 *  @param dateString 时间
 *  @param format     format(e.g:@"yyyy-MM-dd HH:mm:ss")
 *
 *  @return
 */
+ (NSTimeInterval)dateWithTimeStamp:(NSString *)dateString format:(NSString *)format
{
    return [self dateWithTimeStamp:dateString format:format timeZone:nil locale:nil];
}

/**
 *  返回时间戳
 *
 *  @param dateString The string to parse.
 *  @param format     he string's date format.
 *  @param timeZone   The time zone, can be nil.
 *  @param locale     The locale, can be nil.
 *
 *  @return 时间戳
 */
+ (NSTimeInterval)dateWithTimeStamp:(NSString *)dateString format:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (timeZone)
    {
        [formatter setTimeZone:timeZone];
    }
    if (locale)
    {
        [formatter setLocale:locale];
    }
    NSDate *newDate = [formatter dateFromString:dateString];
    return [newDate timeIntervalSince1970];
}

/**
 *  返回时间戳
 *
 *  @param format he string's date format.(e.g:@"yyyy-MM-dd HH:mm:ss")
 *
 *  @return 时间戳
 */
- (NSTimeInterval)stringWithTimeStamp:(NSString *)format
{
    return [self stringWithTimeStamp:format timeZone:nil locale:nil];
}

/**
 *  时间戳
 *
 *  @param format   he string's date format.
 *  @param timeZone The time zone, can be nil.
 *  @param locale   The locale, can be nil.
 *
 *  @return 时间戳
 */
- (NSTimeInterval)stringWithTimeStamp:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    if (timeZone)
    {
        [formatter setTimeZone:timeZone];
    }
    if (locale)
    {
        [formatter setLocale:locale];
    }
    return [self timeIntervalSince1970];
}

/**
 *  得到时间字符串
 *
 *  @param interval 时间戳
 *  @param format   时间格式(e.g:@"yyyy-MM-dd HH:mm:ss")
 *
 *  @return <#return value description#>
 */
+ (NSString *)timeStampWithString:(NSTimeInterval)interval format:(NSString *)format
{
    return [self timeStampWithString:interval format:format timeZone:nil locale:nil];
}

/**
 *  得到时间字符串
 *
 *  @param interval 时间戳
 *  @param format   format
 *  @param timeZone
 *  @param locale
 *
 *  @return 返回时间时间字符串
 */
+ (NSString *)timeStampWithString:(NSTimeInterval)interval format:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    if (timeZone)
    {
        [formatter setTimeZone:timeZone];
    }
    if (locale)
    {
        [formatter setLocale:locale];
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    return [formatter stringFromDate:date];
}


+ (NSDate *)timeStampWithDate:(NSTimeInterval)interval format:(NSString *)format
{
    return [self timeStampWithDate:interval format:format timeZone:nil locale:nil];
}

+ (NSDate *)timeStampWithDate:(NSTimeInterval)interval format:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    if (timeZone)
    {
        [formatter setTimeZone:timeZone];
    }
    if (locale)
    {
        [formatter setLocale:locale];
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    return date;
}

/**
 *  两个日期想减，得到天数
 *
 *  @param startDate 开始时间
 *  @param endDate   结束时间
 *  @param format    格式
 *
 *  @return 天数
 */
+ (NSInteger)daysWithDateStringDiffer:(NSString *)startDate endDate:(NSString *)endDate format:(NSString *)format
{
    NSTimeInterval interval = [self _tyz_timervalWithDateStringDiffer:startDate endDate:endDate format:format];
    return (interval / (24 * 60 * 60));
}

/**
 *  两个时间相减，得到小时
 *
 *  @param startDate
 *  @param endDate
 *  @param format
 *
 *  @return 返回小时
 */
+ (NSInteger)hoursWithDateStringDiffer:(NSString *)startDate endDate:(NSString *)endDate format:(NSString *)format
{
    NSTimeInterval interval = [self _tyz_timervalWithDateStringDiffer:startDate endDate:endDate format:format];
    return (interval / (60 * 60));
}

/// 分
+ (NSInteger)minutesWithDateStringDiffer:(NSString *)startDate endDate:(NSString *)endDate format:(NSString *)format
{
    NSTimeInterval interval = [self _tyz_timervalWithDateStringDiffer:startDate endDate:endDate format:format];
    return (interval / 60);
}

/// 秒
+ (NSInteger)secondsWithDateStringDiffer:(NSString *)startDate endDate:(NSString *)endDate format:(NSString *)format
{
    NSTimeInterval interval = [self _tyz_timervalWithDateStringDiffer:startDate endDate:endDate format:format];
    return interval;
}

+ (NSTimeInterval)_tyz_timervalWithDateStringDiffer:(NSString *)startDate endDate:(NSString *)endDate format:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSDate *start = [formatter dateFromString:startDate];
    NSDate *end = [formatter dateFromString:endDate];
    NSTimeInterval interval = [end timeIntervalSince1970] - [start timeIntervalSince1970];
    return interval;
}

/**
 *  将一种格式的字符串日期转化为另一种日期的字符串
 *
 *  @param strDate   时间
 *  @param inFormat  输入日期格式
 *  @param outFormat 输出日期格式
 *
 *  @return 时间
 */
+ (NSString *)stringWithDateInOut:(NSString *)strDate inFormat:(NSString *)inFormat outFormat:(NSString *)outFormat
{
    NSDate *date = [NSDate dateWithString:strDate format:inFormat];
    return [date stringWithFormat:outFormat];
}

/// 获取当前的时间戳(毫秒)
+ (NSString *)stringWithCurrentTimeStamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval stamp = [date timeIntervalSince1970] * 1000; // *1000是精确到毫秒，不乘就是精切到秒
    debugLog(@"%f", stamp);
    // time(NULL)
    return [NSString stringWithFormat:@"%f", stamp];
}


@end





























