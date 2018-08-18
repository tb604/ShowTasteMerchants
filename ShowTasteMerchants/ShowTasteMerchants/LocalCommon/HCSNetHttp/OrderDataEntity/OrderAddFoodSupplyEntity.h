//
//  OrderAddFoodSupplyEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  添加菜品后，返回的数据
 */
@interface OrderAddFoodSupplyEntity : NSObject

/**
 * 菜品数量
 */
@property (nonatomic, assign) NSInteger total_number;

/**
 * 菜品总价
 */
@property (nonatomic, assign) CGFloat total_price;

/**
 * 预付订金
 */
@property (nonatomic, assign) CGFloat book_deposit;

/**
 *  结算金额
 */
@property (nonatomic, assign) CGFloat pay_amount;

@end























