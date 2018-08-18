//
//  DaDaDistAddOrderTipsEntity.h
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/12/2.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  增加小费的参数
 */
@interface DaDaDistAddOrderTipsEntity : NSObject

/// 商户Id
@property (nonatomic, copy) NSString *source_id;

/// 订单Id
@property (nonatomic, copy) NSString *order_id;

/// 小费金额
@property (nonatomic, assign) float tips;

/// 订单城市区号
@property (nonatomic, copy) NSString *city_code;

/// 备注
@property (nonatomic, copy) NSString *info;

@end























