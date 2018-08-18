//
//  OpenRestaurantViewController.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/7.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseViewController.h"
#import "CuisineFlavorDataEntity.h"
#import "OpenRestaurantInputEntity.h"

/**
 *  开餐厅，第一步
 */
@interface OpenRestaurantViewController : TYZBaseViewController

/**
 *  餐厅类型列表(传统菜系、特色菜系、国际菜系)
 */
@property (nonatomic, strong) CuisineFlavorDataEntity *restaurantEntity;

@property (nonatomic, strong) OpenRestaurantInputEntity *inputEntity;

@end
