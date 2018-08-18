//
//  OrderListInputEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderListInputEntity : NSObject

/**
 *  用户id(Y)
 */
@property (nonatomic, assign) NSInteger userId;

/**
 *  订单类型 0当前订单；1历史订单
 */
@property (nonatomic, assign) NSInteger catId;

/**
 *  页码
 */
@property (nonatomic, assign) NSInteger pageIndex;

/**
 *  每页显示的条数
 */
@property (nonatomic, assign) NSInteger pageSize;

@end





















