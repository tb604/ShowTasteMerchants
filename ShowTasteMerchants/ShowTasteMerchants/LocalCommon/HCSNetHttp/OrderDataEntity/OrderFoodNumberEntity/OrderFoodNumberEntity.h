//
//  OrderFoodNumberEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/31.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OrderFoodNumberEntity : NSObject

/**
 *  菜品分类id
 */
@property (nonatomic, assign) NSInteger categoryId;

/**
 *  菜品分类名称
 */
@property (nonatomic, copy) NSString *categoryName;

/**
 *  分类菜品的数量
 */
@property (nonatomic, assign) NSInteger number;

@property (nonatomic, assign) CGFloat price;

@property (nonatomic, assign) CGFloat activityPrice;

/**
 *  单位
 */
@property (nonatomic, copy) NSString *unit;

@end
