//
//  ShopMealingOrderViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/14.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopMealingOrderViewController.h"
#import "LocalCommon.h"
#import "ManagerModeOrderTopView.h"
#import "ShopMealingOrderViewCell.h"
#import "ShopMealingOrderTopView.h"
#import "OrderCompletedInputEntity.h" // 查询订单传入参数
#import "UserLoginStateObject.h"
#import "OrderDataEntity.h"
#import "OrderEmptyView.h"
#import "OrderDetailDataEntity.h"
#import "WYXRongCloudMessage.h"

@interface ShopMealingOrderViewController ()
{
    ShopMealingOrderTopView *_topView;
    
    OrderEmptyView *_emptyView;
}

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) OrderCompletedInputEntity *inputEntity;

- (void)initWithTopView;

- (void)initWithEmptyView;

- (void)getWithOrderList;

/**
 *  推送的时候，接收到通知
 *
 *  @param note note
 */
- (void)orderWithReceivePushNote:(NSNotification *)note;

@end

@implementation ShopMealingOrderViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kWYXClientReceiveMessageNotification object:nil];
}


- (void)initWithVar
{
    [super initWithVar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderWithReceivePushNote:) name:kWYXClientReceiveMessageNotification object:nil];

    //    NSDate *date = [NSDate date];
    _inputEntity = [OrderCompletedInputEntity new];
    _inputEntity.shopId = [UserLoginStateObject getCurrentShopId];
    _inputEntity.diningDate = @"";//[date stringWithFormat:@"yyyy-MM-dd"];;
    _inputEntity.seat_number = @"";
    _inputEntity.customerName = @"";
    
    
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithTopView];
    
    AppDelegate *app = [UtilityObject appDelegate];
//    CGRect frame = CGRectMake(0, _topView.bottom, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight] - [app navBarHeight] - [app tabBarHeight] - STATUSBAR_HEIGHT - kManagerModeOrderTopViewHeight - _topView.height);
    CGRect frame = CGRectMake(0, _topView.bottom, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight] - [app navBarHeight] - STATUSBAR_HEIGHT - _topView.height);
    self.baseTableView.frame = frame;
    
    [self initWithEmptyView];
}

- (void)initWithEmptyView
{
    if (!_emptyView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight] / 3);
        _emptyView = [[OrderEmptyView alloc] initWithFrame:frame];
        [self.view addSubview:_emptyView];
        _emptyView.center = CGPointMake([[UIScreen mainScreen] screenWidth] / 2, [[UIScreen mainScreen] screenHeight] / 2 - 100);
        _emptyView.hidden = YES;
    }
}


- (void)doRefreshData
{
    [super doRefreshData];
    
    [self getWithOrderList];
    
}

- (void)doMoreRefreshData
{
    [super doMoreRefreshData];
    
    [self getWithOrderList];
}

- (void)initWithTopView
{
    CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kShopMealingOrderTopViewHeight);
    _topView = [[ShopMealingOrderTopView alloc] initWithFrame:frame];
    [self.view addSubview:_topView];
    __weak typeof(self)weakSelf = self;
    _topView.searchOrderBlock = ^(NSString *tableNo, NSString *name)
    {
        [weakSelf searchOrder:tableNo name:name];
    };
}

/**
 *  搜索
 *
 *  @param tableNo 桌号
 *  @param name    食客姓名
 */
- (void)searchOrder:(NSString *)tableNo name:(NSString *)name
{
    [self.view endEditing:YES];
//    debugLog(@"桌号：%@；姓名：%@", tableNo, name);
    _inputEntity.seat_number = objectNull(tableNo);
    _inputEntity.customerName = objectNull(name);
    [SVProgressHUD showWithStatus:@"搜索中"];
    [self doRefreshData];

}

- (void)getWithOrderList
{
    _inputEntity.shopId = [UserLoginStateObject getCurrentShopId];
    _inputEntity.pageIndex = self.pageId;
    [HCSNetHttp requestWithOrderShopingOrders:_inputEntity completion:^(id result) {
        [self responseWithOrderShopingOrders:result];
    }];
}

- (void)responseWithOrderShopingOrders:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success)
    {
        [SVProgressHUD dismiss];
        
        if (self.pageId == 1)
        {
            [self.baseList removeAllObjects];
        }
        
        [self.baseList addObjectsFromArray:respond.data];
        self.pageId += 1;
        [self.baseTableView reloadData];
    }
    else
    {
        [SVProgressHUD dismiss];
        if (self.pageId == 1)
        {
            [self.baseList removeAllObjects];
            [self.baseTableView reloadData];
        }
    }
    [self endAllRefreshing];
    
    _emptyView.hidden = YES;
    if ([self.baseList count] == 0)
    {
        _emptyView.hidden = NO;
    }
    
}

- (NSInteger)getBaseListCount
{
    return [self.baseList count];
}

