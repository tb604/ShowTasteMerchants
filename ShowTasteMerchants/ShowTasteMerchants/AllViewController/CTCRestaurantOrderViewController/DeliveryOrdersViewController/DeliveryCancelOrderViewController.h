//
//  DeliveryCancelOrderViewController.h
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewController.h"
#import "HungryOrderDetailEntity.h"

@interface DeliveryCancelOrderViewController : TYZBaseTableViewController

@property (nonatomic, strong) HungryOrderDetailEntity *orderDetailEntity;

/// 1表示商家取消用户的订单；2表示商家取消达达的配送订单
@property (nonatomic, assign) NSInteger type;

/// 达达的取消原因
@property (nonatomic, strong)NSArray *reasonList;

@end
