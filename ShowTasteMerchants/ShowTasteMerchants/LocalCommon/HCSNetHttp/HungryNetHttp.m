//
//  HungryNetHttp.m
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/16.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "HungryNetHttp.h"
#import "LocalCommon.h"
#import "TYZNetworkHTTP.h"
#import "HungryOrderDetailEntity.h" // 饿了么的订单详情
#import "HungryOrderStatusEntity.h"
#import "HungryBaseInfoObject.h"

@implementation HungryNetHttp

#pragma mark private methods

/**
 *  得到时间戳(秒)
 */
+ (NSString *)getCurrentTimeStamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval stamp = [date timeIntervalSince1970];
    
    return [NSString stringWithFormat:@"%.0f", stamp];
}

#pragma mark -
#pragma mark 美团
+ (NSString *)getMTGenSig:(NSDictionary *)param signKey:(NSString *)signKey
{
    NSString *str = [self concatWithParams:param platform:EN_ORDER_SOURCE_MEITUAN];
    NSString *strCode = [NSString stringWithFormat:@"%@%@", signKey, str];
    NSString *sha1 = [[strCode sha1String] lowercaseString];
    return sha1;
}

#pragma mark -
#pragma mark 饿了么

+ (NSString *)getGenSig:(NSDictionary *)param midUrl:(NSString *)mideUrl
{
    NSString *str = [self concatWithParams:param platform:EN_ORDER_SOURCE_ELE];
    
    NSString *url = [NSString stringWithFormat:@"%@%@/?%@%@", HungryBaseHttp, mideUrl, str, CONSUMER_SECRET];
    debugLog(@"url=%@", url);
    
    NSString *hexStr = [[[url dataUsingEncoding:NSUTF8StringEncoding] hexString] lowercaseString];
//    debugLog(@"hexStr=%@", hexStr);
    
    NSString *sha1 = [hexStr sha1String];
//    debugLog(@"sha1=%@", sha1);
    
    return sha1;
}

+ (NSString *)concatWithParams:(NSDictionary *)param platform:(NSInteger)platform
{
    NSMutableString *str = [[NSMutableString alloc] initWithCapacity:0];
    NSArray *keyArray = [param allKeys];
    NSArray *sortKeyArray = [keyArray sortedArrayUsingSelector:@selector(compare:)];
//    debugLog(@"keyArray=%@", keyArray);
//    debugLog(@"sortKeyArray=%@", sortKeyArray);
    
    for (NSString *key in sortKeyArray)
    {
        NSString *value = [NSString stringWithFormat:@"%@", param[key]];
        if (platform == EN_ORDER_SOURCE_ELE)
        {// 饿了么
            [str appendFormat:@"&%@=%@", [key stringByURLEncode], [value stringByURLEncode]];
        }
        else if (platform == EN_ORDER_SOURCE_MEITUAN)
        {// 美团
            [str appendFormat:@"%@%@", [key stringByURLEncode], [value stringByURLEncode]];
        }
    }
    if (platform == EN_ORDER_SOURCE_ELE)
    {// 饿了么
        NSString *conStr = [str substringFromIndex:1];
        
        return conStr;
    }
    else if (platform == EN_ORDER_SOURCE_MEITUAN)
    {// 美团
        return str;
    }
    return nil;
}

/**
 *  饿了么 基础请求
 *
 */
+ (NSURLSessionDataTask *)requestWithBasicDict:(NSDictionary *)param middleParam:(NSString *)middleParam requestStyle:(requestStyle)reqStyle completion:(void(^)(id result))completion
{
    NSMutableDictionary *mutParam = nil;
    if (param)
    {
        mutParam = [[NSMutableDictionary alloc] initWithDictionary:param];
    }
    else
    {
        mutParam = [NSMutableDictionary new];
    }
    // 加入系统参数
    mutParam[@"consumer_key"] = CONSUMER_KEY;
    mutParam[@"timestamp"] = [self getCurrentTimeStamp];
    
    // 签名
    NSString *gensig = [self getGenSig:mutParam midUrl:middleParam];
    mutParam[@"sig"] = gensig;
    NSString *httpurl = nil;
    NSDictionary *systemDict = @{@"consumer_key":mutParam[@"consumer_key"], @"timestamp":mutParam[@"timestamp"], @"sig":mutParam[@"sig"]};
        httpurl = [NSString stringWithFormat:@"%@%@/?%@", HungryBaseHttp, middleParam, [self concatWithParams:systemDict platform:EN_ORDER_SOURCE_ELE]];
    debugLog(@"requestUrl=%@", httpurl);
    NSDictionary *httpDict = nil;
    NSURLSessionDataTask *dataTask = [TYZNetworkHTTP requestWithURL:httpurl param:param httpHead:httpDict responseStyle:WYXJSON requestStyle:reqStyle completion:completion];
    return dataTask;
}


