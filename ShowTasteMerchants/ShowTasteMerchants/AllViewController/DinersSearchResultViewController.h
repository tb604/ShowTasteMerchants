//
//  DinersSearchResultViewController.h
//  ChefDating
//
//  Created by 唐斌 on 16/8/8.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZRefreshTableViewController.h"
#import "CuisineFlavorDataEntity.h"
#import "MallDataEntity.h"
#import "ShopSearchInputEntity.h"

/**
 *  搜索结果视图
 */
@interface DinersSearchResultViewController : TYZRefreshTableViewController

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
