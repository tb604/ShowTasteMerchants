//
//  OrderMealContentEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/5/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OrderMealContentEntity : NSObject

/**
 *  (id)
 */
@property (nonatomic, assign) NSInteger cId;

/**
 *  (菜品)名称
 */
@property (nonatomic, copy) NSString *name;

/**
 *  图片地址
 */
@property (nonatomic, copy) NSString *image;

/**
 *  餐厅id
 */
@property (nonatomic, assign) NSInteger shop_id;

/**
 *  分类id
 */
@property (nonatomic, assign) NSInteger class_id;

/**
 *  口号或者标语
 */
@property (nonatomic, copy) NSString *slogan;

/**
 *  评价条数
 */
@property (nonatomic, assign) NSInteger comments;

/**
 *  菜品分类数据
 */
@property (nonatomic, copy) NSString *classify;

/**
 *  餐厅首图
 */
@property (nonatomic, copy) NSString *default_image;

/**
 *  厨师头像
 */
@property (nonatomic, copy) NSString *topchef_image;

/**
 *  人均价格
 */
@property (nonatomic, copy) NSString *average;


@property (nonatomic, copy) NSString *cx;

/**
 *  分享地址
 */
@property (nonatomic, copy) NSString *share_url;


@end


