/**
 *  美团 基础请求
 *
 */
+ (NSURLSessionDataTask *)requestWithMTBasicDict:(NSDictionary *)param middleParam:(NSString *)middleParam requestStyle:(requestStyle)reqStyle completion:(void(^)(id result))completion
{
    NSMutableDictionary *mutParam = nil;
    if (param)
    {
        mutParam = [[NSMutableDictionary alloc] initWithDictionary:param];
    }
    else
    {
        mutParam = [NSMutableDictionary new];
    }
    
    /*
     appAuthToken	认领门店返回的token【一店一token】	必须	系统级参数
     charset	交互数据的编码【建议UTF-8】	必须	系统级参数
     timestamp	当前请求的时间戳【单位是秒】	必须	系统级参数
     version	接口版本【默认是1】	非必须	系统级参数
     sign	请求的数字签名	必须	系统级参数
     orderId
     */
    
    // 加入系统参数
    mutParam[@"appAuthToken"] = @"abc";
    mutParam[@"charset"] = @"UTF-8";
    mutParam[@"timestamp"] = [self getCurrentTimeStamp];
    mutParam[@"version"] = @"1";
    
    /*
     //api.open.cater.meituan.com/tuangou/coupon/queryById?
     timestamp=1470364890606
     appAuthToken=abc
     charset=UTF-8
     couponCode=012345678900
     */
    
//    http://api.open.cater.meituan.com/tuangou/coupon/queryById?appAuthToken=abc&charset=UTF-8&couponCode=012345678900&sign=a58428e011ffeb16b71b42c6dbe9c33ebdda20a1&timestamp=1470364890606&version=1
//    http://api.open.cater.meituan.com/tuangou/coupon/queryById?appAuthToken=abc&charset=UTF-8&couponCode=012345678900&sign=a58428e011ffeb16b71b42c6dbe9c33ebdda20a1&timestamp=1470364890606&version=1
    
    // 签名
    // getMTGenSig
    NSString *gensig = [self getMTGenSig:mutParam signKey:MTSignKey];
    mutParam[@"sign"] = gensig;
    NSString *httpurl = nil;
    NSDictionary *systemDict = @{@"appAuthToken":mutParam[@"appAuthToken"], @"timestamp":mutParam[@"timestamp"], @"sign":mutParam[@"sign"], @"charset":mutParam[@"charset"], @"version":mutParam[@"version"]};
    httpurl = [NSString stringWithFormat:@"%@%@?%@", MTBASEHTTP, middleParam, [self concatWithParams:systemDict platform:EN_ORDER_SOURCE_ELE]];
    debugLog(@"requestUrl=%@", httpurl);
    NSDictionary *httpDict = nil;
    NSURLSessionDataTask *dataTask = [TYZNetworkHTTP requestWithURL:httpurl param:param httpHead:httpDict responseStyle:WYXJSON requestStyle:reqStyle completion:completion];
    return dataTask;
}


#pragma mark -
#pragma mark private methods

/**
 *  美团测试
 */
+ (NSURLSessionDataTask *)requestWithMeiTuanTest
{
    debugMethod();
    // http://api.open.cater.meituan.com/tuangou/coupon/queryById?timestamp=1470364890606&appAuthToken= abc&charset=UTF-8&couponCode=012345678900
    NSDictionary *param = nil;//@{@"tp_id":@"123"};
    NSURLSessionDataTask *dataTask = [self requestWithMTBasicDict:param middleParam:@"tuangou/coupon/queryById" requestStyle:WYXGET completion:^(id result) {
        
    }];
    return dataTask;
}

+ (NSURLSessionDataTask *)requestWithTest:(NSInteger)shopId completion:(void(^)(id result))completion
{
    // https://www.ele.me/shop/25381
    NSDictionary *param = @{@"tp_id":@"123"};//@{@"restaurant_id":@"62028381", @"name":@"唐斌", @"weight":@"1.2", @"display_attribute":@"tangbin"};//@{@"restaurant_id":@"62028381", @"restaurant_name":@"饿了么开放平台测试"};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"restaurant/62028381/menu" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
//            MyFinanceTodayDataEntity *ent = [MyFinanceTodayDataEntity modelWithJSON:result.data];
//            result.data = ent;
        }
        
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  查询订单详情(/order/<eleme_order_id>/) 请求方式GET
 *
 *  @param elemeOrderId 饿了吗订单id
 *  @param tpId 0不显示第三方ID；1显示第三方ID
 *  @param completion block
 */
