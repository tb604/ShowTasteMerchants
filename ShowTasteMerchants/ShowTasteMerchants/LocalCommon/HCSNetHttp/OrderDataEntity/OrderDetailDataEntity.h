//
//  OrderDetailDataEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OrderDataEntity.h"
#import "OrderFoodInfoEntity.h"

/**
 *  订单详情(明细)
 */
@interface OrderDetailDataEntity : NSObject

/**
 *  订单基本信息
 */
@property (nonatomic, strong) OrderDataEntity *order;

/**
 *  订单里面的菜品列表(OrderFoodInfoEntity)
 */
@property (nonatomic, strong) NSArray *details;

/**
 *  处理后的，用来在订单详情显示的
 */
@property (nonatomic, strong) NSMutableArray *detailFoods;

/**
 *  新增的菜品列表
 */
@property (nonatomic, strong) NSMutableArray *nowAddFoodList;

/**
 *  旧的菜品列表
 */
@property (nonatomic, strong) NSMutableArray *oldAddFoodList;

/**
 *  总金额
 */
//@property (nonatomic, assign) CGFloat total_price;

/**
 *  预付的定金
 */
//@property (nonatomic, assign) CGFloat book_deposit;

/**
 *  支付金额
 */
//@property (nonatomic, assign) CGFloat pay_amount;

@end


























