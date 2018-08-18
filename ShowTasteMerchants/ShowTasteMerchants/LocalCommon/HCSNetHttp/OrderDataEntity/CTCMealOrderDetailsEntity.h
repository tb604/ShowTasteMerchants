/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCMealOrderDetailsEntity.h
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/26 22:40
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CTCMealOrderFoodEntity.h"

/// 餐中订单明细
@interface CTCMealOrderDetailsEntity : NSObject

/// 订单id
@property (nonatomic, copy) NSString *order_id;

/// 餐厅id
@property (nonatomic, assign) NSInteger shop_id;

/// 餐厅名称
@property (nonatomic, copy) NSString *shop_name;

/// 餐厅地址
@property (nonatomic, copy) NSString *shop_address;

/// 餐厅电话号码
@property (nonatomic, copy) NSString *shop_tel;

/**
 *  1预订订单 2即时订单 3餐厅订单
 */
@property (nonatomic, assign) NSInteger type;

/**
 *  订单类型名称
 */
@property (nonatomic, copy) NSString *type_desc;

/**
 *  座位 座位位置 0  大厅 1 包间 2 走廊 --已经改为从服务器读取
 */
@property (nonatomic, assign) NSInteger seat_type;
/**
 *  座位名称
 */
@property (nonatomic, copy) NSString *seat_type_desc;

/// 就餐人数
@property (nonatomic, assign) NSInteger eater_count;


/**
 *  桌号，餐桌编号
 */
@property (nonatomic, copy) NSString *seat_number;

/**
 *  【 订单状态 1 待商家确认；2 商家已确认(已接单)；3 待支付订金； 4 已完成预订；101 待下单； 102 就餐中； 103 结账中； 104  支付完成； 200 订单已完成； 300 订单已取消； 400 商家已拒绝   】
 */
@property (nonatomic, assign) NSInteger status;

/**
 *  订单状态备注
 */
@property (nonatomic, copy) NSString *status_desc;

/**
 *  订单结束标志(150)
 */
@property (nonatomic, assign) NSInteger sign_end;

/**
 *  订单结束标志的描述
 */
@property (nonatomic, copy) NSString *sign_end_desc;

/// 应付金额
@property (nonatomic, assign) CGFloat yf_amount;

/// 实付金额
@property (nonatomic, assign) CGFloat sf_amount;

/// 修改实付金额的备注
@property (nonatomic, copy) NSString *waiter_amt_note;

/// 菜品总数量
@property (nonatomic, assign) CGFloat total_count;

/// 菜品数组
@property (nonatomic, strong) NSMutableArray *foods;

@end





/*
 {
 "order_id": "2016102599489710",
 "type": 3,
 "type_desc": "餐厅",
 "seat_number": "12",
 "status": 400,
 "status_desc": "就餐中",
 "sign_end": 150,
 "sign_end_desc": "异常",
 "yf_amount": "619.00",
 "sf_amount": "465.00",
 "foods": [
 {
 "food_id": 1,
 "food_name": "红烧鲫鱼",
 "mode": "烘焙",
 "taste": "微糖",
 "unit": "份",
 "food_number": "1.00",
 "total": 45,
 "detail_id": 1178,
 "food_price": "50.00",
 "food_activity_price": "45.00",
 "status": 100,
 "status_desc": "已点菜",
 "operate_time": "",
 "food_category_id": 1,
 "details": []
 },
 {
 "food_id": 3,
 "food_name": "和蓝",
 "mode": "爆炒",
 "taste": "微辣",
 "unit": "份",
 "food_number": "1.00",
 "total": 20,
 "detail_id": 1179,
 "food_price": "25.00",
 "food_activity_price": "20.00",
 "status": 100,
 "status_desc": "已点菜",
 "operate_time": "",
 "food_category_id": 3,
 "details": []
 },
 {
 "food_id": 35,
 "food_name": "羊腿",
 "mode": "清蒸",
 "taste": "麻辣",
 "unit": "份",
 "food_number": "6.00",
 "total": 300,
 "detail_id": 0,
 "food_price": 0,
 "food_activity_price": 0,
 "status": 0,
 "status_desc": "",
 "operate_time": "",
 "food_category_id": 0,
 "details": [
 {
 "detail_id": 1190,
 "operate_time": "",
 "food_number": "4.00",
 "food_price": "68.00",
 "food_activity_price": "50.00",
 "food_category_id": 3,
 "status": 300,
 "status_desc": "已上桌",
 "total": 200
 },
 {
 "detail_id": 1191,
 "operate_time": "",
 "food_number": "2.00",
 "food_price": "68.00",
 "food_activity_price": "50.00",
 "food_category_id": 3,
 "status": 100,
 "status_desc": "已点菜",
 "total": 100
 }
 ]
 },
 {
 "food_id": 35,
 "food_name": "羊腿",
 "mode": "爆炒",
 "taste": "麻辣",
 "unit": "份",
 "food_number": "2.00",
 "total": 100,
 "detail_id": 1189,
 "food_price": "68.00",
 "food_activity_price": "50.00",
 "status": 300,
 "status_desc": "已上桌",
 "operate_time": "",
 "food_category_id": 3,
 "details": []
 }
 ]
 }
 */