+ (NSURLSessionDataTask *)requestWithHungryOrderDetail:(NSInteger)elemeOrderId tpId:(NSInteger)tpId completion:(void(^)(id result))completion
{
//    debugLog(@"rderId=%lld", (long long)elemeOrderId);
//    http://v2.openapi.ele.me/order/101547084688647790/?consumer_key=4556922220&timestamp=1479370299570&sig=e903d85fb6ab2a3357d4e2ae46f8e3d91c6901b0
    NSDictionary *param = @{@"tp_id":@(tpId)};
    NSString *middleParam = [NSString stringWithFormat:@"order/%lld", (long long)elemeOrderId];
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:middleParam requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"orderDetailjson=%@", json);
        if (result.errcode == 200)
        {
            HungryOrderDetailEntity *orderDetilEnt = [HungryOrderDetailEntity modelWithJSON:result.data];
//            debugLog(@"order=%@", NSStringFromClass([orderDetilEnt class]));
            orderDetilEnt.detail.newgroups = [NSMutableArray new];
            orderDetilEnt.detail.newextra = [NSMutableArray new];
            HungryOrderDetailCategoryExtraEntity *extEnt = [HungryOrderDetailCategoryExtraEntity new];
            extEnt.name = @"商品总计";
            extEnt.price = orderDetilEnt.original_price;
            [orderDetilEnt.detail.newextra addObject:extEnt];
            if ([orderDetilEnt.detail.extra count] > 0)
            {
                [orderDetilEnt.detail.newextra addObjectsFromArray:orderDetilEnt.detail.extra];
            }
            
            extEnt = [HungryOrderDetailCategoryExtraEntity new];
            extEnt.name = @"包  装 费";
            extEnt.price = orderDetilEnt.package_fee;
            [orderDetilEnt.detail.newextra addObject:extEnt];
            
            extEnt = [HungryOrderDetailCategoryExtraEntity new];
            extEnt.name = @"配  送 费";
            extEnt.price = orderDetilEnt.deliver_fee;
            [orderDetilEnt.detail.newextra addObject:extEnt];
            
            extEnt = [HungryOrderDetailCategoryExtraEntity new];
            extEnt.name = @"配  送 费";
            extEnt.price = orderDetilEnt.deliver_fee;
            [orderDetilEnt.detail.newextra addObject:extEnt];
            float addHeight = [objectNull(orderDetilEnt.address) heightForFont:FONTSIZE_13 width:[[UIScreen mainScreen] screenWidth] - 20];
            orderDetilEnt.addressHeight = addHeight;
//            debugLog(@"add=%@", orderDetilEnt.address);
            NSMutableArray *groups = [NSMutableArray new];
            for (id list in orderDetilEnt.detail.group)
            {
                NSMutableArray *addList = [NSMutableArray new];
                for (id dict in list)
                {
                    HungryOrderFoodEntity *foodEnt = [HungryOrderFoodEntity modelWithJSON:dict];
                    [addList addObject:foodEnt];
                    [orderDetilEnt.detail.newgroups addObject:foodEnt];
                    if (foodEnt.garnish.count > 0)
                    {
                        [orderDetilEnt.detail.newgroups addObjectsFromArray:foodEnt.garnish];
                    }
                }
                if ([addList count] > 0)
                {
                    [groups addObject:addList];
                }
            }
            if ([groups count] > 0)
            {
                orderDetilEnt.detail.group = groups;
            }
            debugLog(@"detailEnt=%@", [orderDetilEnt modelToJSONString]);
            result.data = orderDetilEnt;
        }
        
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  美团订单详情
 *
 *  @param orderId 订单id
 */
