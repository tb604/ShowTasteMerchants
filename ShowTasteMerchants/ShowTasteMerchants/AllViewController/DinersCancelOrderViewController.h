//
//  DinersCancelOrderViewController.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/20.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewController.h"
//#import "OrderDataEntity.h"
#import "CTCMealOrderDetailsEntity.h"

/**
 *  食客端取消订单视图控制器
 */
@interface DinersCancelOrderViewController : TYZBaseTableViewController

@property (nonatomic, strong) CTCMealOrderDetailsEntity *orderDetailEntity;

@property (nonatomic, strong) NSArray *reasonList;

@end
