//
//  TYZDBManager.m
//  51tourGuide
//
//  Created by 唐斌 on 16/3/18.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZDBManager.h"
#import "TYZDBHelper.h"
#import "TYZKit.h"
#import "HungryBaseInfoObject.h"


@implementation TestDataEntity
@end

#define ktestTableName @"t_test"

// 收藏表
#define kcollectionTableName @"t_collection"

// 饿了么（从自己服务端推送过来的订单id，和商家）
#define keleOrderTableName @"t_ele_order"

// 外卖订单详情
#define keleOrderDetailTableName @"t_ele_order_detail"

// 外卖订单对应的顾客联系电话
//#define keleOrderCustomerMobileTableName @"t_ele_order_mobile"



@interface TYZDBManager ()

/**
 *  创建所有的表
 */
- (void)createAllTable;

@end

@implementation TYZDBManager


+ (TYZDBManager *)shareInstance
{
    static TYZDBManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
        // 创建表
        [instance createAllTable];
    });
    return instance;
}

- (void)createAllTable
{
    FMDatabaseQueue *queue = [TYZDBHelper databaseQueue];
    if (!queue)
    {
        debugLog(@"database queue is nil.");
        return;
    }
    
    
    [queue inDatabase:^(FMDatabase *db) {
        
        NSString *createTableSql = [NSString stringWithFormat:@"create table if not exists %@(autoid integer primary key autoincrement not null, testId integer, testName varchar(30), regtime datetime);", ktestTableName];
        [db executeUpdate:createTableSql];
        
        // 创建收藏表
        createTableSql =  [NSString stringWithFormat:@"create table if not exists %@(autoid integer primary key autoincrement not null, userId integer, shopId integer, regtime datetime);", kcollectionTableName];
        [db executeUpdate:createTableSql];
        
        // 订单表
        /**
         *  autoid 自动编号
         *  userId 用户id
         *  shopId 商户id
         *  orderId 订单id
         * provider 提供者 1为饿了么，2为美团，3为百度外卖
         *  state 0表示通过订单id，获取订单详情失败；1表示获取成功
         */
        createTableSql = [NSString stringWithFormat:@"create table if not exists %@(autoid integer primary key autoincrement not null, userId integer, shopId integer, orderId varchar(50), provider integer, state integer, regtime datetime);", keleOrderTableName];
        [db executeUpdate:createTableSql];
        
        // 订单详情
        // cs_status_code 自己定义的订单状态
        createTableSql = [NSString stringWithFormat:@"create table if not exists %@(autoid integer primary key autoincrement not null, userId integer, shopId integer, address varchar(80), created_at datetime, active_at datetime, deliver_fee float, deliver_time datetime, deliver_status integer, deliver_sub_status integer, description varchar(200), detail text, invoice varchar(40), is_book BOOLEAN, is_online_paid BOOLEAN, order_id varchar(50), phone_list varchar(80), restaurant_id integer, inner_id integer, restaurant_name varchar(40), restaurant_number integer, status_code integer, refund_code integer, user_id integer, user_name varchar(16), total_price float, original_price float, consignee varchar(16), delivery_geo varchar(50), delivery_poi_address varchar(50), invoiced integer, income float, service_rate float, service_fee float, hongbao float, package_fee float, activity_total float, restaurant_part float, eleme_part float, invalid_type integer, provider integer, cs_status_code integer, regtime datetime);", keleOrderDetailTableName];
        [db executeUpdate:createTableSql];
        
        
        /*
         phone_list	int list	顾客联系电话

         */
        
    }];
}

