//
//  ShopDetailViewController.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/1.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZRefreshTableViewController.h"

@class OrderMealContentEntity;

/**
 *  餐厅详情视图控制器
 */
@interface ShopDetailViewController : TYZRefreshTableViewController

@property (nonatomic, strong) OrderMealContentEntity *mealEntity;

@end
