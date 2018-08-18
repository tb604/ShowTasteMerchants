//
//  MyRestaurantListViewController.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/7.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZRefreshTableViewController.h"

/**
 *  经营模式，我开的餐厅列表
 */
@interface MyRestaurantListViewController : TYZRefreshTableViewController

/// 2表示从资质审核中进去的
@property (nonatomic, assign) NSInteger comeType;

@property (nonatomic, strong) NSArray *shopList;

@end
