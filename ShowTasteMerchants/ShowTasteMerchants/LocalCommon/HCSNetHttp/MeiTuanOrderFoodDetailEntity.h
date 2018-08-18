//
//  MeiTuanOrderFoodDetailEntity.h
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/28.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeiTuanOrderFoodDetailEntity : NSObject

/// erp方菜品id(等价于eDishCode)
//@property (nonatomic, copy) NSString *app_food_code;

/// 餐盒数量(餐盒总数量，例如一份菜A需要1个餐盒，订单中点了2份菜A，餐盒数量未2)
//@property (nonatomic, assign) int box_num;

/// 单核单价
//@property (nonatomic, assign) float box_price;

/// 菜品折扣
//@property (nonatomic, assign) float food_discount;

/// 菜品名称
//@property (nonatomic, copy) NSString *food_name;

/// 菜品价格(菜品原价)
//@property (nonatomic, assign) float price;

/// erp方菜品sku
@property (nonatomic, copy) NSString *sku_id;

/// 菜品份数
//@property (nonatomic, assign) int quantity;

/// 单位
//@property (nonatomic, copy) NSString *unit;

@end

/*
 {\"app_food_code\":\"7317\",\"box_num\":2,\"box_price\":1,\"food_discount\":1,\"food_name\":\"猪肉茴香（锅贴）\",\"price\":12,\"quantity\":2,\"sku_id\":\"6857\",\"unit\":\"份\"}
*/



















