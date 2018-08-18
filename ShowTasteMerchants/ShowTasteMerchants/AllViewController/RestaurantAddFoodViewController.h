//
//  RestaurantAddFoodViewController.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/27.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZRefreshTableViewController.h"
#import "ShopFoodDataEntity.h"

typedef NS_ENUM(NSInteger, EN_RES_FOOD_INFO_SECTIONS)
{
    EN_RES_FOOD_INFO_BASE_SECTION = 0, ///< 菜品信息
    EN_RES_FOOD_INFO_RELATED_SECTION, ///< 相关
    EN_RES_FOOD_INFO_MAX_SECTION
};
// related

typedef NS_ENUM(NSInteger, EN_RES_ADDFOOD_INFO_ROWS)
{
    EN_RES_ADDFOOD_INFO_NAME_ROW = 0, ///< 菜名
    EN_RES_ADDFOOD_INFO_CATEGORY_ROW, ///< 类别
    EN_RES_ADDFOOD_INFO_STALL_ROW, ///< 档口
    EN_RES_ADDFOOD_INFO_CRAFT_ROW, ///< 工艺
    EN_RES_ADDFOOD_INFO_CASTE_ROW, ///< 口味
    EN_RES_ADDFOOD_INFO_INTRO_ROW, ///< 介绍
    EN_RES_ADDFOOD_INFO_PRICE_ROW, ///< 价格(元/份)
    EN_RES_ADDFOOD_INFO_ACTIVITY_PRICE_ROW, ///< 活动价格(元/份)
    EN_RES_ADDFOOD_INFO_IMAGE_ROW, ///< 菜品图片、优惠活动
//    EN_RES_ADDFOOD_INFO_RELATED_IMAGE_ROW, ///< 相关菜品图片
    EN_RES_ADDFOOD_INFO_MAX_ROW
};



/**
 *  餐厅添加菜品视图控制器
 */
@interface RestaurantAddFoodViewController : TYZRefreshTableViewController

@property (nonatomic, strong) NSMutableArray *menuList;

/**
 *  1表示添加；2表示编辑
 */
@property (nonatomic, assign) NSInteger type;

/**
 *  档口数组 ShopMouthDataEntity
 */
@property (nonatomic, strong) NSMutableArray *mouthList;

/**
 *  菜品数据
 */
@property (nonatomic, strong) ShopFoodDataEntity *foodEntity;

@end






























