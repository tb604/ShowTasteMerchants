/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCOrderDetailEntity.h
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/26 11:08
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CommentDetailEntity.h"

/// 订单详情
@interface CTCOrderDetailEntity : NSObject

/// 订单id
@property (nonatomic, copy) NSString *order_id;

/// 用户id
@property (nonatomic, assign) NSInteger user_id;

/// 用户名
@property (nonatomic, copy) NSString *name;

/// 手机号码
@property (nonatomic, copy) NSString *mobile;

/// 用户头像
@property (nonatomic, copy) NSString *avatar;

/// 餐厅id
@property (nonatomic, assign) NSInteger shop_id;

/// 餐厅名称
@property (nonatomic, copy) NSString *shop_name;

/// 餐厅电话
@property (nonatomic, copy) NSString *shop_tel;

/// 餐厅地址
@property (nonatomic, copy) NSString *address;

/// 用餐人数
@property (nonatomic, assign) NSInteger number;

/// 座位 座位位置 0  大厅 1 包间 2 走廊 --已经改为从服务器读取
@property (nonatomic, assign) NSInteger seat_type;

/// 座位描述
@property (nonatomic, copy) NSString *seat_type_desc;

/**
 *  1预订订单 2即时订单 3餐厅订单
 */
@property (nonatomic, assign) NSInteger type;

/**
 *  订单类型名称
 */
@property (nonatomic, copy) NSString *type_name;

/**
 *  【 订单状态 1 待商家确认；2 商家已确认(已接单)；3 待支付订金； 4 已完成预订；101 待下单； 102 就餐中； 103 结账中； 104  支付完成； 200 订单已完成； 300 订单已取消； 400 商家已拒绝   】
 */
@property (nonatomic, assign) NSInteger status;

/**
 *  订单状态备注
 */
@property (nonatomic, copy) NSString *status_desc;

/**
 *  桌号，餐桌编号
 */
@property (nonatomic, copy) NSString *seat_number;

/**
 *  备注
 */
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, assign) CGFloat remarkHeight;

/**
 *  订金支付渠道
 */
@property (nonatomic, assign) NSInteger deposit_channel;
/**
 *  说明
 */
@property (nonatomic, copy) NSString *deposit_channel_desc;

/**
 *  订单支付渠道  0 支付宝 1 微信支付 100 线下支付
 */
@property (nonatomic, assign) NSInteger pay_channel;
@property (nonatomic, copy) NSString *pay_channel_desc;

/**
 *  线下支付渠道
 */
@property (nonatomic, assign) NSInteger pay_way;

///  线下支付渠道说明
@property (nonatomic, copy) NSString *pay_way_desc;

/**
 *  退款金额
 */
@property (nonatomic, assign) CGFloat refund_amount;

/**
 *  是否评论 0 未评论 1 已评论
 */
@property (nonatomic, assign) NSInteger comment_status;

/**
 *  评论状态描述
 */
@property (nonatomic, copy) NSString *comment_status_desc;

/**
 *  评论详情
 */
@property (nonatomic, strong) CommentDetailEntity *comment;

/**
 *  就餐时间(预订时间)--到店时间
 */
@property (nonatomic, copy) NSString *dining_date;

/**
 *  创建订单时间(订单生成时间)
 */
@property (nonatomic, copy) NSString *create_date;

/// 支付日期
@property (nonatomic, copy) NSString *pay_date;

/**
 *  总金额
 */
@property (nonatomic, assign) CGFloat total_price;

/**
 *  活动价总额
 */
@property (nonatomic, assign) CGFloat total_act_price;

/**
 *  预付订金
 */
@property (nonatomic, assign) CGFloat book_deposit_amount;

/**
 *  应付金额
 */
@property (nonatomic, assign) CGFloat pay_amount;

/**
 *  实付金额
 */
@property (nonatomic, assign) CGFloat pay_actually;

/**
 *  服务员修改金额的备注
 */
@property (nonatomic, copy) NSString *pay_modify_note;

/**
 *  订单结束标志(150)
 */
@property (nonatomic, assign) NSInteger sign_end;

/**
 *  订单结束标志的描述
 */
@property (nonatomic, copy) NSString *sign_end_desc;


/**
 *  菜品总的描述“热菜8道 / 冷菜10份”
 */
@property (nonatomic, copy) NSString *foodTotalDesc;

@property (nonatomic, assign) CGFloat foodTotalDescHeight;

@property (nonatomic, assign) NSInteger totalCount;

/**
 *  订单里面的菜品列表(OrderFoodInfoEntity)
 */
@property (nonatomic, strong) NSArray *details;

/**
 *  处理后的，用来在订单详情显示的
 */
@property (nonatomic, strong) NSMutableArray *detailFoods;

/**
 *  新增的菜品列表
 */
@property (nonatomic, strong) NSMutableArray *nowAddFoodList;

/**
 *  旧的菜品列表
 */
@property (nonatomic, strong) NSMutableArray *oldAddFoodList;

@end



/*
 {
 "details": [
 {
 "detail_id": 1180,
 "order_id": "2016102599535699",
 "food_id": 1,
 "food_name": "红烧鲫鱼",
 "category_id": 1,
 "category_name": "掌柜推荐",
 "mode": "烘焙",
 "taste": "微糖",
 "unit": "份",
 "number": 3,
 "price": 50,
 "activity_price": 45,
 "status": 100,
 "status_desc": "已点菜",
 "type": 1,
 "type_desc": "首点",
 "op_datetime": ""
 },
 {
 "detail_id": 1181,
 "order_id": "2016102599535699",
 "food_id": 3,
 "food_name": "和蓝",
 "category_id": 3,
 "category_name": "热菜",
 "mode": "爆炒",
 "taste": "微辣",
 "unit": "份",
 "number": 1,
 "price": 25,
 "activity_price": 20,
 "status": 100,
 "status_desc": "已点菜",
 "type": 1,
 "type_desc": "首点",
 "op_datetime": ""
 },
 {
 "detail_id": 1182,
 "order_id": "2016102599535699",
 "food_id": 1,
 "food_name": "红烧鲫鱼",
 "category_id": 13,
 "category_name": "掌柜推荐",
 "mode": "hello",
 "taste": "麻辣",
 "unit": "份",
 "number": 2,
 "price": 50,
 "activity_price": 45,
 "status": 100,
 "status_desc": "已点菜",
 "type": 1,
 "type_desc": "首点",
 "op_datetime": ""
 }
 ]
 }
 */









