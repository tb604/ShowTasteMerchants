//
//  HungryNetHttp.h
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/16.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYZRespondDataEntity.h"

// 美团的signKey
#define MTSignKey @"ahu5xistw1ewteo"

// 美团请求地址
#define MTBASEHTTP @"http://api.open.cater.meituan.com/"


// http://v2.openapi.ele.me/order/101547084688647790/?consumer_key=4556922220&timestamp=1479370299570&sig=e903d85fb6ab2a3357d4e2ae46f8e3d91c6901b0
#define HungryBaseHttp @"http://v2.openapi.ele.me/" // http://v2.openapi.ele.me/
#define CONSUMER_KEY @"4556922220"
#define CONSUMER_SECRET @"877c6388aa36280d28fe91c7fe7f014b6c1239b1"
// 店铺id
#define RESTAURANT_ID @"1958636"
// 店铺名称
#define RESTAURANT_NAME @"好厨师测试"
//餐厅下单测试地址: https://www.ele.me/shop/25381


/**
 *  访问饿了吗服务端
 */
@interface HungryNetHttp : NSObject

/**
 *  美团测试
 */
+ (NSURLSessionDataTask *)requestWithMeiTuanTest;

+ (NSURLSessionDataTask *)requestWithTest:(NSInteger)shopId completion:(void(^)(id result))completion;

/**
 *  查询订单详情(/order/<eleme_order_id>/) 请求方式GET
 *
 *  @param elemeOrderId 饿了吗订单id
 *  @param tpId 0不显示第三方ID；1显示第三方ID
 *  @param completion block
 */
+ (NSURLSessionDataTask *)requestWithHungryOrderDetail:(NSInteger)elemeOrderId tpId:(NSInteger)tpId completion:(void(^)(id result))completion;

/**
 *  美团订单详情
 *
 *  @param orderId 订单id
 */
+ (NSURLSessionDataTask *)requestWithMeiTuanOrderDetail:(NSInteger)orderId completion:(void(^)(id result))completion;

/**
 *  获取订单状态
 *
 *  @param orderId 订单id
 */
+ (NSURLSessionDataTask *)requestWithHungryOrderStatus:(NSInteger)orderId completion:(void(^)(id result))completion;

/**
 *  跟新餐厅营业信息
 *
 *  @param isOpen 是否营业：1表示营业；0表示不营业
 */
+ (NSURLSessionDataTask *)requestWithRestaurantBusinessStatus:(int)isOpen completion:(void(^)(id result))completion;


@end

/*
 code = 1000;
 data = "<null>";
 message = "permission denied with food id 2345";
 "request_id" = 61d9620d3bb04f0db39daf955550a113;
 */
















