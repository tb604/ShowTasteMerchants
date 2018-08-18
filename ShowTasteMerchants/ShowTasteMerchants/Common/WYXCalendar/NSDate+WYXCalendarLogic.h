//
//  NSDate+WYXCalendarLogic.h
//  51tour
//
//  Created by 唐斌 on 15/12/30.
//  Copyright © 2015年 51tour. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (WYXCalendarLogic)

/**
 *  计算当前月有多少天
 *
 *  @return 返回天数
 */
- (NSUInteger)numberOfDaysInCurrentMonth;

/**
 *  当前月份有几个星期
 *
 *  @return 星期数
 */
- (NSUInteger)numberOfWeeksInCurrentMonth;

/**
 *  计算这个月的第一天是星期几
 *
 *  @return 星期几
 */
- (NSUInteger)weeklyOrdinality;

/**
 *  计算当前月份最开始的一天
 *
 *  @return 日期
 */
- (NSDate *)firstDayOfCurrentMonth;

/**
 *  当前月份的最后一天
 *
 *  @return 日期
 */
- (NSDate *)lastDayOfCurrentMonth;

/**
 *  上一个月
 *
 *  @return 日期
 */
- (NSDate *)dayInThePreviousMonth;

/**
 *  下一个月
 *
 *  @return 日期
 */
- (NSDate *)dayInTheFollowingMonth;

/**
 *  获取当前日期之后的几个月
 *
 *  @param month 月数
 *
 *  @return 日期
 */
- (NSDate *)dayInTheFollowingMonth:(int)month;

/**
 *  获取当前日期之后的几个天
 *
 *  @param day 天数
 *
 *  @return 日期
 */
- (NSDate *)dayInTheFollowingDay:(int)day;

/**
 *  获取年月日对象
 *
 *  @return 返回
 */
- (NSDateComponents *)YMDComponents;

/**
 *  NSString转NSDate
 *
 *  @param dateString 字符串日期
 *
 *  @return 日期
 */
- (NSDate *)dateFromString:(NSString *)dateString;

/**
 *  NSDate转NSString
 *
 *  @param date 日期
 *
 *  @return 字符串日期
 */
- (NSString *)stringFromDate:(NSDate *)date;

+ (NSDate *)dateFromStringS:(NSString *)dateString;//NSString转NSDate

+ (NSString *)stringFromDateS:(NSDate *)date;//NSDate转NSString

/**
 *  计算两个日期之间的天数
 *
 *  @param today    开始日期
 *  @param beforday 结束日期
 *
 *  @return 两个日期之间的天数
 */
+ (NSInteger)getDayNumbertoDay:(NSDate *)today beforDay:(NSDate *)beforday;

- (NSInteger)getWeekIntValueWithDate;



/**
 *  判断日期是今天,明天,后天,周几
 *
 *  @return <#return value description#>
 */
- (NSString *)compareIfTodayWithDate;

/**
 *  通过数字返回星期几
 *
 *  @param week <#week description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)getWeekStringFromInteger:(NSInteger)week;

@end
