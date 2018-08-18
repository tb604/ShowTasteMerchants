//
//  WYXCalendarViewController.h
//  51tour
//
//  Created by 唐斌 on 15/12/31.
//  Copyright © 2015年 51tour. All rights reserved.
//

#import <UIKit/UIKit.h>


@class WYXCalendarLogic;
@class WYXCalendarDayModel;

///  块回掉
typedef void (^CalendarBlock)(NSArray *selectList);



@interface WYXCalendarViewController : UIViewController

/**
 *  网格视图
 */
@property (nonatomic, strong) UICollectionView *collectionView;

/**
 *  每个月中的daymodel数组
 */
@property (nonatomic, strong) NSMutableArray *calendarMonth;

/**
 *  得到日期的 WYXCalendarDayModel对象数组。同时给相应的变量赋值，比如：节日，农历字段
 */
@property (nonatomic, strong) WYXCalendarLogic *logic;

/**
 *  回调
 */
@property (nonatomic, copy) CalendarBlock calendarBlock;

/**
 *  1表示开始日期；2表示结束日期
 */
@property (nonatomic, assign) int dateType;


/**
 *  初始化
 *
 *  @param nibNameOrNil d
 *  @param nibBundleOrNil d
 *  @param day            天数
 *  @param selectDate     选择的日期
 *
 *  @return id d
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil day:(NSInteger)day selectDate:(NSString *)selectDate multChoice:(BOOL)multChoice;

//- (void)initWithBackButton;


@end






























