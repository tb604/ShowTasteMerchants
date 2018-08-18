//
//  MyRestaurantPreviewViewController.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/14.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZRefreshTableViewController.h"
#import "RestaurantDetailDataEntity.h" // 餐厅详情
#import "ShopDetailDataEntity.h"

/**
 *  我的餐厅预览视图控制器
 */
@interface MyRestaurantPreviewViewController : TYZRefreshTableViewController

/**
 *  餐厅详情
 */
@property (nonatomic, strong) ShopDetailDataEntity *shopDetailEntity;

@end
