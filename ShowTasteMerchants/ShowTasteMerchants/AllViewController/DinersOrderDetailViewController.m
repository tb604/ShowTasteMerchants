//
//  DinersOrderDetailViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/20.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DinersOrderDetailViewController.h"
#import "LocalCommon.h"
#import "UserLoginStateObject.h"
#import "DinersOrderDetailBottomView.h"
#import "TYZBaseTableViewCell.h"
#import "DinersOrderDetailHeaderView.h"
#import "DinersCreateOrderAddressMobileCell.h" // 地址
#import "DinersOrderDetailFoodTitleView.h"
#import "DinersCreateOrderShopNameCell.h"
#import "DinersOrderDetailViewCell.h" // 订单信息
#import "DinersOrderDetailFoodViewCell.h"
#import "DinersOrderDetailFooterView.h"
#import "OrderFoodNumberEntity.h"
#import "RestaurantReservationInputEntity.h"
#import "ShopingCartEntity.h" // 购物车实体类
#import "DinersRecipeViewController.h"
//#import "OrderMealViewController.h" // 食客端首页视图控制器
#import "ShopSupplementFoodCell.h"
#import "WYXRongCloudMessage.h"

@interface DinersOrderDetailViewController ()
{
    
    DinersOrderDetailHeaderView *_headerView;
    
    DinersOrderDetailFooterView *_footerView;
    
    DinersOrderDetailBottomView *_bottomView;
    
    NSInteger _section;
}

/**
 *  navView右边的按钮
 */
@property (nonatomic, strong) UIButton *btnRight;

- (void)initWithBtnRight;

- (void)initWithHeaderView;

- (void)initWithFooterView;

- (void)initWithBottomView;

- (void)getWithOrderDetail;

/**
 *  推送的时候，接收到通知
 *
 *  @param note note
 */
- (void)orderWithReceivePushNote:(NSNotification *)note;

@end

@implementation DinersOrderDetailViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kWYXClientReceiveMessageNotification object:nil];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!_isFirst)
    {
        [self doRefreshData];
    }
    _isFirst = NO;
}

- (void)initWithVar
{
    [super initWithVar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderWithReceivePushNote:) name:kWYXClientReceiveMessageNotification object:nil];
    
    
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
    
    self.baseTableView.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self hiddenFooterView:YES];
    
    [self initWithHeaderView];
    
    [self initWithFooterView];
    
    [self initWithBottomView];
}

- (void)doRefreshData
{
    [super doRefreshData];
    
    [self getWithOrderDetail];
}

- (void)clickedBack:(id)sender
{
    if (self.popResultBlock)
    {
        self.popResultBlock(_orderDetailEntity);
    }
    
//    NSArray *array = [self.navigationController viewControllers];
    
    // 食客端首页视图控制器
    /*OrderMealViewController *orderMealVC = nil;
    for (id vc in array)
    {
        if ([vc isKindOfClass:[OrderMealViewController class]])
        {
            orderMealVC = vc;
            break;
        }
    }
    
    if (orderMealVC)
    {
        [self.navigationController popToViewController:orderMealVC animated:YES];
    }
    else
    {*/
        [super clickedBack:sender];
    //}
}

