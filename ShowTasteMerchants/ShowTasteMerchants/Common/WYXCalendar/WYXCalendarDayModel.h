//
//  WYXCalendarDayModel.h
//  51tour
//
//  Created by 唐斌 on 15/12/30.
//  Copyright © 2015年 51tour. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate+WYXCalendarLogic.h"

// 可以被点击
#define CAN_SHOW (1)

// 不能被点击
#define CANNOT_SHOW (0)

typedef NS_ENUM(NSInteger, CollectionViewCellDayType)
{
    /**
     *  不显示
     */
    CellDayTypeEmpty,
    /**
     *  过去的日期
     */
    CellDayTypePast,
    /**
     *  将来的日期
     */
    CellDayTypeFutur,
    /**
     *  周末
     */
    CellDayTypeWeek,
    /**
     *  被点击的日期
     */
    CellDayTypeClick
};

@interface WYXCalendarDayModel : NSObject

/**
 *  显示的样式
 */
@property (nonatomic, assign) CollectionViewCellDayType style;

/**
 *  日
 */
@property (nonatomic, assign) NSUInteger day;

/**
 *  月
 */
@property (nonatomic, assign) NSUInteger month;

/**
 *  年
 */
@property (nonatomic, assign) NSUInteger year;

/**
 *  周
 */
@property (nonatomic, assign) NSUInteger week;

/**
 *  农历
 */
@property (nonatomic, copy) NSString *chinese_calendar;

/**
 *  节日
 */
@property (nonatomic, copy) NSString *holiday;

//+ (WYXCalendarDayModel *)calendarDayWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day;

- (id)initWithCalendarDayWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day;

/**
 *  返回当前天的NSDate对象
 *
 *  @return 返回当前天的NSDate对象
 */
- (NSDate *)date;

/**
 *  当前天的NSString对象
 *
 *  @return 返回当前天的NSString对象
 */
- (NSString *)toString;

/**
 *  返回星期
 *
 *  @return 星期几
 */
- (NSString *)getWeek;

/**
 *  判断是不是同一天
 *
 *  @param day <#day description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)isEqualTo:(WYXCalendarDayModel *)day;

@end






























