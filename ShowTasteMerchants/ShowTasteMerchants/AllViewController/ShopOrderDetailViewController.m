//
//  ShopOrderDetailViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/4.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopOrderDetailViewController.h"
#import "LocalCommon.h"
#import "ShopOrderDetailStateHeaderView.h"
#import "ShopOrderDetailDinersInfoCell.h" // 食客基本信息cell
#import "UserLoginStateObject.h"
#import "ShopOrderDetailOrderInfoCell.h"
#import "ShopOrderDetailBottomView.h"
#import "ShopTableNumberBackgroundView.h"
#import "ShopSeatNumberEntity.h" // 传入参数
#import "DinersOrderDetailFoodTitleView.h"
#import "DinersCreateOrderShopNameCell.h"
#import "DinersOrderDetailViewCell.h" // 订单信息
#import "DinersOrderDetailFoodViewCell.h"
#import "ShopOrderDetailFooterView.h"
#import "OrderFoodNumberEntity.h"
#import "RestaurantReservationInputEntity.h"
#import "ShopingCartEntity.h" // 购物车实体类
#import "UpdateOrderFoodInputEntity.h"
#import "ShopAddSubFoodBackgroundView.h" // 服务员加菜或者减菜视图
#import "UpdateOrderFoodInputEntity.h" // 加菜、减菜
#import "ShopAccountStatementBackgroundView.h" // 结算视图
#import "ShopPlaceOrderBackgroundView.h" // 下单视图
#import "ShopModifyActuallyAmountBackgroundView.h" // 修改金额视图
#import "ShopTableNumberSeatEntity.h"
#import "WYXRongCloudMessage.h"
#import "ShopSupplementFoodCell.h"
#import "ShopMouthDataEntity.h"
#import "ShopOrderOfflinePayChannelBackgroundView.h" // 选择线下支付渠道视图

@interface ShopOrderDetailViewController () <UIActionSheetDelegate, UIAlertViewDelegate>
{
    ShopOrderDetailStateHeaderView *_headerView;
    
    ShopOrderDetailFooterView *_footerView;
    
    ShopOrderDetailBottomView *_bottomView;
    
    /**
     *  输入桌号的视图
     */
    ShopTableNumberBackgroundView *_tableNumberView;
    
    /**
     *  服务员加菜或者减菜视图
     */
    ShopAddSubFoodBackgroundView *_addSubFoodView;
    
    /**
     *  结算清单视图
     */
    ShopAccountStatementBackgroundView *_accountStatementView;
    
    /**
     *  修改金额视图
     */
    ShopModifyActuallyAmountBackgroundView *_modifyAmountView;
    
    /**
     *  下单视图
     */
    ShopPlaceOrderBackgroundView *_placeOrderView;
    
    /// 选择线下支付渠道视图
    ShopOrderOfflinePayChannelBackgroundView *_offlinePayChannelView;
    
    NSInteger _section;
    
    /**
     *  点击食客信息视图上的按钮
     */
    BOOL _touchDiners;
    
    /**
     *  对菜品的操作，加菜、退菜、已上菜
     */
    UIActionSheet *_foodActionSheet;
    
    /**
     *  操作菜，1表示加菜；2表示减菜
     */
    NSInteger _operateFood;
    
    /**
     *  100 第一次添加的菜品；101 点击有多次加菜加减菜品的主cell；102 点击有多次加减菜品的子cell
     */
    NSInteger _addSubType;
    
    /// 是否结束订单
    BOOL _isEndOrder;
    
}

/// 支付渠道，从服务单获取的
@property (nonatomic, strong) NSArray *payChannelList;

/**
 *  选中的档口id
 */
@property (nonatomic, assign) NSInteger selectedPrinterId;

/**
 *  传入参数
 */
@property (nonatomic, strong) ShopSeatNumberEntity *shopSeatEntity;

@property (nonatomic, strong) UIActionSheet *foodActionSheet;

@property (nonatomic, strong) ShopAccountStatementBackgroundView *accountStatementView;

@property (nonatomic, strong) NSIndexPath *indexPath;

/**
 *  选中的菜品
 */
@property (nonatomic, strong) OrderFoodInfoEntity *selectFoodEntity;

/**
 *  navView右边的按钮
 */
@property (nonatomic, strong) UIButton *btnRight;

- (void)initWithBtnRight;


- (void)initWithHeaderView;

- (void)initWithFooterView;

- (void)initWithBottomView;

- (void)initWithFoodActionSheet;

/**
 *  输入桌号的视图
 *
 *  @param show YES显示，否则NO
 */
- (void)showWithTableNumberView:(BOOL)show;

/**
 *  服务员加菜或者减菜视图
 *
 *  @param show YES显示，否则NO
 */
- (void)showWithAddSubFoodView:(BOOL)show;

/**
 *  结算清单视图
 *
 *  @param show YES显示，否则NO
 */
- (void)showWithAccountStatementView:(BOOL)show;

/**
 *  修改金额视图
 *
 *  @param show YES显示，否则NO
 */
- (void)showWithModifyAmountView:(BOOL)show;

/**
 *  下单视图
 *
 *  @param show YES显示，否则NO
 */
- (void)showWithPlaceOrderView:(BOOL)show foods:(NSArray *)foods;

/**
 * 显示选择下下支付渠道视图
 *
 *  @param show YES显示，否则NO
 */
- (void)showWithOfflinePayChannelView:(BOOL)show;

- (void)getWithOrderDetail;

/**
 *  推送的时候，接收到通知
 *
 *  @param note note
 */
- (void)orderWithReceivePushNote:(NSNotification *)note;

@end

@implementation ShopOrderDetailViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kWYXClientReceiveMessageNotification object:nil];
}


- (void)initWithVar
{
    [super initWithVar];
    
    _isEndOrder = NO;
    
    ShopMouthDataEntity *ent = [_printerList objectOrNilAtIndex:0];
    
    _selectedPrinterId = ent.id;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderWithReceivePushNote:) name:kWYXClientReceiveMessageNotification object:nil];
    
    _touchDiners = NO;
    _shopSeatEntity = [ShopSeatNumberEntity new];
    _shopSeatEntity.shop_id = _orderDetailEntity.shop_id;
    _shopSeatEntity.order_id = _orderDetailEntity.order_id;
    
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = @"订单详情";
    
    [self initWithBtnRight];
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
    [self hiddenFooterView:YES];
    
    [self initWithHeaderView];
    
//    CGRect frame = self.baseTableView.frame;
//    frame.origin.y = _headerView.bottom;
//    frame.size.height = frame.size.height - kShopOrderDetailStateHeaderViewHeight;
//    self.baseTableView.frame = frame;
    
    [self initWithFooterView];
    
    [self initWithBottomView];
    

//    AppDelegate *app = [UtilityObject appDelegate];
//    [app.managerRootVC hiddenWithWaitView];
    
    
}