- (void)initWithBtnRight
{
    if (!_btnRight)
    {
        NSString *str = @"退单";
        CGFloat width = [str widthForFont:FONTSIZE_16];
        CGRect frame = CGRectMake(0, 0, width, 30);
        UIButton *btn = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"退单" titleColor:[UIColor whiteColor] titleFont:FONTSIZE_16 targetSel:@selector(clickedWithBtnRight:)];
        btn.frame = frame;
        UIBarButtonItem *itemRight = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.rightBarButtonItem = itemRight;
        self.btnRight = btn;
    }
    _btnRight.hidden = YES;
    if (_orderDetailEntity.order.status == NS_ORDER_WAITING_CONFIRMATION_STATE)
    {// 待商家确认(待确认)
        _btnRight.hidden = NO;
        [_btnRight setTitle:@"取消" forState:UIControlStateNormal];
    }
    else if (_orderDetailEntity.order.status == NS_ORDER_WAITING_PAY_DEPOSIT_STATE)
    {// 待支付订金(已接单)
        _btnRight.hidden = NO;
        [_btnRight setTitle:@"取消" forState:UIControlStateNormal];
    }
    else if (_orderDetailEntity.order.status == NS_ORDER_COMPLETED_BOOKING_STATE)
    {// 预订完成
        _btnRight.hidden = NO;
        [_btnRight setTitle:@"退单" forState:UIControlStateNormal];
    }
    else if (_orderDetailEntity.order.status == NS_ORDER_DINING_STATE || _orderDetailEntity.order.status == NS_ORDER_IN_CHECKOUT_STATE)
    {// 就餐中 / 服务员确认，可以买单
        _btnRight.hidden = NO;
        [_btnRight setTitle:@"买单" forState:UIControlStateNormal];
    }
    else if (_orderDetailEntity.order.status == NS_ORDER_IN_CHECKOUT_STATE)
    {// 结账中
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

         */
    }
    else if (_orderDetailEntity.order.status == NS_ORDER_PAY_COMPLETE_STATE)
    {// 支付完成
        
    }
    else if (_orderDetailEntity.order.status == NS_ORDER_ORDER_COMPLETE_STATE)
    {// 订单已完成(已完成)
        
    }
    else if (_orderDetailEntity.order.status == NS_ORDER_SHOP_SAB_STATE)
    {// 退单申请中
        
    }
    else if (_orderDetailEntity.order.status == NS_ORDER_ORDER_CANCELED_STATE)
    {// 订单已取消
        
    }
    else if (_orderDetailEntity.order.status == NS_ORDER_RETREAT_SINGLE_COMPLETE_STATE)
    {// 退单完成（已退款）
        
    }
    else if (_orderDetailEntity.order.status == NS_ORDER_SHOP_REFUSED_STATE)
    {// 商家已拒绝(拒单)
        
    }
    else if (_orderDetailEntity.order.status == NS_ORDER_ORDER_NOT_ACTIVE_STATE)
    {// 订单未激活(即时订单)
        _btnRight.hidden = NO;
        [_btnRight setTitle:@"取消" forState:UIControlStateNormal];
    }
}

- (void)initWithHeaderView
{
    if (!_headerView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kDinersOrderDetailHeaderViewHeight);
        _headerView = [[DinersOrderDetailHeaderView alloc] initWithFrame:frame];
//        self.baseTableView.tableHeaderView = _headerView;
        [self.view addSubview:_headerView];
    }
    [_headerView updateViewData:_orderDetailEntity.order];
}

- (void)initWithFooterView
{
    CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kDinersOrderDetailFooterViewHeight);
    frame.size.height = frame.size.height - 20 + _orderDetailEntity.order.foodTotalDescHeight;
    if (!_footerView)
    {
        _footerView = [[DinersOrderDetailFooterView alloc] initWithFrame:frame];
        self.baseTableView.tableFooterView = _footerView;
    }
    else
    {
        _footerView.frame = frame;
    }
    [_footerView updateViewData:_orderDetailEntity.order];
}

