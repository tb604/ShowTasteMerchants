//
//  HungryBaseInfoObject.h
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/17.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotifyBodyEntity.h"
#import "HungryOrderBodyEntity.h"

/**
 * 订单来源 1为饿了么，2为美团，3为百度外卖
 */
typedef NS_ENUM(NSInteger, EN_ORDER_SOURCE_TYPE)
{
    EN_ORDER_SOURCE_ELE = 1,    ///< 饿了么
    EN_ORDER_SOURCE_MEITUAN,    ///< 美团
    EN_ORDER_SOURCE_BAIDU,      ///< 百度外卖
};


/**
 *  自己定义的订单状态
 */
//@[@"待接单", @"已接单", @"配送未接单", @"取货中", @"配送结果", @"异常订单"];
typedef NS_ENUM(NSInteger, EN_TM_ORDER_STATE)
{
    EN_TM_ORDER_WAIT_ORDER = 0,     ///< 待接单--用户支付了费用或者到货付款(STATUS_CODE_UNPROCESSED-订单未处理)
    EN_TM_ORDER_RECEIVE_ORDER,      ///< 商家已接单--已接单，但未呼叫配送的订单(STATUS_CODE_PROCESSED_AND_VALID[订单已处理] && DELIVER_BE_ASSIGNED_MERCHANT[待分配])
    EN_TM_ORDER_SHIP_NOT_ORDER,     ///< 配送未接单--已经发布给配送方，配送方还没有配送员接单的订单(STATUS_CODE_PROCESSED_AND_VALID[订单已处理] && DELIVER_BE_ASSIGNED_COURIER[待分配])
    EN_TM_ORDER_PICKUP_ORDER,       ///< 取货中--已有配送员，正在取货途中的订单(STATUS_CODE_PROCESSED_AND_VALID[订单已处理] && DELIVER_BE_FETCHED[待取餐])
    EN_TM_ORDER_DIST_RESULT_ORDER,  ///< 配送结果 【(STATUS_CODE_PROCESSED_AND_VALID[订单已处理] && DELIVER_DELIVERING[配送中]) ||(STATUS_CODE_PROCESSED_AND_VALID[订单已处理] && DELIVER_COMPLETED[配送成功]) || STATUS_CODE_FINISHED[订单完成]】
    EN_TM_ORDER_EXCEPTION_ORDER,    ///< 异常订单  【STATUS_CODE_INVALID[订单已取消] || refund_code(退单)】
};
// Shipping order not

/// 美团订单状态
typedef NS_ENUM(NSInteger, EN_MEITUAN_ORDER_STATE)
{
    STATUS_CODE_MT_UNPROCESSED = 1,         ///< 用户已提交订单
    STATUS_CODE_MT_PUSH = 2,                ///< 可推送到App方平台也可推送到商家
    STATUS_CODE_MT_MERCHANT_RECEIVE = 3,    ///< 商家已收到
    STATUS_CODE_MT_MERCHANT_CONFIRM = 4,    ///< 商家已确认
    STATUS_CODE_MT_DELIVER = 6,             ///< 已配送
    STATUS_CODE_MT_FINISHED = 8,            ///< 已完成
    STATUS_CODE_MT_CANCELED = 9,            ///< 已取消
};

/**
 饿了么的订单状态说明
 STATUS_CODE_PENDING是逻辑状态，可以忽略
 STATUS_CODE_USER_CONFIRMED只是用户手动确认收到订单，非手动确认的订单状态一直是会STATUS_CODE_PROCESSED_AND_VALID
 STATUS_CODE_INVALID可以是用户、商家、客服或者风控取消
 */
typedef NS_ENUM(NSInteger, EN_ELE_ORDER_STATE)
{
    ELEME_ORDER_NEW = 2000,                 ///< 新的
    
    STATUS_CODE_INVALID = -1,               ///< 订单已取消(可以是用户、商家、客服或者风控取消)
    ELEME_ORDER_INVALID = 2001,             ///< 订单已取消 自定义
    
    STATUS_CODE_UNPROCESSED = 0,            ///< 订单未处理
    ELEME_ORDER_UNPROCESSED = 2002,         ///< 订单未处理 自定义
    
    STATUS_CODE_PROCESSING = 1,             ///< 订单等待餐厅确认
    ELEME_ORDER_PROCESSING = 2003,          ///< 订单等待餐厅确认 自定义
    
    STATUS_CODE_PROCESSED_AND_VALID = 2,    ///< 订单已处理
    ELEME_ORDER_PROCESSED_AND_VALID = 2004, ///< 订单已处理 自定义
    
    STATUS_CODE_FINISHED = 9,               ///< 订单已完成
    ELEME_ORDER_SUCCESS = 2999,             ///< 订单已完成 自定义
};