- (void)clickedBack:(id)sender
{
    if (self.popResultBlock)
    {
        self.popResultBlock(_orderDetailEntity);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doRefreshData
{
    [super doRefreshData];
    
    [self getWithOrderDetail];
}

- (void)initWithFoodActionSheet
{
    _foodActionSheet = nil;
    if (_addSubType == EN_ADD_SUB_FIRST_TYPE)
    {// 第一次添加的菜品
        if (_selectFoodEntity.status == NS_ORDER_FOOD_TABLE_STATE)
        {
            _foodActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"加菜", @"退菜", nil];
        }
        else
        {
            _foodActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"已上菜" otherButtonTitles:@"加菜", @"退菜", nil];
        }
    }
    else if (_addSubType == EN_ADD_SUB_SECOND_TYPE)
    {// 点击有多次加菜加减菜品的主cell
        if (_selectFoodEntity.status == NS_ORDER_FOOD_TABLE_STATE)
        {
            _foodActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"加菜", nil];
        }
        else
        {
            _foodActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"已上菜" otherButtonTitles:@"加菜", nil];
        }
    }
    else if (_addSubType == EN_ADD_SUB_THIRD_TYPE)
    {// 点击有多次加减菜品的子cell
        if (_selectFoodEntity.status == NS_ORDER_FOOD_TABLE_STATE)
        {
            _foodActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: @"退菜", nil];
        }
        else
        {
            _foodActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"已上菜" otherButtonTitles: @"退菜", nil];
        }
    }
    [_foodActionSheet showInView:self.view];
}

/**
 *  推送的时候，接收到通知
 *
 *  @param note note
 */
- (void)orderWithReceivePushNote:(NSNotification *)note
{
//    debugMethod();
    id msgEnt = [note object];
    if (![msgEnt isKindOfClass:[NotifyMessageEntity class]])
    {
        return;
    }
    NotifyMessageEntity *notifyMsg = (NotifyMessageEntity *)msgEnt;
    NotifyBodyEntity *bodyEnt = notifyMsg.notify_body;
    if (![bodyEnt.order_id isEqualToString:_orderDetailEntity.order_id])
    {
        return;
    }
    
    NSInteger type = bodyEnt.notify_cmd;
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



#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    debugLog(@"buttonIndex=%d", (int)buttonIndex);
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if (buttonIndex == actionSheet.destructiveButtonIndex)
    {// 已上菜
        [SVProgressHUD showWithStatus:@"提交中"];
        
        [HCSNetHttp requestWithOrderDish:_selectFoodEntity.id orderId:_selectFoodEntity.order_id userId:0 shopId:_orderDetailEntity.shop_id dishType:1 completion:^(id result) {
            TYZRespondDataEntity *respond = result;
            if (respond.errcode == respond_success)
            {
                [SVProgressHUD showSuccessWithStatus:@"提交成功"];
//                OrderFoodInfoEntity *foodInfoEntity = nil;
                if (_indexPath.section == EN_SHOP_ORDER_DETAIL_CURRFOOD_SESTION)
                {// 下单的菜品列表
                    for (OrderFoodInfoEntity *foodEnt in _orderDetailEntity.detailFoods)
                    {
                        for (OrderFoodInfoEntity *foodEntity in foodEnt.subFoods)
                        {
                            if (foodEntity.id == _selectFoodEntity.id)
                            {
                                foodEntity.status = NS_ORDER_FOOD_TABLE_STATE;
                                break;
                            }
                        }
                        if (foodEnt.id == _selectFoodEntity.id)
                        {
                            foodEnt.status = NS_ORDER_FOOD_TABLE_STATE;
                            break;
                        }
                    }
                    
                    [MCYPushViewController reloadWithTableView:self.baseTableView indexPath:_indexPath reloadType:2];
                }
//                if (foodInfoEntity)
//                {
//                    // 已上桌
//                    foodInfoEntity.status = NS_ORDER_FOOD_TABLE_STATE;
//                    [MCYPushViewController reloadWithTableView:self.baseTableView indexPath:_indexPath reloadType:2];
//                    
//                    debugLog(@"已上桌==%@; status=%d", foodInfoEntity.food_name, (int)foodInfoEntity.status);
//                }
            }
            else
            {
                [UtilityObject svProgressHUDError:respond viewContrller:self];
            }
        }];
    }
    else if ([title isEqualToString:@"加菜"])
    {// 加菜
        _operateFood = EN_OPERATE_FOOD_ADD_TYPE;
        [self showWithAddSubFoodView:YES];
    }
    else if ([title isEqualToString:@"退菜"])
    {// 退菜
        _operateFood = EN_OPERATE_FOOD_SUB_TYPE;
        [self showWithAddSubFoodView:YES];
    }
}

- (void)initWithBtnRight
{
    if (!_btnRight)
    {
        NSString *str = @"退单";
        CGFloat width = [str widthForFont:FONTSIZE_15];
        CGRect frame = CGRectMake(0, 0, width, 30);
        UIButton *btn = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"退单" titleColor:[UIColor whiteColor] titleFont:FONTSIZE_15 targetSel:@selector(clickedWithBtnRight:)];
        btn.frame = frame;
        UIBarButtonItem *itemRight = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.rightBarButtonItem = itemRight;
        self.btnRight = btn;
    }
    _btnRight.hidden = YES;
    if (_orderDetailEntity.sign_end == 150)
    {
        
    }
    else if (_orderDetailEntity.status == NS_ORDER_WAITING_CONFIRMATION_STATE)
    {// 待商家确认(待确认)
//        _btnRight.hidden = NO;
//        [_btnRight setTitle:@"退单" forState:UIControlStateNormal];
    }
    else if (_orderDetailEntity.status == NS_ORDER_WAITING_PAY_DEPOSIT_STATE)
    {// 待支付订金(已接单)
//        _btnRight.hidden = NO;
//        [_btnRight setTitle:@"退单" forState:UIControlStateNormal];
    }
    else if (_orderDetailEntity.status == NS_ORDER_COMPLETED_BOOKING_STATE)
    {// 预订完成
//        _btnRight.hidden = NO;
//        [_btnRight setTitle:@"退单" forState:UIControlStateNormal];
    }
    else if (_orderDetailEntity.status == NS_ORDER_DINING_STATE)
    {// 就餐中 / 服务员确认，可以买单
        _btnRight.hidden = NO;
        [_btnRight setTitle:@"账单" forState:UIControlStateNormal];
    }
    else if (_orderDetailEntity.status == NS_ORDER_IN_CHECKOUT_STATE)
    {// 结账中
        
    }
    else if (_orderDetailEntity.status == NS_ORDER_PAY_COMPLETE_STATE)
    {// 支付完成
        
    }
    else if (_orderDetailEntity.status == NS_ORDER_ORDER_COMPLETE_STATE)
    {// 订单已完成(已完成)
        
    }
    else if (_orderDetailEntity.status == NS_ORDER_SHOP_SAB_STATE)
    {// 退单申请中
        
    }
    else if (_orderDetailEntity.status == NS_ORDER_ORDER_CANCELED_STATE)
    {// 订单已取消
        
    }
    else if (_orderDetailEntity.status == NS_ORDER_RETREAT_SINGLE_COMPLETE_STATE)
    {// 退单完成（已退款）
        
    }
    else if (_orderDetailEntity.status == NS_ORDER_SHOP_REFUSED_STATE)
    {// 商家已拒绝(拒单)
        
    }
    else if (_orderDetailEntity.status == NS_ORDER_ORDER_NOT_ACTIVE_STATE)
    {// 订单未激活(即时订单)
        
    }
}

