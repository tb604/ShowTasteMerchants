//
//  ShopOrderDetailViewController.h
//  ChefDating
//
//  Created by 唐斌 on 16/8/4.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZRefreshTableViewController.h"
#import "OrderDetailDataEntity.h"
#import "CTCOrderDetailEntity.h"

typedef NS_ENUM(NSInteger, EN_SHOP_ORDER_DETAIL_SESTIONS)
{
//    EN_SHOP_ORDER_DETAIL_STATUS_SESTION = 0, ///< 订单状态
    EN_SHOP_ORDER_DETAIL_DINERSINFO_SESTION = 0, ///< 食客信息
    EN_SHOP_ORDER_DETAIL_CURRFOOD_SESTION, ///< 下单的菜品列表
//    EN_SHOP_ORDER_DETAIL_NEWADDFOOD_SESTION, ///< 新增的菜品列表
    EN_SHOP_ORDER_DETAIL_MAX_SESTION
};

typedef NS_ENUM(NSInteger, EN_SHOP_ORDER_DETAIL_DI_ROWS)
{
    EN_SHOP_ORDER_DETAIL_DI_BASEINFO_ROW = 0, ///< 基本信息
    EN_SHOP_ORDER_DETAIL_DI_ORDERINFO_ROW, ///< 订单信息
    EN_SHOP_ORDER_DETAIL_DI_MAX_ROW
};

/**
 *  餐厅端的订单详情视图视图控制器
 */
@interface ShopOrderDetailViewController : TYZRefreshTableViewController

@property (nonatomic, strong) CTCOrderDetailEntity *orderDetailEntity;

/**
 *  餐厅位置、空间
 */
@property (nonatomic, strong) NSArray *seatLocList;

/**
 *  档口信息(打印机)
 */
@property (nonatomic, strong) NSArray *printerList;

@end
