//
//  CancelReservationEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/19.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  取消预订的传入参数
 */
@interface CancelReservationEntity : NSObject

/**
 *  用户id(Y)
 */
@property (nonatomic, assign) NSInteger userId;

/**
 *  订单编号(Y)
 */
@property (nonatomic, copy) NSString *orderId;

/**
 *  备注(N)
 */
@property (nonatomic, copy) NSString *remark;

/**
 *  取消原因。1尝试下，没打算去；2打电话预订好了；3回复速度慢，等不及了，取消预订；4预订订单填写有误，需修改；5行程安排有变；0其它
 */
@property (nonatomic, assign) NSInteger reason;

@property (nonatomic, assign) NSInteger shopId;

@end


