- (void)initWithHeaderView
{
    if (!_headerView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kShopOrderDetailStateHeaderViewHeight);
        _headerView = [[ShopOrderDetailStateHeaderView alloc] initWithFrame:frame];
//        self.baseTableView.tableHeaderView = _headerView;
        [self.view addSubview:_headerView];
    }
    [_headerView updateViewData:_orderDetailEntity];
    __weak typeof(self)weakSelf = self;
    _headerView.viewCommonBlock = ^(id data)
    {// 下单
        [SVProgressHUD showWithStatus:@"加载中"];
        /*[HCSNetHttp requestWithOrderDetailWaitPrintFoods:weakSelf.orderDetailEntity.order.order_id shopId:weakSelf.orderDetailEntity.order.shop_id completion:^(id result) {
            TYZRespondDataEntity *respond = result;
            if (respond.errcode == respond_success)
            {
                [SVProgressHUD dismiss];
                [weakSelf showWithPlaceOrderView:YES foods:respond.data];
            }
            else if (respond.errcode == respond_nodata)
            {
                [SVProgressHUD dismiss];
                [weakSelf showWithPlaceOrderView:YES foods:respond.data];
            }
            else
            {
                [UtilityObject svProgressHUDError:respond viewContrller:weakSelf];
            }
        }];
        */
    };
}

- (void)initWithFooterView
{
    CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kShopOrderDetailFooterViewHeight);
    frame.size.height = frame.size.height - 20 + _orderDetailEntity.foodTotalDescHeight;
    if (!_footerView)
    {
        _footerView = [[ShopOrderDetailFooterView alloc] initWithFrame:frame];
        self.baseTableView.tableFooterView = _footerView;
    }
    else
    {
        _footerView.frame = frame;
    }
    [_footerView updateViewData:_orderDetailEntity];
}

- (void)initWithBottomView
{
    AppDelegate *app = [UtilityObject appDelegate];
    CGFloat statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navBarHeight = self.navigationController.navigationBar.bounds.size.height;
    CGRect frame = CGRectMake(0, _headerView.bottom, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight] - statusHeight - navBarHeight - [app tabBarHeight] - kShopOrderDetailStateHeaderViewHeight);
    self.baseTableView.frame = frame;
//    self.baseTableView.backgroundColor = [UIColor purpleColor];
    __weak typeof(self)blockSelf = self;
    if (!_bottomView)
    {
        _bottomView = [[ShopOrderDetailBottomView alloc] initWithFrame:CGRectMake(0, frame.size.height + kShopOrderDetailStateHeaderViewHeight, [[UIScreen mainScreen] screenWidth], [app tabBarHeight])];
        [self.view addSubview:_bottomView];
    }
    _bottomView.bottomClickedBlock = ^(NSString *title, NSInteger tag)
    {
        [blockSelf bottomViewClicked:title tag:tag];
    };
    _bottomView.hidden = NO;
    if (_orderDetailEntity.sign_end == 150)
    {// 异常订单
        [_bottomView updateViewData:_orderDetailEntity type:3 leftTitle:nil rightTitle:@"结束订单"];
    }
    else if (_orderDetailEntity.status == NS_ORDER_WAITING_CONFIRMATION_STATE)
    {// 待商家确认(待确认)
        [_bottomView updateViewData:_orderDetailEntity type:5 leftTitle:@"拒绝" rightTitle:@"接单"];
    }
    else if (_orderDetailEntity.status == NS_ORDER_WAITING_PAY_DEPOSIT_STATE)
    {// 待支付订金(已接单)
        frame.size.height = frame.size.height + _bottomView.height;
        self.baseTableView.frame = frame;
        _bottomView.hidden = YES;
    }
    else if (_orderDetailEntity.status == NS_ORDER_COMPLETED_BOOKING_STATE)
    {// 预订完成
        [_bottomView updateViewData:nil type:3 leftTitle:nil rightTitle:@"激活订单"];
    }
    else if (_orderDetailEntity.status == NS_ORDER_DINING_STATE)
    {// 就餐中
        [_bottomView updateViewData:_orderDetailEntity type:1 leftTitle:nil rightTitle:@"加菜"];
    }
    else if (_orderDetailEntity.status == NS_ORDER_IN_CHECKOUT_STATE)
    {// 结账中
        [_bottomView updateViewData:_orderDetailEntity type:3 leftTitle:nil rightTitle:@"支付确认"];
    }
    else if (_orderDetailEntity.status == NS_ORDER_PAY_COMPLETE_STATE)
    {// 支付完成
        [_bottomView updateViewData:_orderDetailEntity type:3 leftTitle:nil rightTitle:@"支付确认"];
    }
    else if (_orderDetailEntity.status == NS_ORDER_ORDER_COMPLETE_STATE)
    {// 订单已完成(已完成)
        frame.size.height = frame.size.height + _bottomView.height;
        self.baseTableView.frame = frame;
        _bottomView.hidden = YES;
    }
    else if (_orderDetailEntity.status == NS_ORDER_SHOP_SAB_STATE)
    {// 退单申请中
        
        // 临时处理
        frame.size.height = frame.size.height + _bottomView.height;
        self.baseTableView.frame = frame;
        _bottomView.hidden = YES;
    }
    else if (_orderDetailEntity.status == NS_ORDER_ORDER_CANCELED_STATE)
    {// 订单已取消
        // 临时处理
        frame.size.height = frame.size.height + _bottomView.height;
        self.baseTableView.frame = frame;
        _bottomView.hidden = YES;
    }
    else if (_orderDetailEntity.status == NS_ORDER_RETREAT_SINGLE_COMPLETE_STATE)
    {// 退单完成（已退款）
        // 临时处理
        frame.size.height = frame.size.height + _bottomView.height;
        self.baseTableView.frame = frame;
        _bottomView.hidden = YES;
    }
    else if (_orderDetailEntity.status == NS_ORDER_SHOP_REFUSED_STATE)
    {// 商家已拒绝(拒单)
        // 临时处理
        frame.size.height = frame.size.height + _bottomView.height;
        self.baseTableView.frame = frame;
        _bottomView.hidden = YES;
    }
    else if (_orderDetailEntity.status == NS_ORDER_ORDER_NOT_ACTIVE_STATE)
    {// 订单未激活(即时订单)
        [_bottomView updateViewData:nil type:3 leftTitle:nil rightTitle:@"激活订单"];
    }
    /*
     NS_ORDER_WAITING_CONFIRMATION_STATE = 1, ///< 待商家确认(待确认)
     NS_ORDER_WAITING_PAY_DEPOSIT_STATE = 3, ///< 待支付订金(已接单)
     NS_ORDER_COMPLETED_BOOKING_STATE = 4, ///< 预订完成
     NS_ORDER_DINING_STATE = 102, ///< 就餐中
     NS_ORDER_IN_CHECKOUT_STATE = 103, ///< 结账中
     NS_ORDER_PAYAMOUNTCONFIRMED_STATE = 104, ///< 服务员已确认支付金额(待支付)
     NS_ORDER_PAY_COMPLETE_STATE = 105, ///< 支付完成
     NS_ORDER_ORDER_COMPLETE_STATE = 200, ///< 订单已完成
     NS_ORDER_SHOP_SAB_STATE = 300, ///< 退单申请中
     NS_ORDER_ORDER_CANCELED_STATE = 301, ///< 订单已取消
     NS_ORDER_RETREAT_SINGLE_COMPLETE_STATE = 302, ///< 退单完成（已退款）
     NS_ORDER_SHOP_REFUSED_STATE = 400, ///< 商家已拒绝(拒单)
     NS_ORDER_ORDER_NOT_ACTIVE_STATE = 500, ///< 订单未激活(即时订单)
     
     
     */
    
}

