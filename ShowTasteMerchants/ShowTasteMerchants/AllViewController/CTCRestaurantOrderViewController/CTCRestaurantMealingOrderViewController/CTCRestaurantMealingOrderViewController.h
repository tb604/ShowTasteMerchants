/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCRestaurantMealingOrderViewController.h
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/17 15:52
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "TYZBaseTableViewController.h"
#import "OrderDetailDataEntity.h"
#import "OrderDiningSeatEntity.h"

/**
 *  餐中订单视图控制器
 */
@interface CTCRestaurantMealingOrderViewController : TYZBaseTableViewController

/// 餐位信息
@property (nonatomic, strong) NSArray *seatLocList;

/// 订单详情
//@property (nonatomic, strong) OrderDetailDataEntity *orderDetailEntity;

/// 选中的订单餐位
@property (nonatomic, strong) OrderDiningSeatEntity *selectedOrderSeatEntity;

/**
 *  档口信息(打印机)
 */
@property (nonatomic, strong) NSArray *printerList;

/// 订单对应的餐位信息列表
@property (nonatomic, strong) NSMutableArray *orderSeatList;

/**
 *  得到订单详情
 */
- (void)getWithOrderDetail;

@end
