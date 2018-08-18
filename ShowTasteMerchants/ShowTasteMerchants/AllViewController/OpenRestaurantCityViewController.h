//
//  OpenRestaurantCityViewController.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/17.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZRefreshTableViewController.h"
#import "OpenRestaurantInputEntity.h"

/**
 *  开餐厅第二步，餐厅所在城市，视图控制器
 */
@interface OpenRestaurantCityViewController : TYZRefreshTableViewController

@property (nonatomic, strong) OpenRestaurantInputEntity *inputEntity;

@end