- (void)bottomViewClicked:(NSString *)title tag:(NSInteger)tag
{
    if ([title isEqualToString:@"激活订单"])
    {
        [self showWithTableNumberView:YES];
    }
    else if ([title isEqualToString:@"加菜"])
    {
        [self shopWithAddFood];
    }
    else if ([title isEqualToString:@"拒绝"])
    {
        [SVProgressHUD showInfoWithStatus:@"提交中"];
        [HCSNetHttp requestWithOrderShopAcceptRefuseBooking:_orderDetailEntity.order_id status:NS_ORDER_SHOP_REFUSED_STATE shopId:_orderDetailEntity.shop_id completion:^(id result) {
            TYZRespondDataEntity *respond = result;
            if (respond.errcode == respond_success)
            {
                [SVProgressHUD showSuccessWithStatus:@"拒绝成功"];
                _orderDetailEntity.status = NS_ORDER_SHOP_REFUSED_STATE;
                [self reloadWithOrderDetail];
            }
            else
            {
                [UtilityObject svProgressHUDError:respond viewContrller:self];
            }
        }];
    }
    else if ([title isEqualToString:@"接单"])
    {
        [SVProgressHUD showInfoWithStatus:@"提交中"];
        [HCSNetHttp requestWithOrderShopAcceptRefuseBooking:_orderDetailEntity.order_id status:NS_ORDER_WAITING_PAY_DEPOSIT_STATE shopId:_orderDetailEntity.shop_id completion:^(id result) {
            TYZRespondDataEntity *respond = result;
            if (respond.errcode == respond_success)
            {
                [SVProgressHUD showSuccessWithStatus:@"接单成功"];
                _orderDetailEntity.status = NS_ORDER_WAITING_PAY_DEPOSIT_STATE;
                [self reloadWithOrderDetail];
                // CTCOrderDetailEntity
//                [[NSNotificationCenter defaultCenter] postNotificationName:kORDERWAITINGDEALNOTE object:_orderDetailEntity.order];
                
            }
            else
            {
                [UtilityObject svProgressHUDError:respond viewContrller:self];
            }
        }];;
    }
    else if ([title isEqualToString:@"下单"])
    {
        [SVProgressHUD showWithStatus:@"下单中"];
        /*[HCSNetHttp requestWithOrderFoodToKitchen:_orderDetailEntity.order.order_id shopId:_orderDetailEntity.order.shop_id printId:_selectedPrinterId completion:^(id result) {
            
        }];*/
    }
    else if ([title isEqualToString:@"支付确认"])
    {// 支付确认
        debugLog(@"支付确认");
        [SVProgressHUD showWithStatus:@"检查中"];
        [HCSNetHttp requestWithOrderCheckPayOnline:_orderDetailEntity.order_id shopId:_orderDetailEntity.shop_id completion:^(id result) {
            [self responseWithOrderCheckPayOnline:result];
        }];
    }
    else if ([title isEqualToString:@"结束订单"])
    {// 结束订单，说是线下支付的，现在要修改了。
        [SVProgressHUD showWithStatus:@"结束中"];
        _isEndOrder = YES;
        
        /*[HCSNetHttp requestWithOrderPayChannel:^(id result) {
            TYZRespondDataEntity *respond = result;
            if (respond.errcode == respond_success)
            {
                self.payChannelList = respond.data;
                [self showWithOfflinePayChannelView:YES];
            }
            else
            {
                [UtilityObject svProgressHUDError:respond viewContrller:self];
            }
        }];*/
    }
}

// 检查订单是否线上支付
- (void)responseWithOrderCheckPayOnline:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success)
    {
        // 0表示未通过线上支付；1表示线上支付
        NSInteger pay_way = [respond.data integerValue];
        // 100表示线下支付
        if (pay_way == 1)
        {// 线上支付
            _orderDetailEntity.status = NS_ORDER_PAY_COMPLETE_STATE;
            _orderDetailEntity.pay_channel = 0;
            _orderDetailEntity.pay_channel_desc = @"支付宝";
            [self reloadWithOrderDetail];
        }
        if (_orderDetailEntity.status == NS_ORDER_PAY_COMPLETE_STATE && _orderDetailEntity.pay_channel != 100)
        {// 支付完成状态；并且是线上支付
            [SVProgressHUD showWithStatus:@"确认中"];
            [HCSNetHttp requestWithOrderOnlineFinish:_orderDetailEntity.order_id shopId:_orderDetailEntity.shop_id completion:^(id result) {
                TYZRespondDataEntity *oRespond = result;
                if (oRespond.errcode == respond_success)
                {
                    [SVProgressHUD showSuccessWithStatus:@"线上支付确认成功！"];
                    _orderDetailEntity.status = NS_ORDER_ORDER_COMPLETE_STATE;
                    [self reloadWithOrderDetail];
                }
                else
                {
                    [UtilityObject svProgressHUDError:respond viewContrller:self];
                }
            }];
        }
        else
        {
            if (_payChannelList)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"尚未完成线上支付，食客是否选择了线下支付？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
                alertView.tag = 201;
                [alertView show];
                return;
            }
            /*[HCSNetHttp requestWithOrderPayChannel:^(id result) {
                TYZRespondDataEntity *respond = result;
                if (respond.errcode == respond_success)
                {
                    self.payChannelList = respond.data;
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"尚未完成线上支付，食客是否选择了线下支付？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
                    alertView.tag = 201;
                    [alertView show];
                }
                else
                {
                    [UtilityObject svProgressHUDError:respond viewContrller:self];
                }
            }];
             */
        }
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
}

- (void)shopWithAddFood
{
    RestaurantReservationInputEntity *inputEnt = [RestaurantReservationInputEntity new];
    inputEnt.orderId = _orderDetailEntity.order_id;
    inputEnt.orderState = _orderDetailEntity.status;
    inputEnt.userId = _orderDetailEntity.user_id;
    inputEnt.shopId = _orderDetailEntity.shop_id;
    inputEnt.shopName = _orderDetailEntity.shop_name;
    inputEnt.shopAddress = _orderDetailEntity.address;
    inputEnt.shopMobile = _orderDetailEntity.shop_tel;
    inputEnt.type = _orderDetailEntity.type;
    inputEnt.addType = 2; // 表示修改菜单
    inputEnt.userType = 1; // 1表示商家
    inputEnt.fixedShopingCartList = [NSMutableArray array];
    
    [MCYPushViewController showWithRecipeVC:self data:inputEnt completion:^(id data) {
        
    }];
}



- (void)getWithOrderDetail
{
    // CTCOrderDetailEntity
    [HCSNetHttp requestWithShopOrderDetail:_orderDetailEntity.order_id shopId:_orderDetailEntity.shop_id completion:^(id result) {
        [self responseWithShopOrderDetail:result];
    }];
    
//    [HCSNetHttp requestWithOrderShowWholeOrderTwo:_orderDetailEntity.order.order_id shopId:_orderDetailEntity.order.shop_id completion:^(id result) {
//        [self responseWithOrderShowWholeOrder:result];
//    }];
}

