//
//  NSDate+TYZAdd.h
//  YYStudyDemo
//
//  Created by 唐斌 on 16/2/29.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Provides extensions for `NSDate`.
 */
@interface NSDate (TYZAdd)
#pragma mark - Component Properties
///=============================================================================
/// @name Component Properties
///=============================================================================

@property (nonatomic, assign, readonly) NSInteger year; ///< Year component
@property (nonatomic, assign, readonly) NSInteger month; ///< Month component (1~12)
@property (nonatomic, assign, readonly) NSInteger day; ///< Day component (1~31)
@property (nonatomic, assign, readonly) NSInteger hour; ///< Hour component (0~23)
@property (nonatomic, assign, readonly) NSInteger minute; ///< Minute component (0~59)
@property (nonatomic, assign, readonly) NSInteger second; ///< Second component (0~59)
@property (nonatomic, assign, readonly) NSInteger nanosecond; ///< Nanosecond component
@property (nonatomic, assign, readonly) NSInteger weekday; ///< Weekday component (1~7, first day is based on user setting)
@property (nonatomic, assign, readonly) NSInteger weekdayOrdinal; ///< WeekdayOrdinal component
@property (nonatomic, assign, readonly) NSInteger weekOfMonth; ///< WeekOfMonth component (1~5)
@property (nonatomic, assign, readonly) NSInteger weekOfYear; ///< WeekOfYear component (1~53)
@property (nonatomic, assign, readonly) NSInteger yearForWeekOfYear; ///< YearForWeekOfYear component
@property (nonatomic, assign, readonly) NSInteger quarter; ///< Quarter component
@property (nonatomic, assign, readonly) BOOL isLeapMonth; ///< whether the month is leap month
@property (nonatomic, assign, readonly) BOOL isLeapYear; ///< whether the year is leap year
@property (nonatomic, assign, readonly) BOOL isToday; ///< whether date is today (based on current locale)
@property (nonatomic, assign, readonly) BOOL isYesterday; ///< whether date is yesterday (based on current locale)

#pragma mark - Date modify
///=============================================================================
/// @name Date modify
///=============================================================================

/**
 Returns a date representing the receiver date shifted later by the provided number of years.
 
 @param years  Number of years to add.
 @return Date modified by the number of desired years.
 */
- (nullable NSDate *)dateByAddingYears:(NSInteger)years;

/**
 Returns a date representing the receiver date shifted later by the provided number of months.
 
 @param months  Number of months to add.
 @return Date modified by the number of desired months.
 */
- (nullable NSDate *)dateByAddingMonths:(NSInteger)months;

/**
 Returns a date representing the receiver date shifted later by the provided number of weeks.
 
 @param weeks  Number of weeks to add.
 @return Date modified by the number of desired weeks.
 */
- (nullable NSDate *)dateByAddingWeeks:(NSInteger)weeks;

/**
 Returns a date representing the receiver date shifted later by the provided number of days.
 
 @param days  Number of days to add.
 @return Date modified by the number of desired days.
 */
- (nullable NSDate *)dateByAddingDays:(NSInteger)days;

/**
 Returns a date representing the receiver date shifted later by the provided number of hours.
 
 @param hours  Number of hours to add.
 @return Date modified by the number of desired hours.
 */
- (nullable NSDate *)dateByAddingHours:(NSInteger)hours;

/**
 Returns a date representing the receiver date shifted later by the provided number of minutes.
 
 @param minutes  Number of minutes to add.
 @return Date modified by the number of desired minutes.
 */
- (nullable NSDate *)dateByAddingMinutes:(NSInteger)minutes;

/**
 Returns a date representing the receiver date shifted later by the provided number of seconds.
 
 @param seconds  Number of seconds to add.
 @return Date modified by the number of desired seconds.
 */
- (nullable NSDate *)dateByAddingSeconds:(NSInteger)seconds;


#pragma mark - Date Format
///=============================================================================
/// @name Date Format
///=============================================================================

/**
 Returns a formatted string representing this date.
 see http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns
 for format description.
 
 @param format   String representing the desired date format.
 e.g. @"yyyy-MM-dd HH:mm:ss"
 
 @return NSString representing the formatted date string.
 */
- (nullable NSString *)stringWithFormat:(NSString *)format;

/**
 Returns a formatted string representing this date.
 see http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns
 for format description.
 
 @param format    String representing the desired date format.
 e.g. @"yyyy-MM-dd HH:mm:ss"
 
 @param timeZone  Desired time zone.
 
 @param locale    Desired locale.
 
 @return NSString representing the formatted date string.
 */
- (nullable NSString *)stringWithFormat:(NSString *)format timeZone:(nullable NSTimeZone *)timeZone locale:(nullable NSLocale *)locale;

