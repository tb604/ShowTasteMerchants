//
//  DinersCreateOrderViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/28.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DinersCreateOrderViewController.h"
#import "LocalCommon.h"
#import "DinersCreateOrderFooterView.h"
#import "DinersCreateOrderBottomView.h"
#import "TYZBaseTableViewCell.h"
#import "DinersCreateOrderFoodHeaderView.h"
#import "DinersCreateOrderFoodViewCell.h"
#import "ShopingCartEntity.h" // 购物车里面的数据实体类
#import "DinersCreateOrderShopNameCell.h"
#import "DinersCreateOrderAddressMobileCell.h"
#import "MyRestaurantCommonViewCell.h"
#import "DinersCreateOrderInfoViewCell.h"
#import "DinersCreateOrderHeaderView.h"
#import "OrderDetailDataEntity.h"
#import "ShopingCartEntity.h"
#import "OrderFoodNumberEntity.h"
#import "UpdateOrderFoodInputEntity.h" // 在未激活的时候，修改菜单的传入参数
#import "DinersOrderDetailViewController.h" // 订单详情视图控制器
#import "ShopOrderDetailViewController.h" // 餐厅端订单详情视图控制器
#import "CTCRestaurantMealingOrderViewController.h"
#import "ShopPlaceOrderBackgroundView.h" // 下单

@interface DinersCreateOrderViewController ()
{
    /**
     *  退单
     */
//    UIButton *_btnCancelOrder;
    
    DinersCreateOrderHeaderView *_headerView;
    
    DinersCreateOrderFooterView *_footerView;
    
    DinersCreateOrderBottomView *_bottomView;
}

/**
 *  选中的档口id
 */
@property (nonatomic, assign) NSInteger selectedPrinterId;

@property (nonatomic, strong) ShopPlaceOrderBackgroundView *placeOrderView;

/**
 *  在未激活的时候，修改菜单的传入参数
 */
@property (nonatomic, strong) UpdateOrderFoodInputEntity *noActiveFoodInputEnt;

//@property (nonatomic, strong) UIButton *btnCancelOrder;

- (void)initWithHeaderView;

- (void)initWithFooterView;

- (void)initWithBottomView;

@end

@implementation DinersCreateOrderViewController

- (void)initWithVar
{
    [super initWithVar];

    if (_inputFoodEntity.orderState == NS_ORDER_ORDER_NOT_ACTIVE_STATE || _inputFoodEntity.orderState == NS_ORDER_DINING_STATE)
    {// 即时菜单未激活， 就餐中
        _noActiveFoodInputEnt = [UpdateOrderFoodInputEntity new];
        _noActiveFoodInputEnt.userId = _inputFoodEntity.userId;
        _noActiveFoodInputEnt.orderId = _inputFoodEntity.orderId;
        _noActiveFoodInputEnt.shopId = _inputFoodEntity.shopId;
        _noActiveFoodInputEnt.orderType = _inputFoodEntity.type;
//        if (_inputFoodEntity.orderState == NS_ORDER_ORDER_NOT_ACTIVE_STATE)
//        {// 未激活
            _noActiveFoodInputEnt.order_food_type = 1;
//        }
//        else
//        {
//            _noActiveFoodInputEnt.order_food_type = 2;
//        }
        _noActiveFoodInputEnt.content = [_inputFoodEntity.foodList modelToJSONString];
    }
    
    
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    if (_inputFoodEntity.addType == 1)
    {
        self.title = @"生成订单";
    }
    else
    {
        self.title = @"修改订单";
    }
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    AppDelegate *app = [UtilityObject appDelegate];
    CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight] - STATUSBAR_HEIGHT - [app navBarHeight] - [app tabBarHeight]);
    self.baseTableView.frame = frame;
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self initWithHeaderView];
    
    [self initWithFooterView];
    
    [self initWithBottomView];
    
}

- (void)initWithHeaderView
{
    if (_inputFoodEntity.orderState != -1)
    {
        if (!_headerView)
        {
            CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kDinersCreateOrderHeaderViewHeight);
            _headerView = [[DinersCreateOrderHeaderView alloc] initWithFrame:frame];
            self.baseTableView.tableHeaderView = _headerView;
        }
    }
    [_headerView updateViewData:@(_inputFoodEntity.orderState)];
}

