//
//  ShopRepairManagerViewController.h
//  ChefDating
//
//  Created by 唐斌 on 16/8/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewController.h"
#import "OrderDetailDataEntity.h"
#import "CTCMealOrderDetailsEntity.h"
#import "ShopPrinterEntity.h"

/**
 *  补单管理视图控制器
 */
@interface ShopRepairManagerViewController : TYZBaseTableViewController

@property (nonatomic, strong) NSArray *batchFoods;

@property (nonatomic, strong) CTCMealOrderDetailsEntity *orderDetailEnt;

@end
