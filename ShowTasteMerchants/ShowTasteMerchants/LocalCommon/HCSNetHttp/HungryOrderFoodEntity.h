//
//  HungryOrderFoodEntity.h
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/16.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 菜品
 */
@interface HungryOrderFoodEntity : NSObject

/// 分类ID
@property (nonatomic, assign) int category_id;

/// 售品名称
@property (nonatomic, copy) NSString *name;

/// 售品价格(单位：元)
@property (nonatomic, assign) float price;

/// 浇头，item为一个售品对象(就是浇头，可以添加到食物里，比如点一个荷包蛋，加到炒饭这个food的garnish里)
@property (nonatomic, strong) NSArray *garnish;

/// 售品ID
@property (nonatomic, assign) NSInteger id;

/// 售品数量
@property (nonatomic, assign) int quantity;

/// 第三方ID
@property (nonatomic, copy) NSString *tp_food_id;

/// 规格名称(是菜品规格，用于描述菜品是大份还是小份等信息)
@property (nonatomic, strong) NSArray *specs;



#pragma mark 美团

/// 餐盒数量(餐盒总数量，例如一份菜A需要1个餐盒，订单中点了2份菜A，餐盒数量未2)--美团
@property (nonatomic, assign) int box_num;

/// 单核单价--美团
@property (nonatomic, assign) float box_price;

/// 菜品折扣--美团
@property (nonatomic, assign) float food_discount;

/// 单位--美团
@property (nonatomic, copy) NSString *unit;

@end

/*
 "category_id": 1,
 "name": "狗不理",
 "price": 100,
 "garnish": [],
 "id": 1,
 "quantity": 1,
 "tp_food_id": "1312312",
 "specs": [
 "辣",
 "大份"
 ]
 */



















