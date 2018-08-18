/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCRestaurantDishUpDownFoodEntity.h
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/26 10:15
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import <Foundation/Foundation.h>

/// 上菜/取消上菜传入参数
@interface CTCRestaurantDishUpDownFoodEntity : NSObject

/// 订单明细编号
@property (nonatomic, assign) NSInteger id;

/// 订单编号
@property (nonatomic, copy) NSString *order_id;

/// 餐厅编号
@property (nonatomic, assign) NSInteger shop_id;

/// 上菜/退菜 1上菜；2取消上菜
@property (nonatomic, assign) NSInteger dish_type;

@end



