- (void)initWithBottomView
{
    AppDelegate *app = [UtilityObject appDelegate];
    CGFloat statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navBarHeight = self.navigationController.navigationBar.bounds.size.height;
    CGRect frame = CGRectMake(0, kDinersOrderDetailHeaderViewHeight, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight] - statusHeight - navBarHeight - [app tabBarHeight] - kDinersOrderDetailHeaderViewHeight);
    self.baseTableView.frame = frame;
    __weak typeof(self)blockSelf = self;
    if (!_bottomView)
    {
        _bottomView = [[DinersOrderDetailBottomView alloc] initWithFrame:CGRectMake(0, frame.size.height+kDinersOrderDetailHeaderViewHeight, [[UIScreen mainScreen] screenWidth], [app tabBarHeight])];
        [self.view addSubview:_bottomView];
    }
    _bottomView.bottomClickedBlock = ^(NSString *title, NSInteger tag)
    {
        [blockSelf bottomViewClicked:title tag:tag];
    };
    _bottomView.hidden = NO;
    if (_orderDetailEntity.order.status == NS_ORDER_WAITING_CONFIRMATION_STATE)
    {// 待商家确认(待确认)
        frame.size.height = frame.size.height + _bottomView.height;
        self.baseTableView.frame = frame;
        _bottomView.hidden = YES;
    }
    else if (_orderDetailEntity.order.status == NS_ORDER_WAITING_PAY_DEPOSIT_STATE)
    {// 待支付订金(已接单)
        [_bottomView updateWithBottom:_orderDetailEntity.order buttonWidthType:3 buttonTitle:@"支付"];
    }
    else if (_orderDetailEntity.order.status == NS_ORDER_COMPLETED_BOOKING_STATE)
    {// 预订完成
        [_bottomView updateWithBottom:_orderDetailEntity.order buttonWidthType:1 buttonTitle:@"分享"];
    }
    else if (_orderDetailEntity.order.status == NS_ORDER_DINING_STATE)
    {// 就餐中
        frame.size.height = frame.size.height + _bottomView.height;
        self.baseTableView.frame = frame;
        _bottomView.hidden = YES;
//        [_bottomView updateWithBottom:_orderDetailEntity.order buttonWidthType:1 buttonTitle:@"加菜"];
    }
    else if (_orderDetailEntity.order.status == NS_ORDER_IN_CHECKOUT_STATE)
    {// 结账中(待支付)
        frame.size.height = frame.size.height + _bottomView.height;
        self.baseTableView.frame = frame;
        _bottomView.hidden = YES;
    }
    else if (_orderDetailEntity.order.status == NS_ORDER_PAY_COMPLETE_STATE || _orderDetailEntity.order.status == NS_ORDER_ORDER_COMPLETE_STATE)
    {// 支付完成
        if (_orderDetailEntity.order.comment_status == 0)
        {// 未评论
            [_bottomView updateWithBottom:_orderDetailEntity.order buttonWidthType:1 buttonTitle:@"去评价"];
        }
        else
        {// 已评论
            frame.size.height = frame.size.height + _bottomView.height;
            self.baseTableView.frame = frame;
            _bottomView.hidden = YES;
        }
        
    }
    else if (_orderDetailEntity.order.status == NS_ORDER_ORDER_COMPLETE_STATE)
    {// 订单已完成(已完成)
        frame.size.height = frame.size.height + _bottomView.height;
        self.baseTableView.frame = frame;
        _bottomView.hidden = YES;
    }
    else if (_orderDetailEntity.order.status == NS_ORDER_SHOP_SAB_STATE)
    {// 退单申请中
        // 临时处理
        frame.size.height = frame.size.height + _bottomView.height;
        self.baseTableView.frame = frame;
        _bottomView.hidden = YES;
    }
    else if (_orderDetailEntity.order.status == NS_ORDER_ORDER_CANCELED_STATE)
    {// 订单已取消
        // 临时处理
        frame.size.height = frame.size.height + _bottomView.height;
        self.baseTableView.frame = frame;
        _bottomView.hidden = YES;
    }
    else if (_orderDetailEntity.order.status == NS_ORDER_RETREAT_SINGLE_COMPLETE_STATE)
    {// 退单完成（已退款）
        // 临时处理
        frame.size.height = frame.size.height + _bottomView.height;
        self.baseTableView.frame = frame;
        _bottomView.hidden = YES;
    }
    else if (_orderDetailEntity.order.status == NS_ORDER_SHOP_REFUSED_STATE)
    {// 商家已拒绝(拒单)
        // 临时处理
        frame.size.height = frame.size.height + _bottomView.height;
        self.baseTableView.frame = frame;
        _bottomView.hidden = YES;
    }
    else if (_orderDetailEntity.order.status == NS_ORDER_ORDER_NOT_ACTIVE_STATE)
    {// 订单未激活(即时订单)
        [_bottomView updateWithBottom:_orderDetailEntity.order buttonWidthType:3 buttonTitle:@"加菜"];
    }
}