/**
 * 退单订单状态
 */
typedef NS_ENUM(NSInteger, EN_ELE_REFUND_ORDER_STATE)
{
    REFUND_STATUS_NO_REFUND = 0,                ///< (未申请退单)
    REFUND_STATUS_LATER_REFUND_REQUEST = 2,     ///< (用户申请退单)
    REFUND_STATUS_LATER_REFUND_RESPONSE = 3,    ///<（餐厅不同意退单）
    REFUND_STATUS_LATER_REFUND_ARBITRATING = 4, ///< (退单仲裁中)
    REFUND_STATUS_LATER_REFUND_FAIL = 5,        ///< (退单失败)
    REFUND_STATUS_LATER_REFUND_SUCCESS = 6,     ///< (退单成功)
};
/**
*   订单取消原因类型
 */
typedef NS_ENUM(NSInteger, EN_ELE_CANCEL_ORDER_REASON_STATE)
{
    TYPE_OTHERS = 0,                        ///<（其它原因）
    TYPE_FAKE_ORDER,                        ///<（假订单）
    TYPE_DUPLICATE_ORDER,                   ///<（重复订单）
    TYPE_FAIL_CONTACT_RESTAURANT,           ///<（联系不上餐厅）
    TYPE_FAIL_CONTACT_USER,                 ///<（联系不上用户）
    TYPE_FOOD_SOLDOUT,                      ///<（食物已售完）
    TYPE_RESTAURANT_CLOSED,                 ///<（餐厅已打烊）
    TYPE_TOO_FAR,                           ///<（超出配送范围）
    TYPE_RST_TOO_BUSY,                      ///<（餐厅太忙）
    TYPE_FORCE_REJECT_ORDER,                ///<(用户无理由退单）
    TYPE_DELIVERY_CHECK_FOOD_UNQUALIFIED,   ///<（配送方检测餐品不合格）
    TYPE_DELIVERY_FAULT,                    ///<（由于配送过程问题,用户退单）
    TYPE_REPLACE_ORDER,                     ///<（订单被替换）
    TYPE_USR_CANCEL_ORDER,                  ///<（用户取消订单）
    TYPE_SYSTEM_AUTO_CANCEL,                ///<（餐厅长时间未接单，订单自动取消）
};

// 美团订单取消原因code(reasonCode) 美团发送取消消息中得值
typedef NS_ENUM(NSInteger, EN_MT_CANCEL_ORDER_REASON_STATE)
{
    TYPE_MT_SYSTEM_AUTO_CANCEL = 1001, ///< 系统取消，超时未确认
    TYPE_MT_SYSTEM_AUTO_CANCEL_UNPAY = 1002 , ///< 系统取消，在线支付订单30分钟未支付
    TYPE_MT_USER_CANCEL_ONLINE_PAY = 1101, ///< 用户取消，在线支付中取消
    TYPE_MT_USER_CANCEL_MERCHANT_CONFIRM_BEFORE = 1102, ///< 用户取消，商家确认前取消
    TYPE_MT_USER_CANCEL_REFUND = 1103, ///< 用户取消，用户退款取消
    TYPE_MT_CS_CANCEL_PLACE_ERROR_ORDER = 1201, ///< 客服取消，用户下错单
    TYPE_MT_CS_CANCEL_USER_TEST = 1202, ///< 客服取消，用户测试
    TYPE_MT_CS_CANCEL_REPEAT_ORDER = 1203, ///< 客服取消，重复订单
    TYPE_MT_CS_CANCEL_OTHER = 1204, ///< 客服取消，其他原因
    TYPE_MT_CANCEL_OTHER = 1301, ///< 其他原因
};