- (void)responseWithShopOrderDetail:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success)
    {
        self.orderDetailEntity = respond.data;
        NSInteger num = 0;
        NSMutableDictionary *categoryDict = [NSMutableDictionary new];
        CTCOrderDetailEntity *orderDetailEnt = respond.data;
        for (OrderFoodInfoEntity *foodEnt in orderDetailEnt.details)
        {
            OrderFoodNumberEntity *foodNumEnt = [OrderFoodNumberEntity new];
            foodNumEnt.categoryId = foodEnt.category_id;
            foodNumEnt.categoryName = foodEnt.category_name;
            foodNumEnt.number = foodEnt.number;
            foodNumEnt.unit = foodEnt.unit;
            if ([[categoryDict allKeys] containsObject:@(foodNumEnt.categoryId)])
            {
                OrderFoodNumberEntity *foodNumberEnt = categoryDict[@(foodNumEnt.categoryId)];
                foodNumberEnt.number += foodNumEnt.number;
            }
            else
            {
                categoryDict[@(foodNumEnt.categoryId)] = foodNumEnt;
            }
            
            // 所有菜品总的数量
            num += foodEnt.number;
        }
        NSMutableString *mutStr = [NSMutableString new];
        for (OrderFoodNumberEntity *ent in [categoryDict allValues])
        {
            if ([mutStr length] == 0)
            {
                [mutStr appendFormat:@"%@%d%@", ent.categoryName, (int)ent.number, ent.unit];
            }
            else
            {
                [mutStr appendFormat:@" / %@%d%@", ent.categoryName, (int)ent.number, ent.unit];
            }
        }
        orderDetailEnt.foodTotalDesc = mutStr;
        orderDetailEnt.foodTotalDescHeight = [UtilityObject mulFontHeights:mutStr font:FONTSIZE_12 maxWidth:[[UIScreen mainScreen] screenWidth] - 30];
        orderDetailEnt.totalCount = num;
        
        [self reloadWithOrderDetail];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
    
    [self endAllRefreshing];
}

- (void)clickedWithBtnRight:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSString *title = btn.titleLabel.text;
    if ([title isEqualToString:@"账单"])
    {
        [self showWithAccountStatementView:YES];
    }
}

/**
 *  刷新视图
 */
- (void)reloadWithOrderDetail
{
    
    [self initWithBtnRight];
    
    [self initWithHeaderView];
    
    [self initWithFooterView];
    
    [self initWithBottomView];
    
    [self.baseTableView reloadData];
}


- (void)showWithTableNumberView:(BOOL)show
{
    __weak typeof(self)weakSelf = self;
    if (!_tableNumberView)
    {
        _tableNumberView =[[ShopTableNumberBackgroundView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight]) seatList:_seatLocList];
        _tableNumberView.alpha = 0;
    }
    
    _tableNumberView.touchTableNumberBlock = ^(id data)
    {
        if (!data)
        {
            [weakSelf showWithTableNumberView:NO];
        }
        else
        {// 激活订单
            [SVProgressHUD showWithStatus:@"激活中"];
            ShopTableNumberSeatEntity *seatEnt = data;
//            NSArray *array = [data componentsSeparatedByString:@"#"];
//            NSInteger personNum = [[array objectOrNilAtIndex:0] integerValue];
//            NSString *tableNo = [array objectOrNilAtIndex:1];
            debugLog(@"人数：%@; 桌号：%@; 空间：%@", @(seatEnt.personNum), seatEnt.tableNo, seatEnt.seatName);
            weakSelf.shopSeatEntity.seat_number = seatEnt.tableNo;
            weakSelf.shopSeatEntity.cust_count = seatEnt.personNum;
            weakSelf.shopSeatEntity.seat_type = seatEnt.seatId;
            [HCSNetHttp requestWithOrderAllocateSeatNumber:weakSelf.shopSeatEntity completion:^(id result) {
                TYZRespondDataEntity *respond = result;
                if (respond.errcode == respond_success)
                {
                    [SVProgressHUD showSuccessWithStatus:@"激活成功"];
                    weakSelf.orderDetailEntity.seat_number = seatEnt.tableNo;// 桌号
                    weakSelf.orderDetailEntity.number = seatEnt.personNum;// 就餐人数
                    weakSelf.orderDetailEntity.seat_type = seatEnt.seatId; // 位置id
                    weakSelf.orderDetailEntity.seat_type_desc = seatEnt.seatName;
                    if (weakSelf.orderDetailEntity.type == 1)
                    {// 预订
                        // 进入”就餐中“状态
                        weakSelf.orderDetailEntity.status = NS_ORDER_DINING_STATE;
                        [weakSelf reloadWithOrderDetail];
                    }
                    else if (weakSelf.orderDetailEntity.type == 2)
                    {// 即时
                        // 激活后，进入”就餐中“状态
                        weakSelf.orderDetailEntity.status = NS_ORDER_DINING_STATE;
                        
                        [weakSelf reloadWithOrderDetail];
                        
                    }
                    [weakSelf showWithTableNumberView:NO];
                    
//                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"现在可以下单吗？" delegate:weakSelf cancelButtonTitle:@"稍后" otherButtonTitles:@"下单", nil];
//                    alertView.tag = 200;
//                    [alertView show];
                    
                    [SVProgressHUD showInfoWithStatus:@"激活完成，请去下单"];
                }
                else
                {
                    [UtilityObject svProgressHUDError:respond viewContrller:weakSelf];
                }
            }];
        }
    };
    
    if (show)
    {
        [self.view.window addSubview:_tableNumberView];
        [UIView animateWithDuration:0.5 animations:^{
            _tableNumberView.alpha = 1.0;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            _tableNumberView.alpha = 0;
        } completion:^(BOOL finished) {
            [_tableNumberView removeFromSuperview];
        }];
    }
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    /*if (alertView.tag == 200)
    {// 是否下单
        if (alertView.cancelButtonIndex != buttonIndex)
        {// 下单
            [SVProgressHUD showWithStatus:@"下单中"];
            [HCSNetHttp requestWithOrderFoodToKitchen:_orderDetailEntity.order.order_id shopId:_orderDetailEntity.order.shop_id completion:^(id result) {
                TYZRespondDataEntity *respond = result;
                if (respond.errcode == respond_success)
                {
                    [SVProgressHUD showSuccessWithStatus:@"下单成功"];
                }
                else
                {
                    [UtilityObject svProgressHUDError:respond viewContrller:self];
                }
            }];
        }
    }
    else */if (alertView.tag == 201)
    {// 线下确认支付
        
        if (buttonIndex != alertView.cancelButtonIndex)
        {
            _isEndOrder = NO;
            [self showWithOfflinePayChannelView:YES];
        }
        else
        {
            [SVProgressHUD dismiss];
        }
    }
}

/**
 *  服务员加菜或者减菜视图
 *
 *  @param show YES显示，否则NO
 */
