//
//  UserPlaceEatingMeWantPayViewController.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewController.h"
#import "OrderDetailDataEntity.h"

/**
 *  就餐完，点击我要支付，后显示的清单视图控制器
 */
@interface UserPlaceEatingMeWantPayViewController : TYZBaseTableViewController

@property (nonatomic, strong) OrderDetailDataEntity *orderDetailEntity;

@end
