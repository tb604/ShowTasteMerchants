//
//  ShopPatchFoodInputEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/8/8.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  服务员补打订单传入参数
 */
@interface ShopPatchFoodInputEntity : NSObject

@property (nonatomic, copy) NSString *orderId;

@property (nonatomic, assign) NSInteger shopId;

/**
 *  档口编号；-1表示补打全部；否则具体的档口
 */
@property (nonatomic, assign) NSInteger printerId;

/**
 *  打印批次号
 */
@property (nonatomic, copy) NSString *batchNo;

@end


