- (void)bottomViewClicked:(NSString *)title tag:(NSInteger)tag
{
    if ([title isEqualToString:@"支付"])
    {
        [MCYPushViewController showWithPayWayVC:self data:_orderDetailEntity completion:^(id data) {
            // 支付完成后返回
            OrderDetailDataEntity *retOrderDetailEnt = data;
            _orderDetailEntity.order.status = retOrderDetailEnt.order.status;
            [self reloadWithOrderDetail];
        }];
    }
    else if ([title isEqualToString:@"分享"])
    {
        // kInviteShareUrl
        UserInfoDataEntity *userInfo = [UserLoginStateObject getUserInfo];
        NSString *userName = [NSString stringWithFormat:@"%@%@", userInfo.family_name, userInfo.name];
        NSString *shareMsg = kInviteShareMsg(userName);
        [UtilityObject showWithShareView:self.view shareImage:nil shareTitle:@"秀味" shareContent:shareMsg shareUrl:kInviteShareUrl(_orderDetailEntity.order.order_id)];
    }
    else if ([title isEqualToString:@"加菜"])
    {// 预订就餐(就餐中)、即时就餐(未激活、就餐中)
        [self dinersAddFood];
    }
    else if ([title isEqualToString:@"去评价"])
    {
        [MCYPushViewController showWithEvaluationPaySucVC:self data:_orderDetailEntity completion:^(id data) {
            OrderDetailDataEntity *retOrderDetailEnt = data;
            _orderDetailEntity.order.status = retOrderDetailEnt.order.status;
            _orderDetailEntity.order.comment_status = retOrderDetailEnt.order.comment_status;
            _orderDetailEntity.order.comment_status_desc = retOrderDetailEnt.order.comment_status_desc;
            [self reloadWithOrderDetail];
        }];
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
    NotifyBodyEntity *bodyEnt = notifyMsg.notify_body;
    if (![bodyEnt.order_id isEqualToString:_orderDetailEntity.order.order_id])
    {
        return;
    }
    
    NSInteger type = bodyEnt.notify_cmd;
    debugLog(@"type=%d", (int)type);
    if (type == EN_PUSH_ORDER_ACTIVATED_TC)
    {// 即时和预订订单激活后的通知。(3)
        _orderDetailEntity.order.status = NS_ORDER_DINING_STATE;
        _orderDetailEntity.order.status_remark = [UtilityObject dinersWithOrderState:_orderDetailEntity.order.status];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadWithOrderDetail];
        });
    }
    else if (type == EN_PUSH_ORDER_SHOPS_NOTIFY_TC)
    {// 预订后，商家的接单和拒单通知 (1)
        [self doRefreshData];
    }
    else if (type == EN_PUSH_ORDER_DEPOSIT_SUCCESS_TC)
    {// 预定支付成功后，明确用户预订信息的通知。(2)
        //        orderEntity.status = NS_ORDER_DINING_STATE;
        //        orderEntity.status_remark = [UtilityObject dinersWithOrderState:orderEntity.status];
        //        [self.baseTableView reloadData];
    }
    else if (type == EN_PUSH_ORDER_KITCHEN_TC)
    {// 服务员下单到后厨的通知(4)
        
    }
    else if (type == EN_PUSH_ORDER_BILL_CONFIRM_TC)
    {// 服务员确认账单的通知。确认后，食客就可以支付了(5)
        _orderDetailEntity.order.status = NS_ORDER_IN_CHECKOUT_STATE;
        _orderDetailEntity.order.status_remark = [UtilityObject dinersWithOrderState:_orderDetailEntity.order.status];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadWithOrderDetail];
        });
    }
    else if (type == EN_PUSH_ORDER_PAYMENT_CONFIRM_TC)
    {// 服务员确认支付，完成订单。感谢下次光临的通知。(6)
//        [self doRefreshData];
        _orderDetailEntity.order.status = NS_ORDER_ORDER_COMPLETE_STATE;
        _orderDetailEntity.order.status_remark = [UtilityObject dinersWithOrderState:_orderDetailEntity.order.status];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadWithOrderDetail];
        });
    }

}


