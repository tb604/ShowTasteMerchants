//
//  DinersCreateOrderViewController.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/28.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewController.h"
#import "RestaurantReservationInputEntity.h"
#import "OrderDataEntity.h"

typedef NS_ENUM(NSInteger, EN_DCO_SECTIONS)
{
    EN_DCO_SHOPINFO_SECTION = 0, ///< 餐厅信息(餐厅名称、地址、电话)
    EN_DCO_FOODLIST_SECTION, ///< 食客点的菜品列表
    EN_DCO_MAX_SECTION
};

typedef NS_ENUM(NSInteger, EN_DCO_SHOPINFO_ROWS)
{// reserve
    EN_DCO_SHOPINFO_SHOPNAME_ROW = 0, ///< 餐厅名称
    EN_DCO_SHOPINFO_ADDRESS_ROW, ///< 餐厅地址
    EN_DCO_SHOPINFO_MOBILE_ROW, ///< 餐厅电话
    EN_DCO_SHOPINFO_RESERVEINFO_ROW, ///< 预订信息
    EN_DCO_SHOPINFO_MAX_ROW
};

//typedef NS_ENUM(NSInteger, ) <#new#>;

/**
 *  食客创建订单视图控制器
 */
@interface DinersCreateOrderViewController : TYZBaseTableViewController

/**
 *  创建订单的参数
 */
@property (nonatomic, strong) RestaurantReservationInputEntity *inputFoodEntity;

/**
 *  档口信息(打印机)
 */
@property (nonatomic, strong) NSArray *printerList;

@end