#pragma mark - test table
- (void)insertTest:(NSInteger)testId testName:(NSString *)testName
{
    FMDatabaseQueue *queue = [TYZDBHelper databaseQueue];
    if (!queue)
    {
        debugLog(@"database queue is nil.");
        return;
    }
    [queue inDatabase:^(FMDatabase *db) {
        NSDate *date = [NSDate date];
        NSString *regtime = [date stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *strSql = [NSString stringWithFormat:@"insert into %@(testId, testName, regtime)values(%d, \"%@\", \"%@\");", ktestTableName, (int)testId, testName, regtime];
        [db executeUpdate:strSql];
    }];
}
- (void)updateTest:(NSInteger)testId testName:(NSString *)testName
{
    FMDatabaseQueue *queue = [TYZDBHelper databaseQueue];
    if (!queue)
    {
        debugLog(@"database queue is nil.");
        return;
    }
    [queue inDatabase:^(FMDatabase *db) {
        NSString *strSql = [NSString stringWithFormat:@"update %@ set testName=\"%@\" where testId=%d;", ktestTableName, testName, (int)testId];
        [db executeUpdate:strSql];
    }];
}
- (void)deleteTest:(NSInteger)testId
{
    FMDatabaseQueue *queue = [TYZDBHelper databaseQueue];
    if (!queue)
    {
        debugLog(@"database queue is nil.");
        return;
    }
    [queue inDatabase:^(FMDatabase *db) {
        NSString *strSql = [NSString stringWithFormat:@"delete from %@ where testid=%d;", ktestTableName, (int)testId];
        [db executeUpdate:strSql];
    }];
}
/**
 *  获取数据
 *
 *  @param testId 为-1表示获取所有数据
 *
 *  @return
 */
- (NSArray *)selectTest:(NSInteger)testId
{
    FMDatabaseQueue *queue = [TYZDBHelper databaseQueue];
    if (!queue)
    {
        debugLog(@"database queue is nil.");
        return nil;
    }
    NSString *strSql = nil;
    if (testId == -1)
    {
        strSql = [NSString stringWithFormat:@"select * from %@;", ktestTableName];
    }
    else
    {
        strSql = [NSString stringWithFormat:@"select * from %@ where testId=%d", ktestTableName, (int)testId];
    }
    NSMutableArray *array = [NSMutableArray array];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:strSql];
        while ([rs next])
        {
            TestDataEntity *ent = [[TestDataEntity alloc] init];
            ent.testId = [rs intForColumn:@"testId"];
            ent.testName = [rs stringForColumn:@"testName"];
            [array addObject:ent];
#if !__has_feature(objc_arc)
            [ent release], ent = nil;
#endif
        }
        [rs class];
    }];
    
    return array;
}


#pragma mark 收藏
/**
 *  插入收藏餐厅
 *
 *  @param userId 用户id
 *  @param shopId 餐厅id
 */
- (void)insertWithCollection:(NSInteger)userId shopId:(NSInteger)shopId
{
    // createTableSql =  [NSString stringWithFormat:@"create table if not exists %@(autoid integer primary key autoincrement not null, userId integer, shopId, regtime datetime);", kcollectionTableName];
    FMDatabaseQueue *queue = [TYZDBHelper databaseQueue];
    if (!queue)
    {
        debugLog(@"database queue is nil.");
        return;
    }
    
    [queue inDatabase:^(FMDatabase *db) {
        
        NSString *strSql = [NSString stringWithFormat:@"select count(*) as  scount from %@ where userId=%d and shopId=%d;", kcollectionTableName, (int)userId, (int)shopId];
//        debugLog(@"str=%@", strSql);
        NSInteger count = 0;
        FMResultSet *rs = [db executeQuery:strSql];
        while ([rs next])
        {
            count = [rs intForColumn:@"scount"];
        }
        [rs class];
        if (count != 0)
        {
            return ;
        }
        
        
        NSDate *date = [NSDate date];
        NSString *regtime = [date stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
        strSql = [NSString stringWithFormat:@"insert into %@(userId, shopId, regtime)values(%d, %d, \"%@\");", kcollectionTableName, (int)userId, (int)shopId, regtime];
        [db executeUpdate:strSql];
    }];
}

/**
 *  删除收藏
 *
 *  @param userId 用户id
 *  @param shopid 餐厅id
 */
- (void)deleteWithCollection:(NSInteger)userId shopId:(NSInteger)shopid
{
    FMDatabaseQueue *queue = [TYZDBHelper databaseQueue];
    if (!queue)
    {
        debugLog(@"database queue is nil.");
        return;
    }
    
    [queue inDatabase:^(FMDatabase *db) {
        NSString *strSql = [NSString stringWithFormat:@"delete from %@ where userId=%d and shopId=%d;", kcollectionTableName, (int)userId, (int)shopid];
        [db executeUpdate:strSql];
    }];
}

/**
 *  查询这个餐厅是否收藏
 *
 *  @param userId 用户id
 *  @param shopId 餐厅id
 *
 *  @return
 */
- (BOOL)selectWithCollection:(NSInteger)userId shopId:(NSInteger)shopId
{
    FMDatabaseQueue *queue = [TYZDBHelper databaseQueue];
    if (!queue)
    {
        debugLog(@"database queue is nil.");
        return NO;
    }
    
    __block BOOL bret = NO;
    
    [queue inDatabase:^(FMDatabase *db) {
        NSString *strSql = [NSString stringWithFormat:@"select count(*) as  scount from %@ where userId=%d and shopId=%d", kcollectionTableName, (int)userId, (int)shopId];
        NSInteger count = 0;
        FMResultSet *rs = [db executeQuery:strSql];
        while ([rs next])
        {
            count = [rs intForColumn:@"scount"];
        }
        [rs class];
        if (count != 0)
        {
            debugLog(@"有了");
            bret = YES;
        }
    }];
    
    return bret;
}

- (NSArray *)getWithAllCollectionList:(NSInteger)userId
{
    FMDatabaseQueue *queue = [TYZDBHelper databaseQueue];
    if (!queue)
    {
        debugLog(@"database queue is nil.");
        return nil;
    }
    NSString *strSql = nil;
    strSql = [NSString stringWithFormat:@"select * from %@;", kcollectionTableName];
    NSMutableArray *array = [NSMutableArray array];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:strSql];
        while ([rs next])
        {
            NSInteger shopId = [rs intForColumn:@"shopId"];
            [array addObject:@(shopId)];
        }
        [rs class];
    }];
    
    return array;
}

