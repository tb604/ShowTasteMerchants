//
//  ShopReservationOrderViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/14.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopReservationOrderViewController.h"
#import "LocalCommon.h"
#import "ManagerModeOrderTopView.h"
#import "ShopReservationOrderViewCell.h"
#import "ShopReservationOrderTopView.h"
#import "OrderCompletedInputEntity.h" // 查询订单传入参数
#import "UserLoginStateObject.h"
#import "ShopImmediateOrderViewCell.h"
#import "OrderDataEntity.h"
#import "TYZComboBox.h"
#import "OrderDetailDataEntity.h"
#import "OrderEmptyView.h"
#import "WYXRongCloudMessage.h"
#import "TYZChoiceDateBackgroundView.h" // 日期选择视图

@interface ShopReservationOrderViewController () <ComboBoxDelegate>
{
    ShopReservationOrderTopView *_topView;
    
    /**
     *  订单类型
     */
    TYZComboBox *_orderTypeComboBox;
    
    OrderEmptyView *_emptyView;
    
    /**
     *  日期选择视图
     */
    TYZChoiceDateBackgroundView *_choiceDateView;
    
}

@property (nonatomic, strong) OrderCompletedInputEntity *inputEntity;

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)initWithTopView;

- (void)initWithOrderTypeComboBox;

- (void)initWithEmptyView;

- (void)getWithOrderList;

/**
 *  推送的时候，接收到通知
 *
 *  @param note note
 */
- (void)orderWithReceivePushNote:(NSNotification *)note;

@end

@implementation ShopReservationOrderViewController

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
    // 订单状态 0：全部订单 1：待确认 2：待预付 4：预订完成
    _inputEntity.status = 0;
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
//    self.baseTableView.hidden = YES;
    
    [self initWithOrderTypeComboBox];
    
    [self initWithEmptyView];
    
}

- (void)initWithOrderTypeComboBox
{
    if (!_orderTypeComboBox)
    {
        CGFloat btnWidth = 60;
        CGFloat _txtWidth;
        
        CGFloat _spaceOne;
        
        CGFloat _spaceTwo;
        if (kiPhone4 || kiPhone5)
        {
            _spaceTwo = 6;
            _spaceOne = 3;
            btnWidth = 50;
        }
        else
        {
            _spaceTwo = 15;
            _spaceOne = 5;
        }
        
        CGFloat width = [[UIScreen mainScreen] screenWidth] - btnWidth - _spaceTwo * 2 - _spaceTwo - _spaceOne * 2;
        NSString *str = @"输入桌号";
        if (kiPhone4 || kiPhone5)
        {
            str = @"类型";
        }
        CGFloat fontWidth = [str widthForFont:FONTSIZE(12)];
        _txtWidth = (width - fontWidth * 2) / 2;
        
        
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - btnWidth - _spaceTwo - _txtWidth, 5, _txtWidth, 30);
        
        _orderTypeComboBox = [[TYZComboBox alloc] initWithFrame:frame];
        //        订单状态 0：全部订单 1：待确认 2：待预付 4：预订完成
        _orderTypeComboBox.listItems = @[@"全部", @"待确认", @"待预付", @"预订完成"];
        _orderTypeComboBox.tag = 100;
        _orderTypeComboBox.borderColor = [UIColor colorWithHexString:@"#cdcdcd"];
        _orderTypeComboBox.bgColor = [UIColor colorWithHexString:@"#f5f5f5"];
        _orderTypeComboBox.borderWidth = 1.0f;
        _orderTypeComboBox.cornerRadius = 4.0f;
        _orderTypeComboBox.arrowImage = [UIImage imageNamed:@"btn_xialasanjiao"];
        _orderTypeComboBox.delegate = self;
        _orderTypeComboBox.testString = @"全部";
        [self.view addSubview:_orderTypeComboBox];
    }
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

#pragma mark ComboBoxDelegate
- (void)comboBox:(TYZComboBox *)comboBox didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = comboBox.listItems[indexPath.row];
    _inputEntity.status = [self getWithOrderState:str];
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
    __weak typeof(self)weakSelf = self;
    CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kShopReservationOrderTopViewHeight);
    _topView = [[ShopReservationOrderTopView alloc] initWithFrame:frame];
    [self.view addSubview:_topView];
    _topView.searchOrderBlock = ^(NSString *date, NSString *orderType, NSString *name)
    {
        [weakSelf searchOrder:date orderType:orderType name:name];
    };
    _topView.viewCommonBlock = ^(id data)
    {// 选择日期
        [weakSelf showWithChoiceDateView:YES];
    };
}

