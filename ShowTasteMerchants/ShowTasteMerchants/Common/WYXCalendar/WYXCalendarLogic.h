//
//  WYXCalendarLogic.h
//  51tour
//
//  Created by 唐斌 on 15/12/30.
//  Copyright © 2015年 51tour. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYXCalendarDayModel.h"
#import "NSDate+WYXCalendarLogic.h"

/**
 *  得到日期的 WYXCalendarDayModel对象数组。同时给相应的变量赋值，比如：节日，农历字段
 */
@interface WYXCalendarLogic : NSObject

- (id)initWithMultChoice:(BOOL)multChoice;

/**
 *  计算当前日期之前几天或者是之后的几天（负数是之前几天，正数是之后的几天）
 *
 *  @param date       当前日期
 *  @param selectDate 默认选中日期
 *  @param needDays   显示的天数
 *
 *  @return <#return value description#>
 */
- (NSMutableArray *)reloadCalendarView:(NSDate *)date selectDate:(NSDate *)selectDate needDays:(NSInteger)needDays;

- (void)selectLogic:(WYXCalendarDayModel *)day;

- (void)unSelectLogic:(WYXCalendarDayModel *)day;

@end





























