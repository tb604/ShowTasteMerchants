//
//  UserEvaluationPaySucViewController.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewController.h"
#import "OrderDetailDataEntity.h"

/**
 *  支付完成后，评论视图控制器
 */
@interface UserEvaluationPaySucViewController : TYZBaseTableViewController

@property (nonatomic, strong) OrderDetailDataEntity *orderDetailEnt;

@property (nonatomic, strong) NSArray *boradTypeList;

@end