#pragma mark -
#pragma mark 外卖订单表的增删改查
/**
 *  插入订单信息
 */
- (void)insertWithOrderInfo:(HungryOrderInputTableEntity *)entity
{
    FMDatabaseQueue *queue = [TYZDBHelper databaseQueue];
    if (!queue)
    {
        debugLog(@"database queue is nil.");
        return;
    }
    
    [queue inDatabase:^(FMDatabase *db) {
        
        NSString *strSql = [NSString stringWithFormat:@"select count(*) as  scount from %@ where orderId=\"%@\";", keleOrderTableName, entity.orderId];
        debugLog(@"str=%@", strSql);
        NSInteger count = 0;
        FMResultSet *rs = [db executeQuery:strSql];
        while ([rs next])
        {
            count = [rs intForColumn:@"scount"];
        }
        [rs class];
        if (count != 0)
        {
            return ;
        }
        
        
        NSDate *date = [NSDate date];
        NSString *regtime = [date stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
        strSql = [NSString stringWithFormat:@"insert into %@(userId, shopId, orderId, provider, state, regtime)values(%d, %d, \"%@\", %d, %d, \"%@\");", keleOrderTableName, (int)entity.userId, (int)entity.shopId, objectNull(entity.orderId), (int)entity.provider, (int)entity.state, regtime];
        [db executeUpdate:strSql];
    }];
}

/**
 *  删除订单
 */
- (void)deleteWithOrderInfo:(NSString *)orderId provider:(NSInteger)provider
{
    FMDatabaseQueue *queue = [TYZDBHelper databaseQueue];
    if (!queue)
    {
        debugLog(@"database queue is nil.");
        return;
    }
    
    [queue inDatabase:^(FMDatabase *db) {
        NSString *strSql = [NSString stringWithFormat:@"delete from %@ where orderId=\"%@\" and provider=%d;", keleOrderTableName, objectNull(orderId), (int)provider];
        [db executeUpdate:strSql];
    }];
}

/**
 *  获取所有订单
 */
- (NSArray *)getWithAllOrderInfo:(NSInteger)userId
{
    FMDatabaseQueue *queue = [TYZDBHelper databaseQueue];
    if (!queue)
    {
        debugLog(@"database queue is nil.");
        return nil;
    }
    NSString *strSql = nil;
    strSql = [NSString stringWithFormat:@"select * from %@ where state=0 order by regtime desc;", keleOrderTableName];
    NSMutableArray *array = [NSMutableArray array];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:strSql];
        while ([rs next])
        {
            // userId, shopId, orderId, provider, state
            HungryOrderInputTableEntity *ent = [HungryOrderInputTableEntity new];
            ent.userId = [rs intForColumn:@"userId"];
            ent.shopId = [rs intForColumn:@"shopId"];
            ent.orderId = [rs stringForColumn:@"orderId"];
            ent.provider = [rs intForColumn:@"provider"];
            ent.state = [rs intForColumn:@"state"];
            [array addObject:ent];
        }
        [rs class];
    }];
    
    return array;
}

#pragma mark -
#pragma mark 外卖订单详情
/**
 *  插入订单详情
 */
