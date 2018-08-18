//
//  ShopFinishOrderViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/14.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopFinishOrderViewController.h"
#import "LocalCommon.h"
#import "ManagerModeOrderTopView.h"
#import "ShopFinishOrderViewCell.h"
#import "ShopFinishOrderTopView.h"
#import "WYXCalendarDayModel.h"
#import "TYZChoiceDateBackgroundView.h" // 日期选择视图
#import "OrderCompletedInputEntity.h" // 查询订单传入参数
#import "UserLoginStateObject.h"
#import "OrderEmptyView.h"
#import "OrderDetailDataEntity.h"
#import "WYXRongCloudMessage.h"

@interface ShopFinishOrderViewController ()
{
    ShopFinishOrderTopView *_topView;
    
    /**
     *  日期选择视图
     */
    TYZChoiceDateBackgroundView *_choiceDateView;
    
    OrderEmptyView *_emptyView;
}

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) OrderCompletedInputEntity *inputEntity;

- (void)initWithTopView;

- (void)getWithOrderList;

- (void)showWithChoiceDateView:(BOOL)show;

/**
 *  推送的时候，接收到通知
 *
 *  @param note note
 */
- (void)orderWithReceivePushNote:(NSNotification *)note;

@end

@implementation ShopFinishOrderViewController

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
    _inputEntity.customerName = @"";
    _inputEntity.orderId = @"";
    
//    [self.baseList addObject:@"1"];
//    [self.baseList addObject:@"1"];
//    [self.baseList addObject:@"1"];
//    [self.baseList addObject:@"1"];
//    [self.baseList addObject:@"1"];
//    [self.baseList addObject:@"1"];
//    [self.baseList addObject:@"1"];
//    [self.baseList addObject:@"1"];
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithTopView];
    
    AppDelegate *app = [UtilityObject appDelegate];
//    CGRect frame = CGRectMake(0, kShopFinishOrderTopViewHeight, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight] - [app navBarHeight] - [app tabBarHeight] - STATUSBAR_HEIGHT - kManagerModeOrderTopViewHeight - kShopFinishOrderTopViewHeight);
    CGRect frame = CGRectMake(0, kShopFinishOrderTopViewHeight, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight] - [app navBarHeight] - STATUSBAR_HEIGHT - kShopFinishOrderTopViewHeight);
    self.baseTableView.frame = frame;
    
    [self initWithEmptyView];
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
    CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kShopFinishOrderTopViewHeight);
    _topView = [[ShopFinishOrderTopView alloc] initWithFrame:frame];
    [self.view addSubview:_topView];
    __weak typeof(self)weakSelf = self;
    _topView.searchOrderBlock = ^(NSString *date, NSString *name, NSString *orderNo)
    {
        [weakSelf searchOrder:date name:name orderNo:orderNo];
    };
    _topView.viewCommonBlock = ^(id data)
    {// 选择日期
        [weakSelf showWithChoiceDateView:YES];
    };
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
    
    if (type == EN_PUSH_ORDER_CANCEL_TS)
    {// 账单取消的通知 (1004)
        [self doRefreshData];
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



/**
 *  搜索
 *
 *  @param date    到店日期
 *  @param name    食客姓名
 *  @param orderNo 订单编号
 */
- (void)searchOrder:(NSString *)date name:(NSString *)name orderNo:(NSString *)orderNo
{
    [self.view endEditing:YES];
    _inputEntity.diningDate = date;
    _inputEntity.orderId = objectNull(orderNo);
    _inputEntity.customerName = objectNull(name);
    [SVProgressHUD showWithStatus:@"搜索中"];
    [self doRefreshData];
}

- (void)showWithChoiceDateView:(BOOL)show
{
    __weak typeof(self)blockSelf = self;
    if (!_choiceDateView)
    {
        _choiceDateView = [[TYZChoiceDateBackgroundView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight])];
        _choiceDateView.alpha = 0;
    }
    _choiceDateView.TouchDateBlock = ^(NSString *date, NSInteger type)
    {
        if (type == -1)
        {
            return;
        }
        [blockSelf modifyWithArriveDate:date];
    };
    if (show)
    {
        
        [_choiceDateView updateWithDate:[_topView getWithDate]];
        [self.view.window addSubview:_choiceDateView];
        [UIView animateWithDuration:0.5 animations:^{
            _choiceDateView.alpha = 1.0;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            _choiceDateView.alpha = 0;
        } completion:^(BOOL finished) {
            [_choiceDateView removeFromSuperview];
        }];
    }
}

- (void)modifyWithArriveDate:(NSString *)date
{
    if (date)
    {
        [_topView updateViewData:date];
    }
    [self showWithChoiceDateView:NO];
}


- (void)getWithOrderList
{
    _inputEntity.shopId = [UserLoginStateObject getCurrentShopId];
    _inputEntity.pageIndex = self.pageId;
    [HCSNetHttp requestWithOrderShopCompletedOrders:_inputEntity completion:^(id result) {
        [self responseWithOrderShopCompletedOrders:result];
    }];
}

- (void)responseWithOrderShopCompletedOrders:(TYZRespondDataEntity *)respond
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
        if (respond.errcode == 0 && self.pageId == 1)
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

// 查看订单信息
- (void)lookWithOrderInfo:(id)data indexPath:(NSIndexPath *)indexPath
{
    self.indexPath = indexPath;
    
    OrderDataEntity *orderEnt = data;
    if (orderEnt.status == NS_ORDER_PAY_COMPLETE_STATE || orderEnt.status == NS_ORDER_ORDER_COMPLETE_STATE)
    {
        [MCYPushViewController showWithFinishOrderDetailVC:self data:orderEnt modeType:1 completion:^(id data) {
            AppDelegate *app = [UtilityObject appDelegate];
            [app hiddenWithTipView:NO isTop:NO];
            OrderDetailDataEntity *orderDetailEnt = data;
            OrderDataEntity *orderEnt = [self.baseList objectOrNilAtIndex:indexPath.section];//self.baseList[indexPath.section];
            if (orderDetailEnt.order.status != orderEnt.status)
            {
                [self doRefreshData];
            }
            else if (orderEnt.status == NS_ORDER_ORDER_COMPLETE_STATE && orderEnt.comment_status != orderDetailEnt.order.comment_status)
            {
                [self doRefreshData];
            }
        }];
        return;
    }
    
    [MCYPushViewController showWithShopOrderDetailVC:self data:data completion:^(id data) {
        AppDelegate *app = [UtilityObject appDelegate];
        [app hiddenWithTipView:NO isTop:NO];
        OrderDetailDataEntity *orderDetailEnt = data;
        OrderDataEntity *orderEnt = [self.baseList objectOrNilAtIndex:indexPath.section];//self.baseList[indexPath.section];
        if (orderDetailEnt.order.status != orderEnt.status)
        {
            [self doRefreshData];
        }
        else if (orderEnt.status == NS_ORDER_ORDER_COMPLETE_STATE && orderEnt.comment_status != orderDetailEnt.order.comment_status)
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
    return [self.baseList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    ShopFinishOrderViewCell *cell = [ShopFinishOrderViewCell cellForTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateCellData:self.baseList[indexPath.section]];
    cell.baseTableViewCellBlock = ^(id data)
    {
        [weakSelf lookWithOrderInfo:data indexPath:indexPath];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = kShopFinishOrderViewControllerHeight;
    
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