+ (NSURLSessionDataTask *)requestWithMeiTuanOrderDetail:(NSInteger)orderId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"orderId":@(orderId)};
    NSString *middleParam = @"waimai/order/queryById";
    NSURLSessionDataTask *dataTask = [self requestWithMTBasicDict:param middleParam:middleParam requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"orderDetailjson=%@", json);
        
        if (result.errcode == respond_success)
        {
            id dict = result.data;
            HungryOrderDetailEntity *orderDetilEnt = [HungryOrderDetailEntity modelWithJSON:dict];
            HungryOrderDetailCategoryEntity *ent = [HungryOrderDetailCategoryEntity new];
            orderDetilEnt.detail = ent;
            NSMutableArray *group = [NSMutableArray new];
            NSArray *details = nil;
            if ([dict[@"detail"] isKindOfClass:[NSArray class]])
            {
                details = dict[@"detail"];
            }
            else if ([dict[@"detail"] isKindOfClass:[NSString class]])
            {
                details = [NSArray modelArrayWithJson:dict[@"detail"]];
            }
            for (id foodDict in details)
            {
                HungryOrderFoodEntity *foodEnt = [HungryOrderFoodEntity modelWithJSON:foodDict];
                [group addObject:foodEnt];
            }
            orderDetilEnt.detail.group = [NSArray arrayWithObject:group];
            
            NSArray *extrs = nil;
            if ([dict[@"extras"] isKindOfClass:[NSArray class]])
            {
                extrs = dict[@"extras"];
            }
            else if ([dict[@"extras"] isKindOfClass:[NSString class]])
            {
                extrs = [NSArray modelArrayWithJson:dict[@"extras"]];
            }
            NSMutableArray *extras = [NSMutableArray new];
            for (id extDict in extrs)
            {
                HungryOrderDetailCategoryExtraEntity *extraEnt = [HungryOrderDetailCategoryExtraEntity modelWithJSON:extDict];
                extraEnt.quantity = 1;
                [extras addObject:extraEnt];
            }
            orderDetilEnt.detail.extra = extras;
            
            
            
            orderDetilEnt.detail.newgroups = [NSMutableArray new];
            orderDetilEnt.detail.newextra = [NSMutableArray new];
            HungryOrderDetailCategoryExtraEntity *extEnt = [HungryOrderDetailCategoryExtraEntity new];
            extEnt.name = @"商品总计";
            extEnt.price = orderDetilEnt.original_price;
            [orderDetilEnt.detail.newextra addObject:extEnt];
            if ([orderDetilEnt.detail.extra count] > 0)
            {
                [orderDetilEnt.detail.newextra addObjectsFromArray:orderDetilEnt.detail.extra];
            }
            
            extEnt = [HungryOrderDetailCategoryExtraEntity new];
            extEnt.name = @"包  装 费";
            extEnt.price = orderDetilEnt.package_fee;
            [orderDetilEnt.detail.newextra addObject:extEnt];
            
            extEnt = [HungryOrderDetailCategoryExtraEntity new];
            extEnt.name = @"配  送 费";
            extEnt.price = orderDetilEnt.deliver_fee;
            [orderDetilEnt.detail.newextra addObject:extEnt];
            
            extEnt = [HungryOrderDetailCategoryExtraEntity new];
            extEnt.name = @"配  送 费";
            extEnt.price = orderDetilEnt.deliver_fee;
            [orderDetilEnt.detail.newextra addObject:extEnt];
            float addHeight = [objectNull(orderDetilEnt.address) heightForFont:FONTSIZE_13 width:[[UIScreen mainScreen] screenWidth] - 20];
            orderDetilEnt.addressHeight = addHeight;
            //            debugLog(@"add=%@", orderDetilEnt.address);
            
            for (id list in orderDetilEnt.detail.group)
            {
                [orderDetilEnt.detail.newgroups addObjectsFromArray:list];
            }
            
            debugLog(@"detailEnt=%@", [orderDetilEnt modelToJSONString]);
            result.data = orderDetilEnt;
            
            
            
            
        }
        
        
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  获取订单状态
 *
 *  @param orderId 订单id
 */
+ (NSURLSessionDataTask *)requestWithHungryOrderStatus:(NSInteger)orderId completion:(void(^)(id result))completion;
{
    NSDictionary *param = nil;
    NSString *middleParam = [NSString stringWithFormat:@"order/%lld/status", (long long)orderId];
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:middleParam requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        //        debugLog(@"requ.data=%@", NSStringFromClass([result.data class]));
        if (result.errcode == 200)
        {
            HungryOrderStatusEntity *orderStatusEnt = [HungryOrderStatusEntity modelWithJSON:result.data];
            result.data = orderStatusEnt;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  跟新餐厅营业信息
 *
 *  @param isOpen 是否营业：1表示营业；0表示不营业
 */
+ (NSURLSessionDataTask *)requestWithRestaurantBusinessStatus:(int)isOpen completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"is_open":@(isOpen)};
    NSString *middleParam = [NSString stringWithFormat:@"restaurant/%@/business_status", RESTAURANT_ID];
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:middleParam requestStyle:WYXPUT completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        //        debugLog(@"requ.data=%@", NSStringFromClass([result.data class]));
        if (result.errcode == 200)
        {
            /*
             {
             "code": 200,
             "data": null,
             "message": "ok",
             "request_id": "115bc4a55e3c4e9eaf3f1a111a3e7271"
             }
             */
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

@end

