- (void)showWithAddSubFoodView:(BOOL)show
{
    __weak typeof(self)weakSelf = self;
    if (!_addSubFoodView)
    {
        _addSubFoodView =[[ShopAddSubFoodBackgroundView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight])];
        _addSubFoodView.alpha = 0;
    }
    _addSubFoodView.touchAddSubFoodBlock = ^(id data)
    {
        if (!data)
        {// 取消
            [weakSelf showWithAddSubFoodView:NO];
        }
        else
        {
            ShopingCartEntity *cartEntity = data;
            cartEntity.number = cartEntity.number - cartEntity.fixedNumber;
            debugLog(@"cartEnt=%@", [cartEntity modelToJSONString]);
            if (cartEntity.number == 0)
            {// 表示没有加菜，也没有减菜
                debugLog(@"表示没有加菜，也没有减菜");
                [weakSelf showWithAddSubFoodView:NO];
                return;
            }
            debugLog(@"number=%d", (int)cartEntity.number);
            UpdateOrderFoodInputEntity *inputEntity = [UpdateOrderFoodInputEntity new];
            inputEntity.orderId = weakSelf.orderDetailEntity.order_id;
            inputEntity.shopId = weakSelf.orderDetailEntity.shop_id;
            NSArray *list = @[cartEntity];
            inputEntity.content = [list modelToJSONString];
            if (cartEntity.number > 0)
            {// 表示加菜
                inputEntity.order_food_type = 2;
            }
            else if (cartEntity.number < 0)
            {// 表示退菜
                inputEntity.order_food_type = 3;
                inputEntity.detailId = cartEntity.foodAutoId;
                inputEntity.foodNumber = -cartEntity.number;
            }
            
            // 提交
            [SVProgressHUD showWithStatus:@"提交中"];
            if (inputEntity.order_food_type == 2)
            {// 加菜
                /*[HCSNetHttp requestWithOrderDetailShopAddFoods:inputEntity completion:^(id result) {
                    [weakSelf responseWithOrderDetailSupplyReturn:result cartEnt:cartEntity];
                }];*/
            }
            else if (inputEntity.order_food_type == 3)
            {// 退菜
                /*[HCSNetHttp requestWithOrderDetailShopReturnFoods:inputEntity completion:^(id result) {
                    [weakSelf responseWithOrderDetailShopReturnFoods:result];
                }];*/
            }
        }
    };
    
    if (show)
    {
        ShopingCartEntity *cartEnt = [ShopingCartEntity new];
        cartEnt.foodAutoId = _selectFoodEntity.id;
        cartEnt.id = _selectFoodEntity.food_id;
        cartEnt.name = _selectFoodEntity.food_name;
        cartEnt.category_id = _selectFoodEntity.category_id;
        cartEnt.categoryName = _selectFoodEntity.category_name;
        cartEnt.price = _selectFoodEntity.price;
        cartEnt.activityPrice = _selectFoodEntity.activity_price;
        cartEnt.mode = _selectFoodEntity.mode;
        cartEnt.taste = _selectFoodEntity.taste;
        cartEnt.unit = _selectFoodEntity.unit;
        
        /*NSInteger number = 0; // 计算出某一道菜的真实数量
        for (OrderFoodInfoEntity *foodEnt in _orderDetailEntity.details)
        {
            NSString *mode = objectNull(foodEnt.mode);
            NSString *taste = objectNull(foodEnt.taste);
            NSString *selMode = objectNull(_selectFoodEntity.mode);
            NSString *selTaste = objectNull(_selectFoodEntity.taste);
            if (foodEnt.food_id == _selectFoodEntity.food_id && [mode isEqualToString:selMode] && [taste isEqualToString:selTaste])
            {
                number = number + foodEnt.number;
            }
        }*/
        cartEnt.number = _selectFoodEntity.number;
        cartEnt.fixedNumber = _selectFoodEntity.number; // 表示在整个加菜减菜过程中不变，主要是用来比较的
        
        [_addSubFoodView updateWithData:cartEnt addSubType:_addSubType operateFood:_operateFood];
        
        [self.view.window addSubview:_addSubFoodView];
        [UIView animateWithDuration:0.5 animations:^{
            _addSubFoodView.alpha = 1.0;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            _addSubFoodView.alpha = 0;
        } completion:^(BOOL finished) {
            [_addSubFoodView removeFromSuperview];
        }];
    }
}

/**
 *  结算清单视图
 *
 *  @param show YES显示，否则NO
 */
- (void)showWithAccountStatementView:(BOOL)show
{
    __weak typeof(self)weakSelf = self;
    if (!_accountStatementView)
    {
        _accountStatementView =[[ShopAccountStatementBackgroundView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight])];
        _accountStatementView.alpha = 0;
    }
    
    _accountStatementView.touchAccountStatementBlock = ^(id data)
    {
        if (!data)
        {
            [weakSelf showWithAccountStatementView:NO];
        }
        else
        {
//            debugLog(@"确认并发送给食客");
            [SVProgressHUD showWithStatus:@"确认中"];
            [HCSNetHttp requestWithOrderConfirmOrderAmount:weakSelf.orderDetailEntity.order_id shopId:weakSelf.orderDetailEntity.shop_id completion:^(id result) {
                TYZRespondDataEntity *respond = result;
                if (respond.errcode == respond_success)
                {
                    [SVProgressHUD showSuccessWithStatus:@"确认成功"];
                    weakSelf.orderDetailEntity.status = NS_ORDER_IN_CHECKOUT_STATE;
                    [weakSelf showWithAccountStatementView:NO];
                    [weakSelf reloadWithOrderDetail];
                }
                else
                {
                    [UtilityObject svProgressHUDError:respond viewContrller:weakSelf];
                }
            }];
        }
    };
    _accountStatementView.modifyActuallyAmountBlock = ^(id data)
    {// 修改实付金额
        [weakSelf showWithModifyAmountView:YES];
    };
    
    if (show)
    {
        [_accountStatementView updateWithData:_orderDetailEntity];
        [self.view.window addSubview:_accountStatementView];
        [UIView animateWithDuration:0.5 animations:^{
            _accountStatementView.alpha = 1.0;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            _accountStatementView.alpha = 0;
        } completion:^(BOOL finished) {
            [_accountStatementView removeFromSuperview];
        }];
    }
}

/**
 *  修改金额视图
 *
 *  @param show YES表示显示，否则NO
 */
- (void)showWithModifyAmountView:(BOOL)show
{
    __weak typeof(self)weakSelf = self;
    if (!_modifyAmountView)
    {
        _modifyAmountView =[[ShopModifyActuallyAmountBackgroundView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight])];
        _modifyAmountView.alpha = 0;
    }
    _modifyAmountView.modifyAmountBlock = ^(id data)
    {
        if (!data)
        {
            [weakSelf showWithModifyAmountView:NO];
        }
        else
        {// 修改金额
            OrderAmountModifyEntity *inputEnt = data;
            
            /*[HCSNetHttp requestWithOrderModifyAmount:inputEnt completion:^(id result) {
                TYZRespondDataEntity *respond = result;
                if (respond.errcode == respond_success)
                {
                    [SVProgressHUD showSuccessWithStatus:@"修改实付金额成功"];
                    
                    weakSelf.orderDetailEntity.order.pay_actually = inputEnt.newAmount;
                    weakSelf.orderDetailEntity.order.pay_modify_note = inputEnt.note;
                    
                    // 更新
                    [weakSelf.accountStatementView updateWithData:weakSelf.orderDetailEntity];
                    [weakSelf.baseTableView reloadData];
                    [weakSelf showWithModifyAmountView:NO];
                }
                else
                {
                    [UtilityObject svProgressHUDError:respond viewContrller:weakSelf];
                }
            }];*/
        }
    };
    
    if (show)
    {
        [_modifyAmountView updateWithData:_orderDetailEntity];
        [self.view.window addSubview:_modifyAmountView];
        [UIView animateWithDuration:0.5 animations:^{
            _modifyAmountView.alpha = 1.0;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            _modifyAmountView.alpha = 0;
        } completion:^(BOOL finished) {
            [_modifyAmountView removeFromSuperview];
        }];
    }
}

/**
 *  下单视图
 *
 *  @param show YES显示，否则NO
 */
