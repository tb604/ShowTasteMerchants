//
//  HungryBaseInfoObject.m
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/17.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "HungryBaseInfoObject.h"
#import "TYZDBManager.h"
#import "UserLoginStateObject.h"
#import "HungryNetHttp.h"
#import "HungryOrderStatusEntity.h"
#import "TYZKit.h"
#import "HungryOrderNoteEntity.h"

@interface HungryBaseInfoObject ()
{
    /// 订单状态
    NSDictionary *_orderStatusDict;
    
    /// 配送的状态
    NSDictionary *_deliverStatusDict;
    
    /// 配送子状态
    NSDictionary *_deliverSubStatusDict;
}
@end

@implementation HungryBaseInfoObject

+ (HungryBaseInfoObject *)shareInstance
{
    static HungryBaseInfoObject *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
        // 创建表
//        [instance createAllTable];
    });
    return instance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        // 订单状态
        _orderStatusDict = @{
                             @(ELEME_ORDER_INVALID):@(STATUS_CODE_INVALID),
                             @(ELEME_ORDER_UNPROCESSED):@(STATUS_CODE_UNPROCESSED),
                             @(ELEME_ORDER_PROCESSING):@(STATUS_CODE_PROCESSING),
                             @(ELEME_ORDER_PROCESSED_AND_VALID):@(STATUS_CODE_PROCESSED_AND_VALID),
                             @(ELEME_ORDER_SUCCESS):@(STATUS_CODE_FINISHED)
                             };
        
        
        // 配送状态
        _deliverStatusDict = @{@(DELIVERY_STATUS_TO_BE_ASSIGNED_MERCHANT):@(DELIVER_BE_ASSIGNED_MERCHANT),
                               @(DELIVERY_STATUS_TO_BE_ASSIGNED_COURIER):@(DELIVER_BE_ASSIGNED_COURIER),
                               @(DELIVERY_STATUS_TO_BE_FETCHED):@(DELIVER_BE_FETCHED),
                               @(DELIVERY_STATUS_DELIVERING):@(DELIVER_DELIVERING),
                               @(DELIVERY_STATUS_COMPLETED):@(DELIVER_COMPLETED),
                               @(DELIVERY_STATUS_CANCELLED):@(DELIVER_CANCELLED),
                               @(DELIVERY_STATUS_EXCEPTION):@(DELIVER_EXCEPTION)
                               };
        
        // 配送子状态(自定义的为key，商家定义的为value)
        _deliverSubStatusDict = @{
                                  @(DELIVERY_SUB_STATUS_MERCHANT_REASON):@(MERCHANT_REASON),
                                  @(DELIVERY_SUB_STATUS_CARRIER_REASON):@(CARRIER_REASON),
                                  @(DELIVERY_SUB_STATUS_USER_REASON):@(USER_REASON),
                                  @(DELIVERY_SUB_STATUS_SYSTEM_REASON):@(SYSTEM_REASON),
                                  @(DELIVERY_SUB_STATUS_MERCHANT_CALL_LATE_ERROR):@(MERCHANT_CALL_LATE_ERROR),
                                  @(DELIVERY_SUB_STATUS_MERCHANT_FOOD_ERROR):@(MERCHANT_FOOD_ERROR),
                                  @(DELIVERY_SUB_STATUS_MERCHANT_INTERRUPT_DELIVERY_ERROR):@(MERCHANT_INTERRUPT_DELIVERY_ERROR),
                                  @(DELIVERY_SUB_STATUS_USER_NOT_ANSWER_ERROR):@(USER_NOT_ANSWER_ERROR),
                                  @(DELIVERY_SUB_STATUS_USER_RETURN_ORDER_ERROR):@(USER_RETURN_ORDER_ERROR),
                                  @(DELIVERY_SUB_STATUS_USER_ADDRESS_ERROR):@(USER_ADDRESS_ERROR),
                                  @(DELIVERY_SUB_STATUS_DELIVERY_OUT_OF_SERVICE):@(DELIVERY_OUT_OF_SERVICE),
                                  @(DELIVERY_SUB_STATUS_CARRIER_REMARK_EXCEPTION_ERROR):@(CARRIER_REMARK_EXCEPTION_ERROR),
                                  @(DELIVERY_SUB_STATUS_SYSTEM_MARKED_ERROR):@(SYSTEM_MARKED_ERROR),
                                  @(DELIVERY_SUB_STATUS_OTHER_ERROR):@(OTHER_ERROR)
                                  };
    }
    return self;
}



