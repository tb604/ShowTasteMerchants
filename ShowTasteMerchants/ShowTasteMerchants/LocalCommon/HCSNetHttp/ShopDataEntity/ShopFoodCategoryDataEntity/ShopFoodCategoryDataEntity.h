//
//  ShopFoodCategoryDataEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/1.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShopFoodDataEntity.h"

@interface ShopFoodCategoryDataEntity : NSObject

/**
 *  菜品分类id
 */
@property (nonatomic, assign) NSInteger id;

/**
 * 餐厅id
 */
@property (nonatomic, assign) NSInteger shop_id;

/**
 * 分类名称
 */
@property (nonatomic, copy) NSString *name;

/**
 * 0：掌柜推荐  1：名厨推荐  2：普通分类
 */
@property (nonatomic, assign) NSInteger type;

/**
 * 0：有效；1：无效
 */
@property (nonatomic, assign) NSInteger state;

/**
 * 备注
 */
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, assign) NSInteger remarkHeight;

/**
 * 分类排序id
 */
@property (nonatomic, assign) NSInteger sort_index;

/**
 *  菜品数组
 */
@property (nonatomic, strong) NSMutableArray *foods;

/**
 *  是否添加
 */
@property (nonatomic, assign) BOOL isAdd;

/**
 *  选中的数量
 */
@property (nonatomic, assign) NSInteger selectNum;

@end






















