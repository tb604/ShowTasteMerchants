/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCMealOrderFoodEntity.h
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/26 22:47
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CTCMealOrderFoodEntity : NSObject

/// 菜品id
@property (nonatomic, assign) NSInteger food_id;

/// 菜品名称
@property (nonatomic, copy) NSString *food_name;

/**
 *  工艺
 */
@property (nonatomic, copy) NSString *mode;

/**
 *  口味
 */
@property (nonatomic, copy) NSString *taste;

/**
 * 菜品的单位
 */
@property (nonatomic, copy) NSString *unit;

/**
 * 数量
 */
@property (nonatomic, assign) NSInteger food_number;

/// 总金额
@property (nonatomic, assign) CGFloat total;

/// 
@property (nonatomic, assign) NSInteger detail_id;

/// 价格
@property (nonatomic, assign) CGFloat food_price;

/// 活动价格
@property (nonatomic, assign) CGFloat food_activity_price;

/**
 * 菜的状态 100 已点菜 200 已下单 300 已上桌 700 已退菜
 */
@property (nonatomic, assign) NSInteger status;

/**
 * 状态描述
 */
@property (nonatomic, copy) NSString *status_desc;

///
@property (nonatomic, copy) NSString *operate_time;

/// 菜品类型id
@property (nonatomic, assign) NSInteger food_category_id;

/**
 *  是否是子
 */
@property (nonatomic, assign) BOOL isSub;

@property (nonatomic, assign) BOOL isCheck;

@property (nonatomic, strong) NSMutableArray *details;

@end

/*
 "food_id": 1,
 "food_name": "红烧鲫鱼",
 "mode": "烘焙",
 "taste": "微糖",
 "unit": "份",
 "food_number": "1.00",
 "total": 45,
 "detail_id": 1178,
 "food_price": "50.00",
 "food_activity_price": "45.00",
 "status": 100,
 "status_desc": "已点菜",
 "operate_time": "",
 "food_category_id": 1,
 "details": []
 */

/*
 {
 "detail_id": 1190,
 "operate_time": "",
 "food_number": "4.00",
 "food_price": "68.00",
 "food_activity_price": "50.00",
 "food_category_id": 3,
 "status": 300,
 "status_desc": "已上桌",
 "total": 200
 }
 */























