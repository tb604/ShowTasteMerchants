//
//  HCSNetHttp.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/20.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "HCSNetHttp.h"
#import "LocalCommon.h"
#import "TYZNetworkHTTP.h"
#import "OrderMealDataEntity.h" // 首页数据
#import "CuisineTypeDataEntity.h"
#import "UserLoginStateObject.h"
#import "ShopListDataEntity.h" // 餐厅列表实体类
#import "ShopTypeConfigDataEntity.h" // 餐厅分类配置信息
#import "ShowTypeDataEntity.h"
#import "UserLoginStateObject.h"
#import "ShopDetailDataEntity.h" // 餐厅详情
#import "QiNiuTokenObject.h" // 七牛token
#import "CuisineFlavorDataEntity.h"
#import "CityDataEntity.h"
#import "MallDataEntity.h"
#import "MallListDataEntity.h"
#import "MallRangDataEntity.h"
#import "RangDataEntity.h"
#import "RestaurantDetailDataEntity.h"
#import "ShopMouthDataEntity.h" // 餐厅档口信息
#import "ShopFoodDataEntity.h" // 菜品信息
#import "ShopFoodUnitDataEntity.h" // 菜品单位
#import "ShopFoodCategoryDataEntity.h" // 菜品分类信息
#import "OrderMealMainDataEntity.h" // 用户端，订餐首页entity
#import "OrderDataEntity.h" // 订单信息
#import "OrderDetailDataEntity.h" // 订单详情信息
#import "OrderAddFoodSupplyEntity.h"
#import "OrderCancelReasonEntity.h" // 取消原因
#import "CellCommonDataEntity.h"
#import "CommentInfoDataEntity.h"
#import "ShopPositionDataEntity.h"
#import "ShopManageDataEntity.h"
#import "ShopManagePositionAuthEntity.h"
#import "ShopSeatInfoEntity.h" // 餐厅位置信息
#import "MyWalletConsumeEntity.h" // 我的钱包的记录
#import "ShopPrinterEntity.h"
#import "OrderDiningSeatEntity.h" // 订单餐桌信息
#import "CTCRestaurantHistoryOrderInputEntity.h" // 历史订单的传入参数
#import "CTCRestaurantOrderHistoryEntity.h" // 历史订单数据
#import "CTCOrderDetailEntity.h"
#import "CTCShopLicenseDataEntity.h" // 资质审核数据
#import "ShopManageNewDataEntity.h" // 员工类
#import "CTCMealOrderDetailsEntity.h" // 餐中订单明细
#import "SVProgressHUD.h"

@implementation HCSNetHttp

#pragma mark private methods
+ (NSURLSessionDataTask *)requestWithBasicDict:(NSDictionary *)param middleParam:(NSString *)middleParam requestStyle:(requestStyle)reqStyle completion:(void(^)(id result))completion
{
    /*
     Userid
     Accesstoken
     
     */
    NSString *userId = objectNull([NSString stringWithFormat:@"%d", (int)[UserLoginStateObject getUserId]]);
    NSString *accessToken = objectNull([UserLoginStateObject getWithAccessToken]);
    if ([userId isEqualToString:@""] || [accessToken isEqualToString:@""])
    {
        debugLog(@"网络请求的header参数有问题。");
    }
    NSDictionary *httpDict = @{@"Userid":userId, @"Accesstoken":accessToken, @"Device":@"ios"};
    
    NSString *httpurl = [NSString stringWithFormat:@"%@%@", REQUESTBASICURL, middleParam];
    NSURLSessionDataTask *dataTask = [TYZNetworkHTTP requestWithURL:httpurl param:param httpHead:httpDict responseStyle:WYXJSON requestStyle:reqStyle completion:completion];
    return dataTask;
}


#pragma mark -
#pragma mark 报表(财务)Report -- 800000

/**
 *  订单日报首页汇总(01)
 *
 *  @param shopId 餐厅id
 *  @param date 日期
 *
 */
+ (NSURLSessionDataTask *)requestWithOrderReportDaySummary:(NSInteger)shopId date:(NSString *)date completion:(void(^)(id result))completion
{
    NSDictionary *param =@{@"shop_id":@(shopId), @"date":objectNull(date)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"OrderReport/DaySummary" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            MyFinanceTodayDataEntity *ent = [MyFinanceTodayDataEntity modelWithJSON:result.data];
            result.data = ent;
        }
        
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}



#pragma mark 消费详情 -- 700000

+ (void)addWithUserConsumeSpec:(MyWalletConsumeEntity *)ent consumeList:(NSMutableArray *)consumeList
{
//    debugLog(@"showDate=%@", ent.showDate);
    BOOL bRet = NO;
    for (MyWalletConsumeEntity *entity in consumeList)
    {
        if ([entity.showDate isEqualToString:ent.showDate])
        {
            [entity.subConsumeList addObject:ent];
            bRet = YES;
        }
    }
    
    if (!bRet)
    {
        ent.subConsumeList = [NSMutableArray array];
        MyWalletConsumeEntity *conEnt = [ent deepCopy];
        [ent.subConsumeList addObject:conEnt];
        [consumeList addObject:ent];
//        debugLog(@"count===%d", (int)[conEnt.subConsumeList count]);
    }
}

/**
 *  获取用户的消费详情(01)
 *
 *  @param userId     用户id
 *  @param category 分类 0全部；1收入；2支出
 *  @param pageIndex  pageindex
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithUserConsume:(NSInteger)userId category:(NSInteger)category pageIndex:(NSInteger)pageIndex completion:(void(^)(id result))completion
{
    NSDictionary *param =@{@"user_id":@(userId), @"category":@(category), @"page_index":@(pageIndex)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"UserConsume" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
//        NSString *json = [result modelToJSONString];
//        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            NSMutableArray *addList = [NSMutableArray new];
            for (id dict in result.data)
            {
                MyWalletConsumeEntity *ent = [MyWalletConsumeEntity modelWithJSON:dict];
                ent.showDate = [NSDate stringWithDateInOut:ent.create_datetime inFormat:@"yyyy-MM-dd HH:mm:ss" outFormat:@"yyy-MM"];
//                debugLog(@"showDate=%@", ent.showDate);
                [self addWithUserConsumeSpec:ent consumeList:addList];
            }
            if ([addList count] != 0)
            {
                result.data = addList;
            }
            else
            {
                result.data = nil;
                result.errcode = respond_nodata;
            }
        }
        
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}


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
//+ (NSURLSessionDataTask *)requestWithPushBind:(NSInteger)userId pUserId:(NSString *)pUserId channelId:(NSString *)channelId appId:(NSString *)appId completion:(void(^)(id result))completion
//{
//    NSDictionary *param =@{@"user_id":@(userId), @"push_user_id":objectNull(pUserId), @"device_channel_key":objectNull(channelId), @"push_app_id": objectNull(appId)};
//    debugLog(@"param=%@", [param modelToJSONString]);
//    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Push/Bind" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
//        NSString *json = [result modelToJSONString];
//        debugLog(@"jsonpush=%@", json);
//        if (completion)
//        {
//            completion(result);
//        }
//    }];
//    return dataTask;
//}

/**
 *  获取用户的推送绑定数据
 *
 *  @param userId     用户id
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithPush:(NSInteger)userId completion:(void(^)(id result))completion
{
    NSDictionary *param =@{@"user_id":@(userId)};
    //    debugLog(@"param=%@", [param modelToJSONString]);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Push" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"jsonpush=%@", json);
        if (result.errcode == respond_success)
        {
            /*
             "data": {
             "user_id": 1,
             "token": "AMqeGTFJEq6Ud/nmTmqs9zmGt4YFP2XH2y3VmF/mhACOneu13DJYmWAmmIrdbOOkpDAAaXjCRbl9RU8pVauf1Q=="
             }
             */
            NSString *ryToken = result.data[@"msg_token"];
            UserInfoDataEntity *userInfo = [UserLoginStateObject getUserInfo];
            userInfo.msg_token = ryToken;
            [UserLoginStateObject saveWithUserInfo:userInfo];
            result.data = ryToken;
        }
        else if (result.errcode == 200)
        {
            [UserLoginStateObject saveWithPhone:EUserUnlogin];
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}


#pragma mark 餐厅餐位接口

/**
 *  获取所有的餐位信息
 *
 *  @param shopId     餐厅id
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithShopSeatSetting:(NSInteger)shopId completion:(void(^)(id result))completion
{
    NSDictionary *param =@{@"shop_id":@(shopId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"ShopSeatSetting" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"seatjson=%@", json);
        if (result.errcode == respond_success)
        {
            NSMutableArray *addList = [NSMutableArray new];
            for (id dict in result.data)
            {
                ShopSeatInfoEntity *ent = [ShopSeatInfoEntity modelWithJSON:dict];
                [addList addObject:ent];
            }
            if ([addList count] != 0)
            {
                result.data = addList;
            }
            else
            {
                result.data = nil;
                result.errcode = respond_nodata;
            }
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  删除餐位信息
 *
 *  @param seatId     餐位id
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithShopSeatSettingDelete:(NSInteger)seatId completion:(void(^)(id result))completion
{
    NSDictionary *param =@{@"id":@(seatId)};
    debugLog(@"param=%@", [param modelToJSONString]);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"ShopSeatSetting/Delete" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  修改餐位
 *
 *  @param seatId     餐位id
 *  @param shopId     餐厅id
 *  @param name       餐位名称
 *  @param remark     餐位备注
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithShopSeatSettingSet:(NSInteger)seatId shopId:(NSInteger)shopId name:(NSString *)name remark:(NSString *)remark completion:(void(^)(id result))completion
{
    NSDictionary *param =@{@"id":@(seatId), @"shop_id":@(shopId), @"name":objectNull(name), @"remark":objectNull(remark)};
    //    debugLog(@"param=%@", [param modelToJSONString]);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"ShopSeatSetting/Set" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  新增餐位信息
 *
 *  @param shopId     餐厅id
 *  @param name       餐位名称
 *  @param remark     餐位备注
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithShopSeatSettingAdd:(NSInteger)shopId name:(NSString *)name remark:(NSString *)remark completion:(void(^)(id result))completion
{
    NSDictionary *param =@{@"shop_id":@(shopId), @"name":objectNull(name), @"remark":objectNull(remark)};
    //    debugLog(@"param=%@", [param modelToJSONString]);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"ShopSeatSetting/Add" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            id seatId = result.data[@"seat_id"];
            result.data = seatId;
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

#pragma mark 用户收藏餐厅接口

/**
 *  获取用户收藏的餐厅列表（01）
 *
 *  @param userId     用户id
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithUserFavoriteGetShopList:(NSInteger)userId completion:(void(^)(id result))completion
{
    NSDictionary *param =@{@"user_id":@(userId)};
    //    debugLog(@"param=%@", [param modelToJSONString]);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"UserFavorite/GetShopList" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            NSMutableArray *addList = [NSMutableArray new];
            for (id dict in result.data)
            {
                ShopListDataEntity *ent = [ShopListDataEntity modelWithJSON:dict];
                [addList addObject:ent];
            }
            if ([addList count] != 0)
            {
                result.data = addList;
            }
            else
            {
                result.data = nil;
                result.errcode = respond_nodata;
            }
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  获取用户收藏的餐厅（02）
 *
 *  @param userId     用户id
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithUserFavorite:(NSInteger)userId completion:(void(^)(id result))completion
{
    NSDictionary *param =@{@"user_id":@(userId)};
//    debugLog(@"param=%@", [param modelToJSONString]);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"UserFavorite" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            id list = result.data[@"favorites"];
            result.data = list;
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  取消收藏（02）
 *
 *  @param userId     用户id
 *  @param shopId     餐厅id
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithUserFavoriteCancel:(NSInteger)userId shopId:(NSInteger)shopId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"user_id":@(userId), @"shop_id":@(shopId)};
    debugLog(@"param=%@", [param modelToJSONString]);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"UserFavorite/Cancel" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"tangibn=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  添加收藏接口（03）
 *
 *  @param userId     用户id
 *  @param shopId     餐厅id
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithUserFavoriteAdd:(NSInteger)userId shopId:(NSInteger)shopId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"user_id":@(userId), @"shop_id":@(shopId)};
    debugLog(@"param=%@", [param modelToJSONString]);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"UserFavorite/Add" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"tangibn=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}


#pragma mark 餐厅搜索接口

/**
 *  获取热门搜索关键字(01)
 *
 *  @param cityId     城市id
 *  @param lat        纬度
 *  @param lng        经度
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithSearchHotKey:(NSInteger)cityId lat:(double)lat lng:(double)lng completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"city_id":@(cityId), @"lat":@(lat), @"lng":@(lng)};
//    debugLog(@"param=%@", [param modelToJSONString]);
        NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Search/HotKey" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
//            NSString *json = [result modelToJSONString];
//            debugLog(@"tangibn=%@", json);
//            if (result.errcode == respond_success)
//            {
//                
//            }
//            else
//            {
//                result.data = nil;
//            }
            if (completion)
            {
                completion(result);
            }
        }];
    return dataTask;
}

/**
 *  首页餐厅搜索接口(02)
 *
 *  @param inputEnt   传入参数
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithSearch:(ShopSearchInputEntity *)inputEnt completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"city_id":@(inputEnt.city_id), @"mall_id":@(inputEnt.mall_id), @"classify_ids":objectNull(inputEnt.classify_ids), @"lat":@(inputEnt.lat), @"lng":@(inputEnt.lng), @"distance":@(inputEnt.distance), @"key":objectNull(inputEnt.key), @"page_index":@(inputEnt.page_index)};
    debugLog(@"param=%@", [param modelToJSONString]);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Search" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"jsoneee=%@", json);
        if (result.errcode == respond_success)
        {
            NSMutableArray *addList = [NSMutableArray new];
            for (id dict in result.data)
            {
                ShopListDataEntity *shopEnt = [ShopListDataEntity modelWithJSON:dict];
                [addList addObject:shopEnt];
            }
            if ([addList count] != 0)
            {
                result.data = addList;
            }
            else
            {
                result.data = nil;
                result.errcode = respond_nodata;
            }
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}


#pragma  mark 支付相关接口
/**
 *  从服务端获取支付宝的签名信息(01)
 *
 *  @param orderNo    订单号
 *  @param name       商品名称
 *  @param body       商品详情
 *  @param money      金额
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithPayAlipayPayUrl:(NSString *)orderNo name:(NSString *)name body:(NSString *)body money:(NSString *)money completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"order_no":objectNull(orderNo), @"name":objectNull(name), @"body":objectNull(body), @"money":objectNull(money)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Pay/AlipayPayUrl" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            NSString *payUrl = result.data[@"payUrl"];
            result.data = payUrl;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

#pragma mark 对订单的评论接口
/**
 *  获取对某个餐厅的所有评论信息(01)
 *
 *  @param shopId     餐厅id
 *  @param pageIndex
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithComment:(NSInteger)shopId pageIndex:(NSInteger)pageIndex completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(shopId), @"page_index":@(pageIndex)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Comment" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            NSMutableArray *addList = [NSMutableArray new];
            for (id dict in result.data)
            {
//                ShopCommentDataEntity *ent= nil;
                CommentInfoDataEntity *ent = [CommentInfoDataEntity modelWithJSON:dict];
                CGFloat maxWidth = [[UIScreen mainScreen] screenWidth] - 15 - 30 - 10 - 15;
                CGFloat fontHeight = [UtilityObject mulFontHeights:ent.content font:FONTSIZE_15 maxWidth:maxWidth];
                ent.contentHeight = fontHeight;
                ent.imgWidth = (maxWidth - 8 * 2) / 3.0;
                
                [addList addObject:ent];
            }
            if ([addList count] != 0)
            {
                result.data = addList;
            }
            else
            {
                result.data = nil;
                result.errcode = respond_nodata;
            }
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  新增对订单的评论(02)
 *
 *  @param commentEnt 评论参数
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithCommentAdd:(CommentInputDataEntity *)commentEnt completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"user_id":@(commentEnt.userId), @"shop_id":@(commentEnt.shopId), @"order_id":objectNull(commentEnt.orderId), @"class_txt":[commentEnt.classList modelToJSONString], @"vote":@(commentEnt.vote), @"score1":@(commentEnt.score1), @"score2":@(commentEnt.score2), @"score3":@(commentEnt.score3), @"images":objectNull([commentEnt.images modelToJSONString]), @"content":objectNull(commentEnt.content)};
    
    debugLog(@"param=%@", [param modelToJSONString]);
//    return nil;
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Comment/Add" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

#pragma mark 餐厅端订单信息归档 (B端 Order)

/**
 *  获取支付渠道列表(01)
 *
 */
/*+ (NSURLSessionDataTask *)requestWithOrderPayChannel:(void(^)(id result))completion
{
    NSDictionary *param = nil;
    debugLog(@"param=%@", param);
    
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Order/PayChannel" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        BOOL isFirst = YES;
        if (result.errcode == respond_success)
        {
            NSMutableArray *addList = [NSMutableArray new];
            for (id dict in result.data)
            {
                PayChannelDataEntity *ent = [PayChannelDataEntity modelWithJSON:dict];
                if (isFirst)
                {
                    ent.isCheck = YES;
                    isFirst = NO;
                }
                if (ent.inUse == 1)
                {
                    [addList addObject:ent];
                }
            }
            if ([addList count] != 0)
            {
                result.data = addList;
            }
            else
            {
                result.data = nil;
                result.errcode = respond_nodata;
            }
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}*/

/**
 *  收银打印(01)
 *
 *  @param orderId    订单id
 *  @param shopId     餐厅id
 *  @param shopUserId 操作者id
 *  @param completion
 *
 *  @return
 */
/*+ (NSURLSessionDataTask *)requestWithOrderCashPrinter:(NSString *)orderId shopId:(NSInteger)shopId shopUserId:(NSInteger)shopUserId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"order_id":objectNull(orderId), @"shop_id":@(shopId), @"shop_user_id":@(shopUserId)};
    debugLog(@"param=%@", param);
    
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Order/CashPrinter" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}*/

/**
 *  餐厅退菜(01)
 *
 *  @param inputEnt
 *  @param completion
 *
 *  @return
 */
/*+ (NSURLSessionDataTask *)requestWithOrderDetailShopReturnFoods:(UpdateOrderFoodInputEntity *)inputEnt completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"order_id":objectNull(inputEnt.orderId), @"shop_id":@(inputEnt.shopId), @"detail_id":@(inputEnt.detailId), @"food_number":@(inputEnt.foodNumber)};
    debugLog(@"param=%@", param);
    
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"OrderDetail/ShopReturnFoods" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}*/

/**
 *  新增菜品下单打印列表(01)
 *
 *  @param orderId    订单id
 *  @param completion
 *
 *  @return
 */
