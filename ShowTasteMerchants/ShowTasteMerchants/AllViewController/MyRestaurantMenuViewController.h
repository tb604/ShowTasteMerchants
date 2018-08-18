//
//  MyRestaurantMenuViewController.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/17.
//  Copyright © 2016年 唐斌. All rights reserved.
//

//#import "TYZBaseTableViewController.h"
#import "TYZBaseCollectionViewController.h"

/**
 *  我的餐厅菜单视图控制器
 */
@interface MyRestaurantMenuViewController : TYZBaseCollectionViewController

/**
 *  分类
 */
@property (nonatomic, strong) NSMutableArray *menuList;

//- (void)responseWithFoodCategoryDetails:(TYZRespondDataEntity *)respond;

- (void)doRefreshData;

- (void)addEditMenu:(NSArray *)list;

@end
