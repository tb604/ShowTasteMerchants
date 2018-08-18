//
//  MyRestaurantMouthSelectEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/9/10.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyRestaurantMouthSelectEntity : NSObject

/**
 *  固定不变的
 */
@property (nonatomic, assign) NSInteger fixPrinterId;

/**
 *  1表示主；0表示副(已归档)
 */
@property (nonatomic, assign) NSInteger flag;

/**
 *  菜品id(已归档)
 */
@property (nonatomic, assign) NSInteger foodId;

/**
 *  档口id(已归档)
 */
@property (nonatomic, assign) NSInteger printerId;

/**
 *  1表示主；0表示副(未归档)
 */
@property (nonatomic, assign) NSInteger nFlag;

/**
 *  菜品id(未归档)
 */
@property (nonatomic, assign) NSInteger nFoodId;

/**
 *  档口id(未归档)
 */
@property (nonatomic, assign) NSInteger nPrinterId;


@end