- (void)insertWithOrderDetail:(HungryOrderDetailEntity *)entity userId:(NSInteger)userId shopId:(NSInteger)shopid
{
    FMDatabaseQueue *queue = [TYZDBHelper databaseQueue];
    if (!queue)
    {
        debugLog(@"database queue is nil.");
        return;
    }
    
    [queue inDatabase:^(FMDatabase *db) {
        
        NSString *orderId = [NSString stringWithFormat:@"%lld", (long long)entity.order_id];
        
        NSString *strSql = [NSString stringWithFormat:@"select count(*) as  scount from %@ where order_id=\"%@\" and provider=%d;", keleOrderDetailTableName, orderId, (int)entity.provider];
        debugLog(@"str=%@", strSql);
        NSInteger count = 0;
        FMResultSet *rs = [db executeQuery:strSql];
        while ([rs next])
        {
            count = [rs intForColumn:@"scount"];
        }
        [rs class];
        if (count != 0)
        {
            strSql = [NSString stringWithFormat:@"delete from %@ where orderId='%@' and provider=%d;", keleOrderTableName, orderId, (int)entity.provider];
            [db executeUpdate:strSql];
            return ;
        }
        
        
        NSDate *date = [NSDate date];
        NSString *regtime = [date stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSMutableString *mutPhone = [NSMutableString new];
        for (NSString *phone in entity.phone_list)
        {
            [mutPhone appendFormat:@",%@", phone];
        }
        NSString *strphone = [mutPhone substringFromIndex:1];
        
//        HungryOrderDetailCategoryEntity *detailEnt = [HungryOrderDetailCategoryEntity new];
//        detailEnt.group = entity.detail.group;
//        detailEnt.extra = entity.detail.extra;
        
        
        NSString *detail = [entity.detail modelToJSONString];
//        debugLog(@"detail=%@", detail);
        
        
        strSql = [NSString stringWithFormat:@"insert into %@(userId, shopId, address, created_at, active_at, deliver_fee, deliver_time, deliver_status, description, detail, invoice, is_book, is_online_paid, order_id, phone_list, restaurant_id, inner_id, restaurant_name, restaurant_number, status_code, refund_code, user_id, user_name, total_price, original_price, consignee, delivery_geo, delivery_poi_address, invoiced, income, service_rate, service_fee, hongbao, package_fee, activity_total, restaurant_part, eleme_part, invalid_type, provider, cs_status_code, regtime)values(%d, %d, \"%@\", \"%@\", \"%@\", %f, \"%@\", %d, \"%@\", '%@', \"%@\", %d, %d, \"%@\", \"%@\", %d, %d, \"%@\", %d, %d, %d, %d, \"%@\", %f, %f, \"%@\", \"%@\", \"%@\", %d, %f, %f, %f, %f, %f, %f, %f, %f, %d, %d, %d, \"%@\");", keleOrderDetailTableName, (int)userId, (int)shopid, objectNull(entity.address), objectNull(entity.created_at), objectNull(entity.active_at), entity.deliver_fee, objectNull(entity.deliver_time), entity.deliver_status, entity.desc, objectNull(detail), objectNull(entity.invoice), entity.is_book, entity.is_online_paid, orderId, strphone, (int)entity.restaurant_id, (int)entity.inner_id, entity.restaurant_name, (int)entity.restaurant_number, (int)entity.status_code, (int)entity.refund_code, (int)entity.user_id, entity.user_name, entity.total_price, entity.original_price, entity.consignee, entity.delivery_geo, objectNull(entity.delivery_poi_address), entity.invoiced, entity.income, entity.service_rate, entity.service_fee, entity.hongbao, entity.package_fee, entity.activity_total, entity.restaurant_part, entity.eleme_part, 9999, (int)entity.provider, (int)entity.cs_status_code, regtime];
        [db executeUpdate:strSql];
        
        
        strSql = [NSString stringWithFormat:@"delete from %@ where orderId='%@' and provider=%d;", keleOrderTableName, orderId, (int)entity.provider];
        [db executeUpdate:strSql];
    }];
}

- (void)deleteWithOrderDetail:(NSInteger)orderId provider:(NSInteger)provider
{
    FMDatabaseQueue *queue = [TYZDBHelper databaseQueue];
    if (!queue)
    {
        debugLog(@"database queue is nil.");
        return;
    }
    
    [queue inDatabase:^(FMDatabase *db) {
        NSString *strSql = [NSString stringWithFormat:@"delete from %@ where status_code=%lld and provider=%d;", keleOrderDetailTableName, (long long)orderId, (int)provider];
        [db executeUpdate:strSql];
    }];
}


/*
 EN_TM_ORDER_WAIT_ORDER = 0,     ///< 待接单--用户支付了费用或者到货付款(STATUS_CODE_PROCESSING-订单未处理)
 EN_TM_ORDER_RECEIVE_ORDER,      ///< 商家已接单--已接单，但未呼叫配送的订单(STATUS_CODE_PROCESSED_AND_VALID[订单已处理] && DELIVER_BE_ASSIGNED_MERCHANT[待分配])
 EN_TM_ORDER_SHIP_NOT_ORDER,     ///< 配送未接单--已经发布给配送方，配送方还没有配送员接单的订单(STATUS_CODE_PROCESSED_AND_VALID[订单已处理] && DELIVER_BE_ASSIGNED_COURIER[待分配])
 EN_TM_ORDER_PICKUP_ORDER,       ///< 取货中--已有配送员，正在取货途中的订单(STATUS_CODE_PROCESSED_AND_VALID[订单已处理] && DELIVER_BE_FETCHED[待取餐])
 EN_TM_ORDER_DIST_RESULT_ORDER,  ///< 配送结果 【(STATUS_CODE_PROCESSED_AND_VALID[订单已处理] && DELIVER_DELIVERING[配送中]) ||(STATUS_CODE_PROCESSED_AND_VALID[订单已处理] && DELIVER_COMPLETED[配送成功]) || STATUS_CODE_FINISHED[订单完成]】
 EN_TM_ORDER_EXCEPTION_ORDER,    ///< 异常订单  【STATUS_CODE_INVALID[订单已取消] || refund_code(退单)】
 */

- (NSArray *)getWithOrderAllDetails:(NSInteger)orderType
{
    FMDatabaseQueue *queue = [TYZDBHelper databaseQueue];
    if (!queue)
    {
        debugLog(@"database queue is nil.");
        return nil;
    }
    NSString *strSql = nil;
    if (orderType == EN_TM_ORDER_WAIT_ORDER)
    {// 待接单
        strSql = [NSString stringWithFormat:@"select * from %@ where status_code=%d or status_code=%d;", keleOrderDetailTableName, (int)STATUS_CODE_PROCESSING, (int)STATUS_CODE_UNPROCESSED];
        // 临时修改
//        strSql = [NSString stringWithFormat:@"select * from %@ ;", keleOrderDetailTableName];
    }
    else if (orderType == EN_TM_ORDER_RECEIVE_ORDER)
    {// 已接单
        
        strSql = [NSString stringWithFormat:@"select * from %@ where status_code=%d and deliver_status=0;", keleOrderDetailTableName, (int)STATUS_CODE_PROCESSED_AND_VALID];
        // 临时修改
//        strSql = [NSString stringWithFormat:@"select * from %@ ;", keleOrderDetailTableName];
    }
    else if (orderType == EN_TM_ORDER_SHIP_NOT_ORDER)
    {// 配送未接单
        strSql = [NSString stringWithFormat:@"select * from %@ where status_code=%d and deliver_status=%d;", keleOrderDetailTableName, (int)STATUS_CODE_PROCESSED_AND_VALID, (int)DELIVER_BE_ASSIGNED_COURIER];
        
        // 临时修改
//        strSql = [NSString stringWithFormat:@"select * from %@ ;", keleOrderDetailTableName];
    }
    else if (orderType == EN_TM_ORDER_PICKUP_ORDER)
    {// 取货中
        strSql = [NSString stringWithFormat:@"select * from %@ where status_code=%d and deliver_status=%d;", keleOrderDetailTableName, (int)STATUS_CODE_PROCESSED_AND_VALID, (int)DELIVER_BE_FETCHED];
        // 临时修改
//        strSql = [NSString stringWithFormat:@"select * from %@ ;", keleOrderDetailTableName];
    }
    else if (orderType == EN_TM_ORDER_DIST_RESULT_ORDER)
    {// 配送结果
        // (STATUS_CODE_PROCESSED_AND_VALID[订单已处理] && DELIVER_DELIVERING[配送中]) ||(STATUS_CODE_PROCESSED_AND_VALID[订单已处理] && DELIVER_COMPLETED[配送成功]) || STATUS_CODE_FINISHED[订单完成]】
        
        strSql = [NSString stringWithFormat:@"select * from %@ where (status_code=%d and deliver_status=%d) or (status_code=%d and deliver_status=%d) or status_code=%d;", keleOrderDetailTableName, (int)STATUS_CODE_PROCESSED_AND_VALID, (int)DELIVER_DELIVERING, (int)STATUS_CODE_PROCESSED_AND_VALID, (int)DELIVER_COMPLETED, (int)STATUS_CODE_FINISHED];
        // 临时修改
//        strSql = [NSString stringWithFormat:@"select * from %@ ;", keleOrderDetailTableName];
    }
    else if (orderType == EN_TM_ORDER_EXCEPTION_ORDER)
    {
        // 【STATUS_CODE_INVALID[订单已取消] || refund_code(退单)】
        strSql = [NSString stringWithFormat:@"select * from %@ where status_code=%d;", keleOrderDetailTableName, (int)STATUS_CODE_INVALID];
        // 临时修改
//        strSql = [NSString stringWithFormat:@"select * from %@ ;", keleOrderDetailTableName];
    }
    NSMutableArray *array = [NSMutableArray array];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:strSql];
        while ([rs next])
        {
            HungryOrderDetailEntity *ent = [HungryOrderDetailEntity new];
            ent.address = [rs stringForColumn:@"address"];
            float addHeight = [objectNull(ent.address) heightForFont:FONTSIZE_13 width:[[UIScreen mainScreen] screenWidth] - 20];
            ent.addressHeight = addHeight;
            ent.created_at = [rs stringForColumn:@"created_at"];
            ent.active_at = [rs stringForColumn:@"active_at"];
            ent.deliver_fee = [rs doubleForColumn:@"deliver_fee"];
            ent.deliver_time = [rs stringForColumn:@"deliver_time"];
            ent.deliver_status = [rs intForColumn:@"deliver_status"];
            ent.desc = [rs stringForColumn:@"description"];
            NSString *detail = [rs stringForColumn:@"detail"];
            NSDictionary *dict = [NSDictionary modelDictionaryWithJson:detail];
            HungryOrderDetailCategoryEntity *detailEnt = [HungryOrderDetailCategoryEntity modelWithJSON:dict];
            detailEnt.newgroups = [NSMutableArray new];
            ent.detail = detailEnt;
            ent.invoice = [rs stringForColumn:@"invoice"];
            ent.is_book = [rs boolForColumn:@"is_book"];
            ent.is_online_paid = [rs boolForColumn:@"is_online_paid"];
            ent.order_id = [[rs stringForColumn:@"order_id"] integerValue];
            ent.phone_list = [[rs stringForColumn:@"phone_list"] componentsSeparatedByString:@","];
            ent.restaurant_id = [rs intForColumn:@"restaurant_id"];
            ent.inner_id = [rs intForColumn:@"inner_id"];
            ent.restaurant_name = [rs stringForColumn:@"restaurant_name"];
            ent.restaurant_number = [rs intForColumn:@"restaurant_number"];
            ent.status_code = [rs intForColumn:@"status_code"];
            ent.refund_code = [rs intForColumn:@"refund_code"];
            ent.user_id = [rs intForColumn:@"user_id"];
            ent.user_name = [rs stringForColumn:@"user_name"];
            ent.total_price = [rs doubleForColumn:@"total_price"];
            ent.original_price = [rs doubleForColumn:@"original_price"];
            ent.consignee = [rs stringForColumn:@"consignee"];
            ent.delivery_geo = [rs stringForColumn:@"delivery_geo"];
            ent.delivery_poi_address = [rs stringForColumn:@"delivery_poi_address"];
            ent.invoiced = [rs intForColumn:@"invoiced"];
            ent.income = [rs doubleForColumn:@"income"];
            ent.service_rate = [rs doubleForColumn:@"service_rate"];
            ent.service_fee = [rs doubleForColumn:@"service_fee"];
            ent.hongbao = [rs doubleForColumn:@"hongbao"];
            ent.package_fee = [rs doubleForColumn:@"package_fee"];
            ent.activity_total = [rs doubleForColumn:@"activity_total"];
            ent.restaurant_part = [rs doubleForColumn:@"restaurant_part"];
            ent.eleme_part = [rs doubleForColumn:@"eleme_part"];
            ent.invalid_type = [rs intForColumn:@"invalid_type"];
            ent.provider = [rs intForColumn:@"provider"];
            ent.cs_status_code = [rs intForColumn:@"cs_status_code"];
            
            NSMutableArray *groups = [NSMutableArray new];
            for (id list in ent.detail.group)
            {
                NSMutableArray *addList = [NSMutableArray new];
                for (id dict in list)
                {
                    HungryOrderFoodEntity *foodEnt = [HungryOrderFoodEntity modelWithJSON:dict];
                    [addList addObject:foodEnt];
                    [ent.detail.newgroups addObject:foodEnt];
                    if (foodEnt.garnish.count > 0)
                    {
                        [ent.detail.newgroups addObjectsFromArray:foodEnt.garnish];
                    }
                }
                if ([addList count] > 0)
                {
                    [groups addObject:addList];
                }
            }
            if ([groups count] > 0)
            {
                ent.detail.group = groups;
            }
            
            [array addObject:ent];
        }
        [rs class];
    }];
    
    // total_price, original_price, consignee, delivery_geo, delivery_poi_address, invoiced, income, service_rate, service_fee, hongbao, package_fee, activity_total, restaurant_part, eleme_part
    
    return array;
}

