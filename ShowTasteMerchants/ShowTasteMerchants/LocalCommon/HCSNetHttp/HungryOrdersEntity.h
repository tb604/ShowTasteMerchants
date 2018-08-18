//
//  HungryOrdersEntity.h
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/23.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HungryOrdersEntity : NSObject

/// 平台类型
@property (nonatomic, copy) NSString *platform;

/// 订单id数组
@property (nonatomic, strong) NSArray *eleme_order_ids;

/// 订单id
@property (nonatomic, copy) NSString *eleme_order_id;

@end

// \"platform\":\"ele\",\"orderIds\":[\"101582797453145710\"]



















