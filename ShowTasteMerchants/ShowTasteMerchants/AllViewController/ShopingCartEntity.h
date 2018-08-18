//
//  ShopingCartEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/25.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  购物车里面的实体类
 */
@interface ShopingCartEntity : NSObject

/**
 *  此菜品加入服务器后生成的编码
 */
@property (nonatomic, assign) NSInteger foodAutoId;

/**
 *  菜品id
 */
@property (nonatomic, assign) NSInteger id;

/**
 *  菜品名称
 */
@property (nonatomic, copy) NSString *name;

/**
 *  菜品分类id
 */
@property (nonatomic, assign) NSInteger category_id;

/**
 *  分类名称 
 */
@property (nonatomic, copy) NSString *categoryName;

/**
 *  购买菜品的数量
 */
@property (nonatomic, assign) NSInteger number;

/**
 *  固定的数量。（对食客来说，比如在即时就餐中，在未激活之前这个值为0表示可以对这个菜进行删除；就餐过程中，不能删除菜品，只能增加，同时可以删除刚才添加的）
 */
@property (nonatomic, assign) NSInteger fixedNumber;

/**
 *  菜品单价
 */
@property (nonatomic, assign) float price;

/**
 *  活动价格
 */
@property (nonatomic, assign) float activityPrice;

/**
 *  工艺
 */
@property (nonatomic, copy) NSString *mode;

/**
 *  口味
 */
@property (nonatomic, copy) NSString *taste;

/**
 *  单位
 */
@property (nonatomic, copy) NSString *unit;

/**
 *  1表示添加；2表示减少
 */
@property (nonatomic, assign) NSInteger addOrSub;


@end

/*
 "id": 1,
 "category_id": 5,
 "number": 2,
 "mode": "烘焙",
 "taste": "",
 "unit": "份",
*/