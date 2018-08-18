//
//  ShopFoodInputEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/1.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  修改菜品的传入参数
 */
@interface ShopFoodInputEntity : NSObject

/**
 * 菜品id(Y)
 */
@property (nonatomic, assign) NSInteger foodId;

/**
 * 餐厅id(Y)
 */
@property (nonatomic, assign) NSInteger shopId;

/**
 * 菜品分类id(Y)
 */
@property (nonatomic, assign) NSInteger categoryId;



/**
 * 档口id(Y)
 */
@property (nonatomic, assign) NSInteger printerId;

/**
 * 菜品名称(Y)
 */
@property (nonatomic, copy) NSString *name;

/**
 * 菜品工艺，逗号隔开(N)
 */
@property (nonatomic, copy) NSString *mode;

/**
 * 菜品口味，逗号隔开(N)
 */
@property (nonatomic, copy) NSString *taste;

/**
 * 菜品简介(N)
 */
@property (nonatomic, copy) NSString *intro;

/**
 * 菜品价格(Y)
 */
@property (nonatomic, assign) NSInteger price;

/**
 * 菜品活动价格(N)
 */
@property (nonatomic, assign) NSInteger activityPrice;

/**
 *  菜品单位(Y)
 */
@property (nonatomic, copy) NSString *unit;

/**
 * 菜品图片(Y)
 */
@property (nonatomic, copy) NSString *image;

/**
 * 菜品备注(N)
 */
@property (nonatomic, copy) NSString *remark;

/**
 *  菜品详情(JSON)(N)  [
 {
 "image": "abc1.png",
 "description": "使用了**食材"
 },
 {
 "image": "abc2.png",
 "description": "使用了**调味"
 }
 ]
 */
@property (nonatomic, copy) NSString *content;

@end




























