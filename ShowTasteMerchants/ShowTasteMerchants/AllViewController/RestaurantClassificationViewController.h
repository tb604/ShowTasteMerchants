//
//  RestaurantClassificationViewController.h
//  ChefDating
//
//  Created by 唐斌 on 16/5/24.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZRefreshTableViewController.h"
#import "OrderMealDataEntity.h"
#import "CuisineFlavorDataEntity.h"


/**
 *  首页分类视图控制器
 */
@interface RestaurantClassificationViewController : TYZRefreshTableViewController

@property (nonatomic, strong) OrderMealDataEntity *orderMealEntity;

/**
 *  类型，传统菜系、特色菜系、国际菜系 
 */
@property (nonatomic, strong) CuisineFlavorDataEntity *cuisineEntity;

@end
