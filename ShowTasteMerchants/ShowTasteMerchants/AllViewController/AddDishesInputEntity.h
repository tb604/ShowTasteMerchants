//
//  AddDishesInputEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/5/24.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  添加菜品出入参数
 */
@interface AddDishesInputEntity : NSObject

/**
 *  餐厅id
 */
@property (nonatomic, assign) NSInteger shopId;

/**
 *  菜品名称
 */
@property (nonatomic, copy) NSString *name;

/**
 *  菜品分类id
 */
@property (nonatomic, assign) NSInteger cid;

/**
 *  菜品简介描述
 */
@property (nonatomic, copy) NSString *intro;

/**
 *  菜品单价
 */
@property (nonatomic, assign) float price;

/**
 *  菜品活动价格
 */
@property (nonatomic, assign) float activityPrice;

/**
 *  菜品图片
 */
@property (nonatomic, copy) NSString *images;

/**
 *  菜品备注
 */
@property (nonatomic, copy) NSString *remark;

@end

NS_ASSUME_NONNULL_END



























