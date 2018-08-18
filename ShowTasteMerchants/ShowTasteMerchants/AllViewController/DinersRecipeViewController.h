//
//  DinersRecipeViewController.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/24.
//  Copyright © 2016年 唐斌. All rights reserved.
//

//#import "TYZRefreshTableViewController.h"
#import "TYZRefreshCollectionViewController.h"
#import "RestaurantReservationInputEntity.h"

/**
 *  食客菜谱视图控制器
 */
@interface DinersRecipeViewController : TYZRefreshCollectionViewController

/**
 *  菜品类型数据
 */
@property (nonatomic, strong) NSArray *cateList;

/**
 *  购物车数据
 */
@property (nonatomic, strong) NSMutableArray *shopingCartList;

/**
 *  预订餐厅的传入参数
 */
@property (nonatomic, strong) RestaurantReservationInputEntity *reservationInputEntity;

@end
