//
//  DaDaDistAddOrderInputEntity.h
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/30.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 达达配送新增订单传入参数
@interface DaDaDistAddOrderInputEntity : NSObject

@property (nonatomic, assign) NSInteger shop_id;

/// 平台类型。eleme/meituan
@property (nonatomic, copy) NSString *platform;

/// 外卖订单订单ID
@property (nonatomic, copy) NSString *order_id;

/// 城市编号，默认电话区号
@property (nonatomic, copy) NSString *city_code;

/// 订单金额
@property (nonatomic, assign) float order_price;

/// 收货人姓名
@property (nonatomic, copy) NSString *name;

/// 收货人地址
@property (nonatomic, copy) NSString *address;

/// 收货人电话号码
@property (nonatomic, copy) NSString *phone;

/// 维度
@property (nonatomic, copy) NSString *lat;

/// 经度
@property (nonatomic, copy) NSString *lng;





@end












