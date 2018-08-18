//
//  UserPayWayViewController.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewController.h"
#import "OrderDetailDataEntity.h"

/**
 *  支付方式视图控制器
 */
@interface UserPayWayViewController : TYZBaseTableViewController

@property (nonatomic, strong) OrderDetailDataEntity *orderDetailEntity;

@end
