/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: OrderDiningSeatEntity.h
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/25 18:00
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CTCMealOrderDetailsEntity.h" // 餐中订单详情

/**
 *  订单餐桌信息
 */
@interface OrderDiningSeatEntity : NSObject

/// 订单id
@property (nonatomic, copy) NSString *order_id;

/// 桌号
@property (nonatomic, copy) NSString *seat_number;

/// 订单类型。1预定；2即时；3餐厅订单
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *type_desc;

/// 订单状态
@property (nonatomic, assign) NSInteger status;

/// 订单状态描述
@property (nonatomic, copy) NSString *status_desc;

// 订单结束标志(150)
@property (nonatomic, assign) NSInteger sign_end;

/// 订单结束标志的描述
@property (nonatomic, copy) NSString *sign_end_desc;

/// 金额
@property (nonatomic, assign) CGFloat total_amount;

/// 人数
@property (nonatomic, assign) NSInteger eater_count;

@property (nonatomic, strong) CTCMealOrderDetailsEntity *orderDetailEntity;

@end

















