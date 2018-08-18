//
//  ShopMouthDataEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/1.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShopFoodDataEntity.h"

/**
 *  餐厅档口信息
 */
@interface ShopMouthDataEntity : NSObject

/**
 *  餐厅档口id
 */
@property (nonatomic, assign) NSInteger id;

/**
 *  餐厅id
 */
@property (nonatomic, assign) NSInteger shop_id;

/**
 *  档口名称
 */
@property (nonatomic, copy) NSString *printer_name;

/**
 *  档口ip地址
 */
@property (nonatomic, copy) NSString *printer_ip;

/**
 *  是否选中
 */
@property (nonatomic, assign) NSInteger selected;

@property (nonatomic, strong) NSArray *foods;


@property (nonatomic, assign) BOOL isCheck;

@property (nonatomic, assign) BOOL isSelected;

@end


















