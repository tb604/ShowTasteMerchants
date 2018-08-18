//
//  LocalCommon.h
//  51tourGuide
//
//  Created by 唐斌 on 16/3/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#ifndef LocalCommon_h
#define LocalCommon_h

#import "TYZCreateCommonObject.h"
#import "TYZKit.h"
#import "TYZRespondDataEntity.h"
#import "UtilityObject.h"
#import "HCSNetHttp.h"
#import "MCYPushViewController.h"
#import "SVProgressHUD.h"
#import "YRTransitionKit.h" // 动画
#import "UserLoginStateObject.h"
#import "TYZDBManager.h"
#import "NotifyMessageEntity.h" // 订单推送消息
//#import "WYXEmptyContentView.h"


#pragma -
#pragma -mark 第三方key
/// 友盟key
#define kYOUMENGKey @"5816eef4e88bad4058000cb1"
/// 百度地图key
#define kBMKMAPKey @"F9e4Gw1ipf0tOaS0QVcC5mgBNteUZilb"

// 百度地图的key
#define kBaiDuMapKey @"F9e4Gw1ipf0tOaS0QVcC5mgBNteUZilb"

// 分享的key
#define kSHARESDK_KEY @"162a40b5608b2"

// ***************************************
// 融云sdk使用的相关
// 测试环境的
#define kRYAppKey @"y745wfm844abv"
#define kRYAppSecret @"Q909RC4hkEj"

// 正式环境的
//#define kRYAppKey @"n19jmcy59kev9"
//#define kRYAppSecret @"9T5wwB71vKDB"

// ***************************************


// 外卖打印机信息
#define kPrinterIP @"TakeOutPrinterIP" // 外卖打印机IP
#define kPrinterModel @"TakeOutPrinterModel" // 外卖打印机型号


#pragma -
#pragma -mark 网络服务地址
// 是否是生产环境
#define kIsProductioinEnvironment 0 // 0表示测试环境；1表示生产环境

#if kIsProductioinEnvironment
#define H5ROOTURL @"http://wap.chinatopchef.com/" // h5
// 生产环境
#define REQUESTBASICURL @"http://shop.webapi.chinatopchef.com/" // 接口的
#else
// 测试环境
#define REQUESTBASICURL @"http://182.254.132.142/"
#define H5ROOTURL @"http://182.254.132.142:8082/"
#endif


/// 一页多少条数据
#define kPageSize 20

// 存储token的key
#define kDeviceToken @"DeviceToken51Tour"


/**
 调用服务端，返回的状态
 */
typedef enum
{
    //服务器返回
    respond_success         = 0,    ///< 成功
    respond_nodata          = 20002,    ///< 没有数据
    respond_serviceserror   = 3,    ///< 服务器异常
    respond_parametererror  = 4,    ///< 请求参数异常
    respond_solveerror      = 5,    ///< 服务器处理错误
    respond_othererror      = 6,    ///< 其他错误
    respond_receicedata     = 7,    ///< 获取资源中
    respond_unziperror      = 8,    ///< 解压失败
    respond_finishdata      = 9,    ///< 所有数据获取完毕
    
    //未连接到服务器返回
    respond_timeout         = -1,   ///< 请求超时
    respond_requesterror    = -2,   ///< 服务器请求错误
    respond_nonet           = -3,   ///< 没有网络
}error_code;

typedef NS_ENUM(NSUInteger, requestStyle)
{
    WYXGET, ///< get请求方式
    WYXPOST, ///< post请求方式
    WYXPUT,   ///< put请求方式
    WYXDELETE ///< delete请求方式
};

/* 表示返回数据类型 */
typedef NS_ENUM(NSUInteger, responseStyle)
{
    WYXDATA,   ///< 请求后，返回的data数据类型
    WYXJSON,   ///< 请求后，返回json数据类型
    WYXXML,    ///< 请求后，返回xml数据类型
};

// 支付类型。1支付宝；2微信
typedef NS_ENUM(NSInteger, EPaymentType)
{
    EPaymentTypeAliPay = 1, ///< 支付宝支付
    EPaymentTypeWX, ///< 微信支付
    EPaymentTypeApply, ///< 苹果支付
};

