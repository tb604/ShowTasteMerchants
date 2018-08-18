//
//  EvenDiningViewController.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/26.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewController.h"
#import "RestaurantBaseDataEntity.h" // 餐厅信息

/**
 *  即时就餐视图控制器(请求即时就餐)
 */
@interface EvenDiningViewController : TYZBaseTableViewController

/**
 *  餐厅详情
 */
@property (nonatomic, strong) RestaurantBaseDataEntity *shopDetailEntity;

@end
