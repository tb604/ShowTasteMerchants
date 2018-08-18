//
//  HCSNetHttp.h
//  ChefDating
//
//  Created by 唐斌 on 16/5/20.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HungryNetHttp.h" // 饿了么
#import "HungryBaseInfoObject.h" // 饿了么
#import "DaDaDistAddOrderInputEntity.h" // 达达配送新增订单
#import "DaDaDistAddOrderTipsEntity.h" // 达达增加小费entity

#import "TYZRespondDataEntity.h"
#import "UserUpdateInputEntity.h" // 用户的请求的传入参数。
#import "AddDishesInputEntity.h" // 添加菜品传入参数
#import "AddSeatInputEntity.h" // 新增餐位预订传入参数L
#import "ShopCreateInputEntity.h" // 新建餐厅需要的参数
#import "ShopTypeFilterInputEntity.h" // 餐厅分类筛选
#import "ShopFoodInputEntity.h" // 菜品传入参数
#import "ShopFoodCategoryInputEntity.h" // 菜品分类传入信息
#import "UploadFileInputObject.h" // 获取图片token需要的参数
#import "RestaurantReservationInputEntity.h" // 订餐传入参数
#import "CancelReservationEntity.h" // 取消预订订单
#import "OrderListInputEntity.h" // 食客订单列表的传入参数
#import "UpdateOrderFoodInputEntity.h" // 加菜传入参数
#import "CommentInputDataEntity.h" // 评论传入参数
#import "ShopSearchInputEntity.h" // 搜索餐厅的传入参数
#import "OrderCompletedInputEntity.h" // 查询完成的订单传入参数
#import "ShopManageInputEntity.h" // 餐厅管理
#import "OrderAmountModifyEntity.h" // 修改订单金额
#import "ShopPatchFoodInputEntity.h" // 补打传入参数
#import "PrintBatchDataEntity.h" // 补打订单列表
#import "ShopSeatNumberEntity.h" // 修改餐桌的信息
#import "MyFinanceTodayDataEntity.h" // 财务--今日的数据
#import "PayChannelDataEntity.h" // 支付渠道实体类
#import "CTCRestaurantDishUpDownFoodEntity.h" // 上菜/取消上菜传入参数
#import "CTCShopLicenseInputEntity.h" // 添加资质认证的传入参数


@class CTCRestaurantHistoryOrderInputEntity; // 历史订单的传入参数

@interface HCSNetHttp : NSObject


#pragma mark -
#pragma mark 报表(财务)Report -- 800000

/**
 *  订单日报首页汇总(01)
 *
 *  @param shopId 餐厅id
 *  @param date 日期
 *
 */
+ (NSURLSessionDataTask *)requestWithOrderReportDaySummary:(NSInteger)shopId date:(NSString *)date completion:(void(^)(id result))completion;


//+ (NSURLSessionDataTask *)requestWithOrderReportDay


#pragma mark -
#pragma mark 消费详情 -- 700000

/**
 *  获取用户的消费详情(01)
 *
 *  @param userId     用户id
 *  @param pageIndex  pageindex
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithUserConsume:(NSInteger)userId category:(NSInteger)category pageIndex:(NSInteger)pageIndex completion:(void(^)(id result))completion;


#pragma mark -
#pragma mark 消息推送（PUSH）


/**
 *  绑定第三方推送数据
 *
 *  @param userId    用户id
 *  @param pUserId   百度推送的UserId
 *  @param channelId 百度推送的渠道id
 *
 *  @return
 */
//+ (NSURLSessionDataTask *)requestWithPushBind:(NSInteger)userId pUserId:(NSString *)pUserId channelId:(NSString *)channelId appId:(NSString *)appId completion:(void(^)(id result))completion;

/**
 *  获取用户的推送绑定数据
 *
 *  @param userId     用户id
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithPush:(NSInteger)userId completion:(void(^)(id result))completion;

#pragma mark -
#pragma mark 餐厅餐位接口

/**
 *  获取所有的餐位信息
 *
 *  @param shopId     餐厅id
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithShopSeatSetting:(NSInteger)shopId completion:(void(^)(id result))completion;

/**
 *  删除餐位信息
 *
 *  @param seatId     餐位id
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithShopSeatSettingDelete:(NSInteger)seatId completion:(void(^)(id result))completion;

/**
 *  修改餐位
 *
 *  @param seatId     餐位id
 *  @param shopId     餐厅id
 *  @param name       餐位名称
 *  @param remark     餐位备注
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithShopSeatSettingSet:(NSInteger)seatId shopId:(NSInteger)shopId name:(NSString *)name remark:(NSString *)remark completion:(void(^)(id result))completion;

/**
 *  新增餐位信息
 *
 *  @param shopId     餐厅id
 *  @param name       餐位名称
 *  @param remark     餐位备注
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithShopSeatSettingAdd:(NSInteger)shopId name:(NSString *)name remark:(NSString *)remark completion:(void(^)(id result))completion;

#pragma mark -
#pragma mark 用户收藏餐厅接口

/**
 *  获取用户收藏的餐厅列表（01）
 *
 *  @param userId     用户id
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithUserFavoriteGetShopList:(NSInteger)userId completion:(void(^)(id result))completion;

/**
 *  获取用户收藏的餐厅（02）
 *
 *  @param userId     用户id
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithUserFavorite:(NSInteger)userId completion:(void(^)(id result))completion;

/**
 *  取消收藏（02）
 *
 *  @param userId     用户id
 *  @param shopId     餐厅id
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithUserFavoriteCancel:(NSInteger)userId shopId:(NSInteger)shopId completion:(void(^)(id result))completion;

/**
 *  添加收藏接口（03）
 *
 *  @param userId     用户id
 *  @param shopId     餐厅id
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithUserFavoriteAdd:(NSInteger)userId shopId:(NSInteger)shopId completion:(void(^)(id result))completion;


#pragma mark -
#pragma mark 餐厅搜索接口

/**
 *  获取热门搜索关键字(01)
 *
 *  @param cityId     城市id
 *  @param lat        纬度
 *  @param lng        经度
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithSearchHotKey:(NSInteger)cityId lat:(double)lat lng:(double)lng completion:(void(^)(id result))completion;

/**
 *  首页餐厅搜索接口(02)
 *
 *  @param inputEnt   传入参数
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithSearch:(ShopSearchInputEntity *)inputEnt completion:(void(^)(id result))completion;

#pragma mark -
#pragma  mark 支付相关接口
/**
 *  从服务端获取支付宝的签名信息(01)
 *
 *  @param orderNo    订单号
 *  @param name       商品名称
 *  @param body       商品详情
 *  @param money      金额
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithPayAlipayPayUrl:(NSString *)orderNo name:(NSString *)name body:(NSString *)body money:(NSString *)money completion:(void(^)(id result))completion;


#pragma mark -
#pragma mark 对订单的评论接口
/**
 *  获取对某个餐厅的所有评论信息(01)
 *
 *  @param shopId     餐厅id
 *  @param pageIndex 页码
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithComment:(NSInteger)shopId pageIndex:(NSInteger)pageIndex completion:(void(^)(id result))completion;

/**
 *  新增对订单的评论(02)
 *
 *  @param commentEnt 评论参数
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithCommentAdd:(CommentInputDataEntity *)commentEnt completion:(void(^)(id result))completion;

#pragma mark -
#pragma mark 餐厅端订单信息归档 (B端 Order)

/**
 *  获取支付渠道列表(01)
 *
 */
