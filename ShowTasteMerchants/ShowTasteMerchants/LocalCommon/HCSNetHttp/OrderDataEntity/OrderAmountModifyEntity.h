//
//  OrderAmountModifyEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/8/4.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  订单金额修改，传入参数
 */
@interface OrderAmountModifyEntity : NSObject

/**
 *  订单编号
 */
@property (nonatomic, copy) NSString *orderId;

/**
 *  餐厅编号
 */
@property (nonatomic, assign) NSInteger shopId;

/**
 *  修改后的支付金额
 */
@property (nonatomic, assign) double newAmount;

/**
 *  备注
 */
@property (nonatomic, copy) NSString *note;

@end


















