//
//  ShopFoodUnitDataEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/1.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  菜品数量单位
 */
@interface ShopFoodUnitDataEntity : NSObject

/**
 *  索引值
 */
@property (nonatomic, assign) NSInteger index;

/**
 *  单位描述
 */
@property (nonatomic, copy) NSString *unit;

@end
