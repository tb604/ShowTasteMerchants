//
//  DinersSearchResultNewViewController.h
//  ChefDating
//
//  Created by 唐斌 on 16/8/11.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZRefreshTableViewController.h"
#import "ShopSearchInputEntity.h"
#import "CuisineFlavorDataEntity.h"

/**
 *  新的搜索结果视图控制器
 */
@interface DinersSearchResultNewViewController : TYZRefreshTableViewController

/**
 *  收藏的餐厅的列表
 */
@property (nonatomic, strong) NSMutableArray *favorites;

/**
 *  搜索的条件
 */
@property (nonatomic, strong) ShopSearchInputEntity *searchInputEntity;

/**
 *  菜系
 */
@property (nonatomic, strong) CuisineFlavorDataEntity *cuisineEntity;

/**
 *  商圈信息
 */
@property (nonatomic, strong) NSArray *mallList;

@end