/*+ (NSURLSessionDataTask *)requestWithOrderDetailWaitPrintFoods:(NSString *)orderId shopId:(NSInteger)shopId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"order_id":objectNull(orderId), @"shop_id":@(shopId)};
    debugLog(@"param=%@", param);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"OrderDetail/WaitPrintFoods" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        
        if (result.errcode == respond_success)
        {
            NSMutableArray *addList = [NSMutableArray new];
            for (id dict in result.data)
            {
                OrderFoodInfoEntity *orderEnt = [OrderFoodInfoEntity modelWithJSON:dict];
                [addList addObject:orderEnt];
            }
            if ([addList count] != 0)
            {
                result.data = addList;
            }
            else
            {
                result.data = nil;
                result.errcode = respond_nodata;
            }
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}*/

/**
 *  获取未接单列表(01)
 *
 *  @param shopId     餐厅id
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithOrderWaitProcessOrders:(NSInteger)shopId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(shopId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Order/WaitProcessOrders" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        
        if (result.errcode == respond_success)
        {
            NSMutableArray *addList = [NSMutableArray new];
//            wait_accept
            NSArray *acceptList = result.data[@"wait_accept"];
            for (id dict in acceptList)
            {
                OrderDataEntity *orderEnt = [OrderDataEntity modelWithJSON:dict];
                [addList addObject:orderEnt];
            }
            
            // wait_refund
            NSArray *refundList = result.data[@"wait_refund"];
            for (id dict in refundList)
            {
                OrderDataEntity *orderEnt = [OrderDataEntity modelWithJSON:dict];
                [addList addObject:orderEnt];
            }
            if ([addList count] != 0)
            {
                result.data = addList;
            }
            else
            {
                result.data = nil;
                result.errcode = respond_nodata;
            }
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  服务员确认订单金额(02)
 *
 *  @param orderId    订单编号
 *  @param shopid     餐厅id
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithOrderConfirmOrderAmount:(NSString *)orderId shopId:(NSInteger)shopid completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"order_id":objectNull(orderId), @"shop_id":@(shopid)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Order/ConfirmOrderAmount" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  餐厅服务员补打订单(03)
 *
 *  @param inputEntity
 *  @param completion
 *
 *  @return
 */
/*+ (NSURLSessionDataTask *)requestWithOrderPatchFoodToKitchen:(ShopPatchFoodInputEntity *)inputEntity completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"order_id":objectNull(inputEntity.orderId), @"shop_id":@(inputEntity.shopId), @"printer_id":@(inputEntity.printerId), @"batch_no":objectNull(inputEntity.batchNo)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Order/PatchFoodToKitchen" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}*/

/**
 *  获取订单打印菜品详情(04)
 *
 *  @param orderId    订单id
 *  @param shopId     餐厅id
 *  @param completion
 *
 *  @return
 */
/*+ (NSURLSessionDataTask *)requestWithOrderGetPrintBatchFoods:(NSString *)orderId shopId:(NSInteger)shopId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"order_id":objectNull(orderId), @"shop_id":@(shopId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Order/GetPrintBatchFoods" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"batchjson=%@", json);
        if (result.errcode == respond_success)
        {
            NSMutableArray *addList = [NSMutableArray new];
            for (id dict in result.data)
            {
//                PrintBatchDataEntity *ent = [PrintBatchDataEntity modelWithJSON:dict];
                ShopPrinterEntity *ent = [ShopPrinterEntity modelWithJSON:dict];
                [addList addObject:ent];
            }
            if ([addList count] != 0)
            {
                result.data = addList;
            }
            else
            {
                result.errcode = respond_nodata;
                result.data = nil;
            }
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}*/

/**
 *  餐厅服务员下单到厨房，让厨房开始做(05)
 *
 *  @param orderId    订单id
 *  @param shopId     餐厅id
 *  @param completion
 *
 *  @return
 */
/*+ (NSURLSessionDataTask *)requestWithOrderFoodToKitchen:(NSString *)orderId shopId:(NSInteger)shopId printId:(NSInteger)printId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"order_id":objectNull(orderId), @"shop_id":@(shopId), @"printer_id":@(printId)};
    debugLog(@"param=%@", [param modelToJSONString]);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Order/FoodToKitchen" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}*/

/**
 *  餐厅服务员修改支付金额(06)
 *
 *  @param inputEntity
 *  @param completion
 *
 *  @return
 */
/*+ (NSURLSessionDataTask *)requestWithOrderModifyAmount:(OrderAmountModifyEntity *)inputEntity completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"order_id":objectNull(inputEntity.orderId), @"shop_id":@(inputEntity.shopId), @"new_amount":@(inputEntity.newAmount), @"note":objectNull(inputEntity.note)};
    
//    debugLog(@"param=%@", [param modelToJSONString]);
//    return nil;
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Order/ModifyAmount" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}*/

/**
 *  检查订单是否线上支付完成(07)
 *
 *  @param orderId    订单id
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithOrderCheckPayOnline:(NSString *)orderId shopId:(NSInteger)shopId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"order_id":objectNull(orderId), @"shop_id":@(shopId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Order/CheckPayOnline" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            // pay_online 1线上支付；0未通过线上支付
            result.data = result.data[@"pay_online"];
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {// errorcode 0表示线上支付完成；1表示未完成线上支付
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  确认线上结束订单(08)
 *
 *  @param orderId    订单id
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithOrderOnlineFinish:(NSString *)orderId shopId:(NSInteger)shopId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"order_id":objectNull(orderId), @"shop_id":@(shopId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Order/OnlineFinish" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  确认线下结束订单(09)
 *
 *  @param orderId    订单id
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithOrderOfflineFinish:(NSString *)orderId shopId:(NSInteger)shopId payChannel:(NSInteger)payChannel completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"order_id":objectNull(orderId), @"shop_id":@(shopId), @"pay_channel":@(payChannel)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Order/OfflineFinish" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  餐厅加菜（10）
 *
 *  @param foodEnt d
 *  @param completion block
 *
 *  @return
 */
/*+ (NSURLSessionDataTask *)requestWithOrderDetailShopAddFoods:(UpdateOrderFoodInputEntity *)foodEnt completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"order_id":objectNull(foodEnt.orderId), @"content":objectNull(foodEnt.content), @"order_food_type":@(foodEnt.order_food_type), @"shop_id":@(foodEnt.shopId)};
    debugLog(@"param=%@", [param modelToJSONString]);
    
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"OrderDetail/ShopAddFoods" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}*/

/**
 *  服务员上菜后更新明细订单状态(11)
 *
 *  @param orderDetailId 订单明细编号
 *  @param orderId       订单号
 *  @param userId        顾客编号(顾客id)
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithOrderDish:(NSInteger)orderDetailId orderId:(NSString *)orderId userId:(NSInteger)userId shopId:(NSInteger)shopId dishType:(NSInteger)dishType completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"id":@(orderDetailId), @"order_id":objectNull(orderId), @"shop_id":@(shopId), @"dish_type":@(dishType)};
    debugLog(@"param=%@", [param modelToJSONString]);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"OrderDetail/Dish" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  顾客到店后餐厅分配餐桌(12)
 *
 *  @param orderId    订单编号
 *  @param seatNumber 餐桌编号
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithOrderAllocateSeatNumber:(ShopSeatNumberEntity *)inputEntity completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"order_id":objectNull(inputEntity.order_id), @"seat_number":objectNull(inputEntity.seat_number), @"shop_id":@(inputEntity.shop_id), @"cust_count":@(inputEntity.cust_count), @"seat_type":@(inputEntity.seat_type)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Order/AllocateSeatNumber" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  餐厅接单或拒单接口(13)
 *
 *  @param orderId    订单编号
 *  @param status     订单状态 2表示接单；400表示拒单
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithOrderShopAcceptRefuseBooking:(NSString *)orderId status:(NSInteger)status shopId:(NSInteger)shopId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"order_id":objectNull(orderId), @"status":@(status), @"shop_id":@(shopId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Order/ShopAcceptRefuseBooking" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  餐厅获取已完成订单(14)
 *
 *  @param inputEnt
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithOrderShopCompletedOrders:(OrderCompletedInputEntity *)inputEnt completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(inputEnt.shopId), @"dining_date":objectNull(inputEnt.diningDate), @"customer_name":objectNull(inputEnt.customerName), @"pageIndex":@(inputEnt.pageIndex)};
    debugLog(@"param=%@", [param modelToJSONString]);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Order/ShopCompletedOrders" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            id array = result.data[@"info"];
            NSMutableArray *addList = [NSMutableArray new];
            for (id dict in array)
            {
                OrderDataEntity *orderEnt = [OrderDataEntity modelWithJSON:dict];
                [addList addObject:orderEnt];
            }
            if ([addList count] != 0)
            {
                result.data = addList;
            }
            else
            {
                result.data = nil;
                result.errcode = respond_nodata;
            }
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  餐厅获取就餐中列表(15)
 *
 *  @param inputEnt (seat_number为空表示所有的，可以获取具体的)
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithOrderShopingOrders:(OrderCompletedInputEntity *)inputEnt completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(inputEnt.shopId), @"seat_number":objectNull(inputEnt.seat_number), @"customer_name":objectNull(inputEnt.customerName), @"pageIndex":@(inputEnt.pageIndex)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Order/ShopdiningOrders" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            id array = result.data[@"info"];
            NSMutableArray *addList = [NSMutableArray new];
            for (id dict in array)
            {
                OrderDataEntity *orderEnt = [OrderDataEntity modelWithJSON:dict];
                [addList addObject:orderEnt];
            }
            if ([addList count] != 0)
            {
                result.data = addList;
            }
            else
            {
                result.data = nil;
                result.errcode = respond_nodata;
            }
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  餐厅获取预订订单列表(16)
 *
 *  @param inputEnt
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithOrderShopBookOrders:(OrderCompletedInputEntity *)inputEnt completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(inputEnt.shopId), @"dining_date":objectNull(inputEnt.diningDate), @"status":@(inputEnt.status), @"customer_name":objectNull(inputEnt.customerName), @"pageIndex":@(inputEnt.pageIndex)};
    debugLog(@"param=%@", [param modelToJSONString]);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Order/ShopBookOrders" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            id array = result.data[@"info"];
            NSMutableArray *addList = [NSMutableArray new];
            for (id dict in array)
            {
                OrderDataEntity *orderEnt = [OrderDataEntity modelWithJSON:dict];
                [addList addObject:orderEnt];
            }
            if ([addList count] != 0)
            {
                result.data = addList;
            }
            else
            {
                result.data = nil;
                result.errcode = respond_nodata;
            }
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

#pragma mark 食客预订接口

/**
 *  取消预订订单是否退款提醒(01)
 *
 *  @param orderId
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithOrderCancelOrderTip:(NSString *)orderId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"order_id":objectNull(orderId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Order/CancelOrderTip" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  修改订单菜品，修改和添加菜品（02）
 *
 *  @param updateFood    传入参数
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithOrderDetailModifyFoodDetail:(UpdateOrderFoodInputEntity *)updateFood completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"user_id":@(updateFood.userId), @"order_id":objectNull(updateFood.orderId), @"shop_id":@(updateFood.shopId), @"order_type":@(updateFood.orderType), @"content":objectNull(updateFood.content), @"order_food_type":@(updateFood.order_food_type)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"OrderDetail/ModifyFoodDetail" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  即时就餐下单（03）
 *
 *  @param inputEntity 传入参数
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithOrderImmediate:(RestaurantReservationInputEntity *)inputEntity completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(inputEntity.shopId), @"content":objectNull(inputEntity.content)};
    debugLog(@"param=%@", [param modelToJSONString]);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Order/Immediate" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        // 返回的data是订单编号
        if (result.errcode == respond_success)
        {
            id orderId = result.data[@"order_id"];
            result.data = orderId;
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  查询退单原因（04）取消订单，使用的
 *
 *  @param completion （OrderCancelReasonEntity）
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithOrderShowReason:(void(^)(id result))completion
{
    NSDictionary *param = nil;
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Order/Showreason" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
//        NSString *json = [result modelToJSONString];
//        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            NSMutableArray *addList = [NSMutableArray new];
            NSInteger i = 0;
            for (id dict in result.data)
            {
                CellCommonDataEntity *ent = [CellCommonDataEntity modelWithJSON:dict];
                
                ent.subTitle = ent.title;
                ent.checkImgName = @"btn_diners_check_sel";
                ent.uncheckImgName = @"btn_diners_check_nor";
                if (i == 0)
                {
                    ent.isCheck = YES;
                }
                else
                {
                    ent.isCheck = NO;
                }
                
                [addList addObject:ent];
                i += 1;
//                debugLog(@"ent=%@", [ent modelToJSONString]);
            }
            
            CellCommonDataEntity *entity = [CellCommonDataEntity new];
            entity.title = @"其它原因";
            entity.subTitle = @"";
            entity.checkImgName = @"btn_diners_check_sel";
            entity.uncheckImgName = @"btn_diners_check_nor";
            entity.isCheck = NO;
            entity.tag = 0;
            [addList addObject:entity];
            
            if ([addList count] != 0)
            {
                result.data = addList;
            }
            else
            {
                result.data = nil;
                result.errcode = respond_nodata;
            }
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

+ (void)addWithList:(NSMutableArray *)list addEnt:(OrderFoodInfoEntity *)addEnt
{
    NSInteger index = -1;
    for (NSInteger i=[list count] - 1; i<[list count]; i--)
    {
        OrderFoodInfoEntity *ent = list[i];
        if (ent.food_id == addEnt.food_id)
        {
            index = i;
            break;
        }
    }
    if (index != -1)
    {
        [list insertObject:addEnt atIndex:index+1];
    }
    else
    {
        [list addObject:addEnt];
    }
}

/**
 *  查询订单主体明细信息(05)
 *
 *  @param orderId    订单id
 *  @param shopId     餐厅id
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithOrderShowWholeOrder:(NSString *)orderId shopId:(NSInteger)shopId  completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"order_id":objectNull(orderId), @"shop_id":@(shopId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Order/ShowWholeOrder" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            OrderDetailDataEntity *orderDetailEnt = [OrderDetailDataEntity modelWithJSON:result.data];
//            debugLog(@"deail.=%d", (int)[orderDetailEnt.details count]);
            NSMutableArray *foodBackList = [NSMutableArray new];
            NSMutableArray *addFoodList = [NSMutableArray new];
            for (OrderFoodInfoEntity *ent in orderDetailEnt.details)
            {
                if (ent.status == 2)
                {// 退菜
                    [foodBackList addObject:ent];
                }
                else
                {
                    [self addWithList:addFoodList addEnt:ent];
                }
            }
            
            for (OrderFoodInfoEntity *backEnt in foodBackList)
            {
                NSInteger index = -1;
                for (NSInteger i=[addFoodList count]-1; i<[addFoodList count]; i--)
                {
                    OrderFoodInfoEntity *adEnt = addFoodList[i];
                    if (adEnt.food_id == backEnt.food_id)
                    {
                        index = i;
                        break;
                    }
                }
                if (index != -1)
                {
                    [addFoodList insertObject:backEnt atIndex:index+1];
                }
            }
            
            orderDetailEnt.details = addFoodList;
            result.data = orderDetailEnt;
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

+ (NSURLSessionDataTask *)requestWithOrderShowWholeOrderTwo:(NSString *)orderId shopId:(NSInteger)shopId  completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"order_id":objectNull(orderId), @"shop_id":@(shopId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Order/ShowWholeOrder" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"orderDetailjson=%@", json);
        if (result.errcode == respond_success)
        {
            OrderDetailDataEntity *orderDetailEnt = [OrderDetailDataEntity modelWithJSON:result.data];
            orderDetailEnt.detailFoods = [NSMutableArray array];
            NSMutableArray *foodBackList = [NSMutableArray new];
            NSMutableArray *addFoodList = [NSMutableArray new];
            
            
            for (OrderFoodInfoEntity *ent in orderDetailEnt.details)
            {
                ent.allNumber = ent.number;
//                debugLog(@"name=%@; number=%d", ent.food_name, (int)ent.number);
                if (ent.status == NS_ORDER_FOOD_RETIRED_STATE)
                {// 退菜
                    [foodBackList addObject:ent];
                }
                else
                {
                    [self addWithList:addFoodList addEnt:ent];
                }
            }
//            debugLog(@"-----------------------------");
            
            for (OrderFoodInfoEntity *backEnt in foodBackList)
            {
                NSInteger index = -1;
                for (NSInteger i=[addFoodList count]-1; i<[addFoodList count]; i--)
                {
                    OrderFoodInfoEntity *adEnt = addFoodList[i];
                    if (adEnt.food_id == backEnt.food_id)
                    {
                        index = i;
                        break;
                    }
                }
                if (index != -1)
                {
                    [addFoodList insertObject:backEnt atIndex:index+1];
                }
            }
            
            NSMutableArray *newList = [NSMutableArray new];
            for (OrderFoodInfoEntity *foodEnt in addFoodList)
            {
                [self addWithOrderDetailFood:foodEnt foodList:newList];
            }
            
            orderDetailEnt.details = addFoodList;
            orderDetailEnt.detailFoods = newList;
            result.data = orderDetailEnt;
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

+ (void)addWithOrderDetailFood:(OrderFoodInfoEntity *)foodEnt foodList:(NSMutableArray *)foodList
{
    BOOL bRet = NO;
    for (OrderFoodInfoEntity *entity in foodList)
    {
        if (entity.food_id == foodEnt.food_id && [objectNull(entity.mode) isEqualToString:objectNull(foodEnt.mode)] && [objectNull(entity.taste) isEqualToString:objectNull(foodEnt.taste)])
        {
            foodEnt.isSub = YES;
//            entity.number += foodEnt.number;
            entity.allNumber += foodEnt.number;
            [entity.subFoods addObject:foodEnt];
            bRet = YES;
            break;
        }
        
    }
    if (!bRet)
    {
        OrderFoodInfoEntity *ent = [OrderFoodInfoEntity new];
        ent.id = foodEnt.id;
        ent.order_id = foodEnt.order_id;
        ent.food_id = foodEnt.food_id;
        ent.food_name = foodEnt.food_name;
        ent.category_id = foodEnt.category_id;
        ent.category_name = foodEnt.category_name;
        ent.number = foodEnt.number;
        ent.allNumber = foodEnt.allNumber;
        ent.unit = foodEnt.unit;
        ent.price = foodEnt.price;
        ent.activity_price = foodEnt.activity_price;
        ent.op_datetime = foodEnt.op_datetime;
        ent.status = foodEnt.status;
        ent.status_desc = foodEnt.status_desc;
        ent.type = foodEnt.type;
        ent.type_desc = foodEnt.type_desc;
        ent.mode = foodEnt.mode;
        ent.taste = foodEnt.taste;
        ent.isCheck = ent.isCheck;
        ent.isSub = YES;
//        debugLog(@"allNum=%d", (int)ent.allNumber);
        foodEnt.subFoods = [NSMutableArray array];
        [foodEnt.subFoods addObject:ent];
        [foodList addObject:foodEnt];
    }
}

/**
 *  订单列表查询（06）
 *
 *  @param inputEntity 传入参数
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithOrderGetOrders:(OrderListInputEntity *)inputEntity completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"cat_id":@(inputEntity.catId), @"pageindex":@(inputEntity.pageIndex), @"pagesize":@(inputEntity.pageSize)};
//    debugLog(@"param=%@", [param modelToJSONString]);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Order/GetOrders" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            id data = result.data[@"info"];
            NSMutableArray *addList = [[NSMutableArray alloc] initWithCapacity:0];
            for (NSDictionary *dict in data)
            {
                OrderDataEntity *orderEnt = [OrderDataEntity modelWithJSON:dict];
                [addList addObject:orderEnt];
            }
            if ([addList count] != 0)
            {
                result.data = addList;
            }
            else
            {
                result.data = nil;
                result.errcode = respond_nodata;
            }
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  查询订单基础信息（07）
 *
 *  @param orderId    订单id
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithOrderShow:(NSString *)orderId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"order_id":orderId};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Order/Show" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            OrderDataEntity *ent = [OrderDataEntity modelWithJSON:result.data];
            result.data = ent;
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  就餐预订，普通预订(08)
 *
 *  @param bookEnt    传入参数
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithOrderBooking:(RestaurantReservationInputEntity *)bookEnt completion:(void(^)(id result))completion
{
    NSString *date = [NSString stringWithFormat:@"%@ %@:00", bookEnt.dueDate, bookEnt.arriveShopTime];
    NSDictionary *param = @{@"shop_id":@(bookEnt.shopId), @"remark":objectNull(bookEnt.note), @"number":@(bookEnt.number), @"seat_type":@(bookEnt.shopLocation), @"dining_date":objectNull(date), @"content":objectNull(bookEnt.content)};
    debugLog(@"param=%@", param);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Order/Booking" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            id orderId = result.data[@"order_id"];
            result.data = orderId;
        }
//        else
//        {
//            result.data = nil;
//        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  取消普通预订订单(09)
 *
 *  @param cancelOrderEnt 传入参数
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithOrderCancelBookOrder:(CancelReservationEntity *)cancelOrderEnt completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"user_id":@(cancelOrderEnt.userId), @"order_id":objectNull(cancelOrderEnt.orderId), @"remark":objectNull(cancelOrderEnt.remark), @"reason":@(cancelOrderEnt.reason)};
    debugLog(@"param=%@", [param modelToJSONString]);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Order/CancelBookOrder" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

#pragma 餐厅管理接口

/**
 *  修改餐厅管理权限信息(01)
 *
 *  @param inputEnt   传入参数
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithManageSet:(ShopManageInputEntity *)inputEnt completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"id":@(inputEnt.id), @"shop_id":@(inputEnt.shopId), @"title":@(inputEnt.title), @"auth":@(inputEnt.auth), @"op_user_id":@(inputEnt.opUserId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Manage/Set" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  删除餐厅管理中的信息(02)
 *
 *  @param inputEnt
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithManageDelete:(ShopManageInputEntity *)inputEnt completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"id":@(inputEnt.id), @"shop_id":@(inputEnt.shopId), @"user_id":@(inputEnt.userId), @"op_user_id":@(inputEnt.opUserId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Manage/Delete" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  餐厅管理信息列表(03)
 *
 *  @param shopId
 *  @param completion (ShopManageDataEntity)
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithManage:(NSInteger)shopId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(shopId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Manage" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            NSMutableArray *addList = [NSMutableArray new];
            for (id dict in result.data)
            {
                ShopManageDataEntity *ent = [ShopManageDataEntity modelWithJSON:dict];
                [addList addObject:ent];
            }
            if ([addList count] != 0)
            {
                result.data = addList;
            }
            else
            {
                result.data = nil;
                result.errcode = respond_nodata;
            }
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  新增餐厅管理权限(04)
 *
 *  @param inputEnt
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithManageAdd:(ShopManageInputEntity *)inputEnt completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(inputEnt.shopId), @"mobile":objectNull(inputEnt.mobile), @"title":@(inputEnt.title), @"auth":@(inputEnt.auth), @"op_user_id":@(inputEnt.opUserId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Manage/Add" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  获取餐厅管理的职位配置数据(05)
 *
 *  @param completion (ShopPositionDataEntity)
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithManageConfigs:(void(^)(id result))completion
{
    NSDictionary *param = nil;
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Manage/Configs" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            ShopManagePositionAuthEntity *poauthEnt = [ShopManagePositionAuthEntity modelWithJSON:result.data];
            result.data = poauthEnt;
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

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
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithShopPrinterSet:(NSString *)content completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"content":objectNull(content)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"ShopPrinter/Set" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  根据餐厅id获取这个餐厅下所有未指定档口的菜品数据(02)
 *
 *  @param shopId     餐厅id
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithShopPrinterGetUnassortedFoods:(NSInteger)shopId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(shopId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"ShopPrinter/GetUnassortedFoods" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            NSMutableArray *addList = [NSMutableArray new];
            for (id dict in result.data)
            {
                ShopFoodDataEntity *foodEnt = [ShopFoodDataEntity modelWithJSON:dict];
                [addList addObject:foodEnt];
            }
            if ([addList count] != 0)
            {
                result.data = addList;
            }
            else
            {
                result.data = nil;
                result.errcode = respond_nodata;
            }
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  根据餐厅id获取所有档口数据(03)
 *
 *  @param shopId     餐厅id
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithShopPrinterGetPrinters:(NSInteger)shopId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(shopId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"ShopPrinter/GetPrinters" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
//        NSString *json = [result modelToJSONString];
//        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            NSMutableArray *addList = [NSMutableArray new];
            for (NSDictionary *dict in result.data)
            {
                ShopMouthDataEntity *entity = [ShopMouthDataEntity modelWithJSON:dict];
                [addList addObject:entity];
            }
            if ([addList count] > 0)
            {
                result.data = addList;
            }
            else
            {
                result.data = nil;
                result.errcode = respond_nodata;
            }
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  根据餐厅id获取所有档口及档口菜品数据(04)
 *
 *  @param shopId
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithShopPrinter:(NSInteger)shopId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(shopId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"ShopPrinter" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"mouthjson=%@", json);
//        debugLog(@"errorCode====%d", result.errcode);
        if (result.errcode == respond_success)
        {
            NSMutableArray *addList = [NSMutableArray new];
            for (NSDictionary *dict in result.data)
            {
                ShopMouthDataEntity *entity = [ShopMouthDataEntity modelWithJSON:dict];
                [addList addObject:entity];
            }
            if ([addList count] > 0)
            {
                result.data = addList;
            }
            else
            {
                result.data = nil;
                result.errcode = respond_nodata;
            }
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  根据档口类型获取档口数据(05)
 *
 *  @param shopId     餐厅id
 *  @param configType 档口类型(0普通类型；1总单；2传菜)
 *  @param seatName   餐位名称（桌号）
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithShopPrinterGetPrintersByConfigType:(NSInteger)shopId configType:(NSInteger)configType seatName:(NSString *)seatName completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(shopId), @"config_type":@(configType), @"seat_name":objectNull(seatName)};
    debugLog(@"param=%@", param);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"ShopPrinter/GetPrintersByConfigType" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            NSMutableArray *addList = [NSMutableArray new];
            for (NSDictionary *dict in result.data)
            {
                ShopMouthDataEntity *entity = [ShopMouthDataEntity modelWithJSON:dict];
                [addList addObject:entity];
            }
            if ([addList count] > 0)
            {
                result.data = addList;
            }
            else
            {
                result.data = nil;
                result.errcode = respond_nodata;
            }
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  获取未归档菜品数据（06） --H5
 *
 *  @param shopId     餐厅id
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithShopPrinterFree:(NSInteger)shopId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(shopId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"ShopPrinter/Free" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            NSMutableArray *addList = [NSMutableArray new];
            for (id dict in result.data)
            {
                ShopFoodDataEntity *foodEnt = [ShopFoodDataEntity modelWithJSON:dict];
                [addList addObject:foodEnt];
            }
            if ([addList count] != 0)
            {
                result.data = addList;
            }
            else
            {
                result.data = nil;
                result.errcode = respond_nodata;
            }
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  获取餐厅所有档口及档口的菜品数据(07) --H5
 *
 *  @param shopId     餐厅id
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithShopPrinterShow:(NSInteger)shopId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(shopId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"ShopPrinter/Show" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            NSMutableArray *addList = [NSMutableArray new];
            for (NSDictionary *dict in result.data)
            {
                ShopMouthDataEntity *entity = [ShopMouthDataEntity modelWithJSON:dict];
                [addList addObject:entity];
            }
            if ([addList count] > 0)
            {
                result.data = addList;
            }
            else
            {
                result.data = nil;
                result.errcode = respond_nodata;
            }
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}


#pragma mark 菜品相关接口

/**
 *  设置菜品上架(01)
 *
 *  @param foodId     菜品id
 *  @param shopId     餐厅id
 *  @param completion completion description
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithFoodPublish:(NSInteger)foodId shopId:(NSInteger)shopId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"food_id":@(foodId), @"shop_id":@(shopId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Food/Publish" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  菜品排序(02)
 *
 *  @param text       JSON字符串 {@"shop_id":8, "category_id":1, "content":[{"id":46}, {"id":43}, {"id":45}]}。shop_id餐厅id，cagegory_id菜品分类id，content需要排序的分类列表， id分类id
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithFoodSetSort:(NSString *)text completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"text":text};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Food/SetSort" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  设置菜品状态为删除(03)
 *
 *  @param foodId     菜品id
 *  @param shopId     餐厅id
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithFoodDelete:(NSInteger)foodId shopId:(NSInteger)shopId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"food_id":@(foodId), @"shop_id":@(shopId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Food/Delete" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  设置菜品状态为下线(04)
 *
 *  @param foodId     菜品id
 *  @param shopId     餐厅id
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithFoodOffline:(NSInteger)foodId shopId:(NSInteger)shopId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"food_id":@(foodId), @"shop_id":@(shopId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Food/Offline" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  获取餐厅菜品分类下的所有菜品信息(05)--餐厅端
 *
 *  @param shopId     餐厅id
 *  @param categoryId 餐厅菜品分类id
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithFoodGetFoods:(NSInteger)shopId categoryId:(NSInteger)categoryId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(shopId), @"category_id":@(categoryId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Food/Show" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            NSMutableArray *addList = [NSMutableArray new];
            for (NSDictionary *dict in result.data)
            {
                ShopFoodDataEntity *entity = [ShopFoodDataEntity modelWithJSON:dict];
                [addList addObject:entity];
            }
            if ([addList count] > 0)
            {
                result.data = addList;
            }
            else
            {
                result.data = nil;
                result.errcode = respond_nodata;
            }
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  获取餐厅菜品分类下的所有菜品信息(05) -- 食客端
 *
 *  @param shopId     餐厅id
 *  @param categoryId 餐厅菜品分类id
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithFoodGetUserFoods:(NSInteger)shopId categoryId:(NSInteger)categoryId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(shopId), @"category_id":@(categoryId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Food/Show" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            NSMutableArray *addList = [NSMutableArray new];
            for (NSDictionary *dict in result.data)
            {
                ShopFoodDataEntity *entity = [ShopFoodDataEntity modelWithJSON:dict];
                [addList addObject:entity];
            }
            if ([addList count] > 0)
            {
                result.data = addList;
            }
            else
            {
                result.data = nil;
                result.errcode = respond_nodata;
            }
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  获取餐厅菜品分类下的所有菜品信息(05)
 *
 *  @param shopId     餐厅id
 *  @param categoryId 餐厅菜品分类id
 *  @param completion
 *
 *  @return
 */
