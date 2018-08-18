//
//  MyRestaurantMenuEditViewController.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/24.
//  Copyright © 2016年 唐斌. All rights reserved.
//

//#import "TYZBaseViewController.h"
//#import "TYZBaseTableViewController.h"
#import "TYZBaseCollectionViewController.h"

/**
 *  餐厅菜单编辑视图控制器
 */
@interface MyRestaurantMenuEditViewController : TYZBaseCollectionViewController

@property (nonatomic, assign) NSInteger shopId;

/**
 *  分类
 */
@property (nonatomic, strong) NSMutableArray *menuList;


@end