/// 商家取消订单时填写的值
typedef NS_ENUM(NSInteger, EN_MT_MERCHANT_CANCEL_ORDER_STATE)
{
    EN_MT_MERCHANT_CANCEL_ORDER_TIMEROUT = 2001, ///< 商家超时接单【商家取消时填写】
    EN_MT_MERCHANT_CANCEL_CHANGE_ORDER = 2002, ///< 非顾客原因修改订单
    EN_MT_MERCHANT_CANCEL_ORDER = 2003, ///< 非客户原因取消订单
    EN_MT_MERCHANT_CANCEL_DELIVER_DELAY = 2004, ///< 配送延迟
    EN_MT_MERCHANT_CANCEL_CUST_COMPLAINT = 2005, ///< 售后投诉
    EN_MT_MERCHANT_CANCEL_USER_REQ = 2006, ///< 用户要求取消
    EN_MT_MERCHANT_CANCEL_OTHER = 2007, ///< 其他原因（未传code，默认为此）
};


/*
  饿了么订单配送状态
// 1：DELIVERY_STATUS_TO_BE_ASSIGNED_MERCHANT 待分配（物流系统已生成运单，待分配配送商）
CONST DELIVERY_STATUS_TO_BE_ASSIGNED_MERCHANT = 2200;

// 2：DELIVERY_STATUS_TO_BE_ASSIGNED_COURIER 待分配（配送系统已接单，待分配配送员）
CONST DELIVERY_STATUS_TO_BE_ASSIGNED_COURIER = 2201;

// 3：DELIVERY_STATUS_TO_BE_FETCHED 待取餐（已分配给配送员，配送员未取餐）
CONST DELIVERY_STATUS_TO_BE_FETCHED = 2202;

// 4：DELIVERY_STATUS_DELIVERING 配送中（配送员已取餐，正在配送）
CONST DELIVERY_STATUS_DELIVERING = 2203;

// 5：DELIVERY_STATUS_COMPLETED 配送成功（配送员配送完成）
CONST DELIVERY_STATUS_COMPLETED = 2204;

// 6：DELIVERY_STATUS_CANCELLED 配送取消（商家可以重新发起配送）
CONST DELIVERY_STATUS_CANCELLED = 2205;

// 7：DELIVERY_STATUS_EXCEPTION 配送异常
CONST DELIVERY_STATUS_EXCEPTION = 2206;
*/

/**
 *配送状态 deliver(饿了么)
 */
typedef NS_ENUM(NSInteger, EN_ELE_DELIVER_ORDER_STATE)
{
    DELIVER_BE_ASSIGNED_MERCHANT = 1,   ///< 待分配（物流系统已生成运单，待分配配送商）
    DELIVERY_STATUS_TO_BE_ASSIGNED_MERCHANT = 2200, ///< 待分配 自己定义
    
    DELIVER_BE_ASSIGNED_COURIER = 2,    ///< 待分配（配送系统已接单，待分配配送员）
    DELIVERY_STATUS_TO_BE_ASSIGNED_COURIER = 2201, ///< 待分配 自己定义
    
    DELIVER_BE_FETCHED = 3,             ///< 待取餐（已分配给配送员，配送员未取餐）
    DELIVERY_STATUS_TO_BE_FETCHED = 2202, ///< 待取餐 自定义
    
    DELIVER_DELIVERING = 4,             ///< 配送中（配送员已取餐，正在配送）
    DELIVERY_STATUS_DELIVERING = 2203, ///< 配送中 自定义
    
    DELIVER_COMPLETED = 5,              ///< 配送成功（配送员配送完成）
    DELIVERY_STATUS_COMPLETED = 2204, ///< 配送成功 自定义
    
    DELIVER_CANCELLED = 6,              ///< 配送取消（商家可以重新发起配送）
    DELIVERY_STATUS_CANCELLED = 2205,  ///< 配送取消 自定义
    
    DELIVER_EXCEPTION = 7,              ///< 配送异常
    DELIVERY_STATUS_EXCEPTION = 2206, ///< 配送异常 自定义
};