/**
 *  从融云接收到订单信息
 */
- (void)revcOrderInfo:(HungryOrderBodyEntity *)entity
{
    NSLog(@"%s", __func__);
    
    /*
     ELEME_ORDER_INVALID = 2001,             ///< 订单已取消(STATUS_CODE_INVALID)
     ELEME_ORDER_UNPROCESSED = 2002,         ///< 订单未处理(STATUS_CODE_UNPROCESSED)
     ELEME_ORDER_PROCESSING = 2003,          ///<订单等待餐厅确认(STATUS_CODE_PROCESSING)
     ELEME_ORDER_PROCESSED_AND_VALID = 2004, ///< 订单已处理(STATUS_CODE_PROCESSED_AND_VALID)
     ELEME_ORDER_SUCCESS = 2999,             ///< 订单已完成(STATUS_CODE_FINISHED)
     */
    NSInteger platformId = EN_ORDER_SOURCE_ELE;
    if ([entity.body.platform isEqualToString:@"ele"])
    {
        platformId = EN_ORDER_SOURCE_ELE;
    }
    
    debugLog(@"order=%@", [entity modelToJSONString]);
    
    if (entity.commend == ELEME_ORDER_NEW)
    {// 新的订单，需要获取订单详情
        for (NSString *orderId in entity.body.eleme_order_ids)
        {
//            NSLog(@"orderId=%@", orderId);
            HungryOrderInputTableEntity *orderEnt = [HungryOrderInputTableEntity new];
            orderEnt.orderId = orderId;
            orderEnt.shopId = entity.shop_id;
            orderEnt.provider = platformId;
            orderEnt.state = 0;
            orderEnt.userId = [UserLoginStateObject getUserId];
            [[TYZDBManager shareInstance] insertWithOrderInfo:orderEnt];
            // 获取订单详情
            [self getOrderDetail:orderEnt commend:entity.commend];
            
        }
    }
    else if ([[_orderStatusDict allKeys] containsObject:@(entity.commend)])
    {// 订单状态修改
        debugLog(@"订单状态修改");
        [self updateWithOrderState:entity platformId:platformId];
    }
    else if ([[_deliverStatusDict allKeys] containsObject:@(entity.commend)])
    {// 订单配送状态
        debugLog(@"订单配送状态");
        [self updateWithOrderDeliverState:entity platformId:platformId];
    }
    else if ([[_deliverSubStatusDict allKeys] containsObject:@(entity.commend)])
    {// 订单配送子状态
        debugLog(@"订单配送子状态");
        [self updateWithOrderDeliverSubState:entity platformId:entity.commend];
    }
    /*else if (entity.commend == ELEME_ORDER_INVALID)
    {// 订单已取消
        [self updateWithOrderState:entity platformId:platformId];
    }
    else if (entity.commend == ELEME_ORDER_UNPROCESSED)
    {// 订单未处理(STATUS_CODE_UNPROCESSED)
        debugLog(@"订单未处理状态了");
        [self updateWithOrderState:entity platformId:platformId];
    }
    else if (entity.commend == ELEME_ORDER_PROCESSING)
    {// 订单等待餐厅确认(STATUS_CODE_PROCESSING)
        debugLog(@"等待餐厅确认呢");
        [self updateWithOrderState:entity platformId:platformId];
    }
    else if (entity.commend == ELEME_ORDER_PROCESSED_AND_VALID)
    {// 订单已处理(STATUS_CODE_PROCESSED_AND_VALID)
        debugLog(@"订单已处理");
        [self updateWithOrderState:entity platformId:platformId];
    }
    else if (entity.commend == ELEME_ORDER_SUCCESS)
    {// 订单已完成(STATUS_CODE_FINISHED)
        debugLog(@"订单已完成");
        [self updateWithOrderState:entity platformId:platformId];
    }*/
    
}