/*
 umeng                2083491727@qq.com  topchef@1727
 sharesdk             2083491727@qq.com  topchef@1727
 微信开发平台         2083491727@qq.com  topchef@1727
 */


/*
 等级     权限                          描述
 1		101,102,103						基本订单业务权限。
 2		100,						所有的订单业务权限。
 3		101,102,103,1						基本订单业务权限，收银权限。
 4		100,1						所有的订单业务权限，收银权限。
 5		100,201,202,203,204,						所有的订单业务权限，资料编辑。
 6		200,100,1,						所有的订单业务权限，资料编辑，人员管理，收银。
 老板		200,100,300						老板的权限
 管理员权限		0						开通所有权限
 */

// 用户权限(订单100，设置200，财务300)
typedef NS_ENUM(NSInteger, EN_USER_AUTHOR)
{// highest authority
    EN_USER_HIGHEST_AUTHOR = 0, ///< 管理员权限(开通所有的)
    EN_USER_CASHIER_AUTHOR = 1, ///< 收银
    EN_USER_ALLORDER_AUTHOR = 100, ///< 订单的所有权限
    EN_USER_TAKEORDER_AUTHOR = 101, ///< 点菜下单
    EN_USER_MEALINGORDER_AUTHOR, ///< 餐中订单
    EN_USER_HISTORYORDER_AUTHOR, ///< 历史订单
    EN_USER_TAKEOUTORDER_AUTHOR, ///< 外卖订单
    EN_USER_RESERVATEORDER_AUTHOR, ///< 预定订单
    EN_USER_ALLSHOP_AUTHOR = 200, ///< 餐厅所有权限
    EN_USER_SHOPINFO_AUTHOR = 201, ///< 餐厅资料
    EN_USER_SHOPMENU_AUTHOR, ///< 菜单菜品
    EN_USER_SHOPSEAT_AUTHOR, ///< 餐位设置
    EN_USER_SHOPMOUTH_AUTHOR, ///< 档口设置
    EN_USER_MEPMANAGER_AUTHOR, ///< 员工管理
    EN_USER_FINANCIAL_AUTHOR = 300, ///< 财务所有权限
//    EN_USER_EARNING_AUTHOR = 301, ///< 收益
    EN_USER_REPORT_AUTHOR = 302, ///< 报表
};
// financial


#pragma -
#pragma mark - 通知
// 百度定位服务通知
#define kDidUpdateUserHeadingNote @"DidUpdateUserHeadingNote" ///< 用户方向更新后，会调用此函数

#define kDidUpdateBMKUserLocationNote @"DidUpdateBMKUserLocationNote" ///< 用户位置更新后，会调用此函数

// 定位状态改变后，发送通知
#define kDidChangeAuthorizationStatusNOTIFICATION @"DidChangeAuthorizationStatus"

// 支付宝支付回调
#define kAliPayNotification @"NOTIFICATION_SAFEPAY_CALLBACK"

// 微信支付回调
#define kWeiXinPayNotification @"NOTIFICATION_WXPAY_CALLBACK"

// 有一个订单处理了后，发送通知，然后更新
#define kORDERWAITINGDEALNOTE @"ORDERWAITINGDEALNOTE"

// 从餐厅列表中切换餐厅，发送通知
#define kCHANGE_SHOP_NOTE  @"change_shop_note"



#pragma -
#pragma mark -  一些常用颜色
// 本项目中字的颜色
// 蓝色
#define kFontColorBlue RGBACOLOR(63.0f, 195.0f, 241.0f, 1)

// 字的颜色(黑色 #333333 R51 G51 B51)
#define kFontColorBlack RGBACOLOR(51.0f, 51.0f, 51.0f, 1)

// 字的颜色(light #999999 R153 G153 B153)
#define kFontColorLight RGBACOLOR(153.0f, 153.0f, 153.0f, 1)

//  视图背景色
#define kViewBackgroundColor RGBACOLOR(242.0f, 244.0f, 245.0f, 1)



