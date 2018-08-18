//
//  OpenRestaurantInputEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/8.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OpenRestaurantInputEntity : NSObject

/**
 *  选择的传统菜系
 */
@property (nonatomic, strong) NSArray *traditions;

/**
 *  选择的特色菜系
 */
@property (nonatomic, strong) NSArray *features;

/**
 *  选择的国际菜系
 */
@property (nonatomic, strong) NSArray *inters;

/**
 *  餐厅地址
 */
@property (nonatomic, copy) NSString *address;

/**
 *  城市id
 */
@property (nonatomic, assign) NSInteger cityId;

/**
 *  城市名称
 */
@property (nonatomic, copy) NSString *cityName;

/**
 *  餐厅名字
 */
@property (nonatomic, copy) NSString *restaurantName;

/**
 *  餐厅id
 */
@property (nonatomic, assign) NSInteger shopId;

/**
 *  1表示从登录这里，点击的“我要开店”;2表示点击编辑按钮进入的；3表示从餐厅列表中进入的，创建餐厅
 */
@property (nonatomic, assign) NSInteger comeType;

@end
