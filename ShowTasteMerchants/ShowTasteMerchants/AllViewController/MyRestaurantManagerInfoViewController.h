//
//  MyRestaurantManagerInfoViewController.h
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/4.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewController.h"
#import "ShopManageNewDataEntity.h"

/**
 *  管理员信息和他名下的餐厅列表
 */
@interface MyRestaurantManagerInfoViewController : TYZBaseTableViewController

@property (nonatomic, strong) ShopManageNewDataEntity *manageEntity;


@end
