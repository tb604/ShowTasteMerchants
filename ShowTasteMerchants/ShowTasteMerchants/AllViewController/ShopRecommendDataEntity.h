//
//  ShopRecommendDataEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/1.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  餐厅推荐类
 */
@interface ShopRecommendDataEntity : NSObject

/**
 *  推荐id(菜品ID)
 */
@property (nonatomic, assign) NSInteger id;

/**
 *  菜品口味
 */
@property (nonatomic, copy) NSString *taste;

/**
 *  制作工艺
 */
@property (nonatomic, copy) NSString *mode;

/**
 *  菜品名称
 */
@property (nonatomic, copy) NSString *name;

/**
 *  餐厅id
 */
@property (nonatomic, assign) NSInteger shop_id;

/**
 *  菜品分类id
 */
@property (nonatomic, assign) NSInteger category_id;

/**
 *  档口id
 */
@property (nonatomic, assign) NSInteger printer_id;

/**
 *  菜品简介
 */
@property (nonatomic, copy) NSString *intro;

@property (nonatomic, assign) CGFloat introHeight;

/**
 *  菜品价格
 */
@property (nonatomic, assign) CGFloat price;

/**
 *  菜品活动价格
 */
@property (nonatomic, assign) CGFloat activity_price;

/**
 *  菜品图片HOST
 */
@property (nonatomic, copy) NSString *image_host;

/**
 *  菜品图片地址
 */
@property (nonatomic, copy) NSString *image;

/**
 *  菜品备注
 */
@property (nonatomic, copy) NSString *remark;

/**
 *  排序id
 */
@property (nonatomic, assign) NSInteger sort_index;

@property (nonatomic, assign) NSInteger state;

@property (nonatomic, copy) NSString *op_datetime;

/**
 *  是否有菜品详情 0 没有详情， 1 有详情
 */
@property (nonatomic, assign) NSInteger display;

/**
 *  单位
 */
@property (nonatomic, copy) NSString *unit;

@end

/*
"intro":"哈哈姐姐姐姐家的小孩的话。我是","unit":"份","printer_id":12}
 
 
 "id": 58,
 "name": "特色东坡肉",
 "category_id": 48,
 "intro": "美味qweqweasdasdasdsad",
 "price": 88,
 "activity_price": 0,
 "image_host": "http://7xsdmx.com2.z0.glb.qiniucdn.com/",
 "images": "[\"shop/8/1b2dfda4-db94-fefd-ce60-649c4a16ad35.jpg\"]",
 "remark": "",
 "sort_index": 3
*/