/*+ (NSURLSessionDataTask *)requestWithFoodShow:(NSInteger)shopId categoryId:(NSInteger)categoryId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(shopId), @"category_id":@(categoryId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Food/Show" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            NSMutableArray *addList = [NSMutableArray new];
            for (NSDictionary *dict in result.data)
            {
                ShopFoodDataEntity *entity = [ShopFoodDataEntity modelWithJSON:dict];
                [addList addObject:entity];
            }
            if ([addList count] > 0)
            {
                result.data = addList;
            }
            else
            {
                result.data = nil;
                result.errcode = respond_nodata;
            }
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}*/

/**
 *  修改菜品数据(06)
 *
 *  @param foodEntity 传入参数
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithFoodSet:(ShopFoodInputEntity *)foodEntity completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"food_id":@(foodEntity.foodId), @"shop_id":@(foodEntity.shopId), @"category_id":@(foodEntity.categoryId), @"printer_id":@(foodEntity.printerId), @"name":objectNull(foodEntity.name), @"mode":objectNull(foodEntity.mode), @"taste":objectNull(foodEntity.taste), @"intro":objectNull(foodEntity.intro), @"price":@(foodEntity.price), @"activity_price":@(foodEntity.activityPrice), @"unit":objectNull(foodEntity.unit), @"image":objectNull(foodEntity.image), @"remark":objectNull(foodEntity.remark), @"content":objectNull(foodEntity.content)};
    debugLog(@"param=%@", [param modelToJSONString]);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Food/Set" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  新增菜品数据(07)
 *
 *  @param foodEntity 菜品参数
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithFoodAdd:(ShopFoodInputEntity *)foodEntity completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(foodEntity.shopId), @"category_id":@(foodEntity.categoryId), @"printer_id":@(foodEntity.printerId), @"name":objectNull(foodEntity.name), @"mode":objectNull(foodEntity.mode), @"taste":objectNull(foodEntity.taste), @"intro":objectNull(foodEntity.intro), @"price":@(foodEntity.price), @"activity_price":@(foodEntity.activityPrice), @"unit":objectNull(foodEntity.unit), @"image":objectNull(foodEntity.image), @"remark":objectNull(foodEntity.remark), @"content":objectNull(foodEntity.content)};
    
    debugLog(@"param=%@", [param modelToJSONString]);
//    return nil;
    
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Food/Add" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        
        /*
         "data": {
         "food_id": 90
         }
         */
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  获取当前菜品详情(08)
 *
 *  @param foodId     菜品id
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithFood:(NSInteger)foodId completion:(void(^)(id result))completion
{
    NSDictionary *param =@{@"food_id":@(foodId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Food" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            ShopFoodDataEntity *entity = [ShopFoodDataEntity modelWithJSON:result.data];
            result.data = entity;
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

#pragma mark 菜品数量（单位）接口
/**
 *  获取菜品数量(单位)数据(01)
 *
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithFoodUnit:(void(^)(id result))completion
{
    NSDictionary *param = nil;
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"FoodUnit" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
//        NSString *json = [result modelToJSONString];
//        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            NSMutableArray *addList = [NSMutableArray new];
            for (NSDictionary *dict in result.data)
            {
                ShopFoodUnitDataEntity *entity = [ShopFoodUnitDataEntity modelWithJSON:dict];
                [addList addObject:entity];
            }
            if ([addList count] > 0)
            {
                result.data = addList;
            }
            else
            {
                result.data = nil;
                result.errcode = respond_nodata;
            }
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

#pragma mark 菜品分类接口

/**
 *  设置菜品分类为上线状态
 *
 *  @param foodCategoryId 菜品分类id
 *  @param shopId         餐厅id
 
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithFoodCategoryPublish:(NSInteger)foodCategoryId shopId:(NSInteger)shopId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"id":@(foodCategoryId), @"shop_id":@(shopId)};
    debugLog(@"param=%@", [param modelToJSONString]);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"FoodCategory/Publish" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  获取餐厅菜品分类以及分类下的菜品数据(02)--餐厅端
 *
 *  @param shopId     餐厅id
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithFoodCategoryGetFoodCategoryDetails:(NSInteger)shopId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(shopId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"FoodCategory/GetFoodCategoryDetails" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            NSMutableArray *addList = [NSMutableArray new];
            for (NSDictionary *dict in result.data)
            {
                ShopFoodCategoryDataEntity *ent = [ShopFoodCategoryDataEntity modelWithJSON:dict];
                [addList addObject:ent];
            }
            if ([addList count] > 0)
            {
                result.data = addList;
            }
            else
            {
                result.data = nil;
                result.errcode = respond_nodata;
            }
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  获取餐厅菜品分类以及分类下的菜品数据(02)--食客端
 *
 *  @param shopId     餐厅id
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithFoodCategoryGetUserFoodCategoryDetails:(NSInteger)shopId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(shopId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"FoodCategory/GetUserFoodCategoryDetails" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            NSMutableArray *addList = [NSMutableArray new];
            for (NSDictionary *dict in result.data)
            {
                ShopFoodCategoryDataEntity *ent = [ShopFoodCategoryDataEntity modelWithJSON:dict];
                [addList addObject:ent];
            }
            if ([addList count] > 0)
            {
                result.data = addList;
            }
            else
            {
                result.data = nil;
                result.errcode = respond_nodata;
            }
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  获取餐厅菜品分类以及分类下的菜品数据(02)
 *
 *  @param shopId     餐厅id
 *  @param completion
 *
 *  @return
 */
/*+ (NSURLSessionDataTask *)requestWithFoodCategoryDetails:(NSInteger)shopId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(shopId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"FoodCategory/Details" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            NSMutableArray *addList = [NSMutableArray new];
            for (NSDictionary *dict in result.data)
            {
                ShopFoodCategoryDataEntity *ent = [ShopFoodCategoryDataEntity modelWithJSON:dict];
                [addList addObject:ent];
            }
            if ([addList count] > 0)
            {
                result.data = addList;
            }
            else
            {
                result.data = nil;
                result.errcode = respond_nodata;
            }
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}
*/

/**
 *  菜品分类排序(03)
 *
 *  @param text       JSON字符串 {"shop_id":65,"content"[{"id":10}, {"id":8}, {"id":5}]}
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithFoodCategorySetSort:(NSString *)text completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"text":text};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"FoodCategory/SetSort" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  设置菜品分类信息(04)
 *
 *  @param inputEntity 菜品分类传入参数
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithFoodCategorySetCategory:(ShopFoodCategoryInputEntity *)inputEntity completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"id":@(inputEntity.categoryId), @"shop_id":@(inputEntity.shopid), @"name":objectNull(inputEntity.name), @"remark":objectNull(inputEntity.remark)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"FoodCategory/SetCategory" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  设置菜品分类为删除状态(05)
 *
 *  @param categoryId 菜品分类id
 *  @param shopId     餐厅id
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithFoodCategoryDelete:(NSInteger)categoryId shopId:(NSInteger)shopId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"id":@(categoryId), @"shop_id":@(shopId)};
    debugLog(@"param=%@", [param modelToJSONString]);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"FoodCategory/Delete" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  设置菜品分类为下线状态(06)
 *
 *  @param categoryId 菜品分类id
 *  @param shopId     餐厅id
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithFoodCategoryOffline:(NSInteger)categoryId shopId:(NSInteger)shopId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"id":@(categoryId), @"shop_id":@(shopId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"FoodCategory/Offline" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  新增菜品分类(07)
 *
 *  @param foodCategoryEnt 传入参数
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithFoodCategoryAdd:(ShopFoodCategoryInputEntity *)foodCategoryEnt completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(foodCategoryEnt.shopid), @"name":objectNull(foodCategoryEnt.name), @"remark":objectNull(foodCategoryEnt.remark)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"FoodCategory/Add" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            ShopFoodCategoryDataEntity *ent = [ShopFoodCategoryDataEntity modelWithJSON:result.data];
            result.data = ent;
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  获取餐厅菜品分类数据(08)--餐厅端
 *
 *  @param shopId     餐厅id
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithFoodCategoryGetFoodCategorys:(NSInteger)shopId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(shopId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"FoodCategory" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            NSMutableArray *addList = [NSMutableArray new];
            for (NSDictionary *dict in result.data)
            {
                ShopFoodCategoryDataEntity *ent = [ShopFoodCategoryDataEntity modelWithJSON:dict];
                [addList addObject:ent];
            }
            if ([addList count] > 0)
            {
                result.data = addList;
            }
            else
            {
                result.data = nil;
                result.errcode = respond_nodata;
            }
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  获取餐厅菜品分类数据(08)-- 食客端
 *
 *  @param shopId     餐厅id
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithFoodCategoryGetUserFoodCategorys:(NSInteger)shopId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(shopId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"FoodCategory" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            NSMutableArray *addList = [NSMutableArray new];
            for (NSDictionary *dict in result.data)
            {
                ShopFoodCategoryDataEntity *ent = [ShopFoodCategoryDataEntity modelWithJSON:dict];
                [addList addObject:ent];
            }
            if ([addList count] > 0)
            {
                result.data = addList;
            }
            else
            {
                result.data = nil;
                result.errcode = respond_nodata;
            }
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  获取餐厅菜品分类数据(08)
 *
 *  @param shopId     餐厅id
 *  @param completion
 *
 *  @return
 */
/*+ (NSURLSessionDataTask *)requestWithFoodCategory:(NSInteger)shopId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(shopId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"FoodCategory" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            NSMutableArray *addList = [NSMutableArray new];
            for (NSDictionary *dict in result.data)
            {
                ShopFoodCategoryDataEntity *ent = [ShopFoodCategoryDataEntity modelWithJSON:dict];
                [addList addObject:ent];
            }
            if ([addList count] > 0)
            {
                result.data = addList;
            }
            else
            {
                result.data = nil;
                result.errcode = respond_nodata;
            }
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}*/

#pragma mark 首页
/**
 *  获取app首屏数据、轮播数据、板块 推荐等(01)
 *
 *  @param lng        经度
 *  @param lat        纬度
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithHome:(double)lng lat:(double)lat completion:(void(^)(id result))completion
{
//    return nil;
    NSDictionary *param = @{@"lng":@(lng), @"lat":@(lat)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Home" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            OrderMealMainDataEntity *mainEntity = [OrderMealMainDataEntity new];
            mainEntity.platInfoList = [NSMutableArray array];
//            NSMutableArray *addList = [[NSMutableArray alloc] initWithCapacity:0];
            for (NSDictionary *dict in result.data)
            {
                OrderMealDataEntity *mealEnt = [OrderMealDataEntity modelWithJSON:dict];
                id content = dict[@"content"];
                if (mealEnt.broad_type == 1 || mealEnt.broad_type == 2)
                {// 轮播宣传
                    mealEnt.content = content;
                }
                else
                {
                    if ([content isKindOfClass:[NSArray class]])
                    {
                        NSMutableArray *addArray = [[NSMutableArray alloc] initWithCapacity:0];
                        for (NSDictionary *dict in content)
                        {
                            OrderMealContentEntity *cEnt = [OrderMealContentEntity modelWithJSON:dict];
                            [addArray addObject:cEnt];
                        }
                        mealEnt.content = addArray;
                    }
                    else if ([content isKindOfClass:[NSDictionary class]])
                    {
                        OrderMealContentEntity *cEnt = [OrderMealContentEntity modelWithJSON:content];
                        mealEnt.content = cEnt;
                    }
                }
//                debugLog(@"mealEnt=%@", [mealEnt modelToJSONString]);
//                [addList addObject:mealEnt];
                if (mealEnt.broad_type == 0)
                {
                    mainEntity.shareEntity = mealEnt;
                }
                else if (mealEnt.broad_type == 1)
                {// 轮播宣传
                    mainEntity.playBannerEntity = mealEnt;
                }
                else if (mealEnt.broad_type == 2)
                {// 欢迎语
                    mainEntity.welcomeLanEntity = mealEnt;
                }
                else if (mealEnt.broad_type == 3)
                {// 热卖美食
                    mainEntity.hotFoodEntity = mealEnt;
                }
                else if (mealEnt.broad_type == 4)
                {
                    [mainEntity.platInfoList addObject:mealEnt];
                }
                else if (mealEnt.broad_type == 5)
                {// 附近美食
                    mainEntity.nearFoodEntity = mealEnt;
                }
            }
            result.data = mainEntity;
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

#pragma mark 菜单分类相关-菜系口味
/**
 *  获取餐厅基本属性、餐厅菜系 特色 国际菜系 口味
 *
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithMenu:(void (^)(id))completion
{
    NSDictionary *param = nil;
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Menu" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
//        NSString *json = [result modelToJSONString];
//        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            /*NSMutableArray *addList = [[NSMutableArray alloc] initWithCapacity:0];
            for (NSDictionary *dict in result.data)
            {
                CuisineTypeDataEntity *ent = [CuisineTypeDataEntity modelWithJSON:dict];
                NSInteger maxNum = 0;
                for (CuisineContentDataEntity *contentEnt in ent.list)
                {
                    contentEnt.menu_nameWidth = [contentEnt.menu_name widthForFont:FONTSIZE_13 height:20];
                    contentEnt.menu_nameNum = [contentEnt.menu_name length];
                    if (contentEnt.menu_nameNum > maxNum)
                    {
                        maxNum = contentEnt.menu_nameNum;
                    }
                }
                ent.listMaxFontNum = maxNum;
                
                [addList addObject:ent];
//                debugLog(@"ent=%@", [ent modelToJSONString]);
            }
            if ([addList count] > 0)
            {
                result.data = addList;
            }
            else
            {
                result.data = nil;
                result.errcode = respond_nodata;
            }*/
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

#pragma mark 餐厅端接口(B端)

/**
 *  获取用户餐厅列表V2.0
 *
 *  @param userId 用户Id
 *
 */
+ (NSURLSessionDataTask *)requestWithShopGetShopListbyUserId:(NSInteger)userId sellerId:(NSInteger)sellerId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"seller_id":@(sellerId), @"user_id":@(userId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Shop/GetShopListByUserId" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"shoListjson=%@", json);
        if (result.errcode == respond_success)
        {
            NSMutableArray *addList = [NSMutableArray new];
            for (NSDictionary *dict in result.data)
            {
                ShopListDataEntity *ent = [ShopListDataEntity modelWithJSON:dict];
                [addList addObject:ent];
            }
            if ([addList count] > 0)
            {
                result.data = addList;
            }
            else
            {
                result.data = nil;
                result.errcode = respond_nodata;
            }
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  获取餐厅审核状态（20）
 *
 *  @param shopId     餐厅id
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithShopState:(NSInteger)shopId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(shopId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Shop/State" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        //        NSString *json = [result modelToJSONString];
        //        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            NSInteger state = [result.data[@"state"] integerValue];
            result.data = @(state);
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}


/**
 *  设置主厨师简介(02)
 *
 *  @param shopId     餐厅id
 *  @param intro      厨师简介
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithShopSetShopChefIntro:(NSInteger)shopId intro:(NSString *)intro completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(shopId), @"intro":intro};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Shop/SetTopChefIntro" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
//        NSString *json = [result modelToJSONString];
//        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  设置主厨师职称(03)
 *
 *  @param shopId     餐厅id
 *  @param title      主厨职称
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithShopSetShopChefTitle:(NSInteger)shopId title:(NSString *)title completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(shopId), @"title":title};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Shop/SetTopChefTitle" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
//        NSString *json = [result modelToJSONString];
//        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  设置厨师姓名(04)
 *
 *  @param shopId     餐厅id
 *  @param name       厨师姓名
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithShopSetShopChefName:(NSInteger)shopId name:(NSString *)name completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(shopId), @"name":name};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Shop/SetTopChefName" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
//        NSString *json = [result modelToJSONString];
//        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  设置餐厅支付账号信息(05)
 *
 *  @param shopId        餐厅id
 *  @param payType    支付类型
 *  @param payAccount 支付账号
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithShopSetPay:(NSInteger)shopId payType:(NSInteger)payType payAccount:(NSString *)payAccount completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(shopId), @"pay_type":@(payType), @"pay_account":payAccount};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Shop/SetPay" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
//        NSString *json = [result modelToJSONString];
//        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  设置餐厅首图(06)
 *
 *  @param shopId     餐厅id
 *  @param imageId    图片id
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithShopSetImage:(NSInteger)shopId imageId:(NSInteger)imageId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(shopId), @"image_id":@(imageId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Shop/SetImage" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
//        NSString *json = [result modelToJSONString];
//        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  设置餐厅所属商圈(07)
 *
 *  @param shopId     餐厅id
 *  @param areaId     行政区域id
 *  @param mallId     商圈id
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithShopsetMall:(NSInteger)shopId areaId:(NSInteger)areaId mallId:(NSInteger)mallId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(shopId), @"area_id":@(areaId), @"mall_id":@(mallId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Shop/SetMall" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
//        NSString *json = [result modelToJSONString];
//        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  设置餐厅地址(08)
 *
 *  @param shopId     餐厅id
 *  @param lng        经度
 *  @param lat        纬度
 *  @param address    餐厅地址
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithShopSetAddress:(NSInteger)shopId lng:(double)lng lat:(double)lat address:(NSString *)address completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(shopId), @"lng":@(lng), @"lat":@(lat), @"address":address};
    debugLog(@"param=%@", [param modelToJSONString]);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Shop/SetAddress" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  设置餐厅人均消费(09)
 *
 *  @param shopId     餐厅id
 *  @param average    餐厅人均消费
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithShopSetAverage:(NSInteger)shopId average:(NSInteger)average completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(shopId), @"average":@(average)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Shop/SetAverage" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
//        NSString *json = [result modelToJSONString];
//        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  修改餐厅简介(10)
 *
 *  @param shopId     餐厅id
 *  @param intro      餐厅简介
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithShopSetIntro:(NSInteger)shopId intro:(NSString *)intro completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(shopId), @"intro":intro};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Shop/SetIntro" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  修改餐厅联系方式(11)
 *
 *  @param shopId     餐厅id
 *  @param mobile     联系方式
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithShopSetMobile:(NSInteger)shopId mobile:(NSString *)mobile completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(shopId), @"mobile":mobile};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Shop/SetMobile" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
//        NSString *json = [result modelToJSONString];
//        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  修改餐厅标语(12)
 *
 *  @param shopId     餐厅id
 *  @param slogan     餐厅标语
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithShopSetSlogan:(NSInteger)shopId slogan:(NSString *)slogan completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(shopId), @"slogan":slogan};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Shop/SetSlogan" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
//        NSString *json = [result modelToJSONString];
//        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  修改餐厅名称(13)
 *
 *  @param shopId     餐厅id
 *  @param name       餐厅名称
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithShopSetName:(NSInteger)shopId name:(NSString *)name completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(shopId), @"name":name};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Shop/SetName" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
//        NSString *json = [result modelToJSONString];
//        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  新建餐厅(14)
 *
 *  @param newEntity  参数
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithShopCreate:(NSString *)content completion:(void(^)(id result))completion
{
//    NSDictionary *param = @{@"ids":newEntity.ids, @"user_id":@(newEntity.userId), @"address":newEntity.address, @"lng":@(newEntity.lng), @"lat":@(newEntity.lat), @"name":newEntity.name};
    NSDictionary *param = @{@"content":content};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Shop/Create" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  检查餐厅是否已经存在(15)
 *
 *  @param name       餐厅名字
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithShopCheckName:(NSString *)name completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"name":name};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Shop/CheckName" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  下架餐厅（16）
 *
 *  @param shopId     餐厅id
 *  @param userId     用户id
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithShopOffline:(NSInteger)shopId userId:(NSInteger)userId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(shopId), @"user_id":@(userId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Shop/Offline" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  取消发布(17)
 *
 *  @param shopId     餐厅id
 *  @param userId     用户id
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithShopRecover:(NSInteger)shopId userId:(NSInteger)userId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(shopId), @"user_id":@(userId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Shop/Recover" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  发布餐厅(18)
 *
 *  @param shopId     餐厅id
 *  @param userId     用户id
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithShopPublish:(NSInteger)shopId userId:(NSInteger)userId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(shopId), @"user_id":@(userId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Shop/Publish" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  餐厅详情(19)
 *
 *  @param shopid     餐厅id
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithShopShow:(NSInteger)shopid completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(shopid)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Shop/Show" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            RestaurantDetailDataEntity *detailEnt = [RestaurantDetailDataEntity modelWithJSON:result.data];
            detailEnt.details.shopId = shopid;
            detailEnt.hallImageList = [NSMutableArray array];
            detailEnt.roomImageList = [NSMutableArray array];
            detailEnt.shopImages = [NSMutableArray array];
            
            for (RestaurantImageEntity *imageEnt in detailEnt.images)
            {
                if (imageEnt.type == EN_UPLOAD_IMAGE_SHOP_FIRST)
                {// 餐厅首图 1张
                    debugLog(@"餐厅首图 1张");
                    detailEnt.mainImageEntity = imageEnt;
                    
                    
                    BOOL isExists = NO;
                    
                    for (RestaurantImageEntity *empEnt in detailEnt.shopImages)
                    {
                        if (empEnt.type == imageEnt.type)
                        {
                            isExists = YES;
                            break;
                        }
                    }
                    if (!isExists)
                    {
                        [detailEnt.shopImages addObject:imageEnt];
                    }
                }
                else if (imageEnt.type == EN_UPLOAD_IMAGE_SHOP_HALL)
                {// 餐厅大厅图 2张
                    debugLog(@"餐厅大厅图 2张");
                    [detailEnt.hallImageList addObject:imageEnt];
                    [detailEnt.shopImages addObject:imageEnt];
                }
                else if (imageEnt.type == EN_UPLOAD_IMAGE_SHOP_ROOMS)
                {// 餐厅包间图  2张
                    debugLog(@"餐厅包间图  2张");
                    [detailEnt.roomImageList addObject:imageEnt];
                    [detailEnt.shopImages addObject:imageEnt];
                }
                else if (imageEnt.type == EN_UPLOAD_IMAGE_SHOP_LANDSCAPE)
                {// 餐厅景观图 1张
                    debugLog(@"餐厅景观图 1张");
                    detailEnt.landscapeImageEntity = imageEnt;
                    [detailEnt.shopImages addObject:imageEnt];
                }
                else if (imageEnt.type == EN_UPLOAD_IMAGE_BUSINESS_LICENSE)
                {// 餐厅营业执照 1张
                    detailEnt.busLicImageEntity = imageEnt;
                }
                else if (imageEnt.type == EN_UPLOAD_IMAGE_BUSINESS_CERTIFICATE)
                {// 餐厅经营许可证 1张
                    detailEnt.busCertImageEntity = imageEnt;
                }
                else if (imageEnt.type == EN_UPLOAD_IMAGE_FIRESAFETY_CERTIFICATE)
                {// 餐厅消防安全证 1张
                    detailEnt.fireSafeImageEntity = imageEnt;
                }
                else if (imageEnt.type == EN_UPLOAD_IMAGE_HEALTH_CERTIFICATE_ONE)
                {// 餐厅从业人员健康证1
                    detailEnt.HealthCertOneImageEntity = imageEnt;
                }
                else if (imageEnt.type == EN_UPLOAD_IMAGE_HEALTH_CERTIFICATE_TWO)
                {// 餐厅从业人员健康证2
                    detailEnt.HealthCertTwoImageEntity = imageEnt;
                }
            }
            
            // 餐厅首图 1张
            if (!detailEnt.mainImageEntity)
            {
                RestaurantImageEntity *ent = [RestaurantImageEntity new];
                ent.type = EN_UPLOAD_IMAGE_SHOP_FIRST;
                detailEnt.mainImageEntity = ent;
            }
            
            // 餐厅大厅图 2张
            if ([detailEnt.hallImageList count] == 0)
            {
                RestaurantImageEntity *ent = [RestaurantImageEntity new];
                ent.type = EN_UPLOAD_IMAGE_SHOP_HALL;
                [detailEnt.hallImageList addObject:ent];
                ent = [RestaurantImageEntity new];
                ent.type = EN_UPLOAD_IMAGE_SHOP_HALL;
                [detailEnt.hallImageList addObject:ent];
            }
            else if ([detailEnt.hallImageList count] == 1)
            {
                RestaurantImageEntity *ent = [RestaurantImageEntity new];
                ent.type = EN_UPLOAD_IMAGE_SHOP_HALL;
                [detailEnt.hallImageList addObject:ent];
            }
            
            // 餐厅包间图  2张
            if ([detailEnt.roomImageList count] == 0)
            {
                RestaurantImageEntity *ent = [RestaurantImageEntity new];
                ent.type = EN_UPLOAD_IMAGE_SHOP_ROOMS;
                [detailEnt.roomImageList addObject:ent];
                ent = [RestaurantImageEntity new];
                ent.type = EN_UPLOAD_IMAGE_SHOP_ROOMS;
                [detailEnt.roomImageList addObject:ent];
            }
            else if ([detailEnt.roomImageList count] == 1)
            {
                RestaurantImageEntity *ent = [RestaurantImageEntity new];
                ent.type = EN_UPLOAD_IMAGE_SHOP_ROOMS;
                [detailEnt.roomImageList addObject:ent];
            }
            
            // 餐厅景观图 1张
            if (!detailEnt.landscapeImageEntity)
            {
                RestaurantImageEntity *ent = [RestaurantImageEntity new];
                ent.type = EN_UPLOAD_IMAGE_SHOP_LANDSCAPE;
                detailEnt.landscapeImageEntity = ent;
            }
            
            // 餐厅营业执照 1张
            if (!detailEnt.busLicImageEntity)
            {
                RestaurantImageEntity *ent = [RestaurantImageEntity new];
                ent.type = EN_UPLOAD_IMAGE_BUSINESS_LICENSE;
                detailEnt.busLicImageEntity = ent;
            }
            
            // 餐厅经营许可证 1张
            if (!detailEnt.busCertImageEntity)
            {
                RestaurantImageEntity *ent = [RestaurantImageEntity new];
                ent.type = EN_UPLOAD_IMAGE_BUSINESS_CERTIFICATE;
                detailEnt.busCertImageEntity = ent;
            }
            
            // 餐厅消防安全证 1张
            if (!detailEnt.fireSafeImageEntity)
            {
                RestaurantImageEntity *ent = [RestaurantImageEntity new];
                ent.type = EN_UPLOAD_IMAGE_FIRESAFETY_CERTIFICATE;
                detailEnt.fireSafeImageEntity = ent;
            }
            
            // 餐厅从业人员健康证1
            if (!detailEnt.HealthCertOneImageEntity)
            {
                RestaurantImageEntity *ent = [RestaurantImageEntity new];
                ent.type = EN_UPLOAD_IMAGE_HEALTH_CERTIFICATE_ONE;
                detailEnt.HealthCertOneImageEntity = ent;
            }
            
            // 餐厅从业人员健康证2
            if (!detailEnt.HealthCertTwoImageEntity)
            {
                RestaurantImageEntity *ent = [RestaurantImageEntity new];
                ent.type = EN_UPLOAD_IMAGE_HEALTH_CERTIFICATE_TWO;
                detailEnt.HealthCertTwoImageEntity = ent;
            }
            
            
            result.data = detailEnt;
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}


/*
 EN_UPLOAD_IMAGE_SHOP_FIRST = 2000, ///< 餐厅首图 1张
 EN_UPLOAD_IMAGE_SHOP_HALL, ///< 餐厅大厅图 2张
 EN_UPLOAD_IMAGE_SHOP_ROOMS, ///< 餐厅包间图  2张
 EN_UPLOAD_IMAGE_SHOP_LANDSCAPE, ///< 餐厅景观图 1张
 EN_UPLOAD_IMAGE_CHEF_HEADER = 3000, ///< 厨师头像 1张
 EN_UPLOAD_IMAGE_BUSINESS_LICENSE = 4000, ///< 餐厅营业执照 1张
 EN_UPLOAD_IMAGE_BUSINESS_CERTIFICATE, ///< 餐厅经营许可证 1张
 EN_UPLOAD_IMAGE_FIRESAFETY_CERTIFICATE, ///< 餐厅消防安全证 1张
 EN_UPLOAD_IMAGE_HYGIENE_LICENSE,  ///< 餐厅卫生许可证 1张
 EN_UPLOAD_IMAGE_HEALTH_CERTIFICATE_ONE, ///< 餐厅从业人员健康证1
 EN_UPLOAD_IMAGE_HEALTH_CERTIFICATE_TWO, ///< 餐厅从业人员健康证2
 */

/*
 {
 "main": "[{"id":83,"name":"http:\/\/7xsdmx.com2.z0.glb.qiniucdn.com\/shop\/8\/20fb4cba-d5a1-7a1a-8cd8-3247d2dea9e4.jpg"}]",
 "food": "[{"id":169,"name":"http:\/\/7xsdmx.com2.z0.glb.qiniucdn.com\/shop\/8\/1d876f9b-7d18-03aa-c357-e0a0fa03adb5.jpg"},{"id":168,"name":"http:\/\/7xsdmx.com2.z0.glb.qiniucdn.com\/shop\/8\/66a60018-0fad-78e4-a28c-551c71f2e2d3.jpg"},{"id":167,"name":"http:\/\/7xsdmx.com2.z0.glb.qiniucdn.com\/shop\/8\/b18c1713-3461-f76c-f2a4-25bd66e04cfa.jpg"},{"id":84,"name":"http:\/\/7xsdmx.com2.z0.glb.qiniucdn.com\/shop\/8\/f368a3d8-ae6c-dfb0-ae96-798fb60c1015.jpg"},{"id":57,"name":"http:\/\/7xsdmx.com2.z0.glb.qiniucdn.com\/shop\/8\/49837d21-6620-9dc3-5761-4d8cca776a70.jpg"}]",
 "base": {
 "name": "江南秀色",
 "slogan": "特色美味，江南风味。",
 "mall_id": 0,
 "mall_name": "新街口/金轮",
 "address": "南京栖霞区",
 "mobile": "13761982589",
 "intro": "南京特色饮食",
 "vote": 1,
 "score1": 2,
 "score2": 3,
 "score3": 4,
 "average": 90,
 "comments": 1,
 "status": 2,
 "cx": "粤菜 特色饮食2",
 "kw": ""
 },
 "pay": {
 "pay_type": 1,
 "pay_account": "sdgb"
 },
 "chef": {
 "chef_image": "[{"id":80,"name":"http:\/\/7xsdmx.com2.z0.glb.qiniucdn.com\/shop\/8\/8-1462140994-c.jpg"}]",
 "chef_name": "左左",
 "chef_intro": "淮扬菜淮扬菜淮扬菜淮扬菜淮扬菜淮扬菜淮扬菜淮扬菜淮扬菜淮扬菜",
 "chef_title": ""
 },
 "auth": {
 "lic1": "[{"id":81,"name":"http:\/\/7xsdmx.com2.z0.glb.qiniucdn.com\/shop\/8\/8-1462141210-a.jpg"}]",
 "lic2": "[{"id":79,"name":"http:\/\/7xsdmx.com2.z0.glb.qiniucdn.com\/shop\/8\/8-1462140634-s.jpg"}]",
 "lic3": "[{"id":82,"name":"http:\/\/7xsdmx.com2.z0.glb.qiniucdn.com\/shop\/8\/8-1462141228-z.jpg"}]"
 }
 }

 */

#pragma mark 餐厅分类接口(ShopClass)
/**
 *  获取餐厅分类配置信息(01)
 *
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithShopClass:(void(^)(id result))completion
{
    NSDictionary *param = nil;
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"ShopClass" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        //        NSString *json = [result modelToJSONString];
        //        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            NSMutableArray *addList = [NSMutableArray new];
            for (NSDictionary *dict in result.data)
            {
                ShopTypeConfigDataEntity *ent = [ShopTypeConfigDataEntity modelWithJSON:dict];
                [addList addObject:ent];
            }
            if ([addList count] > 0)
            {
                result.data = addList;
            }
            else
            {
                result.data = nil;
                result.errcode = respond_nodata;
            }
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

#pragma mark 用户端接口(Shop C端)

/**
 *  获取用户所有餐厅列表信息(01)
 *
 *  @param userId     用户id
 *  @param completion
 *
 *  @return
 */
/*+ (NSURLSessionDataTask *)requestWithShopList:(NSInteger)userId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"user_id":@(userId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Shop/List" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        //        NSString *json = [result modelToJSONString];
        //        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            NSMutableArray *addList = [NSMutableArray new];
            for (NSDictionary *dict in result.data)
            {
                ShopListDataEntity *ent = [ShopListDataEntity modelWithJSON:dict];
                [addList addObject:ent];
            }
            if ([addList count] > 0)
            {
                result.data = addList;
            }
            else
            {
                result.data = nil;
                result.errcode = respond_nodata;
            }
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}*/

/**
 *  按条件搜索餐厅分类数据(02)
 *
 *  @param content    json ({"class_id":40001,"mall_id":0,"page_index":1,"classify":[{"id":10003},{"id":40001}]}
 
 class_id    分类ID
 mall_id     商圈ID
 page_index  当前页ID
 classify    菜系ID列表)
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithShopSearch:(NSString *)content completion:(void(^)(id result))completion
{
    NSDictionary *param = nil;
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Shop/ShowClass" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  获取餐厅预订页详情(03)
 *
 *  @param shopId     餐厅gid
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithShop:(NSInteger)shopId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(shopId)};
    debugLog(@"param=%@", param);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Shop" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            ShopDetailDataEntity *shopDetailEnt = [ShopDetailDataEntity modelWithJSON:result.data];
            shopDetailEnt.details.shopId = shopId;
            result.data = shopDetailEnt;
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

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
/*+ (NSURLSessionDataTask *)requestWithShopOpen:(NSString *)ids userId:(NSInteger)userId cityId:(NSInteger)cityId name:(NSString *)name completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"ids":ids, @"user_id":@(userId), @"city_id":@(cityId), @"name":name};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Shop/open" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        //        NSString *json = [result modelToJSONString];
        //        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}*/
// 上传餐厅图片信息		【暂未完全好】



/**
 *  修改商圈信息
 *
 *  @param shopId     餐厅id
 *  @param mallId     商圈id
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithShopUPdateShopMall:(NSInteger)shopId mallId:(NSInteger)mallId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(shopId), @"mall_id":@(mallId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Shop/UpdateShopMall" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        //        NSString *json = [result modelToJSONString];
        //        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}



/**
 *  修改人均消费金额
 *
 *  @param shopId     餐厅id
 *  @param percapita  人均消费金额
 *  @param completion
 *
 *  @return
 */
/*+ (NSURLSessionDataTask *)requestWithShopUpdateShopPercapita:(NSInteger)shopId percapita:(double)percapita completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(shopId), @"percapita":@(percapita)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Shop/updateShopPercapita" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        //        NSString *json = [result modelToJSONString];
        //        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}*/

/**
 *  添加菜品分类
 *
 *  @param shopId     餐厅id
 *  @param name       菜品分类名称
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithShopAddDishesCategory:(NSInteger)shopId name:(NSString *)name completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(shopId), @"name":name};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Shop/AddDishesCategory" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        //        NSString *json = [result modelToJSONString];
        //        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  添加菜品
 *
 *  @param entity     出入参数(shop_id, name, cid, intro, price, activity_price, images, remark)
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithShopAddDishes:(AddDishesInputEntity *)entity completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(entity.shopId), @"name":entity.name, @"cid":@(entity.cid), @"intro":entity.intro, @"price":@(entity.price), @"activity_price":@(entity.activityPrice), @"images":entity.images, @"remark":entity.remark};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Shop/AddDishes" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        //        NSString *json = [result modelToJSONString];
        //        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  新增餐位预订数据
 *
 *  @param entity     参数(shop_id, mealtime, seat_type, seat_number, reserve_total)
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithShopAddSeat:(AddSeatInputEntity *)entity completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(entity.shopId), @"mealtime":entity.mealtime, @"seat_type":entity.seatType, @"seat_number":@(entity.seatNumber), @"reserve_total":@(entity.reserveTotal)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Shop/AddSeat" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        //        NSString *json = [result modelToJSONString];
        //        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  获取餐位预订数据
 *
 *  @param shopId     餐厅id
 *  @param date       日期
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithShopGetSeats:(NSInteger)shopId date:(NSString *)date completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(shopId), @"date":date};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Shop/GetSeats" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        //        NSString *json = [result modelToJSONString];
        //        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  交换分类排序
 *
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithShopExchangeDishesCategorySort:(void(^)(id result))completion
{
    NSDictionary *param = nil;
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Shop/ExchangeDishesCategorySort" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        //        NSString *json = [result modelToJSONString];
        //        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  下架某分类
 *
 *  @param shopId     餐厅id
 *  @param completion 餐厅分类id
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithShopBanDishesCategory:(NSInteger)shopId categoryId:(NSInteger)categoryId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(shopId), @"category_id":@(categoryId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Shop/BanDishesCategory" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        //        NSString *json = [result modelToJSONString];
        //        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

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
/*+ (NSURLSessionDataTask *)requestWithShopSetShopMall:(NSInteger)shopId areaId:(NSInteger)areaId mallId:(NSInteger)mallId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(shopId), @"area_id":@(areaId), @"mall_id":@(mallId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Shop/setShopMall" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        //        NSString *json = [result modelToJSONString];
        //        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}*/

#pragma mark 短信
/**
 *  密码找回(更新为新密码) (01)
 *
 *  @param entity
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithSmsFindPassword:(UserUpdateInputEntity *)entity completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"uuid":entity.uuid, @"user_id":@([UserLoginStateObject getUserId]), @"mobile":entity.mobile, @"smscode":entity.smscode, @"password":entity.password, @"smschannel":@(entity.smschannel)};
    debugLog(@"param=%@", param);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Sms/FindPassword" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  绑定新手机(02)
 *
 *  @param inputEntity 传入的参数(uuid、userId、mobile、smscode、newmobile、newsmscode、smschannel)
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithSmsBindNewMobile:(UserUpdateInputEntity *)inputEntity completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"uuid":inputEntity.uuid, @"user_id":@(inputEntity.userId), @"mobile":inputEntity.mobile, @"smscode":inputEntity.smscode, @"new_mobile":inputEntity.newmobile, @"new_smscode":inputEntity.newsmscode, @"smschannel":@(inputEntity.smschannel)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Sms/BindNewMobile" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  短信验证码验证 (绑定手机第一步 验证当前手机、找回密码)(03)
 *
 *  @param mobile     手机号码
 *  @param smscode    验证码
 *  @param smschannel 短信渠道 1：注册 2：验证当前手机 号 3：绑定新手机号 4:找回密码
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithSmsVerifyCode:(NSString *)mobile smscode:(NSString *)smscode smschannel:(NSInteger)smschannel completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"mobile":mobile, @"smscode":smscode, @"smschannel":@(smschannel)};
    debugLog(@"param=%@", param);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Sms/VerifyCode" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"jsoncode=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}


/**
 *   发送验证码接口(04)
 *
 *  @param mobile     手机号码
 *  @param smschannel 渠道号 1：注册 2：验证当前手机 号 3：绑定新手机号 4:找回密码
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithSmsSendCode:(NSString *)mobile smschannel:(NSInteger)smschannel completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"mobile":mobile, @"smschannel":@(smschannel)};
    debugLog(@"param=%@", param);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Sms/SendCode" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        /*
         {
         "errcode": 0,
         "msg": "",
         "data": {
         "ts": 60
         }
         }
         */
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}







/**
 *  修改为新输入的密码
 *
 *  @param inputEntity 参数(uuid、userId、mobile、smscode、password、smschannel)
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithSmsFindPasswordAction:(UserUpdateInputEntity *)inputEntity completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"uuid":inputEntity.uuid, @"user_id":@(inputEntity.userId), @"mobile":inputEntity.mobile, @"smscode":inputEntity.smscode, @"password":inputEntity.password, @"smschannel":@(inputEntity.smschannel)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Sms/FindPasswordAction" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        //        NSString *json = [result modelToJSONString];
        //        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}



#pragma mark 用户属性等相关接口

/**
 * 获取用户这拿过户信息(01)
 *
 *  @param userId 用户id
 */
+ (NSURLSessionDataTask *)requestWithUserAccount:(NSInteger)userId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"user_id":@(userId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"User/Account" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            UserInfoDataEntity *ent = [UserInfoDataEntity modelWithJSON:result.data];
            result.data = ent;
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  获取圈子的授权token
 *
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithUserAuthorize:(void(^)(id result))completion
{
    NSDictionary *param = nil;
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"User/Authorize" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"authorizejson=%@", json);
        if (result.errcode == respond_success)
        {
            NSString *token = objectNull(result.data[@"token"]);
            double timestamp = [result.data[@"timestamp"] doubleValue];
            [UtilityObject saveWithCircleAuthorize:token timestamp:timestamp];
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  根据手机号获取用户姓名(01)
 *
 *  @param mobile     手机号
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithUserGetUserNameByMobile:(NSString *)mobile completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"mobile":objectNull(mobile)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"User/GetUserNameByMobile" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            id name = result.data[@"name"];
            result.data = name;
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  补填邀请码(02)
 *
 *  @param userId     用户id
 *  @param inviteCode 邀请码
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithUserSetInviteCode:(NSInteger)userId inviteCode:(NSString *)inviteCode completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"user_id":@(userId), @"invite_code":objectNull(inviteCode)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"User/SetInviteCode" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            // "invite_code": "xcrdxskj"
            NSString *code = result.data[@"invite_code"];
            result.data = code;
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  设置用户邮箱地址（03）
 *
 *  @param userId     用户id
 *  @param email      邮箱
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithUserSetEmail:(NSInteger)userId email:(NSString *)email completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"user_id":@(userId), @"email":objectNull(email)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"User/SetEmail" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
//        NSString *json = [result modelToJSONString];
//        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  (设置支付方式)修改支付渠道及账号(04)
 *
 *  @param userId     用户id
 *  @param payType    支付方式 0 微信 和 1 支付宝
 *  @param payAccount 支付账号
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithUserUpdatePay:(NSInteger)userId payType:(NSInteger)payType payAccount:(NSString *)payAccount completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"user_id":@(userId), @"pay_type":@(payType), @"pay_account":objectNull(payAccount)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"User/SetPay" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  设置(修改)身份证(05)
 *
 *  @param userId       用户id
 *  @param identityCard 身份证号
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithUserUpdateIdentityCard:(NSInteger)userId identityCard:(NSString *)identityCard completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"user_id":@(userId), @"card":identityCard};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"User/SetCard" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  设置(修改)用户登录密码(06)
 *
 *  @param userId     用户id
 *  @param mobile     手机号码
 *  @param password   旧密码
 *  @param newPassword 新密码
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithUserUpdateUserPassword:(NSInteger )userId mobile:(NSString *)mobile password:(NSString *)password newPassword:(NSString *)newPassword completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"user_id":@(userId), @"mobile":mobile, @"password":password, @"new_password":newPassword};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"User/SetPassword" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  设置用户出生年月日(07)
 *
 *  @param userId     用户id
 *  @param birthday   生日
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithUserUpdateUserBirthday:(NSInteger)userId birthday:(NSString *)birthday completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"user_id":@(userId), @"birthday":birthday};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"User/SetBirthday" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        //        NSString *json = [result modelToJSONString];
        //        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  设置(修改)性别(08)
 *
 *  @param userId     用户id
 *  @param sex        性别。0女；1男
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithUserUpdateUserSex:(NSInteger)userId sex:(NSInteger)sex completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"user_id":@(userId), @"sex":@(sex)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"User/SetSex" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  设置(修改)昵称(09)
 *
 *  @param userId     用户id
 *  @param nickName   昵称
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithUserUpdateNikeName:(NSInteger)userId nickName:(NSString *)nickName completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"user_id":@(userId), @"nikename":nickName};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"User/SetNikeName" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        //        NSString *json = [result modelToJSONString];
        //        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  设置(修改)姓氏名称(10)
 *
 *  @param userId     用户id
 *  @param familyName 姓氏
 *  @param name       名
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithUserUpdateuserName:(NSInteger)userId familyName:(NSString *)familyName name:(NSString *)name completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"user_id":@(userId), @"family_name":familyName, @"name":name};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"User/SetUserName" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}