//+ (NSURLSessionDataTask *)requestWithOrderPayChannel:(void(^)(id result))completion;


/**
 *  收银打印(01)
 *
 *  @param orderId    订单id
 *  @param shopId     餐厅id
 *  @param shopUserId 操作者id
 *  @param completion block
 *
 *  @return dt
 */
//+ (NSURLSessionDataTask *)requestWithOrderCashPrinter:(NSString *)orderId shopId:(NSInteger)shopId shopUserId:(NSInteger)shopUserId completion:(void(^)(id result))completion;

/**
 *  餐厅退菜(01)
 *
 *  @param inputEnt 传入参数
 *  @param completion block
 *
 *  @return dt
 */
//+ (NSURLSessionDataTask *)requestWithOrderDetailShopReturnFoods:(UpdateOrderFoodInputEntity *)inputEnt completion:(void(^)(id result))completion;


/**
 *  新增菜品下单打印列表(01)
 *
 *  @param orderId    订单id
 *  @param completion block
 *
 *  @return dt
 */
//+ (NSURLSessionDataTask *)requestWithOrderDetailWaitPrintFoods:(NSString *)orderId shopId:(NSInteger)shopId completion:(void(^)(id result))completion;

/**
 *  获取未接单列表(01)
 *
 *  @param shopId     餐厅id
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithOrderWaitProcessOrders:(NSInteger)shopId completion:(void(^)(id result))completion;

/**
 *  服务员确认订单金额(02)
 *
 *  @param orderId    订单编号
 *  @param shopid     餐厅id
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithOrderConfirmOrderAmount:(NSString *)orderId shopId:(NSInteger)shopid completion:(void(^)(id result))completion;

/**
 *  餐厅服务员补打订单(03)
 *
 *  @param inputEntity 传入参数
 *  @param completion block
 *
 *  @return dt
 */
//+ (NSURLSessionDataTask *)requestWithOrderPatchFoodToKitchen:(ShopPatchFoodInputEntity *)inputEntity completion:(void(^)(id result))completion;

/**
 *  获取订单打印菜品详情(04)
 *
 *  @param orderId    订单id
 *  @param shopId     餐厅id
 *  @param completion block
 *
 *  @return dt
 */
//+ (NSURLSessionDataTask *)requestWithOrderGetPrintBatchFoods:(NSString *)orderId shopId:(NSInteger)shopId completion:(void(^)(id result))completion;

/**
 *  餐厅服务员下单到厨房，让厨房开始做(05)
 *
 *  @param orderId    订单id
 *  @param shopId     餐厅id
 *  @param completion block
 *
 *  @return dt
 */
//+ (NSURLSessionDataTask *)requestWithOrderFoodToKitchen:(NSString *)orderId shopId:(NSInteger)shopId printId:(NSInteger)printId completion:(void(^)(id result))completion;

/**
 *  餐厅服务员修改支付金额(06)
 *
 *  @param inputEntity 传入参数
 *  @param completion block
 *
 *  @return dt
 */
//+ (NSURLSessionDataTask *)requestWithOrderModifyAmount:(OrderAmountModifyEntity *)inputEntity completion:(void(^)(id result))completion;

/**
 *  检查订单是否线上支付完成(07)
 *
 *  @param orderId    订单id
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithOrderCheckPayOnline:(NSString *)orderId shopId:(NSInteger)shopId completion:(void(^)(id result))completion;

/**
 *  确认线上结束订单(08)
 *
 *  @param orderId    订单id
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithOrderOnlineFinish:(NSString *)orderId shopId:(NSInteger)shopId completion:(void(^)(id result))completion;

/**
 *  确认线下结束订单(09)
 *
 *  @param orderId    订单id
 *  @param shopId 餐厅id
 *  @param payChannel 线下支付渠道。0支付宝 1微信 2现金 3大众点评 4美团(EN_OFFLINE_PAYCHANNEL_TYPE)
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithOrderOfflineFinish:(NSString *)orderId shopId:(NSInteger)shopId payChannel:(NSInteger)payChannel completion:(void(^)(id result))completion;

/**
 *  餐厅加菜(10) 适用于食客端和餐厅端
 *
 *  @param foodEnt 传入参数
 *  @param completion block
 *
 *  @return dt
 */
//+ (NSURLSessionDataTask *)requestWithOrderDetailShopAddFoods:(UpdateOrderFoodInputEntity *)foodEnt completion:(void(^)(id result))completion;

/**
 *  服务员上菜后更新明细订单状态(11)
 *
 *  @param orderDetailId 订单明细编号
 *  @param orderId       订单号
 *  @param userId        顾客编号(顾客id)
 *  @param dishType      1上菜；2取消上菜
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithOrderDish:(NSInteger)orderDetailId orderId:(NSString *)orderId userId:(NSInteger)userId shopId:(NSInteger)shopId dishType:(NSInteger)dishType completion:(void(^)(id result))completion;

/**
 *  顾客到店后餐厅分配餐桌(12)
 *
 *  @param inputEntity    传入参数
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithOrderAllocateSeatNumber:(ShopSeatNumberEntity *)inputEntity completion:(void(^)(id result))completion;

/**
 *  餐厅接单或拒单接口(13)
 *
 *  @param orderId    订单编号
 *  @param status     订单状态 2表示接单；400表示拒单
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithOrderShopAcceptRefuseBooking:(NSString *)orderId status:(NSInteger)status shopId:(NSInteger)shopId completion:(void(^)(id result))completion;

/**
 *  餐厅获取已完成订单(14)
 *
 *  @param inputEnt input
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithOrderShopCompletedOrders:(OrderCompletedInputEntity *)inputEnt completion:(void(^)(id result))completion;

/**
 *  餐厅获取就餐中列表(15)
 *
 *  @param inputEnt input
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithOrderShopingOrders:(OrderCompletedInputEntity *)inputEnt completion:(void(^)(id result))completion;

/**
 *  餐厅获取预订订单列表(16)
 *
 *  @param inputEnt 传入参数
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithOrderShopBookOrders:(OrderCompletedInputEntity *)inputEnt completion:(void(^)(id result))completion;


#pragma mark -
#pragma mark 食客端订单信息归档 (C端 Order)

/**
 *  取消预订订单是否退款提醒(01)
 *
 *  @param orderId 订单id
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithOrderCancelOrderTip:(NSString *)orderId completion:(void(^)(id result))completion;

/**
 *  修改订单菜品，修改和添加菜品（02）
 *
 *  @param updateFood    传入参数
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithOrderDetailModifyFoodDetail:(UpdateOrderFoodInputEntity *)updateFood completion:(void(^)(id result))completion;

/**
 *  即时就餐下单（03）
 *
 *  @param inputEntity 传入参数
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithOrderImmediate:(RestaurantReservationInputEntity *)inputEntity completion:(void(^)(id result))completion;

/**
 *  查询退单原因（04）取消订单，使用的
 *
 *  @param completion （OrderCancelReasonEntity）
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithOrderShowReason:(void(^)(id result))completion;

/**
 *  查询订单主体明细信息(05)
 *
 *  @param orderId    订单id
 *  @param shopId     餐厅id
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithOrderShowWholeOrder:(NSString *)orderId shopId:(NSInteger)shopId  completion:(void(^)(id result))completion;

+ (NSURLSessionDataTask *)requestWithOrderShowWholeOrderTwo:(NSString *)orderId shopId:(NSInteger)shopId  completion:(void(^)(id result))completion;


/**
 *  订单列表查询（06）
 *
 *  @param inputEntity 传入参数
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithOrderGetOrders:(OrderListInputEntity *)inputEntity completion:(void(^)(id result))completion;

/**
 *  查询订单基础信息（07）
 *
 *  @param orderId    订单id
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithOrderShow:(NSString *)orderId completion:(void(^)(id result))completion;

/**
 *  就餐预订(08)
 *
 *  @param bookEnt    传入参数
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithOrderBooking:(RestaurantReservationInputEntity *)bookEnt completion:(void(^)(id result))completion;

/**
 *  取消订单，即时和预订(09)
 *
 *  @param cancelOrderEnt 传入参数
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithOrderCancelBookOrder:(CancelReservationEntity *)cancelOrderEnt completion:(void(^)(id result))completion;

#pragma mark -
#pragma 餐厅管理接口
/**
 *  修改餐厅管理权限信息(01)
 *
 *  @param inputEnt   传入参数
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithManageSet:(ShopManageInputEntity *)inputEnt completion:(void(^)(id result))completion;

/**
 *  删除餐厅管理中的信息(02)
 *
 *  @param inputEnt 传入参数
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithManageDelete:(ShopManageInputEntity *)inputEnt completion:(void(^)(id result))completion;

/**
 *  餐厅管理信息列表(03)
 *
 *  @param shopId 餐厅id
 *  @param completion (ShopManageDataEntity)
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithManage:(NSInteger)shopId completion:(void(^)(id result))completion;

/**
 *  新增餐厅管理权限(04)
 *
 *  @param inputEnt 传入参数
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithManageAdd:(ShopManageInputEntity *)inputEnt completion:(void(^)(id result))completion;

/**
 *  获取餐厅管理的职位配置数据(05)
 *
 *  @param completion (ShopPositionDataEntity)
 *
 *  @return  dt
 */