- (void)initWithFooterView
{
    if (!_footerView)
    {
        NSInteger totalNum = 0;
        CGFloat totalPrice = 0;
        NSMutableDictionary *categoryDict = [NSMutableDictionary new];
        for (ShopingCartEntity *cartEnt in _inputFoodEntity.foodList)
        {
            OrderFoodNumberEntity *foodNumEnt = [OrderFoodNumberEntity new];
            foodNumEnt.categoryId = cartEnt.category_id;
            foodNumEnt.categoryName = cartEnt.categoryName;
            foodNumEnt.number = cartEnt.number;
            foodNumEnt.price = cartEnt.price;
            foodNumEnt.activityPrice = cartEnt.activityPrice;
            foodNumEnt.unit = cartEnt.unit;
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
            totalPrice += ((foodNumEnt.activityPrice==0.0?foodNumEnt.price:foodNumEnt.activityPrice) * foodNumEnt.number);
            totalNum += cartEnt.number;
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
        
        
        CGFloat height = [UtilityObject mulFontHeights:mutStr font:FONTSIZE_12 maxWidth:[[UIScreen mainScreen] screenWidth] - 30];
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kDinersCreateOrderFooterViewHeight - 20 + height);
        _footerView = [[DinersCreateOrderFooterView alloc] initWithFrame:frame];
        self.baseTableView.tableFooterView = _footerView;
        [_footerView updateViewData:mutStr totalNum:totalNum totalPrice:totalPrice];
    }
}

- (void)initWithBottomView
{
    AppDelegate *app = [UtilityObject appDelegate];
//    CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight] - STATUSBAR_HEIGHT - [app navBarHeight] - [app tabBarHeight]);
    
    if (!_bottomView)
    {
//        AppDelegate *app = [UtilityObject appDelegate];
        CGRect lframe = CGRectMake(0, self.baseTableView.bottom, [[UIScreen mainScreen] screenWidth], [app tabBarHeight]);
        _bottomView = [[DinersCreateOrderBottomView alloc] initWithFrame:lframe];
        [self.view addSubview:_bottomView];
        [_bottomView updateViewData:_inputFoodEntity];
    }
    _bottomView.hidden = NO;
    [_bottomView updateWithTitle:@"提交"];
    __weak typeof(self) weakSelf = self;
    _bottomView.viewCommonBlock = ^(id data)
    {
        [weakSelf clickedWithBottom:data];
    };
}

- (void)clickedWithBottom:(NSString *)title
{
    [self submitWithFoodInfo];
}

/**
 *  支付成功
 */
- (void)payWithFinish
{
    if (_inputFoodEntity.addType == 1)
    {// 表示创建
        _inputFoodEntity.orderState = NS_ORDER_COMPLETED_BOOKING_STATE;
    }
    [self updateStateReload];
}

// 提交菜品信息
- (void)submitWithFoodInfo
{
    debugLog(@"addType=%d; state=%d", (int)_inputFoodEntity.addType, (int)_inputFoodEntity.orderState);
//    return;
//    debugLog(@"foodList=%@", _inputFoodEntity.foodList);
//    debugLog(@"content=%@", _inputFoodEntity.content);
//    return;
    // 1表示点餐；2表示加菜（修改，可以 添加，可以删除）
    if (_inputFoodEntity.addType == 1)
    {// 创建订单
        [self createWithOrder];
    }
    else
    {// 修改
//        if (_inputFoodEntity.orderState == NS_ORDER_ORDER_NOT_ACTIVE_STATE)
//        {// 即时就餐，未激活的情况下，修改菜单
//            [self noActiveOrder];
//        }
//        else
//        {// 就餐中
            [self dinersEating];
//        }
    }
}

// 即时就餐，未激活的情况下，修改菜单
- (void)noActiveOrder
{
    debugLog(@"未激活");
//    return;
//    [SVProgressHUD showWithStatus:@"提交中"];
//    [HCSNetHttp requestWithOrderDetailModifyFoodDetail:_noActiveFoodInputEnt completion:^(id result) {
//        [self responseWithOrderDetailModifyFoodDetail:result];
//    }];
}

/**
 *  食客正在吃
 */
