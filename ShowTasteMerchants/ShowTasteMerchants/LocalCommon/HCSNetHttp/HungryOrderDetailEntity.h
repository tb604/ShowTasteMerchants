//
//  HungryOrderDetailEntity.h
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/16.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HungryOrderDetailCategoryEntity.h"

/**
 *  饿了吗订单详情
 */
@interface HungryOrderDetailEntity : NSObject

/// 顾客送餐地址
@property (nonatomic, copy) NSString *address;
@property (nonatomic, assign) float addressHeight;

/// 订单收货人(收货人名称)
@property (nonatomic, copy) NSString *consignee;

/// 下单时间
@property (nonatomic, copy) NSString *created_at;

/// 订单生效时间(即支付时间)
@property (nonatomic, copy) NSString *active_at;

/// 配送费
@property (nonatomic, assign) float deliver_fee;

/// 送餐时间(期望送达时间)
@property (nonatomic, copy) NSString *deliver_time;

/// 订单备注(description)
@property (nonatomic, copy) NSString *desc;

/// 订单详细类目列表
@property (nonatomic, strong) HungryOrderDetailCategoryEntity *detail;

/// 发票抬头
@property (nonatomic, copy) NSString *invoice;

/// 是否预订单
@property (nonatomic, assign) BOOL is_book;

/// 是否在线支付
@property (nonatomic, assign) BOOL is_online_paid;

/// 订单id
@property (nonatomic, assign) NSInteger order_id;

/// 顾客联系电话 ["15216709049"]
@property (nonatomic, strong) NSArray *phone_list;

/// 商户餐厅 ID
@property (nonatomic, copy) NSString *tp_restaurant_id;

/// 餐厅id，接口调用时，使用的ID
@property (nonatomic, assign) NSInteger restaurant_id;

/// 餐厅名称
@property (nonatomic, copy) NSString *restaurant_name;

/// 餐厅当日订单序号
@property (nonatomic, assign) NSInteger restaurant_number;

/// 饿了么内部餐厅id，提交给业务人员绑定时，使用的ID
@property (nonatomic, assign) NSInteger inner_id;

/**
 *  订单状态
 *  -1	STATUS_CODE_INVALID（订单已取消）
 *  0	STATUS_CODE_UNPROCESSED（订单未处理）
 *  1	STATUS_CODE_PROCESSING（订单等待餐厅确认）
 *  2	STATUS_CODE_PROCESSED_AND_VALID（订单已处理）
 *  9	订单已完成
 *  订单状态说明
 *  STATUS_CODE_PENDING是逻辑状态，可以忽略
 *  STATUS_CODE_USER_CONFIRMED只是用户手动确认收到订单，非手动确认的订单状态一直是会STATUS_CODE_PROCESSED_AND_VALID
 *  STATUS_CODE_INVALID可以是用户、商家、客服或者风控取消
 */
@property (nonatomic, assign) NSInteger status_code;

/** 退单状态
 *
 *  0	REFUND_STATUS_NO_REFUND (未申请退单)
 *  2	REFUND_STATUS_LATER_REFUND_REQUEST (用户申请退单)
 *  3	REFUND_STATUS_LATER_REFUND_RESPONSE（餐厅不同意退单）
 *  4	REFUND_STATUS_LATER_REFUND_ARBITRATING (退单仲裁中)
 *  5	REFUND_STATUS_LATER_REFUND_FAIL (退单失败)
 *  6	REFUND_STATUS_LATER_REFUND_SUCCESS (退单成功)
 */
@property (nonatomic, assign) NSInteger refund_code;

/// 订单总价(单位：元)
@property (nonatomic, assign) float total_price;

/// 原始价格(优惠前的价格，即菜价加上配送费和打包费，单位：元)
@property (nonatomic, assign) float original_price;

/// 用户Id
@property (nonatomic, assign) NSInteger user_id;

/// 用户名称
@property (nonatomic, copy) NSString *user_name;

/// 订单收货地址经纬度，例如：31.2538,121.4185
@property (nonatomic, copy) NSString *delivery_geo;


/// 配送状态（仅用于第三方配送）
@property (nonatomic, assign) int deliver_status;

/// 配送子状态（仅用于第三方配送）
@property (nonatomic, assign) int deliver_sub_status;

/// 顾客送餐详情地址，例如：近铁城市广场（普陀区金沙江路1518弄)
@property (nonatomic, copy) NSString *delivery_poi_address;

/// 是否需要发票，0-不需要，1-需要
@property (nonatomic, assign) int invoiced;

/// 店铺实收
@property (nonatomic, assign) float income;

/// 饿了么服务费率
@property (nonatomic, assign) float service_rate;

/// 饿了么服务费
@property (nonatomic, assign) float service_fee;

/// 订单中红包金额
@property (nonatomic, assign) float hongbao;

/// 餐盒费
@property (nonatomic, assign) float package_fee;

/// 订单活动总额
@property (nonatomic, assign) float activity_total;

/// 店铺承担活动费用
@property (nonatomic, assign) float restaurant_part;

/// 饿了么承担活动费用
@property (nonatomic, assign) float eleme_part;

/// 订单取消原因类型
@property (nonatomic, assign) int invalid_type;


#pragma mark 美团
/// 城市id(美团)
@property (nonatomic, assign) NSInteger cityId;

/// 是否第三方配送。0否；1是。(美团)
@property (nonatomic, assign) int isThirdShipping;

/// 配送完成时间(单位秒)--美团
@property (nonatomic, assign) NSInteger logisticsCancelTime;

/// 配送类型码--美团
@property (nonatomic, copy) NSString *logisticsCode;

/// 配送单确认时间，骑手接单时间(单位秒)----美团
@property (nonatomic, assign) NSInteger logisticsConfirmTime;

/// 订单展示id(指的是C端用户在外卖App上看道德订单号)--美团
@property (nonatomic, assign) NSInteger orderIdView;

/// 骑手电话（以这个为准）--美团
@property (nonatomic, copy) NSString *shipperPhone;

/// 骑手姓名--美团
@property (nonatomic, copy) NSString *logisticsDispatcherName;

/// 骑手取单时间(单位：秒)--美团
@property (nonatomic, assign) NSInteger logisticsFetchTime;

/// 配送方id--美团
@property (nonatomic, assign) int logisticsId;

/// 配送方名称--美团
@property (nonatomic, copy) NSString *logisticsName;

/// 配送单下单时间(单位：秒)--美团
@property (nonatomic, assign) NSInteger logisticsSendTime;

/// 订单完成时间(单位：秒)--美团
@property (nonatomic, assign) NSInteger orderCompletedTime;

/// 商户确认时间(单位：秒)--美团
@property (nonatomic, assign) NSInteger orderConfirmTime;

/// 订单取消时间(单位：秒)--美团
@property (nonatomic, assign) NSInteger orderCancelTime;

/// 门店服务电话--美团
@property (nonatomic, copy) NSString *poiPhone;

/// 门店地址--美团
@property (nonatomic, copy) NSString *poiAddress;

/// 就餐人数(商家可以根据就餐人数提供餐具)--美团
@property (nonatomic, assign) int dinnersNumber;


#pragma mark -
#pragma mark 开发者自己加的，用来其它用
/// 是否展开；YES表示展开；NO表示收取
@property (nonatomic, assign) BOOL isCharge;

/// 1为饿了么，2为美团，3为百度外卖
@property (nonatomic, assign) NSInteger provider;

/// 自己定义的订单状态
@property (nonatomic, assign) NSInteger cs_status_code;

@end





