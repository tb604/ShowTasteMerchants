//
//  AddFoodPriceViewController.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/12.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseViewController.h"

/**
 *  添加菜品的价格视图控制器
 */
@interface AddFoodPriceViewController : TYZBaseViewController

/**
 *  价格
 */
@property (nonatomic, copy) NSString *content;

/**
 *  单位
 */
@property (nonatomic, copy) NSString *uint;

@property (nonatomic, copy) NSString *placeholder;

/**
 *  单位列表
 */
@property (nonatomic, strong) NSArray *uintList;


@end
