/*
 ELEME_ORDER_INVALID = 2001,             ///< 订单已取消(STATUS_CODE_INVALID)
 ELEME_ORDER_UNPROCESSED = 2002,         ///< 订单未处理(STATUS_CODE_UNPROCESSED)
 ELEME_ORDER_PROCESSING = 2003,          ///< 订单等待餐厅确认(STATUS_CODE_PROCESSING)
 ELEME_ORDER_PROCESSED_AND_VALID = 2004, ///< 订单已处理(STATUS_CODE_PROCESSED_AND_VALID)
 ELEME_ORDER_SUCCESS = 2999,             ///< 订单已完成(STATUS_CODE_FINISHED)
 */
/*- (NSInteger)stateWithCode:(NSInteger)commend
{
    NSInteger statusCode = 0;
    switch (commend)
    {
        case ELEME_ORDER_INVALID:  // 订单已取消
            statusCode = STATUS_CODE_INVALID;
            break;
        case ELEME_ORDER_UNPROCESSED: // 订单未处理
            statusCode = STATUS_CODE_UNPROCESSED;
            break;
        case ELEME_ORDER_PROCESSING: // 订单等待餐厅确认
            statusCode = STATUS_CODE_PROCESSING;
            break;
        case ELEME_ORDER_PROCESSED_AND_VALID: // 订单已处理
            statusCode = STATUS_CODE_PROCESSED_AND_VALID;
            break;
        case ELEME_ORDER_SUCCESS: // 订单已完成
            statusCode = STATUS_CODE_FINISHED;
            break;
        default:
            break;
    }
    return statusCode;
}*/

// _deliverSubStatusDict

/**
 *  修改订单的配送状态
 */
- (void)updateWithOrderDeliverState:(HungryOrderBodyEntity *)entity platformId:(NSInteger)platformId
{
    NSInteger deliverCode = [_deliverStatusDict[@(entity.commend)] integerValue];
    [[TYZDBManager shareInstance] updateOrderDeliverStatusCode:deliverCode csstatusCode:entity.commend orderId:[entity.body.eleme_order_id integerValue] provider:platformId];
    
    HungryOrderDetailEntity *orderDetailEnt = [[TYZDBManager shareInstance] getWithOrderDetail:[entity.body.eleme_order_id integerValue] provider:platformId];
    
    if (orderDetailEnt)
    {
        // 发送通知
        debugLog(@"发送通知");
        [self sendOrderNote:orderDetailEnt commend:entity.commend];
    }
    else
    {
        debugLog(@"发送通知的时候订单详情为空");
    }
}

/**
 *  修改订单的配送子状态
 */
- (void)updateWithOrderDeliverSubState:(HungryOrderBodyEntity *)entity platformId:(NSInteger)platformId
{
    NSInteger deliverSubCode = [_deliverSubStatusDict[@(entity.commend)] integerValue];
    [[TYZDBManager shareInstance] updateOrderDeliverSubStatusCode:deliverSubCode csstatusCode:entity.commend orderId:[entity.body.eleme_order_id integerValue] provider:platformId];
    
    HungryOrderDetailEntity *orderDetailEnt = [[TYZDBManager shareInstance] getWithOrderDetail:[entity.body.eleme_order_id integerValue] provider:platformId];
    
    if (orderDetailEnt)
    {
        // 发送通知
        debugLog(@"发送通知");
        [self sendOrderNote:orderDetailEnt commend:entity.commend];
    }
    else
    {
        debugLog(@"发送通知的时候订单详情为空");
    }
}

/**
 * 修改订单状态
 */