+ (NSURLSessionDataTask *)requestWithManageConfigs:(void(^)(id result))completion;

#pragma mark -
#pragma mark 餐厅档口信息

/**
 *  对当前餐厅菜品进行档口分类(01)
 *
 *  @param content    归档json串内容 (content JSON串内容
 {"shop_id": 7,"printers": [{"fid": 30,"pid": 7}, {"fid": 31,"pid": 7}]}
 
 备注：
 shop_id     餐厅ID
 fid              菜品ID
 pid             档口ID)
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithShopPrinterSet:(NSString *)content completion:(void(^)(id result))completion;

/**
 *  根据餐厅id获取这个餐厅下所有未指定档口的菜品数据(02)
 *
 *  @param shopId     餐厅id
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithShopPrinterGetUnassortedFoods:(NSInteger)shopId completion:(void(^)(id result))completion;

/**
 *  根据餐厅id获取所有档口数据(03)
 *
 *  @param shopId     餐厅id
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithShopPrinterGetPrinters:(NSInteger)shopId completion:(void(^)(id result))completion;

/**
 *  根据餐厅id获取所有档口及档口菜品数据(04)
 *
 *  @param shopId 餐厅id
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithShopPrinter:(NSInteger)shopId completion:(void(^)(id result))completion;


/**
 *  根据档口类型获取档口数据(05)
 *
 *  @param shopId     餐厅id
 *  @param configType 档口类型(0普通类型；1总单；2传菜)
 *  @param seatName   餐位编号
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithShopPrinterGetPrintersByConfigType:(NSInteger)shopId configType:(NSInteger)configType seatName:(NSString *)seatName completion:(void(^)(id result))completion;

/**
 *  获取未归档菜品数据（06）--H5
 *
 *  @param shopId     餐厅id
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithShopPrinterFree:(NSInteger)shopId completion:(void(^)(id result))completion;

/**
 *  获取餐厅所有档口及档口的菜品数据(07) --H5
 *
 *  @param shopId     餐厅id
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithShopPrinterShow:(NSInteger)shopId completion:(void(^)(id result))completion;

#pragma mark -
#pragma mark 菜品相关接口

/**
 *  设置菜品上架(01)
 *
 *  @param foodId     菜品id
 *  @param shopId     餐厅id
 *  @param completion completion description
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithFoodPublish:(NSInteger)foodId shopId:(NSInteger)shopId completion:(void(^)(id result))completion;

/**
 *  菜品排序(02)
 *
 *  @param text       JSON字符串 {@"shop_id":8, "category_id":1, "content":[{"id":46}, {"id":43}, {"id":45}]}。shop_id餐厅id，cagegory_id菜品分类id，content需要排序的分类列表， id分类id
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithFoodSetSort:(NSString *)text completion:(void(^)(id result))completion;

/**
 *  设置菜品状态为删除(03)
 *
 *  @param foodId     菜品id
 *  @param shopId     餐厅id
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithFoodDelete:(NSInteger)foodId shopId:(NSInteger)shopId completion:(void(^)(id result))completion;

/**
 *  设置菜品状态为下线(04)
 *
 *  @param foodId     菜品id
 *  @param shopId     餐厅id
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithFoodOffline:(NSInteger)foodId shopId:(NSInteger)shopId completion:(void(^)(id result))completion;

/**
 *  获取餐厅菜品分类下的所有菜品信息(05)--餐厅端
 *
 *  @param shopId     餐厅id
 *  @param categoryId 餐厅菜品分类id
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithFoodGetFoods:(NSInteger)shopId categoryId:(NSInteger)categoryId completion:(void(^)(id result))completion;

/**
 *  获取餐厅菜品分类下的所有菜品信息(05) -- 食客端
 *
 *  @param shopId     餐厅id
 *  @param categoryId 餐厅菜品分类id
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithFoodGetUserFoods:(NSInteger)shopId categoryId:(NSInteger)categoryId completion:(void(^)(id result))completion;

/**
 *  修改菜品数据(06)
 *
 *  @param foodEntity 传入参数
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithFoodSet:(ShopFoodInputEntity *)foodEntity completion:(void(^)(id result))completion;

/**
 *  新增菜品数据(07)
 *
 *  @param foodEntity 菜品参数
 *  @param completion  "food_id": 90
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithFoodAdd:(ShopFoodInputEntity *)foodEntity completion:(void(^)(id result))completion;

/**
 *  获取当前菜品详情(08)
 *
 *  @param foodId     菜品id
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithFood:(NSInteger)foodId completion:(void(^)(id result))completion;

#pragma mark -
#pragma mark 菜品数量（单位）接口
/**
 *  获取菜品数量(单位)数据(01)
 *
 *  @param completion block
 *
 *  @return datatask
 */
+ (NSURLSessionDataTask *)requestWithFoodUnit:(void(^)(id result))completion;

