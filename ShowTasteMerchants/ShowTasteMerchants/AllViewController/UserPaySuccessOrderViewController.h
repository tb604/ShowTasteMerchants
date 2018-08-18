//
//  UserPaySuccessOrderViewController.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewController.h"
#import "OrderDetailDataEntity.h"

/**
 *  支付成功后，显示的订单详情视图控制器
 */
@interface UserPaySuccessOrderViewController : TYZBaseTableViewController

@property (nonatomic, strong) OrderDetailDataEntity *orderDetailEnt;

@end