- (void)dinersEating
{
    debugLog(@"食客正在吃");
    [SVProgressHUD showWithStatus:@"提交中"];
    [HCSNetHttp requestWithShopOrderAddFoods:_noActiveFoodInputEnt completion:^(id result) {
        [self responseWithOrderDetailModifyFoodDetail:result];
    }];
}

- (void)responseWithOrderDetailModifyFoodDetail:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success)
    {
//        if (_inputFoodEntity.userType == 0)
//        {// 0表示食客
//            [self addOrSubResponse];
//            return;
//        }
        // 表示商家，商家加菜后，同时下单(在就餐过程中)
//        [self addOrSubResponse];
        [SVProgressHUD showInfoWithStatus:@"加菜完成"];
        
        if ([_printerList count] != 0)
        {
            [self placeWithOrder];
        }
        else
        {
            [self addOrSubResponse];
        }
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
}

- (void)addOrSubResponse
{
    [SVProgressHUD showSuccessWithStatus:@"加菜成功"];
//    DinersOrderDetailViewController *orderDetailVC = nil;
    CTCRestaurantMealingOrderViewController *shopOrderDetailVC = nil;
    NSArray *array = [self.navigationController viewControllers];
    for (id vc in array)
    {
        if ([vc isKindOfClass:[CTCRestaurantMealingOrderViewController class]])
        {
            shopOrderDetailVC = vc;
            break;
        }
    }
    if (shopOrderDetailVC)
    {
        [shopOrderDetailVC getWithOrderDetail];
        [self.navigationController popToViewController:shopOrderDetailVC animated:YES];
        return;
    }
    
    if (_inputFoodEntity.userType == 0)
    {// 食客
        OrderDataEntity *orderEnt = [OrderDataEntity new];
        orderEnt.order_id = _inputFoodEntity.orderId;
        orderEnt.shop_id = _inputFoodEntity.shopId;
        [MCYPushViewController showWithDinersOrderDetailVC:self data:orderEnt completion:nil];
    }
    else if (_inputFoodEntity.userType == 1)
    {// 商家
        
    }
}