#pragma mark -
#pragma mark 菜品分类接口
/**
 *  设置菜品分类为上线状态
 *
 *  @param foodCategoryId 菜品分类id
 *  @param shopId         餐厅id
 
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithFoodCategoryPublish:(NSInteger)foodCategoryId shopId:(NSInteger)shopId completion:(void(^)(id result))completion;

/**
 *  获取餐厅菜品分类以及分类下的菜品数据(02)--餐厅端
 *
 *  @param shopId     餐厅id
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithFoodCategoryGetFoodCategoryDetails:(NSInteger)shopId completion:(void(^)(id result))completion;

/**
 *  获取餐厅菜品分类以及分类下的菜品数据(02)--食客端
 *
 *  @param shopId     餐厅id
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithFoodCategoryGetUserFoodCategoryDetails:(NSInteger)shopId completion:(void(^)(id result))completion;

/**
 *  菜品分类排序(03)
 *
 *  @param text       JSON字符串 {"shop_id":65,"content"[{"id":10}, {"id":8}, {"id":5}]}
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithFoodCategorySetSort:(NSString *)text completion:(void(^)(id result))completion;

/**
 *  设置菜品分类信息(04)
 *
 *  @param inputEntity 菜品分类传入参数
 *  @param completion block
 *
 *  @return  dt
 */
+ (NSURLSessionDataTask *)requestWithFoodCategorySetCategory:(ShopFoodCategoryInputEntity *)inputEntity completion:(void(^)(id result))completion;

/**
 *  设置菜品分类为删除状态(05)
 *
 *  @param categoryId 菜品分类id
 *  @param shopId     餐厅id
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithFoodCategoryDelete:(NSInteger)categoryId shopId:(NSInteger)shopId completion:(void(^)(id result))completion;

/**
 *  设置菜品分类为下线状态(06)
 *
 *  @param categoryId 菜品分类id
 *  @param shopId     餐厅id
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithFoodCategoryOffline:(NSInteger)categoryId shopId:(NSInteger)shopId completion:(void(^)(id result))completion;

/**
 *  新增菜品分类(07)
 *
 *  @param foodCategoryEnt 传入参数
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithFoodCategoryAdd:(ShopFoodCategoryInputEntity *)foodCategoryEnt completion:(void(^)(id result))completion;

/**
 *  获取餐厅菜品分类数据(08)--餐厅端
 *
 *  @param shopId     餐厅id
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithFoodCategoryGetFoodCategorys:(NSInteger)shopId completion:(void(^)(id result))completion;

/**
 *  获取餐厅菜品分类数据(08)-- 食客端
 *
 *  @param shopId     餐厅id
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithFoodCategoryGetUserFoodCategorys:(NSInteger)shopId completion:(void(^)(id result))completion;

/**
 *  获取餐厅菜品分类数据(08)
 *
 *  @param shopId     餐厅id
 *  @param completion
 *
 *  @return
 */
//+ (NSURLSessionDataTask *)requestWithFoodCategory:(NSInteger)shopId completion:(void(^)(id result))completion;

#pragma mark -
#pragma mark 首页
/**
 *  获取app首屏数据、轮播数据、板块 推荐等(01)
 *
 *  @param lng        经度
 *  @param lat        纬度
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithHome:(double)lng lat:(double)lat completion:(void(^)(id result))completion;

#pragma mark -
#pragma mark 菜单分类相关-菜系口味


/**
 *  获取餐厅基本属性、餐厅菜系 特色 国际菜系 口味
 *
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithMenu:(void(^)(id result))completion;

#pragma mark -
#pragma mark 餐厅端接口(B端--餐厅端)


/**
 *  获取用户所有餐厅列表信息(01)
 *
 *  @param userId     用户id
 *  @param completion block
 *
 *  @return dt
 */
//+ (NSURLSessionDataTask *)requestWithShopList:(NSInteger)userId completion:(void(^)(id result))completion;

/**
 *  获取用户餐厅列表V2.0
 *
 *  @param userId 用户Id
 *
 */
+ (NSURLSessionDataTask *)requestWithShopGetShopListbyUserId:(NSInteger)userId sellerId:(NSInteger)sellerId completion:(void(^)(id result))completion;

/**
 *  获取餐厅审核状态（01）
 *
 *  @param shopId     餐厅id
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithShopState:(NSInteger)shopId completion:(void(^)(id result))completion;

/**
 *  设置主厨师简介(02)
 *
 *  @param shopId     餐厅id
 *  @param intro      厨师简介
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithShopSetShopChefIntro:(NSInteger)shopId intro:(NSString *)intro completion:(void(^)(id result))completion;

/**
 *  设置主厨师职称(03)
 *
 *  @param shopId     餐厅id
 *  @param title      主厨职称
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithShopSetShopChefTitle:(NSInteger)shopId title:(NSString *)title completion:(void(^)(id result))completion;

/**
 *  设置主厨师姓名(04)
 *
 *  @param shopId     餐厅id
 *  @param name       主厨师姓名
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithShopSetShopChefName:(NSInteger)shopId name:(NSString *)name completion:(void(^)(id result))completion;

/**
 *  设置餐厅支付账号(支付方式)(05)
 *
 *  @param shopId        餐厅id
 *  @param payType    支付类型。1支付宝；2微信
 *  @param payAccount 支付账号
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithShopSetPay:(NSInteger)shopId payType:(NSInteger)payType payAccount:(NSString *)payAccount completion:(void(^)(id result))completion;

/**
 *  设置餐厅首图(06)
 *
 *  @param shopId     餐厅id
 *  @param imageId    图片id
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithShopSetImage:(NSInteger)shopId imageId:(NSInteger)imageId completion:(void(^)(id result))completion;

/**
 *  设置餐厅所属商圈(07)
 *
 *  @param shopId     餐厅id
 *  @param areaId     行政区域id
 *  @param mallId     商圈id
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithShopsetMall:(NSInteger)shopId areaId:(NSInteger)areaId mallId:(NSInteger)mallId completion:(void(^)(id result))completion;

/**
 *  设置餐厅地址(08)
 *
 *  @param shopId     餐厅id
 *  @param lng        经度
 *  @param lat        纬度
 *  @param address    餐厅地址
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithShopSetAddress:(NSInteger)shopId lng:(double)lng lat:(double)lat address:(NSString *)address completion:(void(^)(id result))completion;

/**
 *  设置餐厅人均消费(09)
 *
 *  @param shopId     餐厅id
 *  @param average    餐厅人均消费
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithShopSetAverage:(NSInteger)shopId average:(NSInteger)average completion:(void(^)(id result))completion;

/**
 *  设置(修改)餐厅简介(10)
 *
 *  @param shopId     餐厅id
 *  @param intro      餐厅简介
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithShopSetIntro:(NSInteger)shopId intro:(NSString *)intro completion:(void(^)(id result))completion;

/**
 *  设置(修改)餐厅联系方式(11)
 *
 *  @param shopId     餐厅id
 *  @param mobile     联系方式
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithShopSetMobile:(NSInteger)shopId mobile:(NSString *)mobile completion:(void(^)(id result))completion;

/**
 *  设置(修改)餐厅口号(标语) (12)
 *
 *  @param shopId     餐厅id
 *  @param slogan     餐厅标语(口号)
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithShopSetSlogan:(NSInteger)shopId slogan:(NSString *)slogan completion:(void(^)(id result))completion;

/**
 *  设置(修改)餐厅名称(13)
 *
 *  @param shopId     餐厅id
 *  @param name       餐厅名称
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithShopSetName:(NSInteger)shopId name:(NSString *)name completion:(void(^)(id result))completion;

/**
 *  创建(新建)餐厅(14)
 *
 *  @param content  参数 json
 *  @param completion ("data": {
 "shop_id": 42
 })
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithShopCreate:(NSString *)content completion:(void(^)(id result))completion;

/**
 *  校验(检查)餐厅名称是否已经存在 (15)
 *
 *  @param name       餐厅名字
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithShopCheckName:(NSString *)name completion:(void(^)(id result))completion;

/**
 *  下架餐厅（16）
 *
 *  @param shopId     餐厅id
 *  @param userId     用户id
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithShopOffline:(NSInteger)shopId userId:(NSInteger)userId completion:(void(^)(id result))completion;

/**
 *  取消发布(17)
 *
 *  @param shopId     餐厅id
 *  @param userId     用户id
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithShopRecover:(NSInteger)shopId userId:(NSInteger)userId completion:(void(^)(id result))completion;

/**
 *  发布餐厅(18)
 *
 *  @param shopId     餐厅id
 *  @param userId     用户id
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithShopPublish:(NSInteger)shopId userId:(NSInteger)userId completion:(void(^)(id result))completion;



/**
 *  获取餐厅详情（19）
 *
 *  @param shopid     餐厅id
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithShopShow:(NSInteger)shopid completion:(void(^)(id result))completion;



#pragma mark -
#pragma mark 餐厅分类接口(ShopClass)
/**
 *  获取餐厅分类配置信息(01)
 *
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithShopClass:(void(^)(id result))completion;

#pragma mark -
#pragma mark 用户端接口(Shop C端--食客端)

/**
 *  获取用户所有餐厅列表信息(01)
 *
 *  @param userId     用户id
 *  @param completion block
 *
 *  @return dt
 */