/**
 Returns a string representing this date in ISO8601 format.
 e.g. "2010-07-09T16:13:30+12:00"
 
 @return NSString representing the formatted date string in ISO8601.
 */
- (nullable NSString *)stringWithISOFormat;

/**
 Returns a date parsed from given string interpreted using the format.
 
 @param dateString The string to parse.
 @param format     The string's date format.
 
 @return A date representation of string interpreted using the format.
 If can not parse the string, returns nil.
 */
+ (nullable NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format;

/**
 Returns a date parsed from given string interpreted using the format.
 
 @param dateString The string to parse.
 @param format     The string's date format.
 @param timeZone   The time zone, can be nil.
 @param locale     The locale, can be nil.
 
 @return A date representation of string interpreted using the format.
 If can not parse the string, returns nil.
 */
+ (nullable NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format timeZone:(nullable NSTimeZone *)timeZone locale:(nullable NSLocale *)locale;

/**
 Returns a date parsed from given string interpreted using the ISO8601 format.
 
 @param dateString The date string in ISO8601 format. e.g. "2010-07-09T16:13:30+12:00"
 
 @return A date representation of string interpreted using the format.
 If can not parse the string, returns nil.
 */
+ (nullable NSDate *)dateWithISOFormatString:(NSString *)dateString;



/**
 *  将时间转化为相应格式的时间戳
 *
 *  @param dateString 时间
 *  @param format     format(e.g:@"yyyy-MM-dd HH:mm:ss")
 *
 *  @return
 */
+ (NSTimeInterval)dateWithTimeStamp:(NSString *)dateString format:(NSString *)format;

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
+ (NSTimeInterval)dateWithTimeStamp:(NSString *)dateString format:(NSString *)format timeZone:(nullable NSTimeZone *)timeZone locale:(nullable NSLocale *)locale;

/**
 *  返回时间戳
 *
 *  @param format he string's date format.(e.g:@"yyyy-MM-dd HH:mm:ss")
 *
 *  @return 时间戳
 */
- (NSTimeInterval)stringWithTimeStamp:(NSString *)format;

/**
 *  时间戳
 *
 *  @param format   he string's date format.
 *  @param timeZone The time zone, can be nil.
 *  @param locale   The locale, can be nil.
 *
 *  @return 时间戳
 */
- (NSTimeInterval)stringWithTimeStamp:(NSString *)format timeZone:(nullable NSTimeZone *)timeZone locale:(nullable NSLocale *)locale;

/**
 *  得到时间字符串
 *
 *  @param interval 时间戳
 *  @param format   时间格式(e.g:@"yyyy-MM-dd HH:mm:ss")
 *
 *  @return <#return value description#>
 */
+ (nullable NSString *)timeStampWithString:(NSTimeInterval)interval format:(NSString *)format;

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
+ (nullable NSString *)timeStampWithString:(NSTimeInterval)interval format:(NSString *)format timeZone:(nullable NSTimeZone *)timeZone locale:(nullable NSLocale *)locale;


+ (nullable NSDate *)timeStampWithDate:(NSTimeInterval)interval format:(NSString *)format;

+ (nullable NSDate *)timeStampWithDate:(NSTimeInterval)interval format:(NSString *)format timeZone:(nullable NSTimeZone *)timeZone locale:(nullable NSLocale *)locale;

/**
 *  两个日期想减，得到天数
 *
 *  @param startDate 开始时间
 *  @param endDate   结束时间
 *  @param format    格式
 *
 *  @return 天数
 */
+ (NSInteger)daysWithDateStringDiffer:(NSString *)startDate endDate:(NSString *)endDate format:(NSString *)format;

/**
 *  两个时间相减，得到小时
 *
 *  @param startDate
 *  @param endDate
 *  @param format
 *
 *  @return 返回小时
 */
+ (NSInteger)hoursWithDateStringDiffer:(NSString *)startDate endDate:(NSString *)endDate format:(NSString *)format;

/// 分
+ (NSInteger)minutesWithDateStringDiffer:(NSString *)startDate endDate:(NSString *)endDate format:(NSString *)format;

/// 秒
+ (NSInteger)secondsWithDateStringDiffer:(NSString *)startDate endDate:(NSString *)endDate format:(NSString *)format;

/**
 *  将一种格式的字符串日期转化为另一种日期的字符串
 *
 *  @param strDate   时间
 *  @param inFormat  输入日期格式
 *  @param outFormat 输出日期格式
 *
 *  @return 时间
 */
+ (nullable NSString *)stringWithDateInOut:(NSString *)strDate inFormat:(NSString *)inFormat outFormat:(NSString *)outFormat;

/// 获取当前的时间戳
+ (NSString *)stringWithCurrentTimeStamp;

@end

NS_ASSUME_NONNULL_END

















