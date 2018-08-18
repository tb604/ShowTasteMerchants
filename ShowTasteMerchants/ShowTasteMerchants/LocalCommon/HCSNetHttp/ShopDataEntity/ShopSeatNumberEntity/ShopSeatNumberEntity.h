//
//  ShopSeatNumberEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/8/27.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopSeatNumberEntity : NSObject

/**
 *  订单id
 */
@property (nonatomic, copy) NSString *order_id;

/**
 *  餐桌编号
 */
@property (nonatomic, copy) NSString *seat_number;

/**
 *  餐厅编号
 */
@property (nonatomic, assign) NSInteger shop_id;

/**
 *  实际就餐人数
 */
@property (nonatomic, assign) NSInteger cust_count;

/**
 *  餐桌位置。 0大厅；1包间；2走廊
 */
@property (nonatomic, assign) NSInteger seat_type;

@end






