//+ (NSURLSessionDataTask *)requestWithShopList:(NSInteger)userId completion:(void(^)(id result))completion;

/**
 *  按条件搜索餐厅分类数据(02)
 *
 *  @param content    json ({"class_id":40001,"mall_id":0,"page_index":1,"classify":[{"id":10003},{"id":40001}]}
 
 class_id    分类ID
 mall_id     商圈ID
 page_index  当前页ID
 classify    菜系ID列表)
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithShopSearch:(NSString *)content completion:(void(^)(id result))completion;

/**
 *  获取餐厅预订页详情(03)
 *
 *  @param shopId     餐厅gid
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithShop:(NSInteger)shopId completion:(void(^)(id result))completion;


#pragma mark -
#pragma mark 餐厅

/**
 *  保存前三部餐厅信息
 *
 *  @param ids        所有menu_id，按照逗号分隔
 *  @param userId     餐厅老板用户id
 *  @param cityId     餐厅所在城市id
 *  @param name       餐厅名称
 *  @param completion
 *
 *  @return
 */
//+ (NSURLSessionDataTask *)requestWithShopOpen:(NSString *)ids userId:(NSInteger)userId cityId:(NSInteger)cityId name:(NSString *)name completion:(void(^)(id result))completion;




/**
 *  修改商圈信息
 *
 *  @param shopId     餐厅id
 *  @param mallId     商圈id
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithShopUPdateShopMall:(NSInteger)shopId mallId:(NSInteger)mallId completion:(void(^)(id result))completion;



/**
 *  修改人均消费金额
 *
 *  @param shopId     餐厅id
 *  @param percapita  人均消费金额
 *  @param completion
 *
 *  @return
 */
//+ (NSURLSessionDataTask *)requestWithShopUpdateShopPercapita:(NSInteger)shopId percapita:(double)percapita completion:(void(^)(id result))completion;

/**
 *  添加菜品分类
 *
 *  @param shopId     餐厅id
 *  @param name       菜品分类名称
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithShopAddDishesCategory:(NSInteger)shopId name:(NSString *)name completion:(void(^)(id result))completion;

/**
 *  添加菜品
 *
 *  @param entity     出入参数(shop_id, name, cid, intro, price, activity_price, images, remark)
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithShopAddDishes:(AddDishesInputEntity *)entity completion:(void(^)(id result))completion;

/**
 *  新增餐位预订数据
 *
 *  @param entity     参数(shop_id, mealtime, seat_type, seat_number, reserve_total)
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithShopAddSeat:(AddSeatInputEntity *)entity completion:(void(^)(id result))completion;

/**
 *  获取餐位预订数据
 *
 *  @param shopId     餐厅id
 *  @param date       日期
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithShopGetSeats:(NSInteger)shopId date:(NSString *)date completion:(void(^)(id result))completion;

/**
 *  交换分类排序
 *
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithShopExchangeDishesCategorySort:(void(^)(id result))completion;

/**
 *  下架某分类
 *
 *  @param shopId     餐厅id
 *  @param categoryId 餐厅分类id
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithShopBanDishesCategory:(NSInteger)shopId categoryId:(NSInteger)categoryId completion:(void(^)(id result))completion;

/**
 *  设置商圈信息
 *
 *  @param shopId     餐厅id
 *  @param areaId 区域id
 *  @param mallId 商圈id
 *  @param completion
 *
 *  @return
 */
//+ (NSURLSessionDataTask *)requestWithShopSetShopMall:(NSInteger)shopId areaId:(NSInteger)areaId mallId:(NSInteger)mallId completion:(void(^)(id result))completion;

#pragma mark -
#pragma mark 短信

/**
 *  密码找回(更新为新密码) (01)
 *
 *  @param entity     entity description
 *  @param completion completion description
 *
 *  @return return value description
 */
+ (NSURLSessionDataTask *)requestWithSmsFindPassword:(UserUpdateInputEntity *)entity completion:(void(^)(id result))completion;

/**
 *  绑定新手机(02)
 *
 *  @param inputEntity 传入的参数(uuid、userId、mobile、smscode、newmobile、newsmscode、smschannel)
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithSmsBindNewMobile:(UserUpdateInputEntity *)inputEntity completion:(void(^)(id result))completion;

/**
 *   短信验证码验证 (绑定手机第一步 验证当前手机、找回密码)(03)
 *
 *  @param mobile     手机号码
 *  @param smscode    验证码
 *  @param smschannel 短信渠道 1：注册 2：验证当前手机 号 3：绑定新手机号 4:找回密码
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithSmsVerifyCode:(NSString *)mobile smscode:(NSString *)smscode smschannel:(NSInteger)smschannel completion:(void(^)(id result))completion;

/**
 *   发送短信验证码接口(04)
 *
 *  @param mobile     手机号码
 *  @param smschannel 渠道号 1：注册 2：验证当前手机 号 3：绑定新手机号 4:找回密码
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithSmsSendCode:(NSString *)mobile smschannel:(NSInteger)smschannel completion:(void(^)(id result))completion;

/**
 *  修改为新输入的密码
 *
 *  @param inputEntity 参数(uuid、userId、mobile、smscode、password、smschannel)
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithSmsFindPasswordAction:(UserUpdateInputEntity *)inputEntity completion:(void(^)(id result))completion;


#pragma mark -
#pragma mark 用户属性等相关接口

/**
 * 获取用户这拿过户信息(01)
 *
 *  @param userId 用户id
 */
+ (NSURLSessionDataTask *)requestWithUserAccount:(NSInteger)userId completion:(void(^)(id result))completion;

