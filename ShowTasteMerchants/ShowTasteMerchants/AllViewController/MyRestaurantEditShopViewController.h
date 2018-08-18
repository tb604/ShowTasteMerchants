//
//  MyRestaurantEditShopViewController.h
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/4.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewController.h"

/**
 *  编辑餐厅列表(把餐厅添加给具体的管理人员)
 */
@interface MyRestaurantEditShopViewController : TYZBaseTableViewController

/// 已经有的餐厅
@property (nonatomic, strong) NSMutableArray *selectShopList;

/// 所有的餐厅
@property (nonatomic, strong) NSArray *allShops;

@end