// 创建订单
- (void)createWithOrder
{
    debugLog(@"type=%d", (int)_inputFoodEntity.type);
//    return;
    [SVProgressHUD showWithStatus:@"提交中"];
    if (_inputFoodEntity.type == 1)
    {// 预订就餐,下单
        [HCSNetHttp requestWithOrderBooking:_inputFoodEntity completion:^(id result) {
            TYZRespondDataEntity *respond = result;
            if (respond.errcode == respond_success)
            {
//                [SVProgressHUD dismiss];
                OrderDataEntity *orderEnt = [OrderDataEntity new];
                orderEnt.order_id = respond.data;
                orderEnt.shop_id = _inputFoodEntity.shopId;
                [MCYPushViewController showWithDinersOrderDetailVC:self data:orderEnt completion:nil];
//                _inputFoodEntity.orderId = respond.data;
//                _inputFoodEntity.orderState = NS_ORDER_WAITING_CONFIRMATION_STATE; // 待商家确认
//                [self updateStateReload];
            }
            else
            {
                [UtilityObject svProgressHUDError:respond viewContrller:self];
            }
        }];
    }
    else if (_inputFoodEntity.type == 2)
    {// 即时就餐，下单
        [HCSNetHttp requestWithShopOrderCreateOrder:_inputFoodEntity completion:^(id result) {
            TYZRespondDataEntity *respond = result;
            if (respond.errcode == respond_success)
            {
                [SVProgressHUD showSuccessWithStatus:@"生成订单成功"];
                OrderDataEntity *orderEnt = [OrderDataEntity new];
                orderEnt.order_id = respond.data;
                _inputFoodEntity.orderId = respond.data;
                orderEnt.shop_id = _inputFoodEntity.shopId;
                if ([_printerList count] != 0)
                {// 档口不为空，就进入下单界面
                    [self placeWithOrder];
                }
                else
                {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }
            else
            {
                [UtilityObject svProgressHUDError:respond viewContrller:self];
            }
        }];
    }
}

- (void)updateStateReload
{
    [self initWithHeaderView];
    [self.baseTableView reloadData];
    [self initWithBottomView];

}


/**
 *  下单到厨房
 */
- (void)placeWithOrder
{
    if ([_printerList count] == 0)
    {
        [SVProgressHUD showInfoWithStatus:@"没有档口信息"];
        return;
    }
    
//    [HCSNetHttp requestWithShopPrinterGetPrintersByConfigType:_selectedOrderSeatEntity.orderDetailEntity.shop_id configType:1 seatName:objectNull(_selectedOrderSeatEntity.seat_number) completion:^(TYZRespondDataEntity *respPrinter) {
    
    [SVProgressHUD showWithStatus:@"加载中"];
    // 加菜下单列表
    [HCSNetHttp requestWithShopOrderWaitPrintFoods:_inputFoodEntity.orderId shopId:_inputFoodEntity.shopId completion:^(TYZRespondDataEntity *respond) {
        if (respond.errcode == respond_success)
        {
            [SVProgressHUD dismiss];
            [self showWithPlaceOrderView:YES foods:respond.data];
        }
        else if (respond.errcode == respond_nodata)
        {
            [SVProgressHUD dismiss];
            // 显示下单视图
            [self showWithPlaceOrderView:YES foods:respond.data];
        }
        else
        {
            [UtilityObject svProgressHUDError:respond viewContrller:self];
        }
    }];
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

// 取消、下单、好的
- (void)clickedWithPlaceOrderView:(id)data
{
    if ([data isEqualToString:@"取消"] || [data isEqualToString:@"好的"])
    {
        [self showWithPlaceOrderView:NO foods:nil];
        
        if (_inputFoodEntity.addType == 1)
        {// 创建订单
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {// 加菜
            [self addOrSubResponse];
        }
        
    }
    else if ([data isEqualToString:@"下单"])
    {
        [SVProgressHUD showWithStatus:@"下单中"];
        [HCSNetHttp requestWithShopOrderFoodToKitchen:_inputFoodEntity.orderId shopId:_inputFoodEntity.shopId printId:_selectedPrinterId completion:^(TYZRespondDataEntity *respond) {
            if (respond.errcode == respond_success)
            {
                [SVProgressHUD showSuccessWithStatus:@"下单成功"];
                [self showWithPlaceOrderView:NO foods:nil];
                
                if (_inputFoodEntity.addType == 1)
                {// 创建订单
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
                else
                {// 加菜
                    [self addOrSubResponse];
                }
            }
            else
            {
                [UtilityObject svProgressHUDError:respond viewContrller:self];
            }
        }];
    }
    /*else if ([data isEqualToString:@"补单"])
    {// ShopMouthDataEntity
        [MCYPushViewController showWithRepairVC:self data:_selectedOrderSeatEntity.orderDetailEntity completion:^(id data) {
            if ([data isEqualToString:@"success"])
            {
                _placeOrderView.hidden = YES;
            }
            else
            {
                _placeOrderView.hidden = NO;
            }
        }];
    }*/
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return EN_DCO_MAX_SECTION;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    switch (section)
    {
        case EN_DCO_SHOPINFO_SECTION:
        {
            count = EN_DCO_SHOPINFO_MAX_ROW;
            if (_inputFoodEntity.type == 2)
            {
                count = count - 1;
            }
        } break;
        case EN_DCO_FOODLIST_SECTION:
        {
            count = [_inputFoodEntity.foodList count];
        } break;
            
        default:
            break;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     EN_DCO_SHOPINFO_SHOPNAME_ROW = 0, ///< 餐厅名称
     EN_DCO_SHOPINFO_ADDRESS_ROW, ///< 餐厅地址
     EN_DCO_SHOPINFO_MOBILE_ROW, ///< 餐厅电话
     EN_DCO_SHOPINFO_RESERVEINFO_ROW, ///< 预订信息
     */
    if (indexPath.section == EN_DCO_SHOPINFO_SECTION)
    {
        if (indexPath.row == EN_DCO_SHOPINFO_SHOPNAME_ROW)
        {// 餐厅名称
            DinersCreateOrderShopNameCell *cell = [DinersCreateOrderShopNameCell cellForTableView:tableView];
            [cell updateCellData:_inputFoodEntity.shopName];
            return cell;
        }
        else if (indexPath.row == EN_DCO_SHOPINFO_ADDRESS_ROW)
        {// 餐厅地址
            DinersCreateOrderAddressMobileCell *cell = [DinersCreateOrderAddressMobileCell cellForTableView:tableView];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell updateCellData:_inputFoodEntity.shopAddress imageName:@"hall_icon_addr"];
            return cell;
        }
        else if (indexPath.row == EN_DCO_SHOPINFO_MOBILE_ROW)
        {// 餐厅电话
            DinersCreateOrderAddressMobileCell *cell = [DinersCreateOrderAddressMobileCell cellForTableView:tableView];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell updateCellData:_inputFoodEntity.shopMobile imageName:@"hall_icon_phone"];
            return cell;
        }
        else if (indexPath.row == EN_DCO_SHOPINFO_RESERVEINFO_ROW && _inputFoodEntity.type == 1)
        {// 预订信息
            DinersCreateOrderInfoViewCell *cell = [DinersCreateOrderInfoViewCell cellForTableView:tableView];
            [cell updateCellData:_inputFoodEntity];
            return cell;
        }
    }
    else if (indexPath.section == EN_DCO_FOODLIST_SECTION)
    {
        DinersCreateOrderFoodViewCell *cell = [DinersCreateOrderFoodViewCell cellForTableView:tableView];
        [cell updateCellData:_inputFoodEntity.foodList[indexPath.row]];
        return cell;
    }
    TYZBaseTableViewCell *cell = [TYZBaseTableViewCell cellForTableView:tableView];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 60.0;
    if (indexPath.section == EN_DCO_SHOPINFO_SECTION)
    {
        if (indexPath.row == EN_DCO_SHOPINFO_SHOPNAME_ROW)
        {// 餐厅名称
            height = kDinersCreateOrderShopNameCellHeight;
        }
        else if (indexPath.row == EN_DCO_SHOPINFO_ADDRESS_ROW)
        {// 餐厅地址
            height = kDinersCreateOrderAddressMobileCellHeight;
        }
        else if (indexPath.row == EN_DCO_SHOPINFO_MOBILE_ROW)
        {// 餐厅电话
            height = kDinersCreateOrderAddressMobileCellHeight;
        }
        else if (indexPath.row == EN_DCO_SHOPINFO_RESERVEINFO_ROW && _inputFoodEntity.type == 1)
        {// 预订信息
            height = kDinersCreateOrderInfoViewCellHeight;
            if (![objectNull(_inputFoodEntity.orderId) isEqualToString:@""])
            {
                height = kDinersCreateOrderInfoViewCellMaxHeight;
            }
        }
    }
    else if (indexPath.section == EN_DCO_FOODLIST_SECTION)
    {
        ShopingCartEntity *ent = _inputFoodEntity.foodList[indexPath.row];
        if ([objectNull(ent.mode) isEqualToString:@""] && [objectNull(ent.taste) isEqualToString:@""] && ent.activityPrice == 0.0)
        {
            height = kDinersCreateOrderFoodViewCellMinHeight;
        }
        else
        {
            height = kDinersCreateOrderFoodViewCellMaxHeight;
        }
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == EN_DCO_SHOPINFO_SECTION)
    {
        if (_inputFoodEntity.orderState != -1)
        {
            return 10.0;
        }
        return 0.001;
    }
    else if (section == EN_DCO_FOODLIST_SECTION)
    {
        return kDinersCreateOrderFoodHeaderViewHeight;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == EN_DCO_FOODLIST_SECTION)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kDinersCreateOrderFoodHeaderViewHeight);
        DinersCreateOrderFoodHeaderView *view = [[DinersCreateOrderFoodHeaderView alloc] initWithFrame:frame];
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == EN_DCO_SHOPINFO_SECTION)
    {
        return 10;
    }
    return 0.001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == EN_DCO_SHOPINFO_SECTION)
    {
        if (indexPath.row == EN_DCO_SHOPINFO_ADDRESS_ROW)
        {// 餐厅地址
            [MCYPushViewController showWithPositionMapVC:self data:_inputFoodEntity.shopAddress completion:nil];
        }
        else if (indexPath.row == EN_DCO_SHOPINFO_MOBILE_ROW)
        {// 餐厅电话
            [MCYPushViewController callWithPhone:self phone:_inputFoodEntity.shopMobile];
        }
    }
}


@end