/**
 *  获取订单详情
 *
 *  @param orderId 订单id
 *  @param provider 订单来源
 */
- (HungryOrderDetailEntity *)getWithOrderDetail:(NSInteger)orderId provider:(NSInteger)provider
{
    FMDatabaseQueue *queue = [TYZDBHelper databaseQueue];
    if (!queue)
    {
        debugLog(@"database queue is nil.");
        return nil;
    }
    NSString *strSql = nil;
    strSql = [NSString stringWithFormat:@"select * from %@ where order_id=%lld and provider=%d;", keleOrderDetailTableName, (long long)orderId, (int)provider];
    __block HungryOrderDetailEntity *orderDetailEnt = nil;
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:strSql];
        while ([rs next])
        {
            orderDetailEnt = [HungryOrderDetailEntity new];
            orderDetailEnt.address = [rs stringForColumn:@"address"];
            float addHeight = [objectNull(orderDetailEnt.address) heightForFont:FONTSIZE_13 width:[[UIScreen mainScreen] screenWidth] - 20];
            orderDetailEnt.addressHeight = addHeight;
            orderDetailEnt.created_at = [rs stringForColumn:@"created_at"];
            orderDetailEnt.active_at = [rs stringForColumn:@"active_at"];
            orderDetailEnt.deliver_fee = [rs doubleForColumn:@"deliver_fee"];
            orderDetailEnt.deliver_time = [rs stringForColumn:@"deliver_time"];
            orderDetailEnt.deliver_status = [rs intForColumn:@"deliver_status"];
            orderDetailEnt.deliver_sub_status = [rs intForColumn:@"deliver_sub_status"];
            orderDetailEnt.desc = [rs stringForColumn:@"description"];
            NSString *detail = [rs stringForColumn:@"detail"];
            NSDictionary *dict = [NSDictionary modelDictionaryWithJson:detail];
            HungryOrderDetailCategoryEntity *detailEnt = [HungryOrderDetailCategoryEntity modelWithJSON:dict];
            detailEnt.newgroups = [NSMutableArray new];
            orderDetailEnt.detail = detailEnt;
            orderDetailEnt.invoice = [rs stringForColumn:@"invoice"];
            orderDetailEnt.is_book = [rs boolForColumn:@"is_book"];
            orderDetailEnt.is_online_paid = [rs boolForColumn:@"is_online_paid"];
            orderDetailEnt.order_id = [[rs stringForColumn:@"order_id"] integerValue];
            orderDetailEnt.phone_list = [[rs stringForColumn:@"phone_list"] componentsSeparatedByString:@","];
            orderDetailEnt.restaurant_id = [rs intForColumn:@"restaurant_id"];
            orderDetailEnt.inner_id = [rs intForColumn:@"inner_id"];
            orderDetailEnt.restaurant_name = [rs stringForColumn:@"restaurant_name"];
            orderDetailEnt.restaurant_number = [rs intForColumn:@"restaurant_number"];
            orderDetailEnt.status_code = [rs intForColumn:@"status_code"];
            orderDetailEnt.refund_code = [rs intForColumn:@"refund_code"];
            orderDetailEnt.user_id = [rs intForColumn:@"user_id"];
            orderDetailEnt.user_name = [rs stringForColumn:@"user_name"];
            orderDetailEnt.total_price = [rs doubleForColumn:@"total_price"];
            orderDetailEnt.original_price = [rs doubleForColumn:@"original_price"];
            orderDetailEnt.consignee = [rs stringForColumn:@"consignee"];
            orderDetailEnt.delivery_geo = [rs stringForColumn:@"delivery_geo"];
            orderDetailEnt.delivery_poi_address = [rs stringForColumn:@"delivery_poi_address"];
            orderDetailEnt.invoiced = [rs intForColumn:@"invoiced"];
            orderDetailEnt.income = [rs doubleForColumn:@"income"];
            orderDetailEnt.service_rate = [rs doubleForColumn:@"service_rate"];
            orderDetailEnt.service_fee = [rs doubleForColumn:@"service_fee"];
            orderDetailEnt.hongbao = [rs doubleForColumn:@"hongbao"];
            orderDetailEnt.package_fee = [rs doubleForColumn:@"package_fee"];
            orderDetailEnt.activity_total = [rs doubleForColumn:@"activity_total"];
            orderDetailEnt.restaurant_part = [rs doubleForColumn:@"restaurant_part"];
            orderDetailEnt.eleme_part = [rs doubleForColumn:@"eleme_part"];
            orderDetailEnt.invalid_type = [rs intForColumn:@"invalid_type"];
            orderDetailEnt.provider = [rs intForColumn:@"provider"];
            orderDetailEnt.cs_status_code = [rs intForColumn:@"cs_status_code"];
            
            NSMutableArray *groups = [NSMutableArray new];
            for (id list in orderDetailEnt.detail.group)
            {
                NSMutableArray *addList = [NSMutableArray new];
                for (id dict in list)
                {
                    HungryOrderFoodEntity *foodEnt = [HungryOrderFoodEntity modelWithJSON:dict];
                    [addList addObject:foodEnt];
                    [orderDetailEnt.detail.newgroups addObject:foodEnt];
                    if (foodEnt.garnish.count > 0)
                    {
                        [orderDetailEnt.detail.newgroups addObjectsFromArray:foodEnt.garnish];
                    }
                }
                if ([addList count] > 0)
                {
                    [groups addObject:addList];
                }
            }
            if ([groups count] > 0)
            {
                orderDetailEnt.detail.group = groups;
            }
        }
        [rs class];
    }];
    return orderDetailEnt;
}

