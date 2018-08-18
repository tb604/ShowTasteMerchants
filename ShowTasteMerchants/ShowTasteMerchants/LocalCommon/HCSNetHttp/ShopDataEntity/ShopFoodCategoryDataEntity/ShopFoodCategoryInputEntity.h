//
//  ShopFoodCategoryInputEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/1.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopFoodCategoryInputEntity : NSObject

/**
 * 分类id
 */
@property (nonatomic, assign) NSInteger categoryId;

/**
 * 餐厅id
 */
@property (nonatomic, assign) NSInteger shopid;

/**
 *  分类 0名厨推荐；1普通分类
 */
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) NSInteger state;

/**
 * 分类名称
 */
@property (nonatomic, copy) NSString *name;

/**
 *  分类简介
 */
@property (nonatomic, copy) NSString *remark;

@property (nonatomic, assign) NSInteger sortIndex;

/**
 *  YES表示新增；NO表示更新
 */
@property (nonatomic, assign) BOOL isAdd;

@end



