/*
 // 1：MERCHANT_REASON 商家取消
 CONST DELIVERY_SUB_STATUS_MERCHANT_REASON = 2210;
 
 // 2：CARRIER_REASON 配送商取消
 CONST DELIVERY_SUB_STATUS_CARRIER_REASON = 2211;
 
 // 3：USER_REASON 用户取消
 CONST DELIVERY_SUB_STATUS_USER_REASON = 2212;
 
 // 4：SYSTEM_REASON 物流系统取消
 CONST DELIVERY_SUB_STATUS_SYSTEM_REASON = 2213;
 
 // 5：MERCHANT_CALL_LATE_ERROR 呼叫配送晚
 CONST DELIVERY_SUB_STATUS_MERCHANT_CALL_LATE_ERROR = 2214;
 
 // 6：MERCHANT_FOOD_ERROR 餐厅出餐问题
 CONST DELIVERY_SUB_STATUS_MERCHANT_FOOD_ERROR = 2215;
 
 
 */

/**
 *   配送子状态(当配送状态为CANCELLED或者EXCEPTION使用)
 */
typedef NS_ENUM(NSInteger, EN_ELE_SUB_DELIVER_ORDER_STATE)
{
    MERCHANT_REASON = 1,                ///< 商家取消
    DELIVERY_SUB_STATUS_MERCHANT_REASON = 2210, ///< 商家取消 自定义
    
    CARRIER_REASON = 2,                     ///< 配送商取消
    DELIVERY_SUB_STATUS_CARRIER_REASON = 2211, ///< 配送商取消 自定义
    
    USER_REASON = 3,                        ///< 用户取消
    DELIVERY_SUB_STATUS_USER_REASON = 2212, ///< 用户取消 自定义
    
    SYSTEM_REASON = 4,                      ///< 物流系统取消
    DELIVERY_SUB_STATUS_SYSTEM_REASON = 2213, ///< 物流系统取消 自定义
    
    MERCHANT_CALL_LATE_ERROR = 5,           ///< 呼叫配送晚
    DELIVERY_SUB_STATUS_MERCHANT_CALL_LATE_ERROR = 2214, ///< 呼叫配送晚 自定义
    
    MERCHANT_FOOD_ERROR = 6,                ///< 餐厅出餐问题
    DELIVERY_SUB_STATUS_MERCHANT_FOOD_ERROR = 2215, ///< 餐厅出餐问题 自定义
    
    MERCHANT_INTERRUPT_DELIVERY_ERROR = 7,  ///< 商户中断配送
    DELIVERY_SUB_STATUS_MERCHANT_INTERRUPT_DELIVERY_ERROR = 2216, ///< 商户中断配送 自定义
    
    USER_NOT_ANSWER_ERROR = 8,              ///< 用户不接电话
    DELIVERY_SUB_STATUS_USER_NOT_ANSWER_ERROR = 2217, ///< 用户不接电话 自定义
    
    USER_RETURN_ORDER_ERROR = 9,            ///< 用户退单
    DELIVERY_SUB_STATUS_USER_RETURN_ORDER_ERROR = 2218, ///< 用户退单 自定义
    
    USER_ADDRESS_ERROR = 10,                 ///< 用户地址错误
    DELIVERY_SUB_STATUS_USER_ADDRESS_ERROR = 2219, ///< 用户地址错误 自定义
    
    DELIVERY_OUT_OF_SERVICE = 11,            ///< 超出服务范围
    DELIVERY_SUB_STATUS_DELIVERY_OUT_OF_SERVICE = 2220, ///< 超出服务范围 自定义
    
    CARRIER_REMARK_EXCEPTION_ERROR = 12,     ///< 骑手标记异常
    DELIVERY_SUB_STATUS_CARRIER_REMARK_EXCEPTION_ERROR = 2221, ///< 骑手标记异常 自定义
    
    SYSTEM_MARKED_ERROR = 13,                ///< 系统自动标记异常–订单超过3小时未送达
    DELIVERY_SUB_STATUS_SYSTEM_MARKED_ERROR = 2222, ///< 系统自动标记异常 自定义
    
    OTHER_ERROR = 14,                        ///< 其他异常
    DELIVERY_SUB_STATUS_OTHER_ERROR = 2223, ///< 其他异常 自定义
};