/**
 *  推送的时候，接收到通知
 *
 *  @param note note
 */
- (void)orderWithReceivePushNote:(NSNotification *)note
{
    debugMethod();
    id msgEnt = [note object];
    if (![msgEnt isKindOfClass:[NotifyMessageEntity class]])
    {
        return;
    }
    NotifyMessageEntity *notifyMsg = (NotifyMessageEntity *)msgEnt;
    NotifyBodyEntity *cmdEnt = notifyMsg.notify_body;
    NSInteger type = cmdEnt.notify_cmd;
    debugLog(@"type=%d", (int)type);
    
    if (type == EN_PUSH_ORDER_BOOKED_NOTIFY_TS)
    {// 有客户预订请求的通知(1001)
        
    }
    else if (type == EN_PUSH_ORDER_DEPOSIT_SUCCESS_TS)
    {// 客户订金支付成功，完成预订的通知 (1002)
        
    }
    else if (type == EN_PUSH_ORDER_INSTANT_TS)
    {// 即时订单生成的通知 (1003)
        
    }
    else if (type == EN_PUSH_ORDER_CANCEL_TS)
    {// 账单取消的通知 (1004)
        
    }
    else if (type == EN_PUSH_ORDER_BACK_TS)
    {// 预订成功账单申请退单的通知 (1005)
        
    }
    else if (type == EN_PUSH_ORDER_PAYMENT_SUCCESS_TS)
    {// 食客支付完成账单的通知 (1006)
        [self doRefreshData];
    }

}

/*
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
 */

/*
 EN_PUSH_ORDER_SHOPS_NOTIFY_TC = 1,          ///< 预订后，商家的接单和拒单通知，（食客）
 EN_PUSH_ORDER_DEPOSIT_SUCCESS_TC = 2,       ///< 预定支付成功后，明确用户预订信息的通知。（食客）
 EN_PUSH_ORDER_ACTIVATED_TC = 3,             ///< 即时和预订订单激活后的通知。（食客）
 EN_PUSH_ORDER_KITCHEN_TC = 4,               ///< 服务员下单到后厨的通知。（食客）
 EN_PUSH_ORDER_BILL_CONFIRM_TC =5,           ///< 服务员确认账单的通知。（食客）
 EN_PUSH_ORDER_PAYMENT_CONFIRM_TC = 6,       ///< 服务员确认支付，完成订单。感谢下次光临的通知。（食客）
 EN_PUSH_ORDER_BOOKED_NOTIFY_TS = 1001,      ///< 有客户预订请求的通知。(餐厅）
 EN_PUSH_ORDER_DEPOSIT_SUCCESS_TS = 1002,    ///< 客户订金支付成功，完成预订的通知。（餐厅）
 EN_PUSH_ORDER_INSTANT_TS = 1003,            ///< 即时订单生成的通知。（餐厅）
 EN_PUSH_ORDER_CANCEL_TS = 1004,             ///< 账单取消的通知。（餐厅）
 EN_PUSH_ORDER_BACK_TS = 1005,               ///< 预订成功账单申请退单的通知。(餐厅）
 EN_PUSH_ORDER_PAYMENT_SUCCESS_TS = 1006,    ///< 食客支付完成账单的通知。（餐厅）
 
 */



// 查看订单信息
- (void)lookWithOrderInfo:(id)data indexPath:(NSIndexPath *)indexPath
{
    self.indexPath = indexPath;
    [MCYPushViewController showWithShopOrderDetailVC:self data:data completion:^(id data) {
        AppDelegate *app = [UtilityObject appDelegate];
        [app hiddenWithTipView:NO isTop:NO];
        OrderDetailDataEntity *orderDetailEnt = data;
        OrderDataEntity *orderEnt = [self.baseList objectOrNilAtIndex:indexPath.section];
        if (orderDetailEnt.order.status != orderEnt.status)
        {
            [self doRefreshData];
        }
//        orderEnt.status = orderDetailEnt.order.status;
//        orderEnt.status_remark = orderDetailEnt.order.status_remark;
//        [MCYPushViewController reloadWithTableView:self.baseTableView indexPath:indexPath reloadType:2];
    }];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.baseList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    OrderDataEntity *orderEnt = self.baseList[indexPath.section];
    ShopMealingOrderViewCell *cell = [ShopMealingOrderViewCell cellForTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateCellData:orderEnt];
    cell.baseTableViewCellBlock = ^(id data)
    {
        [weakSelf lookWithOrderInfo:data indexPath:indexPath];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderDataEntity *orderEnt = self.baseList[indexPath.section];
    CGFloat height = [ShopMealingOrderViewCell getWithCellHeight:orderEnt.type];
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OrderDataEntity *orderEnt = self.baseList[indexPath.section];
    [self lookWithOrderInfo:orderEnt indexPath:indexPath];
    
}


@end