/**
 * 修改订单状态
 *
 *  @param statusCode 订单状态
 */
- (void)updateOrderStatusCode:(NSInteger)statusCode csstatusCode:(NSInteger)csstatusCode orderId:(NSInteger)orderId provider:(NSInteger)provider
{
    FMDatabaseQueue *queue = [TYZDBHelper databaseQueue];
    if (!queue)
    {
        debugLog(@"database queue is nil.");
        return;
    }
    
    [queue inDatabase:^(FMDatabase *db) {
        NSString *strSql = @"";
        if (csstatusCode == ELEME_ORDER_PROCESSED_AND_VALID)
        {
            strSql = [NSString stringWithFormat:@"update %@ set status_code=%d, cs_status_code=%d, deliver_status=0 where order_id=%lld and provider=%d;", keleOrderDetailTableName, (int)statusCode, (int)csstatusCode, (long long)orderId, (int)provider];
        }
        else
        {
            strSql = [NSString stringWithFormat:@"update %@ set status_code=%d, cs_status_code=%d where order_id=%lld and provider=%d;", keleOrderDetailTableName, (int)statusCode, (int)csstatusCode, (long long)orderId, (int)provider];
        }
        debugLog(@"strSql=%@", strSql);
        [db executeUpdate:strSql];
    }];
}

