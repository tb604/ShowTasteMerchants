//
//  OrderDataEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/19.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CommentDetailEntity.h" // 评论详情

@interface OrderDataEntity : NSObject

/**
 * 订单订单编号
 */
@property (nonatomic, copy) NSString *order_id;

/**
 *  用户编号
 */
@property (nonatomic, assign) NSInteger user_id;

/**
 *  用户名称
 */
@property (nonatomic, copy) NSString *name;

/**
 *  客户名称(相对餐厅端来说的)
 */
@property (nonatomic, copy) NSString *customer_name;

/**
 *  用户昵称
 */
@property (nonatomic, copy) NSString *nikename;

/**
 *  用户手机号码
 */
@property (nonatomic, copy) NSString *mobile;

/**
 *  食客头像url
 */
@property (nonatomic, copy) NSString *avatar;

/**
 *  商家手机号码
 */
@property (nonatomic, copy) NSString *shop_tel;

/**
 *  商家id
 */
@property (nonatomic, assign) NSInteger shop_id;

/**
 *  餐厅名称
 */
@property (nonatomic, copy) NSString *shop_name;

/**
 *  餐厅地址
 */
@property (nonatomic, copy) NSString *address;

/**
 *  用餐人数
 */
@property (nonatomic, assign) NSInteger number;

/**
 *  座位 座位位置 0  大厅 1 包间 2 走廊 --已经改为从服务器读取
 */
@property (nonatomic, copy) NSString *seat_type;
/**
 *  座位位置名称
 */
@property (nonatomic, copy) NSString *seat_type_name;

/**
 *  1预订订单 2即时订单 3餐厅订单
 */
@property (nonatomic, assign) NSInteger type;
/**
 *  订单类型名称
 */
@property (nonatomic, copy) NSString *type_name;

//@property (nonatomic, copy) NSString *type_desc;

/**
 *  【 订单状态 1 待商家确认；2 商家已确认(已接单)；3 待支付订金； 4 已完成预订；101 待下单； 102 就餐中； 103 结账中； 104  支付完成； 200 订单已完成； 300 订单已取消； 400 商家已拒绝   】
 */
@property (nonatomic, assign) NSInteger status;

/**
 *  订单状态备注
 */
@property (nonatomic, copy) NSString *status_remark;

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
 *  线下支付渠道
 */
@property (nonatomic, assign) NSInteger pay_way;

///  线下支付渠道说明
@property (nonatomic, copy) NSString *pay_way_desc;

/**
 * 订单支付状态 0 未支付 1 已支付 2 已退款
 */
@property (nonatomic, assign) NSInteger pay_status;
@property (nonatomic, copy) NSString *pay_status_desc;

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

/// 线下支付渠道
//@property (nonatomic, assign) NSInteger offline_channel;

/// 线下支付渠道说明
//@property (nonatomic, copy) NSString *offline_channel_desc;

/**
 *  退款金额
 */
@property (nonatomic, assign) CGFloat refund_amount;

/**
 *  订单支付时间
 */
@property (nonatomic, copy) NSString *pay_date;

/**
 *  就餐时间(预订时间)--到店时间
 */
@property (nonatomic, copy) NSString *dining_date;

/**
 *  创建订单时间(订单生成时间)
 */
@property (nonatomic, copy) NSString *create_date;

/// 结算金额
@property (nonatomic, assign) CGFloat settle_amount;

/**
 *  结算时间
 */
@property (nonatomic, copy) NSString *settle_date;

/**
 *  总金额
 */
@property (nonatomic, assign) CGFloat total_price;

/**
 *  实付金额
 */
@property (nonatomic, assign) CGFloat pay_actually;

/**
 *  活动价总额
 */
@property (nonatomic, assign) CGFloat total_act_price;

/**
 *  预订订金支付状态 0 未支付 1 已支付 2 已退款
 */
@property (nonatomic, assign) NSInteger book_deposit_status;

/**
 *  预订订金支付状态 描述
 */
@property (nonatomic, copy) NSString *book_deposit_status_desc;

/**
 * 预订订金支付支付渠道 0 支付宝 1 微信支付
 */
@property (nonatomic, assign) NSInteger book_deposit_channel;
@property (nonatomic, copy) NSString *book_deposit_channel_desc;


/**
 *  预付订金
 */
@property (nonatomic, assign) CGFloat book_deposit_amount;

/**
 *  订金支付时间
 */
@property (nonatomic, copy) NSString *book_deposit_date;

/**
 *  商家折扣金额
 */
@property (nonatomic, assign) CGFloat shop_discount;

/**
 *  秀味折扣金额
 */
@property (nonatomic, assign) CGFloat xiuwei_discount;

/**
 *  应付金额
 */
@property (nonatomic, assign) CGFloat pay_amount;

/**
 *  服务员修改金额的备注
 */
@property (nonatomic, copy) NSString *pay_modify_note;

/**
 *  总的菜品数量
 */
@property (nonatomic, assign) NSInteger totalCount;

/**
 *  菜品总的描述“热菜8道 / 冷菜10份”
 */
@property (nonatomic, copy) NSString *foodTotalDesc;

@property (nonatomic, assign) CGFloat foodTotalDescHeight;

/**
 *
 */
@property (nonatomic, copy) NSString *feedback;

/**
 *  取消理由
 */
@property (nonatomic, copy) NSString *cancel_reason;

/**
 *  订单结束标志(150)
 */
@property (nonatomic, assign) NSInteger sign_end;

/**
 *  订单结束标志的描述
 */
@property (nonatomic, copy) NSString *sign_end_desc;

/// 0服务员；1用户；2官方平台工作人员
@property (nonatomic, assign) NSInteger source_user_type;

/// 描述
@property (nonatomic, copy) NSString *source_user_type_desc;

@property (nonatomic, copy) NSString *statics_date;



@end

/*
 user_mobile: "",
 total_amount: "75.00"
 */

/*
 "source_user_type": 1,
 "source_user_type_desc": "用户",
 "eater_count": 100,
 "statics_date": "2016/10/25",
 */

























