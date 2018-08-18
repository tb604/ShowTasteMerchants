//
//  OrderFoodInfoEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  订单菜品信息
 */
@interface OrderFoodInfoEntity : NSObject

/**
 * 编号
 */
@property (nonatomic, assign) NSInteger id;

/**
 * 订单id
 */
@property (nonatomic, copy) NSString *order_id;

/**
 * 菜品id
 */
@property (nonatomic, assign) NSInteger food_id;

/**
 * 菜品名称
 */
@property (nonatomic, copy) NSString *food_name;

/**
 * 菜品类型id
 */
@property (nonatomic, assign) NSInteger category_id;

/**
 * 菜品类型名称
 */
@property (nonatomic, copy) NSString *category_name;

/**
 * 数量
 */
@property (nonatomic, assign) NSInteger number;

/**
 * 菜品的单位
 */
@property (nonatomic, copy) NSString *unit;

/**
 * 价格
 */
@property (nonatomic, assign) CGFloat price;

/**
 * 活动价格
 */
@property (nonatomic, assign) CGFloat activity_price;

@property (nonatomic, copy) NSString *op_datetime;

/**
 * 菜的状态 100 已点菜 200 已下单 300 已上桌 700 已退菜
 */
@property (nonatomic, assign) NSInteger status;

/**
 * 状态描述
 */
@property (nonatomic, copy) NSString *status_desc;

/**
 *  订餐类型，0 提前预订 1 即时预订 2 新增的菜品
 */
@property (nonatomic, assign) NSInteger type;

/**
 * 订餐类型描述
 */
@property (nonatomic, copy) NSString *type_desc;

/**
 *  工艺
 */
@property (nonatomic, copy) NSString *mode;

/**
 *  口味
 */
@property (nonatomic, copy) NSString *taste;



@property (nonatomic, assign) BOOL isCheck;

@property (nonatomic, assign) NSInteger allNumber;

/**
 *  一道菜，后来添加或者减少的
 */
@property (nonatomic, strong) NSMutableArray *subFoods;

/**
 *  是否是子
 */
@property (nonatomic, assign) BOOL isSub;

@end






