- (void)showWithPlaceOrderView:(BOOL)show foods:(NSArray *)foods
{
    __weak typeof(self)weakSelf = self;
    if (!_placeOrderView)
    {
        _placeOrderView =[[ShopPlaceOrderBackgroundView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight])];
        _placeOrderView.alpha = 0;
    }
    
    _placeOrderView.viewCommonBlock = ^(id data)
    {// 取消、下单、好的、补单
        [weakSelf clickedWithPlaceOrderView:data];
    };
    _placeOrderView.choiceWithPrintIdBlock = ^(NSInteger mouthId)
    {
        weakSelf.selectedPrinterId = mouthId;
    };
    
    
    if (show)
    {
//        debugLog(@"printlist=%@", [_printerList jsonPrettyStringEncoded]);
        debugLog(@"printcount=%d", (int)[_printerList count]);
        [_placeOrderView updateWithData:foods printerList:_printerList];
        [self.view.window addSubview:_placeOrderView];
        [UIView animateWithDuration:0.5 animations:^{
            _placeOrderView.alpha = 1.0;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            _placeOrderView.alpha = 0;
        } completion:^(BOOL finished) {
            [_placeOrderView removeFromSuperview];
        }];
    }
}

/**
 * 显示选择下下支付渠道视图
 *
 *  @param show YES显示，否则NO
 */
- (void)showWithOfflinePayChannelView:(BOOL)show
{
    __weak typeof(self)weakSelf = self;
    if (!_offlinePayChannelView)
    {
        _offlinePayChannelView =[[ShopOrderOfflinePayChannelBackgroundView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight])];
        _offlinePayChannelView.alpha = 0;
    }
    _offlinePayChannelView.touchWithButtonBlock = ^(id data)
    {
        [weakSelf choiceWithOfflineChannel:data];
    };
    
    if (show)
    {
        [_offlinePayChannelView updateWithPayChannelList:_payChannelList];
        [self.view.window addSubview:_offlinePayChannelView];
        [UIView animateWithDuration:0.5 animations:^{
            _offlinePayChannelView.alpha = 1.0;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            _offlinePayChannelView.alpha = 0;
        } completion:^(BOOL finished) {
            [_offlinePayChannelView removeFromSuperview];
        }];
    }
}

- (void)choiceWithOfflineChannel:(id)data
{
    if (!data)
    {
        [self showWithOfflinePayChannelView:NO];
        [SVProgressHUD dismiss];
        _isEndOrder = NO;
        return;
    }
    
    //
    PayChannelDataEntity *payChannelEnt = data;
    debugLog(@"channName=%@", payChannelEnt.desc);
    [SVProgressHUD showWithStatus:@"确认中"];
    [HCSNetHttp requestWithOrderOfflineFinish:_orderDetailEntity.order_id shopId:_orderDetailEntity.shop_id payChannel:payChannelEnt.value completion:^(id result) {
        TYZRespondDataEntity *respond = result;
        if (respond.errcode == respond_success)
        {
            if (_isEndOrder)
            {// 结束订单
                [SVProgressHUD showSuccessWithStatus:@"结束完成"];
            }
            else
            {
                [SVProgressHUD showSuccessWithStatus:@"线下支付确认成功！"];
            }
            
            _orderDetailEntity.pay_channel = 100;
            _orderDetailEntity.pay_channel_desc = @"线下支付";
            _orderDetailEntity.status = NS_ORDER_ORDER_COMPLETE_STATE;
            _orderDetailEntity.pay_way = payChannelEnt.value;
            _orderDetailEntity.pay_way_desc = payChannelEnt.desc;
            [self reloadWithOrderDetail];
        }
        else
        {
            [UtilityObject svProgressHUDError:respond viewContrller:self];
        }
        [self showWithOfflinePayChannelView:NO];
    }];
}

// 取消、下单、好的
- (void)clickedWithPlaceOrderView:(id)data
{
    if ([data isEqualToString:@"取消"] || [data isEqualToString:@"好的"])
    {
        [self showWithPlaceOrderView:NO foods:nil];
    }
    else if ([data isEqualToString:@"下单"])
    {
        [SVProgressHUD showWithStatus:@"下单中"];
        /*[HCSNetHttp requestWithOrderFoodToKitchen:self.orderDetailEntity.order.order_id shopId:self.orderDetailEntity.order.shop_id printId:_selectedPrinterId completion:^(id result) {
            TYZRespondDataEntity *respond = result;
            if (respond.errcode == respond_success)
            {
                [SVProgressHUD showSuccessWithStatus:@"下单成功"];
                [self showWithPlaceOrderView:NO foods:nil];
            }
            else
            {
                [UtilityObject svProgressHUDError:respond viewContrller:self];
            }
        }];
        */
    }
    else if ([data isEqualToString:@"补单"])
    {// ShopMouthDataEntity
        [MCYPushViewController showWithRepairVC:self data:_orderDetailEntity completion:^(id data) {
            if ([data isEqualToString:@"success"])
            {
                _placeOrderView.hidden = YES;
            }
            else
            {
                _placeOrderView.hidden = NO;
            }
        }];
    }
}

// 减菜返回结果
- (void)responseWithOrderDetailShopReturnFoods:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success)
    {
        [self doRefreshData];
        [SVProgressHUD showSuccessWithStatus:@"退菜成功"];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
    [self showWithAddSubFoodView:NO];
}