/**
 *  设置用户最后管理的餐厅id（11）
 *
 *  @param userId     用户id
 *  @param shopId     餐厅id
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithUserSetShop:(NSInteger)userId shopId:(NSInteger)shopId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"user_id":@(userId), @"shop_id":@(shopId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"User/SetShop" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        //        NSString *json = [result modelToJSONString];
        //        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  用户注册(12)
 *
 *  @param mobile     手机号码
 *  @param smscode    手机验证码
 *  @param smschannel 短信通道。1表示注册
 *  @param password   密码
 *  @param completion
 *
 *  @return
 */
/*+ (NSURLSessionDataTask *)requestWithUserRegister:(NSString *)mobile smscode:(NSString *)smscode smschannel:(NSInteger)smschannel password:(NSString *)password completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"mobile":mobile, @"smscode":smscode, @"smschannel":@(smschannel), @"password":password};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"User/Register" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            UserInfoDataEntity *userInfo = [UserInfoDataEntity modelWithJSON:result.data];
            userInfo.password = password;
            result.data = userInfo;
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}*/


/**
 *  获取用户信息(14)
 *
 *  @param userId     用户id
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithUserInfo:(NSInteger)userId completion:(void(^)(id result))completion
{
    if (userId == 0)
    {
        return nil;
    }
//    return nil;
    NSDictionary *param = @{@"user_id":@(userId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"User" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"userjson=%@", json);
        // 077d7901c62581b86e7427a1cba88ebf
        if (result.errcode == respond_success)
        {
            // access_token
            UserInfoDataEntity *userInfo = [UserInfoDataEntity modelWithJSON:result.data];
            userInfo.password = [UserLoginStateObject getUserInfo].password;
            userInfo.userMode = [UserLoginStateObject getUserInfo].userMode;
            userInfo.shop_state = [UserLoginStateObject getUserInfo].shop_state;
            result.data = userInfo;
            [UserLoginStateObject saveWithUserInfo:userInfo];
            
            
            
        }
        else if (result.errcode == 200)
        {
            [UserLoginStateObject saveLoginState:EUserUnlogin];
//            [SVProgressHUD showWithStatus:result.msg];
            [SVProgressHUD showErrorWithStatus:result.msg];
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

#pragma mark 餐厅分类配置接口
/**
 *  获取餐厅菜系口味信息接口(01)
 *
 *  @param id_        1获取菜系口味数据；2获取菜系数据；3获取口味数据；4获取餐厅分类数据
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithShopClassifyConfig:(NSInteger)id_ completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"id":@(id_), @"device":@"ios"};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"ShopClassifyConfig" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            if (id_ == 4)
            {
                NSArray *list = result.data[@"content"];
                NSMutableArray *addList = [NSMutableArray new];
                for (id dict in list)
                {
                    OrderMealContentEntity *ent = [OrderMealContentEntity modelWithJSON:dict];
                    [addList addObject:ent];
                }
                if ([addList count] != 0)
                {
                    result.data = addList;
                }
                else
                {
                    result.data = nil;
                    result.errcode = respond_nodata;
                }
            }
            else
            {
                CuisineFlavorDataEntity *entity = [CuisineFlavorDataEntity modelWithJSON:result.data];
                if (entity.chuantong)
                {// 传统
                    NSInteger maxNum = 0;
                    for (CuisineContentDataEntity *contentEnt in entity.chuantong.content)
                    {
                        contentEnt.menu_nameWidth = [contentEnt.name widthForFont:FONTSIZE_13 height:20];
                        contentEnt.menu_nameNum = [contentEnt.name length];
                        if (contentEnt.menu_nameNum > maxNum)
                        {
                            maxNum = contentEnt.menu_nameNum;
                        }
                    }
                    entity.chuantong.listMaxFontNum = maxNum;
                }
                if (entity.tese)
                {// 特色
                    NSInteger maxNum = 0;
                    for (CuisineContentDataEntity *contentEnt in entity.tese.content)
                    {
                        contentEnt.menu_nameWidth = [contentEnt.name widthForFont:FONTSIZE_13 height:20];
                        contentEnt.menu_nameNum = [contentEnt.name length];
                        if (contentEnt.menu_nameNum > maxNum)
                        {
                            maxNum = contentEnt.menu_nameNum;
                        }
                    }
                    entity.tese.listMaxFontNum = maxNum;
                }
                if (entity.guoji)
                {// 国际
                    NSInteger maxNum = 0;
                    for (CuisineContentDataEntity *contentEnt in entity.guoji.content)
                    {
                        contentEnt.menu_nameWidth = [contentEnt.name widthForFont:FONTSIZE_13 height:20];
                        contentEnt.menu_nameNum = [contentEnt.name length];
                        if (contentEnt.menu_nameNum > maxNum)
                        {
                            maxNum = contentEnt.menu_nameNum;
                        }
                    }
                    entity.guoji.listMaxFontNum = maxNum;
                }
                if (entity.kouwei)
                {// 口味
                    NSInteger maxNum = 0;
                    for (CuisineContentDataEntity *contentEnt in entity.kouwei.content)
                    {
                        contentEnt.menu_nameWidth = [contentEnt.name widthForFont:FONTSIZE_13 height:20];
                        contentEnt.menu_nameNum = [contentEnt.name length];
                        if (contentEnt.menu_nameNum > maxNum)
                        {
                            maxNum = contentEnt.menu_nameNum;
                        }
                    }
                    entity.kouwei.listMaxFontNum = maxNum;
                }
                result.data = entity;
            }
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

#pragma mark 商圈相关接口
/**
 *  根据城市id获取商圈信息列表(01)
 *
 *  @param cityId     城市id
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithMallCityId:(NSInteger)cityId completion:(void(^)(id result))completion
{
    NSDictionary *param =@{@"city_id":@(cityId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Mall" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
//        NSString *json = [result modelToJSONString];
//        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            NSMutableArray *addList = [NSMutableArray new];
            for (NSDictionary *dict in result.data)
            {
                MallDataEntity *ent = [MallDataEntity modelWithJSON:dict];
                [addList addObject:ent];
            }
            if ([addList count] > 0)
            {
                result.data = addList;
            }
            else
            {
                result.data = nil;
                result.errcode = respond_nodata;
            }
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  根据城市id获取商圈筛选配置数据(02)
 *
 *  @param cityId     城市id
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithMallNearby:(NSInteger)cityId completion:(void(^)(id result))completion
{
    NSDictionary *param =@{@"city_id":@(cityId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Mall/Nearby" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
//        NSString *json = [result modelToJSONString];
//        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            MallRangDataEntity *ent = [MallRangDataEntity modelWithJSON:result.data];
            
            // MallDataEntity *ent = [MallDataEntity modelWithJSON:dict];
            // MallListDataEntity
            MallDataEntity *mallEnt = [MallDataEntity new];
            mallEnt.name = @"附近";
            NSMutableArray *addList = [NSMutableArray new];
            for (RangDataEntity *rEnt in ent.rangs)
            {
                MallListDataEntity *listEnt = [MallListDataEntity new];
                listEnt.name = rEnt.desc;
                listEnt.distance = rEnt.rang;
                [addList addObject:listEnt];
            }
            mallEnt.malls = [NSArray arrayWithArray:addList];
            
            NSMutableArray *addArray = [NSMutableArray new];
            [addArray addObject:mallEnt];
            [addArray addObjectsFromArray:ent.areas];
            
            result.data = addArray;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

#pragma mark 城市信息接口
/**
 *  获取热门城市列表(01)
 *
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithCityHot:(void(^)(id result))completion
{
    NSDictionary *param =nil;
    //    debugLog(@"param=%@", param);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"City/Hot" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
//        NSString *json = [result modelToJSONString];
//        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            NSMutableArray *addList = [NSMutableArray new];
            for (NSDictionary *dict in result.data)
            {
                CityDataEntity *ent = [CityDataEntity modelWithJSON:dict];
                [addList addObject:ent];
            }
            if ([addList count] > 0)
            {
                result.data = addList;
            }
            else
            {
                result.data = nil;
                result.errcode = respond_nodata;
            }
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  查找城市信息(02)
 *
 *  @param cityName   城市名称
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithCitySearch:(NSString *)cityName completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"name":cityName};
    //    debugLog(@"param=%@", param);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"City/Search" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
//        NSString *json = [result modelToJSONString];
//        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
//            debugLog(@"data.class=%@", NSStringFromClass([result.data class]));
            if ([result.data isKindOfClass:[NSArray class]])
            {
                NSMutableArray *addList = [NSMutableArray new];
                for (NSDictionary *dict in result.data)
                {
                    CityDataEntity *ent = [CityDataEntity modelWithJSON:dict];
                    debugLog(@"city=%@", [ent modelToJSONString]);
                    [addList addObject:ent];
                }
                if ([addList count] > 0)
                {
                    result.data = addList;
                }
                else
                {
                    result.data = nil;
                    result.errcode = respond_nodata;
                }
            }
            else if ([result.data isKindOfClass:[NSDictionary class]])
            {
                CityDataEntity *ent = [CityDataEntity modelWithJSON:result.data];
//                debugLog(@"city=%@", [ent modelToJSONString]);
                result.data = ent;
            }
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

#pragma mark 七牛上传相关接口

/**
 *  获取发帖上传图片的token
 *
 *  @param inputEnt
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithUploadCommunityToken:(UploadFileInputObject *)inputEnt completion:(void(^)(id result))completion
{
    NSDictionary *param1 = @{@"action":@"token", @"user_id":@(inputEnt.userId), @"ext_name":inputEnt.extName};
    
    NSMutableDictionary *param = [param1 mutableCopy];
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Upload/Community" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            QiNiuTokenObject *tokenEnt = [QiNiuTokenObject modelWithJSON:result.data];
            result.data = tokenEnt;
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  删除评论上传的图片(01)
 *
 *  @param imageId    图片id
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithUploadCommentDelete:(NSInteger)imageId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"action":@"delete", @"image_id":@(imageId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Upload/Comment" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
//        NSString *json = [result modelToJSONString];
//        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  获取评论相关图片上传的token(02)
 *
 *  @param inputEntity
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithUploadCommentToken:(UploadFileInputObject *)inputEntity completion:(void(^)(id result))completion
{
    NSDictionary *param1 = @{@"action":@"token", @"user_id":@(inputEntity.userId), @"shop_id":@(inputEntity.shopId), @"image_id":@(inputEntity.imageId), @"ext_name":inputEntity.extName};
    
//    debugLog(@"param=%@", param1);
//    return nil;
    NSMutableDictionary *param = [param1 mutableCopy];
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Upload/Comment" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
//        NSString *json = [result modelToJSONString];
//        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            QiNiuTokenObject *tokenEnt = [QiNiuTokenObject modelWithJSON:result.data];
            result.data = tokenEnt;
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  删除上传的菜品详情图片(03)
 *
 *  @param shopId     餐厅id
 *  @param imageUrl   菜品详情图片url
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithUploadFoodDetailsDelete:(NSInteger)shopId imageUrl:(NSString *)imageUrl completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"action":@"delete", @"shop_id":@(shopId), @"image_url":imageUrl};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Upload/FoodDetails" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
//        NSString *json = [result modelToJSONString];
//        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  获取菜品详情图片上传的token(04)
 *
 *  @param inputEntity 传入参数(shopId,imageurl,extname)
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithUploadFoodDetailsToken:(UploadFileInputObject *)inputEntity completion:(void(^)(id result))completion
{
    NSDictionary *param1 = @{@"action":@"token", @"shop_id":@(inputEntity.shopId), @"ext_name":inputEntity.extName};
    NSMutableDictionary *param = [param1 mutableCopy];
    if (![objectNull(inputEntity.imageUrl) isEqualToString:@""])
    {
        param[@"image_url"] = inputEntity.imageUrl;
    }
    
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Upload/FoodDetails" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
//        NSString *json = [result modelToJSONString];
//        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            QiNiuTokenObject *tokenEnt = [QiNiuTokenObject modelWithJSON:result.data];
            result.data = tokenEnt;
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  删除上传的菜品图片(05)
 *
 *  @param shopId     餐厅id
 *  @param imageUrl   图片url地址
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithUploadFoodDelete:(NSInteger)shopId imageUrl:(NSString *)imageUrl completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"action":@"delete", @"shop_id":@(shopId), @"image_url":imageUrl};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Upload/Food" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
//        NSString *json = [result modelToJSONString];
//        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  获取菜品图片上传的token(06)
 *
 *  @param inputEntity 传入参数(shopid,imageurl,extname)
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithUploadFoodToken:(UploadFileInputObject *)inputEntity completion:(void(^)(id result))completion
{
    NSDictionary *param1 = @{@"action":@"token", @"shop_id":@(inputEntity.shopId), @"ext_name":inputEntity.extName};
    NSMutableDictionary *param = [param1 mutableCopy];
    if (![objectNull(inputEntity.imageUrl) isEqualToString:@""])
    {
        param[@"image_url"] = inputEntity.imageUrl;
    }
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Upload/Food" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            QiNiuTokenObject *tokenEnt = [QiNiuTokenObject modelWithJSON:result.data];
            result.data = tokenEnt;
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  删除上传的餐厅图片(07)
 *
 *  @param imageId    餐厅图片ID
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithUploadShopDelete:(NSInteger)imageId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"action":@"delete", @"image_id":@(imageId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Upload/Shop" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
//        NSString *json = [result modelToJSONString];
//        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  获取上传餐厅图片的token(08)
 *
 *  @param inputEntity 传入参数
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithUploadShopToken:(UploadFileInputObject *)inputEntity completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"action":@"token", @"user_id":@(inputEntity.userId), @"shop_id":@(inputEntity.shopId), @"image_id":@(inputEntity.imageId), @"image_type":@(inputEntity.imageType), @"ext_name":objectNull(inputEntity.extName)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Upload/Shop" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
//        NSString *json = [result modelToJSONString];
//        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            QiNiuTokenObject *tokenEnt = [QiNiuTokenObject modelWithJSON:result.data];
            result.data = tokenEnt;
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  删除上传的用户头像(09)
 *
 *  @param userId     用户id
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithUploadUserDelete:(NSInteger)userId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"action":@"delete", @"user_id":@(userId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Upload/User" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
//        NSString *json = [result modelToJSONString];
//        debugLog(@"json=%@", json);
        
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  获取上传用户头像的token(10)
 *
 *  @param userId     用户id
 *  @param extName    上传文件的扩展名
 *  @param completion
 *
 *  @return
 */