#pragma -
#pragma mark -  ENUM定义
// 将菜系列表保存到本地
#define kCacheCuisineFileName @"CuisineCacheData.plist"
#define kCacheCuisineData @"CuisineData"
// smschannel 渠道号 1：注册 2：验证当前手机号 3：绑定新手机号 4:找回密码
typedef NS_ENUM(NSInteger, EN_SMS_CHANNEL_TYPE)
{
    EN_SMS_CHANNEL_TYPE_REGISTER = 1,   ///< 注册
    EN_SMS_CHANNEL_TYPE_CURPHONE,       ///< 验证当前手机
    EN_SMS_CHANNEL_TYPE_BINDING,        ///< 绑定新手机号
    EN_SMS_CHANNEL_TYPE_FORGOT          ///< 找回密码
};



/*
 1000：用户头像 1张
 2000：餐厅首图 1张
 2001：餐厅大厅图 2张
 2002：餐厅包间图 2张
 2003：餐厅景观图 1张
 3000：厨师头像 1张
 4000：餐厅营业执照 1张
 4001：餐厅经营许可证 1张
 4002：餐厅消防安全证 1张
 4003：餐厅卫生许可证 1张
 4004：餐厅从业人员健康证1
 4005：餐厅从业人员健康证2
 5000：订单评论图片 3张
 
 */
typedef NS_ENUM(NSInteger, EN_UPLOAD_IMAGE_TYPE)
{
    EN_UPLOAD_IMAGE_HEADER = 1000, ///< 用户头像 1张
    EN_UPLOAD_IMAGE_SHOP_FIRST = 2000, ///< 餐厅首图 1张
    EN_UPLOAD_IMAGE_SHOP_HALL, ///< 餐厅大厅图 2张
    EN_UPLOAD_IMAGE_SHOP_ROOMS, ///< 餐厅包间图  2张
    EN_UPLOAD_IMAGE_SHOP_LANDSCAPE, ///< 餐厅景观图 1张
    EN_UPLOAD_IMAGE_CHEF_HEADER = 3000, ///< 厨师头像 1张
    EN_UPLOAD_IMAGE_BUSINESS_LICENSE = 4000, ///< 餐厅营业执照 1张
    EN_UPLOAD_IMAGE_BUSINESS_CERTIFICATE, ///< 餐厅经营许可证 or 餐厅卫生许可证 1张
    EN_UPLOAD_IMAGE_FIRESAFETY_CERTIFICATE, ///< 餐厅消防安全证 1张(不要了)
    EN_UPLOAD_IMAGE_HYGIENE_LICENSE,  ///< 餐厅卫生许可证 1张（不要了）
    EN_UPLOAD_IMAGE_HEALTH_CERTIFICATE_ONE = 4004, ///< 餐厅从业人员健康证1
    EN_UPLOAD_IMAGE_HEALTH_CERTIFICATE_TWO, ///< 餐厅从业人员健康证2
    EN_UPLOAD_IMAGE_ORDER_COMMEND = 5000, ///< 订单评论图片 3张
    EN_UPLOAD_IMAGE_COMMUNITY_COMMEND = 6000, ///< 社区图片
    EN_UPLOAD_IMAGE_FOOD_DETAIL = 10000, ///< 菜品详情图片
    EN_UPLOAD_IMAGE_FOOD_RELATED = 10001, ///< 菜品相关图片
    
};//  Health certificate, please