/**
 *  获取圈子的授权token
 *
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithUserAuthorize:(void(^)(id result))completion;

/**
 *  根据手机号获取用户姓名(01)
 *
 *  @param mobile     手机号
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithUserGetUserNameByMobile:(NSString *)mobile completion:(void(^)(id result))completion;

/**
 *  补填邀请码(02)
 *
 *  @param userId     用户id
 *  @param inviteCode 邀请码
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithUserSetInviteCode:(NSInteger)userId inviteCode:(NSString *)inviteCode completion:(void(^)(id result))completion;

/**
 *  设置用户邮箱地址（03）
 *
 *  @param userId     用户id
 *  @param email      邮箱
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithUserSetEmail:(NSInteger)userId email:(NSString *)email completion:(void(^)(id result))completion;

/**
 *  (设置支付方式)修改支付渠道及账号(04)
 *
 *  @param userId     用户id
 *  @param payType    支付方式 0 微信 和 1 支付宝
 *  @param payAccount 支付账号
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithUserUpdatePay:(NSInteger)userId payType:(NSInteger)payType payAccount:(NSString *)payAccount completion:(void(^)(id result))completion;

/**
 *  设置(修改)身份证(05)
 *
 *  @param userId       用户id
 *  @param identityCard 身份证号
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithUserUpdateIdentityCard:(NSInteger)userId identityCard:(NSString *)identityCard completion:(void(^)(id result))completion;

/**
 *  设置(修改)用户登录密码(06)
 *
 *  @param userId     用户id
 *  @param mobile     手机号码
 *  @param password   旧密码f
 *  @param newPassword 新密码
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithUserUpdateUserPassword:(NSInteger )userId mobile:(NSString *)mobile password:(NSString *)password newPassword:(NSString *)newPassword completion:(void(^)(id result))completion;

/**
 *  设置用户出生年月日(07)
 *
 *  @param userId     用户id
 *  @param birthday   生日
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithUserUpdateUserBirthday:(NSInteger)userId birthday:(NSString *)birthday completion:(void(^)(id result))completion;


/**
 *  设置(修改)性别(08)
 *
 *  @param userId     用户id
 *  @param sex        性别。0女；1男
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithUserUpdateUserSex:(NSInteger)userId sex:(NSInteger)sex completion:(void(^)(id result))completion;

/**
 *  设置(修改)昵称(09)
 *
 *  @param userId     用户id
 *  @param nickName   昵称
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithUserUpdateNikeName:(NSInteger)userId nickName:(NSString *)nickName completion:(void(^)(id result))completion;


/**
 *  设置(修改)姓氏名称(10)
 *
 *  @param userId     用户id
 *  @param familyName 姓氏
 *  @param name       名
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithUserUpdateuserName:(NSInteger)userId familyName:(NSString *)familyName name:(NSString *)name completion:(void(^)(id result))completion;


/**
 *  设置用户最后管理的餐厅id（11）
 *
 *  @param userId     用户id
 *  @param shopId     餐厅id
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithUserSetShop:(NSInteger)userId shopId:(NSInteger)shopId completion:(void(^)(id result))completion;

/**
 *  用户注册(12)
 *
 *  @param mobile     手机号码
 *  @param smscode    手机验证码
 *  @param smschannel 短信通道。1表示注册
 *  @param password   密码
 *  @param completion block
 *
 *  @return dt
 */
//+ (NSURLSessionDataTask *)requestWithUserRegister:(NSString *)mobile smscode:(NSString *)smscode smschannel:(NSInteger)smschannel password:(NSString *)password completion:(void(^)(id result))completion;

/**
 *  App登录接口(13)
 *
 *  @param mobile     手机号码
 *  @param password   密码
 *  @param completion block
 *
 *  @return dt
 */
//+ (NSURLSessionDataTask *)requestWithUserLogin:(NSString *)mobile password:(NSString *)password completion:(void(^)(id result))completion;

/**
 *  获取用户信息(14)
 *
 *  @param userId     用户id
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithUserInfo:(NSInteger)userId completion:(void(^)(id result))completion;

#pragma mark -
#pragma mark 餐厅分类配置接口
/**
 *  获取餐厅菜系口味信息接口(01)
 *
 *  @param id_        1获取菜系口味数据；2获取菜系数据；3获取口味数据；4获取餐厅分类数据
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithShopClassifyConfig:(NSInteger)id_ completion:(void(^)(id result))completion;

#pragma mark -
#pragma mark 商圈相关接口
/**
 *  根据城市id获取商圈信息列表(01)
 *
 *  @param cityId     城市id
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithMallCityId:(NSInteger)cityId completion:(void(^)(id result))completion;

/**
 *  根据城市id获取商圈筛选配置数据(02)
 *
 *  @param cityId     城市id
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithMallNearby:(NSInteger)cityId completion:(void(^)(id result))completion;

#pragma mark -
#pragma mark 城市信息接口
/**
 *  获取热门城市列表(01)
 *
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithCityHot:(void(^)(id result))completion;

/**
 *  查找城市信息(02)
 *
 *  @param cityName   城市名称
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithCitySearch:(NSString *)cityName completion:(void(^)(id result))completion;

#pragma mark -
#pragma mark 七牛上传相关接口
/**
 *  获取发帖上传图片的token
 *
 *  @param inputEnt 传入参数
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithUploadCommunityToken:(UploadFileInputObject *)inputEnt completion:(void(^)(id result))completion;

/**
 *  删除评论上传的图片(01)
 *
 *  @param imageId    图片id
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithUploadCommentDelete:(NSInteger)imageId completion:(void(^)(id result))completion;

/**
 *  获取评论相关图片上传的token(02)
 *
 *  @param inputEntity 传入参数
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithUploadCommentToken:(UploadFileInputObject *)inputEntity completion:(void(^)(id result))completion;

/**
 *  删除上传的菜品详情图片(03)
 *
 *  @param shopId     餐厅id
 *  @param imageUrl   菜品详情图片url
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithUploadFoodDetailsDelete:(NSInteger)shopId imageUrl:(NSString *)imageUrl completion:(void(^)(id result))completion;

/**
 *  获取菜品详情图片上传的token(04)
 *
 *  @param inputEntity 传入参数(shopId,imageurl,extname)
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithUploadFoodDetailsToken:(UploadFileInputObject *)inputEntity completion:(void(^)(id result))completion;

/**
 *  删除上传的菜品图片(05)
 *
 *  @param shopId     餐厅id
 *  @param imageUrl   图片url地址
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithUploadFoodDelete:(NSInteger)shopId imageUrl:(NSString *)imageUrl completion:(void(^)(id result))completion;

/**
 *  获取菜品图片上传的token(06)
 *
 *  @param inputEntity 传入参数(shopid,imageurl,extname)
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithUploadFoodToken:(UploadFileInputObject *)inputEntity completion:(void(^)(id result))completion;


/**
 *  删除上传的餐厅图片(07)
 *
 *  @param imageId    餐厅图片ID
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithUploadShopDelete:(NSInteger)imageId completion:(void(^)(id result))completion;

/**
 *  获取上传餐厅图片的token(08)
 *
 *  @param inputEntity 传入参数
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithUploadShopToken:(UploadFileInputObject *)inputEntity completion:(void(^)(id result))completion;

/**
 *  删除上传的用户头像(09)
 *
 *  @param userId     用户id
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithUploadUserDelete:(NSInteger)userId completion:(void(^)(id result))completion;

/**
 *  获取上传用户头像的token(10)
 *
 *  @param userId     用户id
 *  @param extName    上传文件的扩展名
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithUploadUserToken:(NSInteger)userId extName:(NSString *)extName completion:(void(^)(id result))completion;

#pragma mark -
#pragma mrakr 餐厅端【餐厅资质】V2.0

/**
 *  获取餐厅经营资质(01-2)
 *
 *  @param shopId 餐厅id
 *  @param completion block
 */
