//
//  HungryOrderStatusEntity.h
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/24.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HungryOrderExtraStatusEntity.h"

/**
 * 从饿了么返回的订单状态
 */
@interface HungryOrderStatusEntity : NSObject

/// 订单id
@property (nonatomic, assign) NSInteger order_id;

/// 订单状态
@property (nonatomic, assign) NSInteger status_code;

/// 扩展状态
@property (nonatomic, strong) HungryOrderExtraStatusEntity *extra;

@end



















