//
//  OrderCompletedInputEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/8/2.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  查询完成订单的参数
 */
@interface OrderCompletedInputEntity : NSObject

/**
 * 餐厅编号
 */
@property (nonatomic, assign) NSInteger shopId;

/**
 * 到店日期
 */
@property (nonatomic, copy) NSString *diningDate;

/**
 *  订单编号
 */
@property (nonatomic, copy) NSString *orderId;

/**
 *  餐桌编号
 */
@property (nonatomic, copy) NSString *seat_number;

/**
 *  订单状态(-1)
 */
@property (nonatomic, assign) NSInteger status;

/**
 * 顾客名称
 */
@property (nonatomic, copy) NSString *customerName;

/**
 *
 */
@property (nonatomic, assign) NSInteger pageIndex;

/**
 *
 */
@property (nonatomic, assign) NSInteger pageSize;

@end

