+ (NSURLSessionDataTask *)requestWithShopCertificate:(NSInteger)shopId completion:(void(^)(id result))completion;

/**
 *  保存资质
 *
 *  @param shopId 餐厅id
 *  @param userId 用户id
 */
+ (NSURLSessionDataTask *)requestWithShopSaveCertificate:(NSInteger)shopId userId:(NSInteger)userId completion:(void(^)(id result))completion;

/**
 *  添加餐厅经营资质(02-1)
 *
 *  @param inputEntity 传入参数
 */
+ (NSURLSessionDataTask *)requestWithShopLicenseAdd:(CTCShopLicenseInputEntity *)inputEntity completion:(void(^)(id result))completion;


#pragma mark -
#pragma mark 餐厅端【用户接口】V2.0

/**
 *  掌柜登录接口(01-6)
 *
 *  @param mobile     手机号码
 *  @param password   密码
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithUserLogin:(NSString *)mobile password:(NSString *)password completion:(void (^)(id result))completion;

/**
 *  员工登录接口(02-5)
 *
 *  @param shopId   餐厅id
 *  @param mobile     手机号码
 *  @param password   密码
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithUserEmployeeLogin:(NSInteger)shopId mobile:(NSString *)mobile password:(NSString *)password completion:(void (^)(id result))completion;

/**
 *  获取员工职位(03-4)
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithUserTitleGetUserTitles:(void (^)(id result))completion;

/**
 *  创建员工(04-3)
 *
 *  @param  inputEntity 参数
 *  @param  completion block
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithUserCreateEmployee:(ShopManageInputEntity *)inputEntity completion:(void (^)(id result))completion;

/**
 *  绑定身份(05-2)
 *
 *  @param userName 用户名
 *  @param identifyCard 身份证
 *  @param completion block
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithUserSetIdentity:(NSString *)userName identifyCard:(NSString *)identifyCard completion:(void (^)(id result))completion;

/**
 *  开店注册(06-1)
 *
 *  @param  mobile   手机号码
 *  @param  smscode 验证码
 *  @param  password 密码
 *
 */
+ (NSURLSessionDataTask *)requestWithUserRegister:(NSString *)mobile smscode:(NSInteger)smscode password:(NSString *)password completion:(void (^)(id result))completion;

/**
 *  获取用户信息(07-7)
 *
 *  @param  userId 用户id
 *  @param completion block
 */
+ (NSURLSessionDataTask *)requestWithUser:(NSInteger)userId completion:(void (^)(id result))completion;

/**
 *  获取餐厅所有员工信息(08-8)
 *
 *  @param shopId 餐厅id
 */
+ (NSURLSessionDataTask *)requestWithUserGetEmployeeList:(NSInteger)shopId completion:(void (^)(id result))completion;

/**
 *  获取所有职位和角色权限信息(09-10)
 *
 *  @param completion block
 */
+ (NSURLSessionDataTask *)requestWithUserGetTitleAndRoleConfigs:(void(^)(id result))completion;

/**
 *  修改员工信息(10-11)
 *
 *  @param inputEntity 传入参数
 *  @param completion block
 */
+ (NSURLSessionDataTask *)requestWithUserSetEmployee:(ShopManageInputEntity *)inputEntity completion:(void (^)(id result))completion;

/**
 *  删除员工(11-12)
 *
 *  @param userId 员工id
 *  @param type 1表示创建者、管理员；2表示普通员工
 *  @param completion block
 */
+ (NSURLSessionDataTask *)requestWithUserDeleteEmployee:(NSInteger)userId shopId:(NSInteger)shopId sellerId:(NSInteger)sellerId type:(NSInteger)type completion:(void (^)(id result))completion;

#pragma mark -
#pragma mark 餐厅端【订单接口】V2.0
/**
 *  餐厅创建订单(01-1)
 *
 *  @param inputEntity 传入参数
 *  @param completion block
 *
 */
+ (NSURLSessionDataTask *)requestWithShopOrderCreateOrder:(RestaurantReservationInputEntity *)inputEntity completion:(void (^)(id result))completion;

/**
 *  餐厅取消订单(02-2)
 *
 *  @param orderId 订单id
 *  @param reasonId 取消原因id
 *  @param mark 取消理由备注
 *  @param completion block
 */
+ (NSURLSessionDataTask *)requestWithShopOrderCancelOrder:(NSString *)orderId reasonId:(NSInteger)reasonId mark:(NSString *)mark completion:(void (^)(id result))completion;

/**
 *  修改餐桌和人数(03-3)
 *
 *  @param inputEntity 参数
 *  @param completion block
 *
 */
+ (NSURLSessionDataTask *)requestWithShopOrderChangeSeat:(RestaurantReservationInputEntity *)inputEntity completion:(void (^)(id result))completion;

/**
 *  修改订单金额(04-4)
 *
 *  @param inputEntity 参数
 *  @param completion block
 */
+ (NSURLSessionDataTask *)requestWithShopOrderChangeTotal:(OrderAmountModifyEntity *)inputEntity completion:(void (^)(id result))completion;

/**
 *  获取打印批次[获取订单打印菜品详情](05-5)
 *
 *  @param orderId 订单编号
 *  @param shopId 餐厅id
 *  @param completion block
 */
+ (NSURLSessionDataTask *)requestWithShopOrderGetPrintBatchFoods:(NSString *)orderId shopId:(NSInteger)shopId completion:(void (^)(id result))completion;

/**
 *  下单到厨房(06-6)
 *
 *  @param orderId 订单id
 *  @param shopId 餐厅id
 *  @param printId 打印机编号
 *  @param completion block
 */
+ (NSURLSessionDataTask *)requestWithShopOrderFoodToKitchen:(NSString *)orderId shopId:(NSInteger)shopId printId:(NSInteger)printId completion:(void(^)(id result))completion;

/**
 *  打印收银信息(07-7)
 *
 *  @param orderId 订单id
 *  @param shopId 餐厅id
 *  @param completion block
 */
+ (NSURLSessionDataTask *)requestWithShopOrderCashPrinter:(NSString *)orderId shopId:(NSInteger)shopId completion:(void(^)(id result))completion;

/**
 *  补打下单信息(08-8)
 *
 *  @param inputEntity 传入参数
 *  @param completion block
 *
 */
+ (NSURLSessionDataTask *)requestWithShopOrderPatchFoodToKitchen:(ShopPatchFoodInputEntity *)inputEntity completion:(void(^)(id result))completion;

/**
 *  加菜下单列表(09-9)
 *
 *  @param orderId    订单id
 *  @param shopId 餐厅
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithShopOrderWaitPrintFoods:(NSString *)orderId shopId:(NSInteger)shopId completion:(void(^)(id result))completion;

/**
 *  结束交易订单(10-10)
 *
 *  @param orderId 订单id
 *  @param payChannel 支付渠道 //0：支付宝 1：微信 2：现金 3：大众点评 4：美团 5：刷卡
 *  @param payWay 0线下；1线上
 *  @param completion block
 */