- (void)updateWithOrderState:(HungryOrderBodyEntity *)entity platformId:(NSInteger)platformId
{
    NSInteger statusCode = [_orderStatusDict[@(entity.commend)] integerValue];//[self stateWithCode:entity.commend];
    [[TYZDBManager shareInstance] updateOrderStatusCode:statusCode csstatusCode:entity.commend orderId:[entity.body.eleme_order_id integerValue] provider:platformId];
    [HungryNetHttp requestWithHungryOrderStatus:[entity.body.eleme_order_id integerValue] completion:^(TYZRespondDataEntity *result) {
        debugLog(@"返回状态了");
        if (result.errcode == 200)
        {
            debugLog(@"获取状态成功");
            HungryOrderStatusEntity *orderStatus = result.data;
            // 更新订单状态
            [[TYZDBManager shareInstance] updateOrderStatusCode:orderStatus.status_code csstatusCode:entity.commend orderId:[entity.body.eleme_order_id integerValue] provider:platformId];
            if (orderStatus.extra)
            {
                // 更新取消原因类型
                [[TYZDBManager shareInstance] updateOrderinValidType:orderStatus.extra.invalid_type orderId:[entity.body.eleme_order_id integerValue] provider:platformId];
            }
        }
        
        HungryOrderDetailEntity *orderDetailEnt = [[TYZDBManager shareInstance] getWithOrderDetail:[entity.body.eleme_order_id integerValue] provider:platformId];
        
        if (orderDetailEnt)
        {
            // 发送通知
            debugLog(@"发送通知");
            [self sendOrderNote:orderDetailEnt commend:entity.commend];
        }
        else
        {
            debugLog(@"发送通知的时候订单详情为空");
        }
    }];
}

/*
 RC:CtcMsgWaiMai
 
 {"shop_id":76,"type":2,"cmd":2000,"body":"{\"platform\":\"ele\",\"eleme_order_ids\":[\"101582797453145710\"]}","description":"ddd","request_id":"c38dca418e6bfb0877ce8a4373df7a8b"}
 */

/**
 *  通过订单id获取订单详情
 */
- (void)orderIdToOrderDetail
{
    NSArray *list = [[TYZDBManager shareInstance] getWithAllOrderInfo:0];
    for (HungryOrderInputTableEntity *ent in list)
    {
        [self getOrderDetail:ent commend:9999];
    }
}

/**
 *  获取订单详情
 */
- (void)getOrderDetail:(HungryOrderInputTableEntity *)entity commend:(NSInteger)commend
{
    if (entity.provider == EN_ORDER_SOURCE_ELE)
    {// 饿了么
        [HungryNetHttp requestWithHungryOrderDetail:[entity.orderId integerValue] tpId:0 completion:^(TYZRespondDataEntity *result) {
            if (result.errcode == 200)
            {
                HungryOrderDetailEntity *orderDetailEnt = result.data;
                orderDetailEnt.provider = entity.provider;
                if (commend != 9999)
                {
                    orderDetailEnt.cs_status_code = commend;
                }
                
                [[TYZDBManager shareInstance] insertWithOrderDetail:orderDetailEnt userId:entity.userId shopId:entity.shopId];
                
                // 发送通知
                [self sendOrderNote:orderDetailEnt commend:commend];
            }
            else
            {
                
            }
        }];
    }
    
}

/**
 *  获取订单详情数组
 *
 *  @param orderType 类型
 */
- (NSArray *)getOrderDetailList:(NSInteger)orderType
{
    return [[TYZDBManager shareInstance] getWithOrderAllDetails:orderType];
}

/**
 * 发送通知
 */
- (void)sendOrderNote:(HungryOrderDetailEntity *)orderDetailEnt commend:(NSInteger)commend
{
    HungryOrderNoteEntity *noteEnt = [HungryOrderNoteEntity new];
    noteEnt.orderEntitiy = orderDetailEnt;
    noteEnt.commend = commend;
    [[NSNotificationCenter defaultCenter] postNotificationName:kHUNGRY_NEW_ORDER_NOTE object:noteEnt];
}

- (void)getWithOrderDetail:(NSInteger)orderId
{
//    debugLog(@"dddddddd");
    [HungryNetHttp requestWithHungryOrderDetail:orderId tpId:0 completion:^(TYZRespondDataEntity *result) {
        
        
        if (result.errcode == 200)
        {
            debugLog(@"rrrr");
            HungryOrderDetailEntity *detailEnt = result.data;
            [[TYZDBManager shareInstance] updateOrderStatusCode:detailEnt.status_code csstatusCode:2004 orderId:detailEnt.order_id provider:1];
        }
        
    }];
}

@end
