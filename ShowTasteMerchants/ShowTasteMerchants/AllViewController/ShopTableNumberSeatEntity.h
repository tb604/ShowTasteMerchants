//
//  ShopTableNumberSeatEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/9/8.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopTableNumberSeatEntity : NSObject

/**
 *  位置id
 */
@property (nonatomic, assign) NSInteger seatId;

/**
 *  位置名称
 */
@property (nonatomic, copy) NSString *seatName;

/**
 *  人数
 */
@property (nonatomic, assign) NSInteger personNum;

/**
 *  桌号
 */
@property (nonatomic, copy) NSString *tableNo;

@end
