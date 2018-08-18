//
//  TYZDBManager.h
//  51tourGuide
//
//  Created by 唐斌 on 16/3/18.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HungryOrderInputTableEntity.h" // 订单
#import "HungryOrderDetailEntity.h"

@interface TestDataEntity : NSObject
@property (nonatomic, assign) NSInteger testId;
@property (nonatomic, copy) NSString *testName;
@end

@interface TYZDBManager : NSObject

+ (TYZDBManager *)shareInstance;

#pragma mark - test table
- (void)insertTest:(NSInteger)testId testName:(NSString *)testName;
- (void)updateTest:(NSInteger)testId testName:(NSString *)testName;
- (void)deleteTest:(NSInteger)testId;
/**
 *  获取数据
 *
 *  @param testId 为-1表示获取所有数据
 *
 *  @return array
 */
- (NSArray *)selectTest:(NSInteger)testId;

// collection
/**
 *  插入收藏餐厅
 *
 *  @param userId 用户id
 *  @param shopId 餐厅id
 */
- (void)insertWithCollection:(NSInteger)userId shopId:(NSInteger)shopId;

/**
 *  删除收藏
 *
 *  @param userId 用户id
 *  @param shopid 餐厅id
 */
- (void)deleteWithCollection:(NSInteger)userId shopId:(NSInteger)shopid;

/**
 *  查询这个餐厅是否收藏
 *
 *  @param userId 用户id
 *  @param shopId 餐厅id
 *
 *  @return bool
 */
- (BOOL)selectWithCollection:(NSInteger)userId shopId:(NSInteger)shopId;

- (NSArray *)getWithAllCollectionList:(NSInteger)userId;


#pragma mark -
#pragma mark 外卖订单表的增删改查
/**
 *  插入订单信息(存在问题，加入这个人有多家餐厅的，就不知道，具体的订单是哪家餐厅的)
 */
- (void)insertWithOrderInfo:(HungryOrderInputTableEntity *)entity;

/**
 *  删除订单
 */
- (void)deleteWithOrderInfo:(NSString *)orderId provider:(NSInteger)provider;

/**
 *  获取所有订单
 */
- (NSArray *)getWithAllOrderInfo:(NSInteger)userId;


#pragma mark -
#pragma mark 外卖订单详情
/**
 *  插入订单详情
 */
- (void)insertWithOrderDetail:(HungryOrderDetailEntity *)entity userId:(NSInteger)userId shopId:(NSInteger)shopid;

- (void)deleteWithOrderDetail:(NSInteger)orderId provider:(NSInteger)provider;

/**
 *  根据订单类型获取订单列表
 *
 *  @param orderType 订单类型
 */
- (NSArray *)getWithOrderAllDetails:(NSInteger)orderType;

/**
 *  获取订单详情
 *
 *  @param orderId 订单id
 *  @param provider 订单来源
 */
- (HungryOrderDetailEntity *)getWithOrderDetail:(NSInteger)orderId provider:(NSInteger)provider;


/**
 * 修改订单状态
 *
 *  @param statusCode 订单状态
 *  @param csstatusCode 自定义的订单状态
 *  @param orderId 订单id
 *  @param provider 来源
 */
- (void)updateOrderStatusCode:(NSInteger)statusCode csstatusCode:(NSInteger)csstatusCode orderId:(NSInteger)orderId provider:(NSInteger)provider;


/**
 *  修改订单的配送状态
 *
 *  @param deliverCode 订单配送状态
 *  @param csstatusCode 自定义的订单状态
 *  @param orderId 订单id
 *  @param provider 来源
 */
- (void)updateOrderDeliverStatusCode:(NSInteger)deliverCode csstatusCode:(NSInteger)csstatusCode orderId:(NSInteger)orderId provider:(NSInteger)provider;

/**
 *  修改订单的配送子状态
 *
 *  @param deliverSubCode 订单配送状态
 *  @param csstatusCode 自定义的订单状态
 *  @param orderId 订单id
 *  @param provider 来源
 */
- (void)updateOrderDeliverSubStatusCode:(NSInteger)deliverSubCode csstatusCode:(NSInteger)csstatusCode orderId:(NSInteger)orderId provider:(NSInteger)provider;

/**
 *  取消订单的原因类型
 *
 *  @param invalidType 取消订单原因类型
 *  @param orderId 订单id
 *  @param provider 平台id
 */
- (void)updateOrderinValidType:(NSInteger)invalidType orderId:(NSInteger)orderId provider:(NSInteger)provider;

// invalid_type



- (void)updateEmpOrder:(NSInteger)stateCode deliverCode:(NSInteger)deliverCode csCode:(NSInteger)csCode orderId:(NSInteger)orderId;


@end






