/**
 *  食客加菜(修改，添加、删除)
 */
- (void)dinersAddFood
{
//    DinersRecipeViewController
    NSArray *list = self.navigationController.viewControllers;
    DinersRecipeViewController *drVC = nil;
    for (id vc in list)
    {
        if ([vc isKindOfClass:[DinersRecipeViewController class]])
        {
            drVC = vc;
            break;
        }
    }
    
    if (drVC)
    {
        drVC.reservationInputEntity.orderId = _orderDetailEntity.order.order_id;
        drVC.reservationInputEntity.addType = 2;
        drVC.reservationInputEntity.orderState = _orderDetailEntity.order.status;
        [self.navigationController popToViewController:drVC animated:YES];
        return;
    }
    
    RestaurantReservationInputEntity *inputEnt = [RestaurantReservationInputEntity new];
    inputEnt.orderId = _orderDetailEntity.order.order_id;
    inputEnt.orderState = _orderDetailEntity.order.status;
    inputEnt.userId = _orderDetailEntity.order.user_id;
    inputEnt.shopId = _orderDetailEntity.order.shop_id;
    inputEnt.shopName = _orderDetailEntity.order.shop_name;
    inputEnt.shopAddress = _orderDetailEntity.order.address;
    inputEnt.shopMobile = _orderDetailEntity.order.shop_tel;
    inputEnt.type = _orderDetailEntity.order.type;
    inputEnt.addType = 2; // 表示修改菜单
    inputEnt.fixedShopingCartList = [NSMutableArray array];
    
    if (_orderDetailEntity.order.status == NS_ORDER_ORDER_NOT_ACTIVE_STATE)
    {// 未激活
        for (OrderFoodInfoEntity *foodEnt in _orderDetailEntity.details)
        {
            ShopingCartEntity *cartEnt = [ShopingCartEntity new];
            cartEnt.id = foodEnt.food_id;
            cartEnt.name = foodEnt.food_name;
            cartEnt.category_id = foodEnt.category_id;
            cartEnt.categoryName = foodEnt.category_name;
            cartEnt.price = foodEnt.price;
            cartEnt.activityPrice = foodEnt.activity_price;
            cartEnt.number = foodEnt.number;
            cartEnt.unit = foodEnt.unit;
            cartEnt.mode = foodEnt.mode;
            cartEnt.taste = foodEnt.taste;
            [inputEnt.fixedShopingCartList addObject:cartEnt];
        }
    }
    // ShopingCartEntity
    
//    DinersRecipeViewController
    
    [MCYPushViewController showWithRecipeVC:self data:inputEnt completion:^(id data) {
        
    }];
}