+ (NSURLSessionDataTask *)requestWithUploadUserToken:(NSInteger)userId extName:(NSString *)extName completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"action":@"token", @"user_id":@(userId), @"ext_name":extName};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Upload/User" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
//        NSString *json = [result modelToJSONString];
//        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            QiNiuTokenObject *tokenEnt = [QiNiuTokenObject modelWithJSON:result.data];
            result.data = tokenEnt;
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}


#pragma mark -
#pragma mrakr 餐厅端【餐厅资质】V2.0

+ (void)addShopCertificate:(NSMutableArray *)addList certEntity:(CTCShopCertificateDataEntity *)certEntity
{
    NSInteger index = -1;
    for (NSInteger i=0; i<addList.count; i++)
    {
        CTCShopCertificateDataEntity *ent = addList[i];
        if (certEntity.type == ent.type)
        {
            index = i;
            break;
        }
    }
    if (index == -1)
    {
        [addList addObject:certEntity];
    }
}

+ (CTCShopCertificateDataEntity *)getWithCertificate:(NSMutableArray *)list type:(NSInteger)type
{
    CTCShopCertificateDataEntity *cert = nil;
    for (CTCShopCertificateDataEntity *ent in list)
    {
        if (ent.type == type)
        {
            cert = ent;
            break;
        }
    }
    return cert;
}

