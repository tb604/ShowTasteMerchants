//
//  AddSeatInputEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/5/24.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  新增餐位预订出入参数
 */
@interface AddSeatInputEntity : NSObject

/**
 *  餐厅id
 */
@property (nonatomic, assign) NSInteger shopId;

/**
 *  就餐时段
 */
@property (nonatomic, copy) NSString *mealtime;

/**
 *  就餐位置
 */
@property (nonatomic, copy) NSString *seatType;

/**
 *  就餐人数
 */
@property (nonatomic, assign) NSInteger seatNumber;

/**
 *  可预订数
 */
@property (nonatomic, assign) NSInteger reserveTotal;

@end


























