//
//  ShopFoodDataEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/1.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ShopFoodImageEntity.h"
#import "StandardDataEntity.h"

/**
 *  菜品信息
 */
@interface ShopFoodDataEntity : NSObject

/**
 * 菜品id
 */
@property (nonatomic, assign) NSInteger id;

/**
 *  餐厅id
 */
@property (nonatomic, assign) NSInteger shop_id;

/**
 *  菜品分类id
 */
@property (nonatomic, assign) NSInteger category_id;

/**
 *  菜品分类名称
 */
@property (nonatomic, copy) NSString *category_name;

/**
 * 档口id
 */
@property (nonatomic, assign) NSInteger printer_id;

/**
 *  档口名称
 */
@property (nonatomic, copy) NSString *printer_name;

/**
 * 菜品名称
 */
@property (nonatomic, copy) NSString *name;

/**
 * 菜品工艺(逗号分隔)
 */
@property (nonatomic, copy) NSString *mode;

/**
 * 菜品口味(逗号隔开)
 */
@property (nonatomic, copy) NSString *taste;

/**
 *  这个菜品，在购物车里面的数据
 */
@property (nonatomic, strong) NSMutableArray *shopCartList;

/**
 * 菜品介绍
 */
@property (nonatomic, copy) NSString *intro;

@property (nonatomic, assign) CGFloat introHeight;

/**
 * 菜品价格
 */
@property (nonatomic, assign) float price;

/**
 * 菜品活动价格
 */
@property (nonatomic, assign) float activity_price;

/**
 * 菜品图片
 */
@property (nonatomic, copy) NSString *image;
@property (nonatomic, strong) UIImage *imageData;

/**
 * 菜品状态。0在线；1下架；2删除
 */
@property (nonatomic, assign) NSInteger state;

/**
 * 菜品备注
 */
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, assign) CGFloat remarkHeight;

/**
 * 操作菜品下架、删除的时间
 */
@property (nonatomic, copy) NSString *op_datetime;


// 详情
/**
 *  菜品单位(份)
 */
@property (nonatomic, copy) NSString *unit;

/**
 *  是否有详情，0 没有详情  1 有详情
 */
@property (nonatomic, assign) NSInteger display;

/**
 *  菜品详情列表
 */
@property (nonatomic, strong) NSMutableArray *content;

/**
 *  规格
 */
@property (nonatomic, strong) StandardDataEntity *standard;

/**
 *  是添加到购物车，还是从购物车删除；YES表示添加，否则删除
 */
@property (nonatomic, assign) BOOL isAdd;

@end





/*
 {

 "standard": {
 "state": 1,
 "mode": [
 "太说我是"
 ],
 "taste": [
 "太胖了"
 ]
 },
 }
 */