/**
 *  获取餐厅经营资质(01-2)
 *
 *  @param shopId 餐厅id
 *  @param completion block
 */
+ (NSURLSessionDataTask *)requestWithShopCertificate:(NSInteger)shopId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(shopId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"ShopCertificate" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"shoplicensejson=%@", json);
        if (result.errcode == respond_success)
        {
            CTCShopLicenseDataEntity *shopLicenseEnt = [CTCShopLicenseDataEntity modelWithJSON:result.data];
            
            NSMutableArray *addList = [NSMutableArray new];
            for (CTCShopCertificateDataEntity *certEnt in shopLicenseEnt.certificates)
            {
                [self addShopCertificate:addList certEntity:certEnt];
            }
            
            NSMutableArray *certList = [NSMutableArray new];
            if ([addList count] == 0)
            {// 没有数据
                debugLog(@"没有数据");
                // 营业执照
                CTCShopCertificateDataEntity *ent = [CTCShopCertificateDataEntity new];
                ent.type = EN_UPLOAD_IMAGE_BUSINESS_LICENSE;
                [certList addObject:ent];
                
                // 餐厅经营许可证/卫生许可证
                ent = [CTCShopCertificateDataEntity new];
                ent.type = EN_UPLOAD_IMAGE_BUSINESS_CERTIFICATE;
                [certList addObject:ent];
                
                // 健康证(1)
                ent = [CTCShopCertificateDataEntity new];
                ent.type = EN_UPLOAD_IMAGE_HEALTH_CERTIFICATE_ONE;
                [certList addObject:ent];
                
                // 健康证(2)
                ent = [CTCShopCertificateDataEntity new];
                ent.type = EN_UPLOAD_IMAGE_HEALTH_CERTIFICATE_TWO;
                [certList addObject:ent];
            }
            else if ([addList count] == 1)
            {// 只有一条数据
                CTCShopCertificateDataEntity *entity = addList[0];
                if (entity.type == EN_UPLOAD_IMAGE_BUSINESS_LICENSE)
                {// 营业执照
                    // 营业执照
                    [certList addObject:entity];
                    
                    // 餐厅经营许可证/卫生许可证
                    CTCShopCertificateDataEntity *ent = [CTCShopCertificateDataEntity new];
                    ent.type = EN_UPLOAD_IMAGE_BUSINESS_CERTIFICATE;
                    [certList addObject:ent];
                    
                    // 健康证(1)
                    ent = [CTCShopCertificateDataEntity new];
                    ent.type = EN_UPLOAD_IMAGE_HEALTH_CERTIFICATE_ONE;
                    [certList addObject:ent];
                    
                    // 健康证(2)
                    ent = [CTCShopCertificateDataEntity new];
                    ent.type = EN_UPLOAD_IMAGE_HEALTH_CERTIFICATE_TWO;
                    [certList addObject:ent];
                }
                else if (entity.type == EN_UPLOAD_IMAGE_BUSINESS_CERTIFICATE)
                {// 餐厅经营许可证/卫生许可证
                    // 营业执照
                    CTCShopCertificateDataEntity *ent = [CTCShopCertificateDataEntity new];
                    ent.type = EN_UPLOAD_IMAGE_BUSINESS_LICENSE;
                    [certList addObject:ent];
                    
                    // 餐厅经营许可证/卫生许可证
                    [certList addObject:entity];
                    
                    // 健康证(1)
                    ent = [CTCShopCertificateDataEntity new];
                    ent.type = EN_UPLOAD_IMAGE_HEALTH_CERTIFICATE_ONE;
                    [certList addObject:ent];
                    
                    // 健康证(2)
                    ent = [CTCShopCertificateDataEntity new];
                    ent.type = EN_UPLOAD_IMAGE_HEALTH_CERTIFICATE_TWO;
                    [certList addObject:ent];
                }
            }
            else if ([addList count] == 2)
            {// 有两条数据
                // 营业执照
                CTCShopCertificateDataEntity *yyzzEnt = [self getWithCertificate:addList type:EN_UPLOAD_IMAGE_BUSINESS_LICENSE];
                
                // 餐厅经营许可证/卫生许可证
                CTCShopCertificateDataEntity *wsxkzEnt = [self getWithCertificate:addList type:EN_UPLOAD_IMAGE_BUSINESS_CERTIFICATE];
//                [addList removeAllObjects];
                if (yyzzEnt)
                {
                    [certList addObject:yyzzEnt];
                }
                else
                {
                    // 营业执照
                    CTCShopCertificateDataEntity *ent = [CTCShopCertificateDataEntity new];
                    ent.type = EN_UPLOAD_IMAGE_BUSINESS_LICENSE;
                    [certList addObject:ent];
                }
                
                if (wsxkzEnt)
                {
                    [certList addObject:wsxkzEnt];
                }
                else
                {
                    CTCShopCertificateDataEntity *ent = [CTCShopCertificateDataEntity new];
                    ent.type = EN_UPLOAD_IMAGE_BUSINESS_CERTIFICATE;
                    [certList addObject:ent];
                }
                
                // 健康证(1)
                CTCShopCertificateDataEntity *ent = [CTCShopCertificateDataEntity new];
                ent.type = EN_UPLOAD_IMAGE_HEALTH_CERTIFICATE_ONE;
                [certList addObject:ent];
                
                // 健康证(2)
                ent = [CTCShopCertificateDataEntity new];
                ent.type = EN_UPLOAD_IMAGE_HEALTH_CERTIFICATE_TWO;
                [certList addObject:ent];
            }
            else if ([addList count] == 3)
            {
                // 营业执照
                CTCShopCertificateDataEntity *yyzzEnt = [self getWithCertificate:addList type:EN_UPLOAD_IMAGE_BUSINESS_LICENSE];
                
                // 餐厅经营许可证/卫生许可证
                CTCShopCertificateDataEntity *wsxkzEnt = [self getWithCertificate:addList type:EN_UPLOAD_IMAGE_BUSINESS_CERTIFICATE];
                
                
                CTCShopCertificateDataEntity *jkzEnt = [self getWithCertificate:addList type:EN_UPLOAD_IMAGE_HEALTH_CERTIFICATE_ONE];
                int isOne = 1; // 1表示健康证1；2表示健康证2；3表示健康证1和健康证2都没有
                if (!jkzEnt)
                {
                    jkzEnt = [self getWithCertificate:addList type:EN_UPLOAD_IMAGE_HEALTH_CERTIFICATE_TWO];
                    if (jkzEnt)
                    {
                        isOne = 2;
                    }
                    else
                    {
                        isOne = 3;
                    }
                }
                
//                [addList removeAllObjects];
                
                if (yyzzEnt)
                {
                    [certList addObject:yyzzEnt];
                }
                else
                {
                    // 营业执照
                    CTCShopCertificateDataEntity *ent = [CTCShopCertificateDataEntity new];
                    ent.type = EN_UPLOAD_IMAGE_BUSINESS_LICENSE;
                    [certList addObject:ent];
                }
                
                if (wsxkzEnt)
                {
                    [certList addObject:wsxkzEnt];
                }
                else
                {
                    CTCShopCertificateDataEntity *ent = [CTCShopCertificateDataEntity new];
                    ent.type = EN_UPLOAD_IMAGE_BUSINESS_CERTIFICATE;
                    [certList addObject:ent];
                }
                
                // 1表示健康证1；2表示健康证2；3表示健康证1和健康证2都没有
                if (isOne == 1)
                {
                    [certList addObject:jkzEnt];
                    CTCShopCertificateDataEntity *ent = [CTCShopCertificateDataEntity new];
                    ent.type = EN_UPLOAD_IMAGE_HEALTH_CERTIFICATE_TWO;
                    [certList addObject:ent];
                }
                else if (isOne == 2)
                {
                    CTCShopCertificateDataEntity *ent = [CTCShopCertificateDataEntity new];
                    ent.type = EN_UPLOAD_IMAGE_HEALTH_CERTIFICATE_ONE;
                    [certList addObject:ent];
                    
                    [certList addObject:jkzEnt];
                }
                else
                {
                    // 健康证(1)
                    CTCShopCertificateDataEntity *ent = [CTCShopCertificateDataEntity new];
                    ent.type = EN_UPLOAD_IMAGE_HEALTH_CERTIFICATE_ONE;
                    [certList addObject:ent];
                    
                    // 健康证(2)
                    ent = [CTCShopCertificateDataEntity new];
                    ent.type = EN_UPLOAD_IMAGE_HEALTH_CERTIFICATE_TWO;
                    [certList addObject:ent];
                }
            }
            debugLog(@"addList.count=%d", (int)[certList count]);
            shopLicenseEnt.certificates = certList;
            debugLog(@"cers.count=%d", (int)[shopLicenseEnt.certificates count]);
            result.data = shopLicenseEnt;
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  保存资质
 *
 *  @param shopId 餐厅id
 *  @param userId 用户id
 */
+ (NSURLSessionDataTask *)requestWithShopSaveCertificate:(NSInteger)shopId userId:(NSInteger)userId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(shopId), @"user_id":@(userId)};
    debugLog(@"param=%@", param);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Shop/SaveCertificate" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"addlicensejson=%@", json);
        
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  添加餐厅经营资质(02-1)
 *
 *  @param inputEntity 传入参数
 */