/// 美团配送状态
typedef NS_ENUM(NSInteger, EN_METU_DELIVER_ORDER_STATE)
{
    DELIVER_MT_BE_ASSIGNED_MERCHANT = 0, ///< 配送单发往配送
    DELIVER_MT_BE_FETCHED = 10,          ///< 配送单已确认(骑手接单)
    DELIVER_MT_DELIVERING = 20,          ///< 骑手已取餐
    DELIVER_MT_COMPLETED = 40,           ///< 骑手已送达
    DELIVER_MT_CANCELLED = 100,          ///< 配送单已取消
};

/*
*   餐厅营业状态
 */
typedef NS_ENUM(NSInteger, EN_ELE_SHOP_BUSINESS_STATE)
{
    BUSY_LEVEL_FREE = 0, ///<（餐厅正常营业）
    BUSY_LEVEL_CLOSED = 2, ///<（餐厅休息中）
    BUSY_LEVEL_NETWORK_UNSTABLE = 3, ///<（餐厅网络不稳定/电话订餐）
    BUSY_LEVEL_HOLIDAY = 4, ///<（餐厅放假中）
};


/// 配送方式(不同的配送方) 传给美团的时候是字符串，要四位数，不够左边补零
typedef NS_ENUM(NSInteger, EN_METU_DELIVER_WAY_STATE)
{
    DELIVER_MT_MERCHANT_AUTO = 0,  ///< 商家自配送(0000)
    DELIVER_MT_MERCHANT_QUHUO = 2, ///< 趣活(0002)
    DELIVER_MT_MERCHANT_DADA = 16, ///< 达达(0016)
    DELIVER_MT_MERCHANT_EDS = 33, ///< E代送(0033)
    DELIVER_MT_MERCHANT_JIAMENG = 1001, ///< 美团专送-加盟(1001)
    DELIVER_MT_MERCHANT_ZIJIAN = 1002, ///< 美团专送-自建(1002)
    DELIVER_MT_MERCHANT_ZHONGBAO = 1003, ///< 美团配送-众包(1003)
    DELIVER_MT_MERCHANT_CITYAGENT = 2004, ///< 美团专送-城市代理(2004)
    DELIVER_MT_MERCHANT_JIAOMA = 2001, ///< 角马(2001)
    DELIVER_MT_MERCHANT_KUAISONG = 2002, ///< 快送(2002)
};


/// 通知(新订单通知)
#define kHUNGRY_NEW_ORDER_NOTE @"HUNGRY_NEW_ORDER_NOTE"


@interface HungryBaseInfoObject : NSObject

+ (HungryBaseInfoObject *)shareInstance;

/**
 *  从融云接收到订单信息
 */
- (void)revcOrderInfo:(HungryOrderBodyEntity *)entity;

/**
 *  通过订单id获取订单详情
 */
- (void)orderIdToOrderDetail;

/**
 *  获取订单详情数组
 *
 *  @param orderType 类型
 */
- (NSArray *)getOrderDetailList:(NSInteger)orderType;




- (void)getWithOrderDetail:(NSInteger)orderId;


@end


/*
 
 
 订单模式
 模式	含义
 1	使用开放平台接单
 2	使用饿了么商家版后台接单
 3	使用饿了么商家版的android客户端接单
 4	使用饿了么商家版的ios客户端接单
 
 
 图片上传结果
 状态	含义
 -1	上传失败
 1	处理中
 2	上传成功
 
 
 饿了么自配送餐厅合作类型(service_category)
 状态	含义
 1	A（电话报单）
 2	B（代购）
 3	C（打印机出单）
 
 
 订单项目分类
 ID	含义
 1	食物
 2	配送费
 3	优惠券
 11	美食活动
 12	餐厅活动
 13	使用饿了么红包
 102	打包费
 
 
 餐厅活动类型
 ID	含义
 3	优惠券
 7	新用户折扣
 100	额外折扣
 101	在线支付折扣
 102	活动折扣
 103	新用户折扣
 104	订单红包
 105	JINBAO折扣
 
 
 美食活动类型
 ID	含义
 1	折扣价
 2	减价
 3	第N份折扣价
 4	固定价格
 5	赠品
 
 
 餐厅整体营业状态
 状态	含义
 1	餐厅营业中
 2	餐厅关闭
 3	餐厅网络不稳定
 4	餐厅休息中
 5	只接受预定
 6	只接受电话订餐
 7	餐厅休假中
 注解
 
 建议第三方平台将3/6/7状态也当做餐厅休息中处理

*/
