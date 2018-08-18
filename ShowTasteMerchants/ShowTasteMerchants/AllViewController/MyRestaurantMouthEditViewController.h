//
//  MyRestaurantMouthEditViewController.h
//  ChefDating
//
//  Created by 唐斌 on 16/8/3.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewController.h"

/**
 *  档口编辑视图控制器
 */
@interface MyRestaurantMouthEditViewController : TYZBaseTableViewController

/**
 *  档口数据
 */
@property (nonatomic, strong) NSMutableArray *mouthList;

/**
 *  未归档的菜品数据
 */
@property (nonatomic, strong) NSMutableArray *freeFoodList;

@end




