// 加菜返回结果
- (void)responseWithOrderDetailSupplyReturn:(TYZRespondDataEntity *)respond cartEnt:(ShopingCartEntity *)cartEnt
{
    if (respond.errcode == respond_success)
    {
        [self doRefreshData];
//        if (cartEnt.number > 0)
//        {// 加菜
            // 同时下单
            /*[HCSNetHttp requestWithOrderFoodToKitchen:_orderDetailEntity.order.order_id shopId:_orderDetailEntity.order.shop_id completion:^(id result) {
                TYZRespondDataEntity *tRespond = result;
                if (tRespond.errcode == respond_success)
                {
                    [self doRefreshData];
                    [SVProgressHUD showSuccessWithStatus:@"加菜成功"];
                }
                else
                {
                    [UtilityObject svProgressHUDError:respond viewContrller:self];
                }
            }];
             */
        [SVProgressHUD showInfoWithStatus:@"加菜完成，请去下单"];
//        }
//        else if (cartEnt.number < 0)
//        {// 退菜
//            [self doRefreshData];
//            [SVProgressHUD showSuccessWithStatus:@"退菜成功"];
//        }
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
    [self showWithAddSubFoodView:NO];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = EN_SHOP_ORDER_DETAIL_MAX_SESTION;
    _section = count;
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    switch (section)
    {
        case EN_SHOP_ORDER_DETAIL_DINERSINFO_SESTION:
        {// 食客信息
            count = EN_SHOP_ORDER_DETAIL_DI_MAX_ROW;
            if (!_touchDiners)
            {
                count -= 1;
            }
        } break;
        case EN_SHOP_ORDER_DETAIL_CURRFOOD_SESTION:
        {// old菜品列表
            count = [_orderDetailEntity.detailFoods count];
        } break;
        default:
            break;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    switch (indexPath.section)
    {
        case EN_SHOP_ORDER_DETAIL_DINERSINFO_SESTION:
        {// 基本信息
            if (indexPath.row == EN_SHOP_ORDER_DETAIL_DI_BASEINFO_ROW)
            {// 食客信息
                ShopOrderDetailDinersInfoCell *cell = [ShopOrderDetailDinersInfoCell cellForTableView:tableView];
                [cell updateCellData:_orderDetailEntity isSelected:_touchDiners];
                if (_touchDiners)
                {
                    [cell hiddenWithLine:NO];
                }
                else
                {
                    [cell hiddenWithLine:YES];
                }
                cell.baseTableViewCellBlock = ^(id data)
                {// 点击看订单信息
                    BOOL select = [data boolValue];
                    _touchDiners = !select;
                    [MCYPushViewController reloadWithTableView:tableView indexPath:indexPath reloadType:2];
                };
                return cell;
            }
            else if (indexPath.row == EN_SHOP_ORDER_DETAIL_CURRFOOD_SESTION)
            {// 订单信息
                ShopOrderDetailOrderInfoCell *cell = [ShopOrderDetailOrderInfoCell cellForTableView:tableView];
                [cell updateCellData:_orderDetailEntity];
                cell.baseTableViewCellBlock = ^(id data)
                {
                    [MCYPushViewController callWithPhone:weakSelf phone:weakSelf.orderDetailEntity.mobile];
                };
                return cell;
            }
        } break;
        case EN_SHOP_ORDER_DETAIL_CURRFOOD_SESTION:
        {// old菜品列表
            OrderFoodInfoEntity *foodEnt = _orderDetailEntity.detailFoods[indexPath.row];
            if (foodEnt.isSub)
            {// 子cell
                ShopSupplementFoodCell *cell = [ShopSupplementFoodCell cellForTableView:tableView];
                [cell updateCellData:foodEnt];
                return cell;
            }
            else
            {
                DinersOrderDetailFoodViewCell *cell = [DinersOrderDetailFoodViewCell cellForTableView:tableView];
                [cell updateCellData:foodEnt];
                cell.baseTableViewCellBlock = ^(id data)
                {
                    OrderFoodInfoEntity *orderFoodEnt = data;
                    weakSelf.indexPath = indexPath;
//                    debugLog(@"row==%d", (int)weakSelf.indexPath.row);
                    if (orderFoodEnt.status == NS_ORDER_FOOD_RETIRED_STATE)
                    {// 退的菜
                        BOOL bRet = NO;
                        for (OrderFoodInfoEntity *ent in orderFoodEnt.subFoods)
                        {
                            if (ent.status != NS_ORDER_FOOD_RETIRED_STATE)
                            {
                                bRet = YES;
                            }
                        }
                        if (!bRet)
                        {
                            return;
                        }
                    }
                    if (weakSelf.orderDetailEntity.status != NS_ORDER_DINING_STATE)
                    {
                        return;
                    }
                    weakSelf.selectFoodEntity = orderFoodEnt;
                    if ([orderFoodEnt.subFoods count] > 1)
                    {
                        _addSubType = EN_ADD_SUB_SECOND_TYPE; //点击有多次加菜加减菜品的主cell
                    }
                    else
                    {
                        _addSubType = EN_ADD_SUB_FIRST_TYPE;
                    }
                    // 0 正常 1 已上桌 2 已退菜
//                    [weakSelf.foodActionSheet showInView:self.view];
                    [weakSelf initWithFoodActionSheet];
                };
                return cell;
            }
        } break;
        default:
            break;
    }
    
    TYZBaseTableViewCell *cell = [TYZBaseTableViewCell cellForTableView:tableView];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 40;
    switch (indexPath.section)
    {
        case EN_SHOP_ORDER_DETAIL_DINERSINFO_SESTION:
        {// 基本信息
            if (indexPath.row == EN_SHOP_ORDER_DETAIL_DINERSINFO_SESTION)
            {// 食客基本信息
                height = kShopOrderDetailDinersInfoCellHeight;
            }
            else if (indexPath.row == EN_SHOP_ORDER_DETAIL_CURRFOOD_SESTION)
            {
                height = [ShopOrderDetailOrderInfoCell getWithCellHeight:_orderDetailEntity.type];
            }
        } break;
        case EN_SHOP_ORDER_DETAIL_CURRFOOD_SESTION:
        {// old菜品列表
            // OrderFoodInfoEntity
            OrderFoodInfoEntity *foodEnt = _orderDetailEntity.detailFoods[indexPath.row];
            if (foodEnt.isSub)
            {
                height = kShopSupplementFoodCellHeight;
            }
            else
            {
                height = [DinersOrderDetailFoodViewCell getWithCellHeight:foodEnt];
            }
        } break;
        default:
            break;
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == EN_SHOP_ORDER_DETAIL_CURRFOOD_SESTION)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], 30);
        DinersOrderDetailFoodTitleView *view = [[DinersOrderDetailFoodTitleView alloc] initWithFrame:frame];
//        DinersCreateOrderFoodHeaderView
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == EN_SHOP_ORDER_DETAIL_DINERSINFO_SESTION)
    {
        return 10;
    }
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == EN_SHOP_ORDER_DETAIL_DINERSINFO_SESTION)
    {
        return 10.0;
    }
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    debugMethod();
    self.indexPath = indexPath;
    debugLog(@"row===%d", (int)_indexPath.row);
    OrderFoodInfoEntity *foodInfoEntity = nil;
    if (indexPath.section == EN_SHOP_ORDER_DETAIL_CURRFOOD_SESTION)
    {// 下单的菜品列表
        foodInfoEntity = _orderDetailEntity.detailFoods[indexPath.row];
        
        if ([foodInfoEntity.subFoods count] > 1)
        {
            foodInfoEntity.isCheck = !foodInfoEntity.isCheck;
            
            DinersOrderDetailFoodViewCell *cell = (DinersOrderDetailFoodViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            [cell updateCellData:foodInfoEntity];
            
            NSMutableArray *foodList = [NSMutableArray new];
            if (foodInfoEntity.isCheck)
            {
                [_orderDetailEntity.detailFoods insertObjects:foodInfoEntity.subFoods atIndex:indexPath.row+1];
                for (NSInteger i=1; i<=foodInfoEntity.subFoods.count; i++)
                {
                    [foodList addObject:[NSIndexPath indexPathForRow:i+indexPath.row inSection:indexPath.section]];
                }
                [tableView insertRowsAtIndexPaths:foodList withRowAnimation:UITableViewRowAnimationFade];
            }
            else
            {
                [_orderDetailEntity.detailFoods removeObjectsInArray:foodInfoEntity.subFoods];
                for (NSInteger i=1; i<=foodInfoEntity.subFoods.count; i++)
                {
                    [foodList addObject:[NSIndexPath indexPathForRow:i+indexPath.row inSection:indexPath.section]];
                }
                [tableView deleteRowsAtIndexPaths:foodList withRowAnimation:UITableViewRowAnimationFade];
            }
            
        }
        
    }

    if (foodInfoEntity && foodInfoEntity.isSub)
    {
        if (foodInfoEntity.status == NS_ORDER_FOOD_RETIRED_STATE)
        {// 退的菜
            return;
        }
        if (_orderDetailEntity.status != NS_ORDER_DINING_STATE)
        {
            return;
        }
        self.selectFoodEntity = foodInfoEntity;
        
        _addSubType = EN_ADD_SUB_THIRD_TYPE; // 点击有多次加减菜品的子cell
//        [_foodActionSheet showInView:self.view];
        [self initWithFoodActionSheet];
        
    }
    else
    {
        self.selectFoodEntity = nil;
    }
}


@end














