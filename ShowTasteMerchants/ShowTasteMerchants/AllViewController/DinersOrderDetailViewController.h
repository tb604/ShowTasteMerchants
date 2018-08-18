//
//  DinersOrderDetailViewController.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/20.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZRefreshTableViewController.h"
#import "OrderDetailDataEntity.h"

typedef NS_ENUM(NSInteger, EN_ORDER_DETAIL_SECTIONS)
{
    EN_ORDER_DETAIL_BASEINFO_SECTION = 0, ///< 基本信息
    EN_ORDER_DETAIL_OLDFOOD_SECTION, ///< old菜品列表
//    EN_ORDER_DETAIL_NEWADDFOOD_SECTION, ///< 新增菜品列表
    EN_ORDER_DETAIL_MAX_SECTION
};

typedef NS_ENUM(NSInteger, EN_ORDER_DETAIL_BASEINFO_ROWS)
{
    EN_ORDER_DETAIL_BASEINFO_SHOPNAME_ROW = 0, ///< 餐厅名称
    EN_ORDER_DETAIL_BASEINFO_SHOPADDRESS_ROW, ///< 餐厅地址
    EN_ORDER_DETAIL_BASEINFO_SHOPMOBILE_ROW, ///< 餐厅电话
    EN_ORDER_DETAIL_BASEINFO_ORDERINFO_ROW, ///< 订单信息
    EN_ORDER_DETAIL_BASEINFO_MAX_ROW
};


/**
 *  食客订单详情视图控制器
 */
@interface DinersOrderDetailViewController : TYZRefreshTableViewController

@property (nonatomic, strong) OrderDetailDataEntity *orderDetailEntity;

@property (nonatomic, assign) BOOL isFirst;

@end