/*+ (NSURLSessionDataTask *)requestWithShopLicenseAdd:(CTCShopLicenseInputEntity *)inputEntity completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(inputEntity.shopId), @"biz_lic":objectNull(inputEntity.biz_lic), @"opt_lic":objectNull(inputEntity.opt_lic), @"health_lic1":objectNull(inputEntity.health_lic1), @"health_lic2":objectNull(inputEntity.health_lic2)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"User/Login" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"addlicensejson=%@", json);
        
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}*/


#pragma mark -
#pragma mark 餐厅端【用户接口】

/**
 *  掌柜登录接口(01 -6)
 *
 *  @param mobile     手机号码
 *  @param password   密码
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithUserLogin:(NSString *)mobile password:(NSString *)password completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"mobile":mobile, @"password":password};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"User/Login" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"bossloginjson=%@", json);
        if (result.errcode == respond_success)
        {
            UserInfoDataEntity *userInfo = [UserInfoDataEntity modelWithJSON:result.data];
            userInfo.password = password;
            result.data = userInfo;
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

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
+ (NSURLSessionDataTask *)requestWithUserEmployeeLogin:(NSInteger)shopId mobile:(NSString *)mobile password:(NSString *)password completion:(void (^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(shopId), @"username":mobile, @"password":password};
    debugLog(@"param=%@", param);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"User/EmployeeLogin" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"loginjson=%@", json);
        if (result.errcode == respond_success)
        {
            UserInfoDataEntity *userInfo = [UserInfoDataEntity modelWithJSON:result.data];
            userInfo.password = password;
            result.data = userInfo;
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  获取员工职位(03-4)
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithUserTitleGetUserTitles:(void (^)(id result))completion
{
    NSDictionary *param = nil;
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"UserTitle/GetUserTitles" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        
    }];
    
    return dataTask;
}

/**
 *  创建员工(04-3)--添加员工
 *
 *  @param  inputEntity 参数
 *  @param  completion block
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithUserCreateEmployee:(ShopManageInputEntity *)inputEntity completion:(void (^)(id result))completion
{
    NSDictionary *dict = @{@"seller_id":@(inputEntity.sellerId), @"shop_id":@(inputEntity.shopId), @"mobile":objectNull(inputEntity.mobile), @"username":objectNull(inputEntity.userName), @"password":objectNull(inputEntity.password), @"title_id":@(inputEntity.title), @"role_id":@(inputEntity.auth)};
    NSMutableDictionary *param = [dict mutableCopy];
    debugLog(@"param=%@", param);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"User/CreateEmployee" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  绑定身份(05-2)
 *
 *  @param userName 用户名
 *  @param identifyCard 身份证
 *  @param completion block
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithUserSetIdentity:(NSString *)userName identifyCard:(NSString *)identifyCard completion:(void (^)(id result))completion
{
    NSDictionary *param = @{@"username":objectNull(userName), @"identity_card":objectNull(identifyCard)};
    debugLog(@"param=%@", param);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"User/SetIdentity" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"injson=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  开店注册(06-1)
 *
 *  @param  mobile   手机号码
 *  @param  smscode 验证码
 *  @param  password 密码
 *
 */