- (void)clickedWithBtnRight:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSString *title = btn.titleLabel.text;
//    debugLog(@"%@", title);
    if ([title isEqualToString:@"退单"] || [title isEqualToString:@"取消"])
    {
        [MCYPushViewController showWithDinersCancelOrderVC:self data:_orderDetailEntity.order completion:^(id data) {
            OrderDataEntity *orderEnt = data;
            _orderDetailEntity.order.status = orderEnt.status;
            [self reloadWithOrderDetail];
        }];
    }
    else if ([title isEqualToString:@"买单"])
    {
        if (_orderDetailEntity.order.status == NS_ORDER_IN_CHECKOUT_STATE)
        {// 服务员确认后，可以支付了，结账中
            [MCYPushViewController showWithWantPayVC:self data:_orderDetailEntity completion:^(id data) {
                OrderDetailDataEntity *detailEtn = data;
                if (detailEtn.order.status != _orderDetailEntity.order.status)
                {
                    [self doRefreshData];
                }
//                _orderDetailEntity.order.status = detailEtn.order.status;
//                [self reloadWithOrderDetail];
            }];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"通知餐厅人员核对并确认菜单信息" message:@"通过秀味App支付，可获得分佣收益享受更多服务" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
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

- (void)getWithOrderDetail
{
    [HCSNetHttp requestWithOrderShowWholeOrderTwo:_orderDetailEntity.order.order_id shopId:_orderDetailEntity.order.shop_id completion:^(id result) {
        [self responseWithOrderShowWholeOrder:result];
    }];
}

- (void)responseWithOrderShowWholeOrder:(TYZRespondDataEntity *)respond
{
    debugMethod();
    if (respond.errcode == respond_success)
    {
        self.orderDetailEntity = respond.data;
        NSInteger num = 0;
        NSMutableDictionary *categoryDict = [NSMutableDictionary new];
        OrderDetailDataEntity *orderDetailEnt = respond.data;
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
        orderDetailEnt.order.foodTotalDesc = mutStr;
        orderDetailEnt.order.foodTotalDescHeight = [UtilityObject mulFontHeights:mutStr font:FONTSIZE_12 maxWidth:[[UIScreen mainScreen] screenWidth] - 30];
        orderDetailEnt.order.totalCount = num;
        
        
        [self reloadWithOrderDetail];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
    
    [self endAllRefreshing];
}

// 给商家打电话
- (void)callWithShopMobile:(id)sender
{
//    [MCYPushViewController callWithPhone:self phone:_orderDetailEntity.shop_tel];
}

/*
 【 订单状态 1 待商家确认；2 商家已确认(已接单)；3 待支付订金； 4 已完成预订；101 待下单； 102 就餐中； 103 结账中； 104  支付完成； 200 订单已完成； 300 订单已取消； 400 商家已拒绝   】
 */


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = EN_ORDER_DETAIL_MAX_SECTION;
    _section = count;
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    switch (section)
    {
        case EN_ORDER_DETAIL_BASEINFO_SECTION:
        {// 基本信息
            count = EN_ORDER_DETAIL_BASEINFO_MAX_ROW;
        } break;
        case EN_ORDER_DETAIL_OLDFOOD_SECTION:
        {// old菜品列表
            count = [_orderDetailEntity.detailFoods count];
            debugLog(@"count=%d", (int)count);
        } break;
        default:
            break;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case EN_ORDER_DETAIL_BASEINFO_SECTION:
        {// 基本信息
            if (indexPath.row == EN_ORDER_DETAIL_BASEINFO_SHOPNAME_ROW)
            {// 餐厅名称
                DinersCreateOrderShopNameCell *cell = [DinersCreateOrderShopNameCell cellForTableView:tableView];
                [cell updateCellData:_orderDetailEntity.order.shop_name];
                return cell;
            }
            else if (indexPath.row == EN_ORDER_DETAIL_BASEINFO_SHOPADDRESS_ROW)
            {// 餐厅地址
                DinersCreateOrderAddressMobileCell *cell = [DinersCreateOrderAddressMobileCell cellForTableView:tableView];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell updateCellData:objectNull(_orderDetailEntity.order.address) imageName:@"hall_icon_addr"];
                return cell;
            }
            else if (indexPath.row == EN_ORDER_DETAIL_BASEINFO_SHOPMOBILE_ROW)
            {// 餐厅电话
                DinersCreateOrderAddressMobileCell *cell = [DinersCreateOrderAddressMobileCell cellForTableView:tableView];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell updateCellData:objectNull(_orderDetailEntity.order.shop_tel) imageName:@"hall_icon_phone"];
                return cell;
            }
            else if (indexPath.row == EN_ORDER_DETAIL_BASEINFO_ORDERINFO_ROW)
            {// 订单信息
                DinersOrderDetailViewCell *cell = [DinersOrderDetailViewCell cellForTableView:tableView];
                [cell updateCellData:_orderDetailEntity.order];
                return cell;
            }
        } break;
        case EN_ORDER_DETAIL_OLDFOOD_SECTION:
        {// old菜品列表
            OrderFoodInfoEntity *foodEnt = _orderDetailEntity.detailFoods[indexPath.row];
            
            if (foodEnt.isSub)
            {
                ShopSupplementFoodCell *cell = [ShopSupplementFoodCell cellForTableView:tableView];
                [cell updateCellData:foodEnt];
                return cell;
            }
            else
            {
//                debugLog(@"number=%d; allNum=%d", (int)foodEnt.number, (int)foodEnt.allNumber);
                DinersOrderDetailFoodViewCell *cell = [DinersOrderDetailFoodViewCell cellForTableView:tableView];
                [cell updateCellData:foodEnt];
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
        case EN_ORDER_DETAIL_BASEINFO_SECTION:
        {// 基本信息
            if (indexPath.row == EN_ORDER_DETAIL_BASEINFO_SHOPNAME_ROW)
            {// 餐厅名称
                height = kDinersCreateOrderShopNameCellHeight;
            }
            else if (indexPath.row == EN_ORDER_DETAIL_BASEINFO_SHOPADDRESS_ROW)
            {// 餐厅地址
                height = kDinersCreateOrderAddressMobileCellHeight;
            }
            else if (indexPath.row == EN_ORDER_DETAIL_BASEINFO_SHOPMOBILE_ROW)
            {// 餐厅电话
                height = kDinersCreateOrderAddressMobileCellHeight;
            }
            else if (indexPath.row == EN_ORDER_DETAIL_BASEINFO_ORDERINFO_ROW)
            {// 订单信息
                height = [DinersOrderDetailViewCell getWithCellHeight:_orderDetailEntity.order.type];
            }
        } break;
        case EN_ORDER_DETAIL_OLDFOOD_SECTION:
        {// old菜品列表
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
    if (section == EN_ORDER_DETAIL_OLDFOOD_SECTION)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], 30);
        DinersOrderDetailFoodTitleView *view = [[DinersOrderDetailFoodTitleView alloc] initWithFrame:frame];
        
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == EN_ORDER_DETAIL_BASEINFO_SECTION)
    {
        return 10;
    }
    return 30;
}
/*
 EN_ORDER_DETAIL_BASEINFO_SECTION = 0, ///< 基本信息
 EN_ORDER_DETAIL_OLDFOOD_SECTION, ///< old菜品列表
 EN_ORDER_DETAIL_NEWADDFOOD_SECTION, ///< 新增菜品列表
 */

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == EN_ORDER_DETAIL_BASEINFO_SECTION)
    {
        return 10.0;
    }
    return 0.001;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section)
    {
        case EN_ORDER_DETAIL_BASEINFO_SECTION:
        {// 基本信息
            if (indexPath.row == EN_ORDER_DETAIL_BASEINFO_SHOPNAME_ROW)
            {// 餐厅名称
                
            }
            else if (indexPath.row == EN_ORDER_DETAIL_BASEINFO_SHOPADDRESS_ROW)
            {// 餐厅地址
                
            }
            else if (indexPath.row == EN_ORDER_DETAIL_BASEINFO_SHOPMOBILE_ROW)
            {// 餐厅电话
                
            }
            else if (indexPath.row == EN_ORDER_DETAIL_BASEINFO_ORDERINFO_ROW)
            {// 订单信息
                
            }
        } break;
        case EN_ORDER_DETAIL_OLDFOOD_SECTION:
        {// old菜品列表
            OrderFoodInfoEntity *foodInfoEntity = _orderDetailEntity.detailFoods[indexPath.row];
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
            
        } break;
        default:
            break;
    }

}


@end









