//
//  RestaurantReservationViewController.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/19.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewController.h"
#import "OrderDataEntity.h" // 订单
#import "RestaurantBaseDataEntity.h" // 餐厅基本信息
#import "RestaurantReservationInputEntity.h"

typedef NS_ENUM(NSInteger, EN_SHOP_RESERVATION_SESTIONS)
{
    EN_SHOP_RESERVATION_INFO_SECTION = 0, ///< 基本信息
    EN_SHOP_RESERVATION_NOTE_SECTION, ///< 备注
    EN_SHOP_RESERVATION_MAX_SESTIONS
};

typedef NS_ENUM(NSInteger, EN_SHOP_RESERVATION_INFO_ROW)
{
    EN_SHOP_RESERVATION_INFO_DATE_ROW = 0, ///< 预订日期
    EN_SHOP_RESERVATION_INFO_TIME_ROW, ///< 到店时段
    EN_SHOP_RESERVATION_INFO_NUMBER_ROW, ///< 就餐人数
    EN_SHOP_RESERVATION_INFO_LOCATION_ROW, ///< 餐厅位置
    EN_SHOP_RESERVATION_INFO_MAX_ROW
};

typedef NS_ENUM(NSInteger, EN_SHOP_RESERVATION_NOTE_ROWS)
{
    EN_SHOP_RESERVATION_NOTE_ROW = 0, ///< 备注
    EN_SHOP_RESERVATION_NOTE_MAX_ROW
};

/**
 *  餐厅预订视图控制器
 */
@interface RestaurantReservationViewController : TYZBaseTableViewController

@property (nonatomic, strong) RestaurantReservationInputEntity *inputEntity;

/**
 *  餐厅位置信息(大厅、包间、等)
 */
@property (nonatomic, strong) NSArray *seatLocList;

/**
 *  餐厅id
 */
//@property (nonatomic, assign) NSInteger shopId;

/**
 *  餐厅信息
 */
//@property (nonatomic, strong) RestaurantBaseDataEntity *shopEntity;

/**
 *  订单信息
 */
//@property (nonatomic, strong) OrderDataEntity *orderEntity;

@end
