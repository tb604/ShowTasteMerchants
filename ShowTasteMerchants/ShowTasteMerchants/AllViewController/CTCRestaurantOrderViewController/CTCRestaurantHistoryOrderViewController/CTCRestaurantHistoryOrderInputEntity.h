/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCRestaurantHistoryOrderInputEntity.h
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/26 09:39
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import <Foundation/Foundation.h>

/// 历史订单的传入参数
@interface CTCRestaurantHistoryOrderInputEntity : NSObject

/// 餐厅id(Y)
@property (nonatomic, assign) NSInteger shop_id;

/// 桌号(N)
@property (nonatomic, copy) NSString *seat_number;

/// 日期(N)
@property (nonatomic, copy) NSString *date;

/// 页码(Y)
@property (nonatomic, assign) NSInteger pageIndex;

/// 一页的条数(Y)
@property (nonatomic, assign) NSInteger pageSize;

@end