+ (NSURLSessionDataTask *)requestWithUserRegister:(NSString *)mobile smscode:(NSInteger)smscode password:(NSString *)password completion:(void (^)(id result))completion
{
    NSDictionary *param = @{@"mobile":mobile, @"password":password, @"sms_code":@(smscode)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"User/Register" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"registerjson=%@", json);
        if (result.errcode == respond_success)
        {
            UserInfoDataEntity *userInfo = [UserInfoDataEntity modelWithJSON:result.data];
            userInfo.password = password;
            result.data = userInfo;
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  获取用户信息(07-7)
 *
 *  @param  userId 用户id
 *  @param completion block
 */
+ (NSURLSessionDataTask *)requestWithUser:(NSInteger)userId completion:(void (^)(id result))completion
{
    NSDictionary *param = @{@"user_id":@(userId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"User" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"loginjson=%@", json);
        if (result.errcode == respond_success)
        {
            UserInfoDataEntity *userInfo = [UserInfoDataEntity modelWithJSON:result.data];
            userInfo.password = [UserLoginStateObject getUserInfo].password;
//            userInfo.userMode = [UserLoginStateObject getUserInfo].userMode;
            userInfo.shop_state = [UserLoginStateObject getUserInfo].shop_state;
            result.data = userInfo;
            [UserLoginStateObject saveWithUserInfo:userInfo];
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;

}

/**
 *  获取餐厅所有员工信息(08-8)
 *
 *  @param shopId 餐厅id
 */
+ (NSURLSessionDataTask *)requestWithUserGetEmployeeList:(NSInteger)shopId completion:(void (^)(id))completion
{
    NSDictionary *param = @{@"shop_id":@(shopId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"User/GetEmployeeList" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"employeejson=%@", json);
        if (result.errcode == respond_success)
        {
            NSMutableArray *addList = [NSMutableArray new];
            for (id dict in result.data)
            {
                ShopManageNewDataEntity *ent = [ShopManageNewDataEntity modelWithJSON:dict];
                [addList addObject:ent];
            }
            if ([addList count] != 0)
            {
                result.data = addList;
            }
            else
            {
                result.data = nil;
                result.errcode = respond_nodata;
            }
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  获取所有职位和角色权限信息
 *
 *  @param completion block
 */
+ (NSURLSessionDataTask *)requestWithUserGetTitleAndRoleConfigs:(void(^)(id result))completion
{
    NSDictionary *param = nil;
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"User/GetTitleAndRoleConfigs" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            ShopManagePositionAuthEntity *poauthEnt = [ShopManagePositionAuthEntity modelWithJSON:result.data];
            
//            ShopPositionDataEntity *ent = poauthEnt.titles[0];
//            debugLog(@"id=%d; name=%@", (int)ent.id, ent.name);
            
            result.data = poauthEnt;
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  修改员工信息(10-11)
 *
 *  @param inputEntity 传入参数
 *  @param completion block
 */
+ (NSURLSessionDataTask *)requestWithUserSetEmployee:(ShopManageInputEntity *)inputEntity completion:(void (^)(id result))completion
{
    
    NSDictionary *dict = @{@"user_id":@(inputEntity.userId), @"username":objectNull(inputEntity.userName), @"mobile":objectNull(inputEntity.mobile), @"title_id":@(inputEntity.title), @"role_id":@(inputEntity.auth)};
    NSMutableDictionary *param = [dict mutableCopy];
    if (![objectNull(inputEntity.password) isEqualToString:@""] && ![objectNull(inputEntity.password) isEqualToString:@"******"])
    {
        [param setValue:objectNull(inputEntity.password) forKey:@"password"];
    }
    debugLog(@"param=%@", param);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"User/SetEmployee" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  删除员工(11-12)
 *
 *  @param userId 员工id
 *  @param type 1表示创建者、管理员；2表示普通员工
 *  @param completion block
 */
+ (NSURLSessionDataTask *)requestWithUserDeleteEmployee:(NSInteger)userId shopId:(NSInteger)shopId sellerId:(NSInteger)sellerId type:(NSInteger)type completion:(void (^)(id result))completion
{
    NSDictionary *param = @{@"user_id":@(userId), @"shop_id":@(shopId), @"seller_id":@(sellerId), @"user_type":@(type)};
    debugLog(@"param=%@", param);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"User/DeleteEmployee" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

#pragma mark -
#pragma mark 餐厅端【订单接口】V2.0
/**
 *  餐厅创建订单(01-1)
 *
 *  @param inputEntity 传入参数
 *  @param completion block
 *
 */
+ (NSURLSessionDataTask *)requestWithShopOrderCreateOrder:(RestaurantReservationInputEntity *)inputEntity completion:(void (^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(inputEntity.shopId), @"cust_count":@(inputEntity.number), @"seat_type":@(inputEntity.shopLocation), @"seat_number":objectNull(inputEntity.tableNo), @"content":objectNull(inputEntity.content)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"ShopOrder/CreateOrder" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"createOrderjson=%@", json);
        if (result.errcode == respond_success)
        {
            NSDictionary *dict = result.data;
            NSString *orderId = dict[@"order_id"];
            result.data = orderId;
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  餐厅取消订单(02-2)
 *
 *  @param orderId 订单id
 *  @param reasonId 取消原因id
 *  @param mark 取消理由备注
 *  @param completion block
 */
+ (NSURLSessionDataTask *)requestWithShopOrderCancelOrder:(NSString *)orderId reasonId:(NSInteger)reasonId mark:(NSString *)mark completion:(void (^)(id result))completion
{
    NSDictionary *param = @{@"order_id":objectNull(orderId), @"reason_id":@(reasonId), @"mark":objectNull(mark)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"ShopOrder/CancelOrder" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"cancelOrderjson=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  修改餐桌和人数(03-3)
 *
 *  @param inputEntity 参数
 *  @param completion block
 *
 */
+ (NSURLSessionDataTask *)requestWithShopOrderChangeSeat:(RestaurantReservationInputEntity *)inputEntity completion:(void (^)(id result))completion
{
    NSDictionary *param = @{@"order_id":objectNull(inputEntity.orderId), @"seat_number":objectNull(inputEntity.tableNo), @"seat_type":@(inputEntity.shopLocation), @"shop_id":@(inputEntity.shopId), @"cust_count":@(inputEntity.number)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"ShopOrder/ChangeSeat" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"changeseatjson=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}


/**
 *  修改订单金额(04-4)
 *
 *  @param inputEntity 参数
 *  @param completion block
 */
+ (NSURLSessionDataTask *)requestWithShopOrderChangeTotal:(OrderAmountModifyEntity *)inputEntity completion:(void (^)(id result))completion
{
    NSDictionary *param = @{@"order_id":objectNull(inputEntity.orderId), @"shop_id":@(inputEntity.shopId), @"new_amount":@(inputEntity.newAmount), @"note":objectNull(inputEntity.note)};
    
    //    debugLog(@"param=%@", [param modelToJSONString]);
    //    return nil;
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"ShopOrder/ChangeTotal" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}


/**
 *  获取打印批次[获取订单打印菜品详情](05-5)
 *
 *  @param orderId 订单编号
 *  @param shopId 餐厅id
 *  @param completion block
 */
+ (NSURLSessionDataTask *)requestWithShopOrderGetPrintBatchFoods:(NSString *)orderId shopId:(NSInteger)shopId completion:(void (^)(id result))completion
{
    NSDictionary *param = @{@"order_id":objectNull(orderId), @"shop_id":@(shopId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"ShopOrder/GetPrintBatchFoods" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"batchjson=%@", json);
        if (result.errcode == respond_success)
        {
            NSMutableArray *addList = [NSMutableArray new];
            for (id dict in result.data)
            {
                //                PrintBatchDataEntity *ent = [PrintBatchDataEntity modelWithJSON:dict];
                ShopPrinterEntity *ent = [ShopPrinterEntity modelWithJSON:dict];
                [addList addObject:ent];
            }
            if ([addList count] != 0)
            {
                result.data = addList;
            }
            else
            {
                result.errcode = respond_nodata;
                result.data = nil;
            }
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  下单到厨房(06-6)
 *
 *  @param orderId 订单id
 *  @param shopId 餐厅id
 *  @param printId 打印机编号
 *  @param completion block
 */
+ (NSURLSessionDataTask *)requestWithShopOrderFoodToKitchen:(NSString *)orderId shopId:(NSInteger)shopId printId:(NSInteger)printId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"order_id":objectNull(orderId), @"shop_id":@(shopId), @"printer_id":@(printId)};
    debugLog(@"param=%@", [param modelToJSONString]);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"ShopOrder/FoodToKitchen" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  打印收银信息(07-7)
 *
 *  @param orderId 订单id
 *  @param shopId 餐厅id
 *  @param completion block
 */
+ (NSURLSessionDataTask *)requestWithShopOrderCashPrinter:(NSString *)orderId shopId:(NSInteger)shopId completion:(void(^)(id result))completion;
{
    NSDictionary *param = @{@"order_id":objectNull(orderId), @"shop_id":@(shopId)};
    debugLog(@"param=%@", param);
    
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"ShopOrder/CashPrinter" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"cashPrinterjson=%@", json);
        
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  补打下单信息(08-8)
 *
 *  @param inputEntity 传入参数
 *  @param completion block
 *
 */
+ (NSURLSessionDataTask *)requestWithShopOrderPatchFoodToKitchen:(ShopPatchFoodInputEntity *)inputEntity completion:(void(^)(id result))completion;
{
    NSDictionary *param = @{@"order_id":objectNull(inputEntity.orderId), @"shop_id":@(inputEntity.shopId), @"printer_id":@(inputEntity.printerId), @"batch_no":objectNull(inputEntity.batchNo)};
    debugLog(@"param=%@", param);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"ShopOrder/PatchFoodToKitchen" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"patchFoodjson=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  加菜下单列表(09-9)
 *
 *  @param orderId    订单id
 *  @param shopId 餐厅
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithShopOrderWaitPrintFoods:(NSString *)orderId shopId:(NSInteger)shopId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"order_id":objectNull(orderId), @"shop_id":@(shopId)};
    debugLog(@"param=%@", param);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"ShopOrder/WaitPrintFoods" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        
        if (result.errcode == respond_success)
        {
            NSMutableArray *addList = [NSMutableArray new];
            for (id dict in result.data)
            {
                OrderFoodInfoEntity *orderEnt = [OrderFoodInfoEntity modelWithJSON:dict];
                [addList addObject:orderEnt];
            }
            if ([addList count] != 0)
            {
                result.data = addList;
            }
            else
            {
                result.data = nil;
                result.errcode = respond_nodata;
            }
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  结束交易订单(10-10)
 *
 *  @param orderId 订单id
 *  @param completion block
 */
+ (NSURLSessionDataTask *)requestWithShopOrderCompleteOrder:(NSString *)orderId payChannel:(NSInteger)payChannel payWay:(NSInteger)payWay completion:(void (^)(id))completion
{
    NSDictionary *param = @{@"order_id":objectNull(orderId), @"pay_channel":@(payChannel), @"pay_way":@(payWay)};
    debugLog(@"param=%@", param);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"ShopOrder/CompleteOrder" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        
        
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  获取餐中订单餐桌信息(11-11)
 *
 *  @param shopId 餐厅id
 *  @param completion block
 */
+ (NSURLSessionDataTask *)requestWithShopOrderDiningSeats:(NSInteger)shopId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(shopId)};
    debugLog(@"param=%@", param);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"ShopOrder/DiningSeats" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"orderseatjson=%@", json);
        if (result.errcode == respond_success)
        {
            NSMutableArray *addList = [NSMutableArray new];
            for (id dict in result.data)
            {
                OrderDiningSeatEntity *ent = [OrderDiningSeatEntity modelWithJSON:dict];
                [addList addObject:ent];
            }
            if ([addList count] > 0)
            {
                result.data = addList;
            }
            else
            {
                result.errcode = respond_nodata;
                result.data = nil;
            }
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  餐中订单明细(12-12)
 *
 *  @param orderId 订单id
 *  @param shopId 餐厅id
 *  @param completion block
 */
+ (NSURLSessionDataTask *)requestWithShopOrderDiningDetails:(NSString *)orderId shopId:(NSInteger)shopId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"order_id":objectNull(orderId), @"shop_id":@(shopId)};
    debugLog(@"param=%@", param);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"ShopOrder/DiningDetails" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            CTCMealOrderDetailsEntity *ent = [CTCMealOrderDetailsEntity modelWithJSON:result.data];
            
            for (CTCMealOrderFoodEntity *foodEnt in ent.foods)
            {
                for (CTCMealOrderFoodEntity *foodEntity in foodEnt.details)
                {
                    foodEntity.isSub = YES;
                }
            }
            
            result.data = ent;
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  查询历史订单(13-13)
 *
 *  @param inputEntity 传入参数
 *  @param completion block
 */
+ (NSURLSessionDataTask *)requestWithShopOrderHistoryOrders:(CTCRestaurantHistoryOrderInputEntity *)inputEntity completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(inputEntity.shop_id), @"seat_number":objectNull(inputEntity.seat_number), @"date":objectNull(inputEntity.date), @"pageIndex":@(inputEntity.pageIndex), @"pageSize":@(inputEntity.pageSize)};
    debugLog(@"param=%@", param);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"ShopOrder/HistoryOrders" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"historyjson=%@", json);
        if (result.errcode == respond_success)
        {
            CTCRestaurantOrderHistoryEntity *ent = [CTCRestaurantOrderHistoryEntity modelWithJSON:result.data];
            if ([ent.group count] != 0)
            {
                result.data = ent.group;
            }
            else
            {
                result.data = nil;
                result.errcode = respond_nodata;
            }
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  上菜/取消上菜(14-14)
 *
 *  @param inputEntity 传入参数
 *  @param completion block
 */
+ (NSURLSessionDataTask *)requestWithShopOrderDishUpDown:(CTCRestaurantDishUpDownFoodEntity *)inputEntity completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"id":@(inputEntity.id), @"order_id":objectNull(inputEntity.order_id), @"shop_id":@(inputEntity.shop_id), @"dish_type":@(inputEntity.dish_type)};
    debugLog(@"param=%@", param);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"ShopOrder/DishUpDown" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"historyjson=%@", json);
        
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}
                                      
/**
 *  加菜(15-15)
 *
 *  @param foodEnt 传入参数
 *  @param completion block
 */
+ (NSURLSessionDataTask *)requestWithShopOrderAddFoods:(UpdateOrderFoodInputEntity *)foodEnt completion:(void(^)(id result))completion
{
        NSDictionary *param = @{@"order_id":objectNull(foodEnt.orderId), @"shop_id":@(foodEnt.shopId), @"order_food_type":@(foodEnt.order_food_type), @"content":objectNull(foodEnt.content)};
        debugLog(@"param=%@", [param modelToJSONString]);
        
        NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"ShopOrder/AddFoods" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
            NSString *json = [result modelToJSONString];
            debugLog(@"addFoodsjson=%@", json);
            if (completion)
            {
                completion(result);
            }
        }];
        return dataTask;
}

/**
 *  餐厅退菜(16-16)
 *
 *  @param inputEnt 传入参数
 *  @param completion block
 *
 *  @return dt
 */
+ (NSURLSessionDataTask *)requestWithShopOrderReturnFoods:(UpdateOrderFoodInputEntity *)inputEnt completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"order_id":objectNull(inputEnt.orderId), @"shop_id":@(inputEnt.shopId), @"detail_id":@(inputEnt.detailId), @"food_number":@(inputEnt.foodNumber)};
    debugLog(@"param=%@", param);
    
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"ShopOrder/ReturnFoods" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  获取支付渠道信息列表(17-17)
 *
 *  @param completion block
 */
+ (NSURLSessionDataTask *)requestWithShopOrderPayChannel:(void(^)(id result))completion
{
    NSDictionary *param = nil;
    debugLog(@"param=%@", param);
    
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"ShopOrder/PayChannel" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        BOOL isFirst = YES;
        if (result.errcode == respond_success)
        {
            NSMutableArray *addList = [NSMutableArray new];
            for (id dict in result.data)
            {
                PayChannelDataEntity *ent = [PayChannelDataEntity modelWithJSON:dict];
                if (isFirst)
                {
                    ent.isCheck = YES;
                    isFirst = NO;
                }
                if (ent.inUse == 1)
                {
                    [addList addObject:ent];
                }
            }
            if ([addList count] != 0)
            {
                result.data = addList;
            }
            else
            {
                result.data = nil;
                result.errcode = respond_nodata;
            }
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  订单详情(18-18)
 *
 *  @param orderId 订单id
 *  @param shopId 餐厅id
 */
+ (NSURLSessionDataTask *)requestWithShopOrderDetail:(NSString *)orderId shopId:(NSInteger)shopId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"order_id":objectNull(orderId), @"shop_id":@(shopId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"ShopOrder/Detail" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"orderDetailjson=%@", json);
        if (result.errcode == respond_success)
        {
            CTCOrderDetailEntity *orderDetailEnt = [CTCOrderDetailEntity modelWithJSON:result.data];
            orderDetailEnt.detailFoods = [NSMutableArray array];
            NSMutableArray *foodBackList = [NSMutableArray new];
            NSMutableArray *addFoodList = [NSMutableArray new];
            
            
            for (OrderFoodInfoEntity *ent in orderDetailEnt.details)
            {
                ent.allNumber = ent.number;
                if (ent.status == NS_ORDER_FOOD_RETIRED_STATE)
                {// 退菜
                    [foodBackList addObject:ent];
                }
                else
                {
                    [self addWithList:addFoodList addEnt:ent];
                }
            }
            //            debugLog(@"-----------------------------");
            
            for (OrderFoodInfoEntity *backEnt in foodBackList)
            {
                NSInteger index = -1;
                for (NSInteger i=[addFoodList count]-1; i<[addFoodList count]; i--)
                {
                    OrderFoodInfoEntity *adEnt = addFoodList[i];
                    if (adEnt.food_id == backEnt.food_id)
                    {
                        index = i;
                        break;
                    }
                }
                if (index != -1)
                {
                    [addFoodList insertObject:backEnt atIndex:index+1];
                }
            }
            
            NSMutableArray *newList = [NSMutableArray new];
            for (OrderFoodInfoEntity *foodEnt in addFoodList)
            {
                [self addWithOrderDetailFood:foodEnt foodList:newList];
            }
            
            orderDetailEnt.details = addFoodList;
            orderDetailEnt.detailFoods = newList;
            result.data = orderDetailEnt;
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  取消订单原因列表(19-19)
 *
 */
+ (NSURLSessionDataTask *)requestWithShopOrderCancelReasons:(void(^)(id result))completion
{
    NSDictionary *param = nil;
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"ShopOrder/CancelReasons" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            NSMutableArray *addList = [NSMutableArray new];
            NSInteger i = 0;
            for (id dict in result.data)
            {
                CellCommonDataEntity *ent = [CellCommonDataEntity modelWithJSON:dict];
                
                ent.subTitle = ent.title;
                ent.checkImgName = @"btn_diners_check_sel";
                ent.uncheckImgName = @"btn_diners_check_nor";
                if (i == 0)
                {
                    ent.isCheck = YES;
                }
                else
                {
                    ent.isCheck = NO;
                }
                
                [addList addObject:ent];
                i += 1;
                debugLog(@"ent=%@", [ent modelToJSONString]);
            }
            
            CellCommonDataEntity *entity = [CellCommonDataEntity new];
            entity.title = @"其它原因";
            entity.subTitle = @"";
            entity.checkImgName = @"btn_diners_check_sel";
            entity.uncheckImgName = @"btn_diners_check_nor";
            entity.isCheck = NO;
            entity.tag = 0;
            [addList addObject:entity];
            
            if ([addList count] != 0)
            {
                result.data = addList;
            }
            else
            {
                result.data = nil;
                result.errcode = respond_nodata;
            }
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  取消订单(20-20)
 */
+ (NSURLSessionDataTask *)requestWithShopOrderCancelOrder:(CancelReservationEntity *)inputEntity completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"order_id":objectNull(inputEntity.orderId), @"reason_id":@(inputEntity.reason), @"reason_note":@(inputEntity.reason), @"shop_id":@(inputEntity.shopId)};
    debugLog(@"param=%@", [param modelToJSONString]);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"ShopOrder/CancelOrder" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  获取等待接单的订单列表
 *
 *  @param shopId 餐厅id
 *  @param completion block
 */
+ (NSURLSessionDataTask *)requestWithShopOrderWaitOrders:(NSInteger)shopId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(shopId)};
    debugLog(@"param=%@", [param modelToJSONString]);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"ShopOrder/WaitOrders" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            NSMutableArray *addList = [NSMutableArray new];
            for (id dict in result.data)
            {
                OrderDataEntity *orderEnt = [OrderDataEntity modelWithJSON:dict];
                [addList addObject:orderEnt];
            }
            if (addList.count > 0)
            {
                result.data = addList;
            }
            else
            {
                result.data = nil;
                result.errcode = respond_nodata;
            }
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  餐厅确认接单
 *
 *  @param orderId 订单id
 *  @param shopId 餐厅id
 *  @param completion block
 */
+ (NSURLSessionDataTask *)requestWithShopOrderAccept:(NSString *)orderId shopId:(NSInteger)shopId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"order_id":objectNull(orderId), @"shop_id":@(shopId)};
    debugLog(@"param=%@", [param modelToJSONString]);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"ShopOrder/Accept" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

#pragma mark -
#pragma mark 餐厅【商户相关】

/**
 *  获取我管理的店(01-8)
 *
 *  @param userId 用户id
 */
+ (NSURLSessionDataTask *)requestWithSellerGetManageShop:(NSInteger)userId sellerId:(NSInteger)sellerId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"seller_id":@(sellerId), @"user_id":@(userId)};
    debugLog(@"param=%@", [param modelToJSONString]);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Seller/GetManageShop" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"mangeshopjson=%@", json);
        if (result.errcode == respond_success)
        {
            NSMutableArray *addList = [NSMutableArray new];
            for (id dict in result.data)
            {
                ShopListDataEntity *shopEnt = [ShopListDataEntity modelWithJSON:dict];
                [addList addObject:shopEnt];
            }
            if ([addList count] != 0)
            {
                result.data = addList;
            }
            else
            {
                result.data = nil;
                result.errcode = respond_nodata;
            }
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  设置我管理的餐厅(02-7)
 *
 *  @param userId 用户id
 *  @param sellerId 商户id
 *  @param shopIds 管理的餐厅id，多个用逗号隔开
 */
+ (NSURLSessionDataTask *)requestWithSellerSetManageShop:(NSInteger)userId sellerId:(NSInteger)sellerId shopIds:(NSString *)shopIds completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"user_id":@(userId), @"seller_id":@(sellerId), @"shop_ids":objectNull(shopIds)};
    debugLog(@"param=%@", [param modelToJSONString]);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Seller/SetManageShop" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  获取管理员列表(03-6)
 *
 */
+ (NSURLSessionDataTask *)requestWithSellerGetManageList:(NSInteger)sellerId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"seller_id":@(sellerId)};
    debugLog(@"param=%@", [param modelToJSONString]);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Seller/GetManageList" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            NSMutableArray *addList = [NSMutableArray new];
            for (id dict in result.data)
            {
                ShopManageNewDataEntity *ent = [ShopManageNewDataEntity modelWithJSON:dict];
                [addList addObject:ent];
            }
            if ([addList count] != 0)
            {
                result.data = addList;
            }
            else
            {
                result.data = nil;
                result.errcode = respond_nodata;
            }
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  管理登陆(01-4)
 *
 *  @param mobile 手机号码
 *  @param password 密码
 */
+ (NSURLSessionDataTask *)requestWithSellerLogin:(NSString *)mobile password:(NSString *)password completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"mobile":objectNull(mobile), @"password":objectNull(password)};
    debugLog(@"param=%@", [param modelToJSONString]);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Seller/Login" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            UserInfoDataEntity *userInfo = [UserInfoDataEntity modelWithJSON:result.data];
            userInfo.password = password;
            result.data = userInfo;
        }
        else
        {
            result.data = nil;
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  @brief 添加管理员(02-3)
 *
 *  @param sellerId 商户id
 *  @param mobile 手机号码
 *  @param shopIds 管理的餐厅id，多个用逗号隔开
 */
+ (NSURLSessionDataTask *)requestWithSellerCreateManager:(NSInteger)sellerId mobile:(NSString *)mobile shopIds:(NSString *)shopIds completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"seller_id":@(sellerId), @"mobile":objectNull(mobile), @"shop_ids":objectNull(shopIds)};
    debugLog(@"param=%@", [param modelToJSONString]);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Seller/CreateManager" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  商户注册(03-1)
 *
 *  @param mobile 手机号码
 *  @param password 密码
 *  @param smscode 验证码
 */
+ (NSURLSessionDataTask *)requestWithSellerRegister:(NSString *)mobile password:(NSString *)password smscode:(NSInteger)smscode completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"mobile":objectNull(mobile), @"password":objectNull(password), @"sms_code":@(smscode)};
    debugLog(@"param=%@", [param modelToJSONString]);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Seller/Register" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

#pragma mark -
#pragma mark 外卖(外卖平台接单接口)

/**
 *  商户取消订单(拒单)
 *
 *  @param orderId 订单id
 *  @param reason 取消原因
 *  @param completion block
 *
 */
+ (NSURLSessionDataTask *)requestWithWaimaiCancelOrder:(NSString *)orderId reason:(NSString *)reason completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"eleme_order_id":objectNull(orderId), @"reason":objectNull(reason)};
    debugLog(@"param=%@", param);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Waimai/CancelOrder" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  商户接单
 *
 *  @param orderId 订单Id
 *  @param completion block
 */
+ (NSURLSessionDataTask *)requestWithWaimaiConfirmOrder:(NSString *)orderId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"eleme_order_id":objectNull(orderId)};
    debugLog(@"param=%@", [param modelToJSONString]);
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Waimai/ConfirmOrder" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  达达配送新增订单接口
 *
 *  @param input 传入参数
 *  @param completion block
 */
+ (NSURLSessionDataTask *)requestWithDadaAddOrder:(DaDaDistAddOrderInputEntity *)input completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"shop_id":@(input.shop_id), @"platform":objectNull(input.platform), @"order_id":objectNull(input.order_id), @"city_code":objectNull(input.city_code), @"order_price":@(input.order_price), @"name":objectNull(input.name), @"address":objectNull(input.address), @"phone":objectNull(input.phone), @"lat":objectNull(input.lat), @"lng":objectNull(input.lng)};
    debugLog(@"param=%@", [param modelToJSONString]);
//    return nil;
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Dada/AddOrder" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  取消达达 订单
 *
 *  @param sourceId 商户Id
 *  @param orderId 订单Id
 *  @param cancelReasonId 取消原因id
 *  @param cancelReason 取消原因
 *  @param completion block
 */
+ (NSURLSessionDataTask *)requestWithDadaCancelOrder:(NSString *)sourceId orderId:(NSString *)orderId cancelReasonId:(int)cancelReasonId cancelReason:(NSString *)cancelReason completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"source_id":objectNull(sourceId), @"order_id":objectNull(orderId), @"cancel_reason_id":@(cancelReasonId), @"cancel_reason":objectNull(cancelReason)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Dada/CancelOrder" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  取消达达订单的条件(原因)
 *
 *  @param sourceId 商户Id
 *  @param completion block
 */
+ (NSURLSessionDataTask *)requestWithDadaCancelOrderReq:(NSString *)sourceId completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"source_id":objectNull(sourceId)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Dada/CancelOrderReq" requestStyle:WYXGET completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (result.errcode == respond_success)
        {
            NSMutableArray *addList = [NSMutableArray new];
            for (id dict in result.data)
            {
                CellCommonDataEntity *ent = [CellCommonDataEntity modelWithJSON:dict];
                [addList addObject:ent];
            }
            if (addList.count > 0)
            {
                result.data = addList;
            }
            else
            {
                result.data = nil;
                result.errcode = respond_nodata;
            }
        }
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

/**
 *  达达新增订单小费
 *
 *  @param tipEntity 传入参数
 *  @param completion block
 */
+ (NSURLSessionDataTask *)requestWithDadaAddTip:(DaDaDistAddOrderTipsEntity *)tipEntity completion:(void(^)(id result))completion
{
    NSDictionary *param = @{@"source_id":objectNull(tipEntity.source_id), @"order_id":objectNull(tipEntity.order_id), @"tips":@(tipEntity.tips), @"city_code":objectNull(tipEntity.city_code), @"info":objectNull(tipEntity.info)};
    NSURLSessionDataTask *dataTask = [self requestWithBasicDict:param middleParam:@"Dada/AddTip" requestStyle:WYXPOST completion:^(TYZRespondDataEntity *result) {
        NSString *json = [result modelToJSONString];
        debugLog(@"json=%@", json);
        if (completion)
        {
            completion(result);
        }
    }];
    return dataTask;
}

@end






