// 订单状态
typedef NS_ENUM(NSInteger, EN_ORDER_STATE)
{
    NS_ORDER_WAITING_CONFIRMATION_STATE = 100, ///< 待商家确认(待确认)
    NS_ORDER_WAITING_PAY_DEPOSIT_STATE = 110, ///< 待付订金(已接单)
    NS_ORDER_COMPLETED_BOOKING_STATE = 120, ///< 预订完成（预订成功）
    NS_ORDER_DINING_STATE = 400, ///< 就餐中
    NS_ORDER_IN_CHECKOUT_STATE = 410, ///< 结账中(服务员已确认支付金额(待支付))
    NS_ORDER_PAY_COMPLETE_STATE = 420, ///< 支付完成(支付成功)
    NS_ORDER_ORDER_COMPLETE_STATE = 800, ///< 订单完成
    NS_ORDER_SHOP_SAB_STATE = 200, ///< 退单申请中
    NS_ORDER_SHOP_REFUNDING_STATE = 210, ///< 退款中
    NS_ORDER_ORDER_CANCELED_STATE = 820, ///< 订单已取消
    NS_ORDER_RETREAT_SINGLE_COMPLETE_STATE = 830, ///< 退单完成（已退款）
    NS_ORDER_SHOP_REFUSED_STATE = 810, ///< 商家已拒绝(拒单)
    NS_ORDER_ORDER_NOT_ACTIVE_STATE = 300, ///< 未激活(即时订单)--即时
};


// 餐厅的状态

typedef NS_ENUM(NSInteger, EN_SHOP_STATE)
{
    EN_SHOP_NOTAUDIT_STATE = 0, ///< 未审核
    EN_SHOP_WAITINGAUDIT_STATE, ///< 待审核
    EN_SHOP_HAVEGAUDIT_STATE, ///< 已审核
    EN_SHOP_PUBLISHED_STATE, ///< 已发布
    EN_SHOP_OFFSHELVES_STATE, ///< 已下架
}; // off the shelves

// 餐厅状态 0 未审核 1 待审核 2 已审核 3 已发布 4 已下架

// 100 已点菜 200 已下单 300 已上桌 700 已退菜
// 订单里面菜品的状态
typedef NS_ENUM(NSInteger, EN_ORDER_FOOD_STATE)
{
    NS_ORDER_FOOD_DISHES_STATE = 100, ///< 已点菜
    NS_ORDER_FOOD_HAVE_STATE = 200, ///< 已下单
    NS_ORDER_FOOD_TABLE_STATE = 300, ///< 已上桌
    NS_ORDER_FOOD_RETIRED_STATE = 700, ///< 已退菜
};

// 订单推送的，cmd字段的描述
typedef NS_ENUM(NSInteger, EN_PUSH_ORDER_NOTIFYCMD)
{
    EN_PUSH_ORDER_SHOPS_NOTIFY_TC = 1,          ///< 预订后，商家的接单和拒单通知，
    EN_PUSH_ORDER_DEPOSIT_SUCCESS_TC = 2,       ///< 支付成功后，明确用户预订信息的通知。
    EN_PUSH_ORDER_ACTIVATED_TC = 3,             ///< 即时和预订订单激活后的通知。
    EN_PUSH_ORDER_KITCHEN_TC = 4,               ///< 服务员下单到后厨的通知。
    EN_PUSH_ORDER_BILL_CONFIRM_TC =5,           ///< 服务员确认账单的通知。
    EN_PUSH_ORDER_PAYMENT_CONFIRM_TC = 6,       ///< 服务员确认支付，完成订单。感谢下次光临的通知。
    EN_PUSH_ORDER_BOOKED_NOTIFY_TS = 1001,      ///< 有客户预订请求的通知。
    EN_PUSH_ORDER_DEPOSIT_SUCCESS_TS = 1002,    ///< 客户订金支付成功，完成预订的通知。
    EN_PUSH_ORDER_INSTANT_TS = 1003,            ///< 即时订单生成的通知。
    EN_PUSH_ORDER_CANCEL_TS = 1004,             ///< 账单取消的通知。
    EN_PUSH_ORDER_BACK_TS = 1005,               ///< 预订成功账单申请退单的通知。
    EN_PUSH_ORDER_PAYMENT_SUCCESS_TS = 1006,    ///< 食客支付完成账单的通知。
};

// 线下支付渠道。0支付宝 1微信 2现金 3大众点评 4美团
typedef NS_ENUM(NSInteger, EN_OFFLINE_PAYCHANNEL_TYPE)
{
    EN_OFFLINE_PAYCHANNEL_ALIPAY = 0, ///< 支付宝支付
    EN_OFFLINE_PAYCHANNEL_WXPAY, ///<微信支付
    EN_OFFLINE_PAYCHANNEL_CASHPAY, ///现金支付
    EN_OFFLINE_PAYCHANNEL_PCOPAY, ///< 大众点评支付
    EN_OFFLINE_PAYCHANNEL_MELPAY, ///< 美团支付
};
// Employe

