//
//  UpdateOrderFoodInputEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/28.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  修改订单菜品传入参数
 */
@interface UpdateOrderFoodInputEntity : NSObject

/**
 *  用户id(Y)
 */
@property (nonatomic, assign) NSInteger userId;

/**
 *  订单编号
 */
@property (nonatomic, copy) NSString *orderId;

/**
 *  餐厅id
 */
@property (nonatomic, assign) NSInteger shopId;

/**
 *  订单类型。1预订订单；2即时订单
 */
@property (nonatomic, assign) NSInteger orderType;

/**
 *  菜单明细json串
 */
@property (nonatomic, copy) NSString *content;

/**
 *  1 首点；2新增；3退菜
 */
@property (nonatomic, assign) NSInteger order_food_type;

/**
 *  明细编号
 */
@property (nonatomic, assign) NSInteger detailId;

/**
 *  退菜数量(整数)
 */
@property (nonatomic, assign) NSInteger foodNumber;

@end

