+ (NSURLSessionDataTask *)requestWithShopOrderCompleteOrder:(NSString *)orderId payChannel:(NSInteger)payChannel payWay:(NSInteger)payWay completion:(void(^)(id result))completion;

/**
 *  获取餐中订单餐桌信息(11-11)
 *
 *  @param shopId 餐厅id
 *  @param completion block
 */
+ (NSURLSessionDataTask *)requestWithShopOrderDiningSeats:(NSInteger)shopId completion:(void(^)(id result))completion;

/**
 *  餐中订单明细(12-12)
 *
 *  @param orderId 订单id
 *  @param shopId 餐厅id
 *  @param completion block
 */
+ (NSURLSessionDataTask *)requestWithShopOrderDiningDetails:(NSString *)orderId shopId:(NSInteger)shopId completion:(void(^)(id result))completion;

/**
 *  查询历史订单(13-13)
 *
 *  @param inputEntity 传入参数
 *  @param completion block
 */
+ (NSURLSessionDataTask *)requestWithShopOrderHistoryOrders:(CTCRestaurantHistoryOrderInputEntity *)inputEntity completion:(void(^)(id result))completion;

/**
 *  上菜/取消上菜(14-14)
 *
 *  @param inputEntity 传入参数
 *  @param completion block
 */
+ (NSURLSessionDataTask *)requestWithShopOrderDishUpDown:(CTCRestaurantDishUpDownFoodEntity *)inputEntity completion:(void(^)(id result))completion;

/**
 *  餐厅加菜(15-15)
 *
 *  @param foodEnt 传入参数
 *  @param completion block
 */
+ (NSURLSessionDataTask *)requestWithShopOrderAddFoods:(UpdateOrderFoodInputEntity *)foodEnt completion:(void(^)(id result))completion;

/**
 *  餐厅退菜(16-16)
 *
 *  @param inputEnt 传入参数
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithShopOrderReturnFoods:(UpdateOrderFoodInputEntity *)inputEnt completion:(void(^)(id result))completion;

/**
 *  获取支付渠道信息列表(17-17)
 *
 *  @param completion block
 */
+ (NSURLSessionDataTask *)requestWithShopOrderPayChannel:(void(^)(id result))completion;

/**
 *  订单详情(18-18)
 *
 *  @param orderId 订单id
 *  @param shopId 餐厅id
 */
+ (NSURLSessionDataTask *)requestWithShopOrderDetail:(NSString *)orderId shopId:(NSInteger)shopId completion:(void(^)(id result))completion;

/**
 *  取消订单原因列表(19-19)
 *
 */
+ (NSURLSessionDataTask *)requestWithShopOrderCancelReasons:(void(^)(id result))completion;

/**
 *  取消订单(20-20)
 */
+ (NSURLSessionDataTask *)requestWithShopOrderCancelOrder:(CancelReservationEntity *)inputEntity completion:(void(^)(id result))completion;


/**
 *  获取等待接单的订单列表
 *
 *  @param shopId 餐厅id
 *  @param completion block
 */
+ (NSURLSessionDataTask *)requestWithShopOrderWaitOrders:(NSInteger)shopId completion:(void(^)(id result))completion;

/**
 *  餐厅确认接单
 *
 *  @param orderId 订单id
 *  @param shopId 餐厅id
 *  @param completion block
 */
+ (NSURLSessionDataTask *)requestWithShopOrderAccept:(NSString *)orderId shopId:(NSInteger)shopId completion:(void(^)(id result))completion;


#pragma mark -
#pragma mark 餐厅【商户相关】

/**
 *  获取我管理的店(01-8)
 *
 *  @param userId 用户id
 */
+ (NSURLSessionDataTask *)requestWithSellerGetManageShop:(NSInteger)userId sellerId:(NSInteger)sellerId completion:(void(^)(id result))completion;

/**
 *  设置我管理的餐厅(02-7)
 *
 *  @param userId 用户id
 *  @param sellerId 商户id
 *  @param shopIds 管理的餐厅id，多个用逗号隔开
 */
+ (NSURLSessionDataTask *)requestWithSellerSetManageShop:(NSInteger)userId sellerId:(NSInteger)sellerId shopIds:(NSString *)shopIds completion:(void(^)(id result))completion;

/**
 *  获取管理员列表(03-6)
 *
 */
+ (NSURLSessionDataTask *)requestWithSellerGetManageList:(NSInteger)sellerId completion:(void(^)(id result))completion;

/**
 *  管理登陆(01-4)
 *
 *  @param mobile 手机号码
 *  @param password 密码
 */
+ (NSURLSessionDataTask *)requestWithSellerLogin:(NSString *)mobile password:(NSString *)password completion:(void(^)(id result))completion;

/**
 *  @brief 添加管理员(02-3)
 *
 *  @param sellerId 商户id
 *  @param mobile 手机号码
 *  @param shopIds 管理的餐厅id，多个用逗号隔开
 */
+ (NSURLSessionDataTask *)requestWithSellerCreateManager:(NSInteger)sellerId mobile:(NSString *)mobile shopIds:(NSString *)shopIds completion:(void(^)(id result))completion;

/**
 *  商户注册(03-1)
 *
 *  @param mobile 手机号码
 *  @param password 密码
 *  @param smscode 验证码
 */
+ (NSURLSessionDataTask *)requestWithSellerRegister:(NSString *)mobile password:(NSString *)password smscode:(NSInteger)smscode completion:(void(^)(id result))completion;


#pragma mark -
#pragma mark 外卖(外卖平台接单接口)

/**
 *  饿了么商户取消订单(拒单)
 *
 *  @param orderId 订单id
 *  @param reason 取消原因
 *  @param completion block
 *
 */
+ (NSURLSessionDataTask *)requestWithWaimaiCancelOrder:(NSString *)orderId reason:(NSString *)reason completion:(void(^)(id result))completion;

/**
 *  饿了么商户接单
 *
 *  @param orderId 订单Id
 *  @param completion block
 */
+ (NSURLSessionDataTask *)requestWithWaimaiConfirmOrder:(NSString *)orderId completion:(void(^)(id result))completion;

/**
 *  达达配送新增订单接口
 *
 *  @param input 传入参数
 *  @param completion block
 */
+ (NSURLSessionDataTask *)requestWithDadaAddOrder:(DaDaDistAddOrderInputEntity *)input completion:(void(^)(id result))completion;

/**
 *  取消达达 订单
 *
 *  @param sourceId 商户Id
 *  @param orderId 订单Id
 *  @param cancelReasonId 取消原因id
 *  @param cancelReason 取消原因
 *  @param completion block
 */
+ (NSURLSessionDataTask *)requestWithDadaCancelOrder:(NSString *)sourceId orderId:(NSString *)orderId cancelReasonId:(int)cancelReasonId cancelReason:(NSString *)cancelReason completion:(void(^)(id result))completion;

/**
 *  取消达达订单的条件(原因)
 *
 *  @param sourceId 商户Id
 *  @param completion block
 */
+ (NSURLSessionDataTask *)requestWithDadaCancelOrderReq:(NSString *)sourceId completion:(void(^)(id result))completion;

/**
 *  达达新增订单小费
 *
 *  @param tipEntity 传入参数
 *  @param completion block
 */
+ (NSURLSessionDataTask *)requestWithDadaAddTip:(DaDaDistAddOrderTipsEntity *)tipEntity completion:(void(^)(id result))completion;

@end



























