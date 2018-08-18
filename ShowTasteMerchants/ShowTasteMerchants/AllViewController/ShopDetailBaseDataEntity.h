//
//  ShopDetailBaseDataEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/1.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShopBaseInfoDataEntity.h" // 餐厅基本信息
#import "ShopChefDataEntity.h" // 餐厅厨师信息
#import "RestaurantChefDataEntity.h"
#import "RestaurantBaseDataEntity.h"

/**
 *  餐厅的详细信息
 */
@interface ShopDetailBaseDataEntity : NSObject

/**
 *  餐厅图片数组
 */
@property (nonatomic, strong) NSArray *images;

/**
 *  餐厅基本信息
 */
//@property (nonatomic, strong) ShopBaseInfoDataEntity *base;

@property (nonatomic, strong) RestaurantBaseDataEntity *details;

/**
 *  餐厅厨师信息
 */
//@property (nonatomic, strong) ShopChefDataEntity *chef;

/**
 *  厨师信息
 */
@property (nonatomic, strong) RestaurantChefDataEntity *topchef;

@end





