// 老板登录、员工登录
typedef NS_ENUM(NSInteger, EN_LOGIN_USER_TYPE)
{
    EN_LOGIN_USER_BOSS_TYPE = 1,  ///< 老板登录
    EN_LOGIN_USER_EMPLOYE_TYPE,   ///< 员工登录
};


// 食客添加菜品放入购物车
//#define kCacheShopingCartFileName @"CacheShopingCart.plist"
//#define kCacheShopingCartData @"CacheShopingCartData"

#pragma -
#pragma mark -  缓存的本地文件名
// 将菜系列表保存到本地
#define kCacheCuisineFileName @"CuisineCacheData.plist"
#define kCacheCuisineData @"CuisineData"

// 预订购物车
#define kCacheBookingShopingCartFileName @"CacheBookingShopingCart.plist"
#define kCacheBookingShopingCartData @"kCacheBookingShopingCartData"

// 即时购物车
#define kCacheInstantShopingCartFileName @"CacheInstantShopingCart.plist"
#define kCacheInstantShopingCartData @"kCacheInstantShopingCartData"


// 用户输入的搜索的关键字写入本地
#define kCacheSearchKeyFileName @"CacheSearchKey.plist"
#define kCacheSearchKeyData @"CacheSearchKey"

#pragma -
#pragma mark 分享信息
// 餐厅详情
#define kShopDetailShareUrl(shopId) [NSString stringWithFormat:@"http://www.chinatopchef.com/share/shop-details-%d.html", shopId]
#define kShopDetailShareMsg @"秀味：热门餐厅来临。"

//  餐厅菜品详情
#define kShopFoodDetailShareUrl(shopId, foodId) [NSString stringWithFormat:@"http://www.chinatopchef.com/share/shop-food-details-%d-%d.html", shopId, foodId]
#define kShopFoodDetailShareMsg @"秀味：热门美食来了。"

// 邀请函
#define kInviteShareUrl(orderId) [NSString stringWithFormat:@"http://www.chinatopchef.com/share/invite-%@.html", orderId]
#define kInviteShareMsg(nickName) [NSString stringWithFormat:@"秀味：%@ ，邀请你吃饭了。", nickName]

// 邀请函详情
#define kInviteDetailShareUrl(orderId) [NSString stringWithFormat:@"http://www.chinatopchef.com/share/invite-details-%@.html", orderId]
#define kInviteDetailShareMsg(nickName) [NSString stringWithFormat:@"秀味：%@ ，美食菜单。", n


/*
 餐厅详情：
 shop-details-{餐厅ID}
 http://www.chinatopchef.com/share/shop-details-1.html
 餐厅菜品详情：
 shop-food-details-{餐厅ID}-{菜品ID}
 http://www.chinatopchef.com/share/shop-food-details-1-2.html
 邀请函：
 invite/{订单ID}.html
 http://www.chinatopchef.com/share/invite-2016082210251100.html
 邀请函详情：
 invite-details-{订单ID}.html
 http://www.chinatopchef.com/share/invite-details-2016082210251100.html
 topchef 换成你那边的 chinatopchef
 
 1 .  秀味：热门餐厅来临
 2.   秀味：热门美食来了
 3.   秀味：*** ，邀请你吃饭了。
 4.   秀味：***，美食菜单。
 */

#endif /* LocalCommon_h */



/*
 剩下工作：
 1、餐厅订单详情的加菜减菜功能修改。(完成）
 2、餐厅详情 菜品下面加一个 “更多”。(完成)
 3、分享功能开发。(赞未完成：食客订单详情分享没有、我的餐厅预览分享)
 4、登陆注册完成后，进入主页。(完成)
 5、首页分享美食体验。
 6、推送的时候显示的消息条如何处理?
 */


























