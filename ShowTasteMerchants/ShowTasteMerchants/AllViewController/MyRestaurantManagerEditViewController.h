//
//  MyRestaurantManagerEditViewController.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/28.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZRefreshTableViewController.h"
#import "ShopManagePositionAuthEntity.h"

@interface MyRestaurantManagerEditViewController : TYZRefreshTableViewController

/**
 *  餐厅员工信息列表
 */
@property (nonatomic, strong) NSArray *list;

/**
 *  职位、权限
 */
@property (nonatomic, strong) ShopManagePositionAuthEntity *postionAuthEntity;

@end
