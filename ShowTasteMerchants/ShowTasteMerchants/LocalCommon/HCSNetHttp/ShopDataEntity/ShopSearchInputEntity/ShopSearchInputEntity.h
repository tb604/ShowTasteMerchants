//
//  ShopSearchInputEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/8/2.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  餐厅搜索的传入参数
 */
@interface ShopSearchInputEntity : NSObject

/**
 * 城市id(Y)
 */
@property (nonatomic, assign) NSInteger city_id;

/**
 * 商圈id(N)
 */
@property (nonatomic, assign) NSInteger mall_id;

/**
 * 菜系口味ID列表，逗号隔开(N)
 */
@property (nonatomic, copy) NSString *classify_ids;

/**
 * 纬度(Y)
 */
@property (nonatomic, assign) double lat;

/**
 * 经度(Y)
 */
@property (nonatomic, assign) double lng;

/**
 * 范围(N)
 */
@property (nonatomic, assign) NSInteger distance;

/**
 * 搜索关键字(Y)
 */
@property (nonatomic, copy) NSString *key;

/**
 * 当前页码(Y)
 */
@property (nonatomic, assign) NSInteger page_index;

@end





