/**
 *  修改订单的配送状态
 *
 *  @param deliverCode 订单配送状态
 *  @param csstatusCode 自定义的订单状态
 *  @param orderId 订单id
 *  @param provider 来源
 */
- (void)updateOrderDeliverStatusCode:(NSInteger)deliverCode csstatusCode:(NSInteger)csstatusCode orderId:(NSInteger)orderId provider:(NSInteger)provider
{
    FMDatabaseQueue *queue = [TYZDBHelper databaseQueue];
    if (!queue)
    {
        debugLog(@"database queue is nil.");
        return;
    }
    
    [queue inDatabase:^(FMDatabase *db) {
        NSString *strSql = [NSString stringWithFormat:@"update %@ set deliver_status=%d, cs_status_code=%d where order_id=%lld and provider=%d;", keleOrderDetailTableName, (int)deliverCode, (int)csstatusCode, (long long)orderId, (int)provider];
        debugLog(@"strSql=%@", strSql);
        [db executeUpdate:strSql];
    }];
}

/**
 *  修改订单的配送子状态
 *
 *  @param deliverSubCode 订单配送状态
 *  @param csstatusCode 自定义的订单状态
 *  @param orderId 订单id
 *  @param provider 来源
 */
- (void)updateOrderDeliverSubStatusCode:(NSInteger)deliverSubCode csstatusCode:(NSInteger)csstatusCode orderId:(NSInteger)orderId provider:(NSInteger)provider
{
    FMDatabaseQueue *queue = [TYZDBHelper databaseQueue];
    if (!queue)
    {
        debugLog(@"database queue is nil.");
        return;
    }
    
    [queue inDatabase:^(FMDatabase *db) {
        NSString *strSql = [NSString stringWithFormat:@"update %@ set deliver_sub_status=%d, cs_status_code=%d where order_id=%lld and provider=%d;", keleOrderDetailTableName, (int)deliverSubCode, (int)csstatusCode, (long long)orderId, (int)provider];
        debugLog(@"strSql=%@", strSql);
        [db executeUpdate:strSql];
    }];
}

