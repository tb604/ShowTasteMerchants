//
//  ShopCreateInputEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/5/31.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  新建餐厅，需要传入的参数
 */
@interface ShopCreateInputEntity : NSObject

/**
 * 口味菜系ID列表，多个用逗号隔开
 */
@property (nonatomic, copy) NSString *ids;

/**
 *  用户Id
 */
@property (nonatomic, assign) NSInteger userId;

/**
 *  餐厅地址
 */
@property (nonatomic, copy) NSString *address;

/**
 *  经度
 */
@property (nonatomic, assign) double lng;

/**
 *  纬度
 */
@property (nonatomic, assign) double lat;

/**
 *  餐厅名称
 */
@property (nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END


























