//
//  DinersRecipeFoodDetailViewController.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/26.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZRefreshTableViewController.h"
#import "ShopFoodDataEntity.h" // 菜品详情

typedef NS_ENUM(NSInteger, EN_DRFD_ROWS)
{
    EN_DRFD_BASE_ROW = 0, ///< 基本信息
    EN_DRFD_STANDARD_ACTIVITY_ROW, ///< 规格
    EN_DRFD_INTRO_ROW, ///< 菜品简介
    EN_DRFD_MAX_ROW
};

/**
 *  菜谱，点击具体的菜品，进入菜品详情，同时购物车
 */
@interface DinersRecipeFoodDetailViewController : TYZRefreshTableViewController

@property (nonatomic, strong) ShopFoodDataEntity *foodDetailEntity;

/**
 *  购物车数据
 */
@property (nonatomic, strong) NSMutableArray *shopingCartList;

/**
 *  YES表示浏览，不做能做加入购物车操作
 */
@property (nonatomic, assign) BOOL isBrowse;

@end