/**
 *  取消订单的原因类型
 *
 *  @param invalidType 取消订单原因类型
 *  @param orderId 订单id
 *  @param provider 平台id
 */
- (void)updateOrderinValidType:(NSInteger)invalidType orderId:(NSInteger)orderId provider:(NSInteger)provider
{
    FMDatabaseQueue *queue = [TYZDBHelper databaseQueue];
    if (!queue)
    {
        debugLog(@"database queue is nil.");
        return;
    }
    
    [queue inDatabase:^(FMDatabase *db) {
        NSString *strSql = [NSString stringWithFormat:@"update %@ set invalid_type=%d where order_id=%lld and provider=%d;", keleOrderDetailTableName, (int)invalidType, (long long)orderId, (int)provider];
        debugLog(@"strSql=%@", strSql);
        [db executeUpdate:strSql];
    }];
}

- (void)updateEmpOrder:(NSInteger)stateCode deliverCode:(NSInteger)deliverCode csCode:(NSInteger)csCode orderId:(NSInteger)orderId
{
    FMDatabaseQueue *queue = [TYZDBHelper databaseQueue];
    if (!queue)
    {
        debugLog(@"database queue is nil.");
        return;
    }
    
    [queue inDatabase:^(FMDatabase *db) {
        NSString *strSql = [NSString stringWithFormat:@"update %@ set status_code=%d, deliver_status=%d, cs_status_code=%d where order_id=%lld;", keleOrderDetailTableName, (int)stateCode, (int)deliverCode, (int)csCode, (long long)orderId];
        debugLog(@"strSql=%@", strSql);
        [db executeUpdate:strSql];
    }];
}

@end


