/**
 *
 *
 *  @param date      到店日期
 *  @param orderType 订单类型
 *  @param name      食客姓名
 */
- (void)searchOrder:(NSString *)date orderType:(NSString *)orderType name:(NSString *)name
{
    [self.view endEditing:YES];
    _inputEntity.diningDate = date;
    _inputEntity.customerName = name;
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
    // 获取预订订单列表
    [HCSNetHttp requestWithOrderShopBookOrders:_inputEntity completion:^(id result) {
        [self responseWithOrderShopBookOrders:result];
    }];
    
}

- (void)responseWithOrderShopBookOrders:(TYZRespondDataEntity *)respond
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

/*
 订单状态 0：全部订单 1：待确认 2：待预付 4：预订完成
 */
- (NSInteger)getWithOrderState:(NSString *)stateDesc
{
    NSInteger state = 0;
    if ([stateDesc isEqualToString:@"待确认"])
    {
        state = 1;
    }
    else if ([stateDesc isEqualToString:@"待预付"])
    {
        state = 2;
    }
    else if ([stateDesc isEqualToString:@"预订完成"])
    {
        state = 4;
    }
    
    return state;
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
//    debugLog(@"type=%d", (int)notifyMsg.notify_type);
    
//    NSInteger type = notifyMsg.notify_type;
    NotifyBodyEntity *cmdEnt = notifyMsg.notify_body;
    NSInteger type = cmdEnt.notify_cmd;
    debugLog(@"type=%d", (int)type);
    if (type == EN_PUSH_ORDER_BOOKED_NOTIFY_TS)
    {// 有客户预订请求的通知(1001)
        [self doRefreshData];
    }
    else if (type == EN_PUSH_ORDER_DEPOSIT_SUCCESS_TS)
    {// 客户订金支付成功，完成预订的通知 (1002)
        [self doRefreshData];
    }
    else if (type == EN_PUSH_ORDER_INSTANT_TS)
    {// 即时订单生成的通知 (1003)
        [self doRefreshData];
    }
    else if (type == EN_PUSH_ORDER_CANCEL_TS)
    {// 账单取消的通知 (1004)
        [self doRefreshData];
    }
    else if (type == EN_PUSH_ORDER_BACK_TS)
    {// 预订成功账单申请退单的通知 (1005)
        [self doRefreshData];
    }
    else if (type == EN_PUSH_ORDER_PAYMENT_SUCCESS_TS)
    {// 食客支付完成账单的通知 (1006)
        
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
        OrderDataEntity *orderEnt = [self.baseList objectOrNilAtIndex:indexPath.section];//self.baseList[indexPath.section];
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
    return [self.baseList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    
    OrderDataEntity *orderEnt = self.baseList[indexPath.section];
    if (orderEnt.type == 1)
    {// 预订订单
        ShopReservationOrderViewCell *cell = [ShopReservationOrderViewCell cellForTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell updateCellData:orderEnt];
        cell.baseTableViewCellBlock = ^(id data)
        {
            [weakSelf lookWithOrderInfo:data indexPath:indexPath];
        };
        return cell;
    }
    else if (orderEnt.type == 2)
    {// 即时订单
        ShopImmediateOrderViewCell *cell = [ShopImmediateOrderViewCell cellForTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell updateCellData:orderEnt];
        cell.baseTableViewCellBlock = ^(id data)
        {
            
            [weakSelf lookWithOrderInfo:data indexPath:indexPath];
        };
        return cell;
    }
    TYZBaseTableViewCell *cell = [TYZBaseTableViewCell cellForTableView:tableView];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = kShopReservationOrderViewCellHeight;
    OrderDataEntity *orderEnt = self.baseList[indexPath.section];
    if (orderEnt.type == 2)
    {// 即时
        height = kShopImmediateOrderViewCellHeight;
    }
    
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
    
//    __weak typeof(self)weakSelf = self;
    
    OrderDataEntity *orderEnt = self.baseList[indexPath.section];
    [self lookWithOrderInfo:orderEnt indexPath:indexPath];
//    if (orderEnt.type == 1)
//    {
//        
//    }
//    else
//    {
//        
//    }
    
}

@end
