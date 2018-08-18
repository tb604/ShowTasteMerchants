//
//  DeliveryOrdersListViewController.h
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/17.
//  Copyright © 2016年 唐斌. All rights reserved.
//

//#import "TYZBaseTableViewController.h"
#import "TYZRefreshTableViewController.h"

@interface DeliveryOrdersListViewController : TYZRefreshTableViewController

/// 订单类型，（@"待接单", @"已接单", @"配送未接单", @"取货中", @"配送结果", @"异常订单"）
@property (nonatomic, assign) NSInteger orderType;

@end

/*
 基本信息
 name  好厨师测试
 consumer_key  4556922220
 consumer_secret  877c6388aa36280d28fe91c7fe7f014b6c1239b1
 
 测试店铺管理员账号：haochushi
 密码 haochushi123
 测试店铺ID 1958636   https://www.ele.me/shop/1958636
 */
