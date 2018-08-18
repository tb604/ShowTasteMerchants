/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCRestaurantReserveOrderViewController.h
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/17 15:53
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "TYZRefreshTableViewController.h"

/**
 *  预定订单视图控制器
 */
@interface CTCRestaurantReserveOrderViewController : TYZRefreshTableViewController

// 1表示点击通知后，进入餐前订单；2表示预定订单
@property (nonatomic, assign) int type;

@end
