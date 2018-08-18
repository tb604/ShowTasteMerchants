//
//  MCYPushViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/12.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MCYPushViewController.h"
#import "UserLoginStateObject.h"
#import "LocalCommon.h"
#import "TYZRespondDataEntity.h"
#import "ShopDetailDataEntity.h"
#import "OrderFoodNumberEntity.h"
#import "ShopListDataEntity.h"
#import "HCSLocationManager.h"
#import "OrderDataEntity.h" // 食客订单详情
#import "RestaurantReservationInputEntity.h"
#import "CTCOrderDetailEntity.h" // 订单详情
//#import "UserLoginViewController.h" // 登录视图控制器
#import "CTCLoginViewController.h" // 登录视图控制器
//#import "UserRegisterViewController.h" // 注册视图控制器
#import "CTCRegistereViewController.h" // 注册视图控制器
#import "RestaurantClassificationViewController.h" // 首页分类(信息板块)
#import "UserForgotPasswordViewController.h" // 找回密码视图控制器
#import "ResetPawwordViewController.h" // 重置密码视图控制器
#import "UserInfoViewController.h" // 用户信息视图控制器
#import "CTCUserInfoViewController.h" // 用户信息视图控制器
#import "UserInfoModifyViewController.h" // 编辑用户资料视图控制器
#import "ModifyUserNameViewController.h" // 修改用户姓名视图控制器
#import "ModifyCommonViewController.h" // 修改信息视图控制器
#import "ModifyPasswordViewController.h" // 修改密码视图控制器
#import "ModifyMobileViewController.h" // 修改手机号码
#import "ShopDetailViewController.h" // 餐厅详情视图控制器
#import "CurrentPositionMapViewController.h" // 在地图上的地址视图控制器
#import "CTCBindCardIdViewController.h" // 绑定身份证试图控制器
#import "CTCNoShopViewController.h" // 开餐厅第零步视图控制器
#import "OpenRestaurantViewController.h" // 开餐厅第一步(选择餐厅类型)视图控制器
#import "OpenRestaurantAddressViewController.h" // 开餐厅第二步，餐厅地址
#import "OpenRestaurantCityViewController.h" // 开餐厅第二步，餐厅城市
#import "OpenRestaurantNameViewController.h" // 开餐厅第三步，餐厅名称
#import "CTCShopQualificationViewController.h" // 餐厅资质视图控制器
#import "OpenRestaurantInfoViewController.h" // 餐厅信息视图控制器
#import "MyRestaurantListViewController.h" // 我的餐厅列表视图控制器
#import "RestaurantIntroEditViewController.h" // 编辑多文本框视图控制器
#import "RestaurantSingleEditViewController.h" // 编辑多文本框视图控制器
#import "RestaurantMallEditViewController.h" // 餐厅的商圈视图控制器
#import "RestaurantAddressEditViewController.h" // 修改餐厅的地址视图控制器
#import "MyRestaurantMenuEditViewController.h" // 餐厅菜单编辑视图控制器
#import "RestaurantAddFoodCategoryViewController.h" // 餐厅添加菜品类别视图控制器
#import "RestaurantAddFoodViewController.h" // 餐厅添加菜品视图控制器
#import "MyRestaurantManagerEditViewController.h" // 餐厅管理编辑视图控制器
#import "ThridPartPayChoiceViewController.h" // 修改第三方支付方式视图控制器
#import "RestaurantEditMainImageViewController.h" // 编辑餐厅组图视图控制器
#import "ChoiceFoodCategoryViewController.h" // 选择菜品类别视图控制器
#import "ShopPrinterChoiceViewController.h" // 选择档口视图控制器
#import "AddFoodPriceViewController.h" // 添加菜品的价格视图控制器
#import "AddFoodRelatedInfoViewController.h" // 添加菜品相关图片信息视图控制器
#import "MyRestaurantPreviewViewController.h" // 显示餐厅详情预览视图控制器
#import "RestaurantReservationViewController.h" // 显示预订餐厅视图控制器
#import "WYXCalendarViewController.h" // 选择日期视图控制器
#import "DinersOrderDetailViewController.h" // 食客订单详情视图控制器
#import "DinersCancelOrderViewController.h" // 食客订单取消视图控制器
//#import "UserReserveCompleteOrderViewController.h" // 食客端预订完成订单详情视图控制器
//#import "UserPlaceEatingViewController.h" // 食客端待下单、就餐中订单详情视图控制
#import "CTCRestaurantReserveOrderViewController.h" // 预定订单视图控制器
#import "UserPlaceEatingMeWantPayViewController.h" // 结算清单视图控制器
#import "UserPayWayViewController.h" // 支付方式视图控制器
#import "UserPaySuccessOrderViewController.h" // 支付成功后，进入的第个视图控制器
#import "UserEvaluationPaySucViewController.h" // 支付成功后，点评视图控制器
#import "DinersRecipeViewController.h" // 食客菜谱视图控制器
#import "EvenDiningViewController.h" // 即时就餐视图控制器
#import "DinersRecipeFoodDetailViewController.h" // 菜谱里面的菜品详情视图控制器
#import "DinersCreateOrderViewController.h" // 食客创建订单视图控制器
#import "MyRestaurantMouthEditViewController.h" // 档口编辑视图控制器
#import "ShopOrderDetailViewController.h" // 餐厅端订单详情视图控制器
#import "DinersSearchViewController.h" // 搜索视图控制器
#import "DinersSearchResultViewController.h" // 搜索结果视图控制器
#import "DinersSearchResultNewViewController.h" // 新搜索结果视图控制器
//#import "DinersRefundOrderDetailViewController.h" // 退款订单详情视图控制器
#import "ShopCommentListViewController.h" // 餐厅评论列表视图控制器
#import "WaitingNoticeOrderViewController.h" // 待处理订单的视图控制器
#import "MyCollectionListViewController.h" // 我的收藏
#import "MyWalletViewController.h" // 我的钱包视图控制器
#import "MyWalletDetailViewController.h" // 我的钱包明细视图控制器
#import "MyWalletThirdPayWayViewController.h" // 我的钱包支付方式的视图控制器
#import "MyWalletTopUpViewController.h" // 我的钱包充值视图控制器
#import "MyWalletWithdrawalViewController.h" // 我的钱包提现视图控制器
#import "MyWalletDetailStreamViewController.h" // 我的钱包流水详情视图控制器

#import "ShopRepairManagerViewController.h" // 补单管理视图控制器
#import "MyRestaurantMenuViewController.h" // 菜单视图控制器
#import "MyJoinPromotionViewController.h" // 加入推广视图控制器
#import "MySettingsViewController.h" // 我的设置视图控制器
#import "MyAboutViewController.h" // 关于视图控制器
#import "MyRestaurantRoomSpaceEditViewController.h" // 空间编辑视图控制器
#import "MyRestaurantRoomSpaceAddViewController.h" // 添加修改空间视图控制器
#import "MyFinanceTodayOrderListViewController.h" // 我的财务，今日订单汇总视图控制器
#import "FinishedOrderDetailViewController.h" // 完成的订单的详情视图控制器
#import "MyFinanceTodayOrderSummaryViewController.h" // 我的财务，今日订单汇总视图控制器
#import "MyFinanceTodayAggregateViewController.h" // 我的财务，日汇总视图控制器
#import "PromotionEarningViewController.h" // 推广收益视图控制器
#import "OMNearShopViewController.h" // 附近餐厅列表视图控制器

#import "CTCRestaurantTakeOrderViewController.h" // 点菜下单视图控制器
//#import "ShopMealingOrderViewController.h" // 餐中订单试图控制器
#import "CTCRestaurantMealingOrderViewController.h" // 餐中订单试图控制器
#import "ShopReservationOrderViewController.h" // 餐前订单试图控制器
//#import "ShopFinishOrderViewController.h" // 历史订单试图控制器
#import "CTCRestaurantHistoryOrderViewController.h" // 历史订单试图控制器
#import "MyRestaurantDataViewController.h" // 餐厅信息视图控制器
#import "MyRestaurantMenuViewController.h" // 餐厅菜单视图控制器
#import "MyRestaurantRoomSpaceViewController.h" // 餐厅空间(餐位)视图控制器
#import "MyRestaurantManagerViewController.h" // 员工管理视图控制器
#import "MyRestaurantMouthViewController.h" // 餐厅档口视图控制器
#import "MyFinanceViewController.h" // 财务、收益视图控制器
#import "CTCRestaurantManagerAddViewController.h" // 添加或编辑员工信息视图控制器
#import "CTCRestaurantManagerPerMissViewController.h" // 权限说明视图控制器
#import "CTCCustomersPayViewController.h" // 食客视图视图控制器
#import "MyRestaurantManagerListViewController.h" // 管理员视图控制器
#import "MyRestaurantAddManagerViewController.h" // 编辑管理员视图控制器
#import "MyRestaurantEditShopViewController.h" // 编辑选中的餐厅列表视图控制器
#import "MyRestaurantManagerInfoViewController.h" // 管理员以及他名下的餐厅列表视图控制器
#import "DeliveryOrdersViewController.h" // 外卖订单视图控制器
#import "DeliverySettingsViewController.h" // 外卖设置视图控制器
#import "DeliveryBusinessHoursViewController.h" // 设置营业时间视图控制器
#import "DeliveryCancelOrderViewController.h" // 外卖商家拒单视图控制器
#import "HCSNetHttp.h"

@interface MCYPushViewController ()

@end

@implementation MCYPushViewController

/**
 *  显示登录视图控制器
 *
 *  @param vc         vc
 *  @param data       传入参数
 *  @param completion block
 */
+ (void)showWithUserLoginVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    CTCLoginViewController *userLoginVC = [[CTCLoginViewController alloc] initWithNibName:nil bundle:nil];
    userLoginVC.userLoginType = [data integerValue];
    userLoginVC.popResultBlock = completion;
    [self showWithBaseVC:vc pushVC:userLoginVC];
}

/**
 *  显示注册视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithUserRegisterVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    CTCRegistereViewController *userLoginVC = [[CTCRegistereViewController alloc] initWithNibName:nil bundle:nil];
    userLoginVC.popResultBlock = completion;
    [self showWithBaseVC:vc pushVC:userLoginVC];
}

/**
 *  显示找回密码视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithUserForgotPswVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    UserForgotPasswordViewController *forgotPswVC = [[UserForgotPasswordViewController alloc] initWithNibName:nil bundle:nil];
    forgotPswVC.popResultBlock = completion;
    [self showWithBaseVC:vc pushVC:forgotPswVC];
}

/**
 *  重置密码视图控制器
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithResetPasswordVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
//    debugMethod();
    ResetPawwordViewController *resetPswVC = [[ResetPawwordViewController alloc] initWithNibName:nil bundle:nil];
    resetPswVC.pswCodeDict = data;
    resetPswVC.popResultBlock = completion;
    [self showWithBaseVC:vc pushVC:resetPswVC];
}


/**
 *  显示首页分类视图控制器
 *
 *  @param vc         <#vc description#>
 *  @param data       <#data description#>
 *  @param completion <#completion description#>
 */
+ (void)showWithRestaurantClassVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    [SVProgressHUD showWithStatus:@"加载中"];
    [HCSNetHttp requestWithShopClassifyConfig:2 completion:^(id result) {
        TYZRespondDataEntity *respond = result;
        if (respond.errcode == respond_success)
        {
            [SVProgressHUD dismiss];
            RestaurantClassificationViewController *restaurantVC = [[RestaurantClassificationViewController alloc] initWithNibName:nil bundle:nil isStylePlain:YES firstShowRefresh:NO];
            restaurantVC.orderMealEntity = data;
            restaurantVC. cuisineEntity = respond.data;
            restaurantVC.popResultBlock = completion;
            [self showWithBaseVC:vc pushVC:restaurantVC];
        }
        else
        {
            [UtilityObject svProgressHUDError:respond viewContrller:vc];
        }
    }];
    
//    [HCSNetHttp requestWithShopShowClas:cEnt.class_id completion:^(id result) {
////        [self getClassifyData:result];
//    }];
    
    

    
     
}

/**
 *  显示用户信息视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithUserInfoVC:(UIViewController *)vc  data:(id)data completion:(void(^)(id data))completion
{
    CTCUserInfoViewController *userInfoVC = [[CTCUserInfoViewController alloc] initWithNibName:nil bundle:nil isStylePlain:NO];
    userInfoVC.popResultBlock = completion;
//    userInfoVC.userInfoEntity = data;
    [self showWithBaseVC:vc pushVC:userInfoVC];
}

/**
 *  显示用户信息编辑视图控制器
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithUserInfoModifyVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    UserInfoModifyViewController *userInfoModifyVC = [[UserInfoModifyViewController alloc] initWithNibName:nil bundle:nil isStylePlain:NO];
    userInfoModifyVC.userInfoEntity = data;
    userInfoModifyVC.popResultBlock = completion;
    [self showWithBaseVC:vc pushVC:userInfoModifyVC];
}

/**
 *  修改用户姓名
 *
 *  @param vc
 *  @param data
 *  @param completion (data ({@"familyName":@"tang", @"lastName":@"bin"}))
 */
+ (void)showWithModifyUserNameVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    ModifyUserNameViewController *modifyNameVC = [[ModifyUserNameViewController alloc] initWithNibName:nil bundle:nil];
    modifyNameVC.popResultBlock = completion;
    [self showWithBaseVC:vc pushVC:modifyNameVC];
}

/**
 *  修改信息
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithModifyInfoVC:(UIViewController *)vc data:(NSDictionary *)param completion:(void(^)(id data))completion
{
    NSString *title = param[@"title"];
    id data = param[@"data"];
    NSString *placeholder = param[@"placeholder"];
    BOOL singleRow = [param[@"singleRow"] boolValue];
    BOOL isNumber = [param[@"isNumber"] boolValue];
    
    ModifyCommonViewController *modifyVC = [[ModifyCommonViewController alloc] initWithNibName:nil bundle:nil];
    modifyVC.popResultBlock = completion;
    modifyVC.isSingleRow = singleRow;
    modifyVC.placeholder = placeholder;
    modifyVC.title = title;
    modifyVC.data = data;
    modifyVC.isNumber = isNumber;
    [self showWithBaseVC:vc pushVC:modifyVC];
}


/**
 *  修改密码视图控制器
 *
 *  @param vc         <#vc description#>
 *  @param data       <#data description#>
 *  @param completion <#completion description#>
 */
+ (void)showWithModifyPswVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    ModifyPasswordViewController *modifyPswVC = [[ModifyPasswordViewController alloc] initWithNibName:nil bundle:nil];
    modifyPswVC.popResultBlock = completion;
    modifyPswVC.userInfoEntity = data;
    [self showWithBaseVC:vc pushVC:modifyPswVC];
}

/**
 *  显示修改手机视图控制器
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithModifyMobileVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    ModifyMobileViewController *modifyMobileVC = [[ModifyMobileViewController alloc] initWithNibName:nil bundle:nil];
    modifyMobileVC.updateEntity = data;
    modifyMobileVC.popResultBlock = completion;
    [self showWithBaseVC:vc pushVC:modifyMobileVC];
}

/**
 *  显示餐厅详情视图控制器
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithShopDetailVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    ShopDetailViewController *shopDetailVC = [[ShopDetailViewController alloc] initWithNibName:nil bundle:nil isStylePlain:YES firstShowRefresh:NO];
    shopDetailVC.mealEntity = data;
    shopDetailVC.popResultBlock = completion;
    [self showWithBaseVC:vc pushVC:shopDetailVC];
}

/**
 *  根据地址显示在地图上的位置
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithPositionMapVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    CurrentPositionMapViewController *mapVC = [[CurrentPositionMapViewController alloc] initWithNibName:nil bundle:nil];
    mapVC.address = data;
    mapVC.popResultBlock = completion;
    [self showWithBaseVC:vc pushVC:mapVC];
}

/**
 *  绑定身份证视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithBindCardIdVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    CTCBindCardIdViewController *bindCardIdVC = [[CTCBindCardIdViewController alloc] initWithNibName:nil bundle:nil];
    bindCardIdVC.popResultBlock = completion;
    [self showWithBaseVC:vc pushVC:bindCardIdVC];
}
//CTCBindCardIdViewController

/**
 *  开餐厅第零步，检测是否有餐厅
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithOpenRestaurantZeroVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    CTCNoShopViewController *bindCardIdVC = [[CTCNoShopViewController alloc] initWithNibName:nil bundle:nil];
    bindCardIdVC.popResultBlock = completion;
    [self showWithBaseVC:vc pushVC:bindCardIdVC];
}
// CTCNoShopViewController

/**
 *  开餐厅第一步
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithOpenRestaurantFirstVC:(UIViewController *)vc data:(id)data inputEnt:(id)inputEnt completion:(void(^)(id data))completion
{
    [SVProgressHUD showWithStatus:@"加载中"];
    // 2获取菜系数据
    [HCSNetHttp requestWithShopClassifyConfig:2 completion:^(id result) {
        TYZRespondDataEntity *respond = result;
        if (respond.errcode == respond_success)
        {
            [SVProgressHUD dismiss];
            OpenRestaurantViewController *openRestaurantVC = [[OpenRestaurantViewController alloc] initWithNibName:nil bundle:nil];
            openRestaurantVC.restaurantEntity = respond.data;
            openRestaurantVC.inputEntity = inputEnt;
            openRestaurantVC.popResultBlock = completion;
            [self showWithBaseVC:vc pushVC:openRestaurantVC];
        }
        else
        {
            [UtilityObject svProgressHUDError:respond viewContrller:vc];
        }
    }];
}

/**
 *  开餐厅第二步，餐厅地址
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithOpenRestaurantAddressVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    OpenRestaurantAddressViewController *addressVC = [[OpenRestaurantAddressViewController alloc] initWithNibName:nil bundle:nil];
    addressVC.inputEntity = data;
    addressVC.popResultBlock = completion;
    [self showWithBaseVC:vc pushVC:addressVC];
}

/**
 *  开餐厅第二步，餐厅城市
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithOpenRestaurantCityVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
//    debugMethod();
    OpenRestaurantCityViewController *cityVC = [[OpenRestaurantCityViewController alloc] initWithNibName:nil bundle:nil isStylePlain:YES firstShowRefresh:NO];
    cityVC.inputEntity = data;
    cityVC.popResultBlock = completion;
    [self showWithBaseVC:vc pushVC:cityVC];
}


/**
 *  开餐厅第三部，餐厅名称
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithOpenRestaurantNameVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    OpenRestaurantNameViewController *restaurantNameVC = [[OpenRestaurantNameViewController alloc] initWithNibName:nil bundle:nil];
    restaurantNameVC.inputEntity = data;
    restaurantNameVC.popResultBlock = completion;
    [self showWithBaseVC:vc pushVC:restaurantNameVC];
}

/**
 *  餐厅资质
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithShopQualificationVC:(UIViewController *)vc data:(id)data shopId:(NSInteger)shopId completion:(void(^)(id data))completion
{
    if (!data)
    {
        debugLog(@"data is nil");
        [SVProgressHUD showWithStatus:@"加载中"];
        NSInteger curShopId = (shopId == 0?[UserLoginStateObject getCurrentShopId]:shopId);
        debugLog(@"shopId=%d", (int)curShopId);
        [HCSNetHttp requestWithShopCertificate:curShopId completion:^(TYZRespondDataEntity *result) {
            if (result.errcode == respond_success)
            {
                debugLog(@"有餐厅资质");
                [SVProgressHUD dismiss];
                CTCShopQualificationViewController *openResInfoVC = [[CTCShopQualificationViewController alloc] initWithNibName:nil bundle:nil isStylePlain:YES];
                openResInfoVC.shopId = curShopId;
                openResInfoVC.licenseEntity = result.data;
                openResInfoVC.popResultBlock = completion;
                [self showWithBaseVC:vc pushVC:openResInfoVC];
            }
            else if (result.errcode == 1)
            {// 没有餐厅资质
                debugLog(@"没有餐厅资质");
                [SVProgressHUD dismiss];
                CTCShopQualificationViewController *openResInfoVC = [[CTCShopQualificationViewController alloc] initWithNibName:nil bundle:nil isStylePlain:YES];
                openResInfoVC.shopId = curShopId;
                openResInfoVC.licenseEntity = nil;
                openResInfoVC.popResultBlock = completion;
                [self showWithBaseVC:vc pushVC:openResInfoVC];
            }
            else
            {
                [UtilityObject svProgressHUDError:result viewContrller:vc];
            }
        }];
    }
    else
    {
        debugLog(@"data is not nil");
        CTCShopQualificationViewController *openResInfoVC = [[CTCShopQualificationViewController alloc] initWithNibName:nil bundle:nil isStylePlain:YES];
        if ([data isKindOfClass:[NSString class]] && [data isEqualToString:@"nodata"])
        {// 没有餐厅资质
            debugLog(@"没有餐厅资质");
            openResInfoVC.licenseEntity = nil;
        }
        else
        {
            debugLog(@"有餐厅资质");
            openResInfoVC.licenseEntity = data;
        }
        openResInfoVC.popResultBlock = completion;
        [self showWithBaseVC:vc pushVC:openResInfoVC];
    }
}
// CTCShopQualificationViewController

/**
 *  餐厅信息编辑视图
 *
 *  @param vc vc
 *  @param data daa
 *  @param completion block
 */
+ (void)showWithOpenRestaurantInfoVC:(UIViewController *)vc inputData:(id)inputData data:(id)data completion:(void (^)(id))completion
{
    OpenRestaurantInfoViewController *openResInfoVC = [[OpenRestaurantInfoViewController alloc] initWithNibName:nil bundle:nil isStylePlain:NO firstShowRefresh:NO];
    openResInfoVC.inputEntity = inputData;
    openResInfoVC.popResultBlock = completion;
    [self showWithBaseVC:vc pushVC:openResInfoVC];
}

/**
 *  开餐厅的列表视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithOpenRestaurantListVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    [HCSNetHttp requestWithShopGetShopListbyUserId:[UserLoginStateObject getUserId] sellerId:[UserLoginStateObject getUserInfo].seller_id completion:^(TYZRespondDataEntity *result) {
        if (result.errcode == respond_success)
        {
            MyRestaurantListViewController *restaurantListVC = [[MyRestaurantListViewController alloc] initWithNibName:nil bundle:nil isStylePlain:YES firstShowRefresh:NO];
            restaurantListVC.shopList = result.data;
            if ([data isKindOfClass:[NSNumber class]])
            {
                restaurantListVC.comeType = [data integerValue];
            }
            restaurantListVC.popResultBlock = completion;
            [self showWithBaseVC:vc pushVC:restaurantListVC];
        }
        else if (result.errcode == respond_nodata)
        {// 没有餐厅
            [MCYPushViewController showWithOpenRestaurantZeroVC:vc data:nil completion:nil];
        }
        else
        {
            [UtilityObject svProgressHUDError:result viewContrller:vc];
        }
    }];
}

/**
 *  编辑多文本信息视图控制器
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithRestaurantIntroEditVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
//    NSDictionary *param = @{@"title":@"餐厅介绍", @"data":objectNull(_detailEntity.details.intro), @"placeholder":@"请输入餐厅介绍", @"fontNum":@(0)};
    RestaurantIntroEditViewController *introEditVC = [[RestaurantIntroEditViewController alloc] initWithNibName:nil bundle:nil];
    introEditVC.title = data[@"title"];
    introEditVC.content = data[@"data"];
    introEditVC.placeholder = data[@"placeholder"];
    introEditVC.fontNumber = [data[@"fontNum"] integerValue];
    introEditVC.popResultBlock = completion;
    [self showWithBaseVC:vc pushVC:introEditVC];
}

/**
 *  编辑单文本信息视图控制器
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithRestaurantSingleEditVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
//    NSDictionary *param = @{@"title":@"昵称", @"data":objectNull(_userInfo.vtgUser.nickName), @"placeholder":@"请输入昵称", @"isNumber":@(NO)};
    RestaurantSingleEditViewController *singleEditVC = [[RestaurantSingleEditViewController alloc] initWithNibName:nil bundle:nil];
    singleEditVC.title = data[@"title"];
    singleEditVC.content = data[@"data"];
    singleEditVC.placeholder = data[@"placeholder"];
    singleEditVC.isNumber = [data[@"isNumber"] boolValue];
    singleEditVC.popResultBlock = completion;
    [self showWithBaseVC:vc pushVC:singleEditVC];
}

/**
 *  修改餐厅商圈的视图控制器
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithRestaurantMallEditVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    RestaurantMallEditViewController *mallEditVC = [[RestaurantMallEditViewController alloc] initWithNibName:nil bundle:nil isStylePlain:YES firstShowRefresh:NO];
    mallEditVC.cityId = [data integerValue];
    mallEditVC.popResultBlock = completion;
    [self showWithBaseVC:vc pushVC:mallEditVC];
}

/**
 *  修改餐厅地址视图控制器
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithRestaurantAddressEditVC:(UIViewController *)vc data:(id)data completion:(void(^)(NSString *name, NSString *address, CLLocationCoordinate2D coordinate))completion
{
    RestaurantAddressEditViewController *addressVC = [[RestaurantAddressEditViewController alloc] initWithNibName:nil bundle:nil];
    addressVC.cityName = data;
    addressVC.ChoiceLocationInfoBlock = completion;
    [self showWithBaseVC:vc pushVC:addressVC];
}

/**
 *  编辑餐厅菜单视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithResaurantMenuEditVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    if (data && [data isKindOfClass:[NSNumber class]])
    {
        [SVProgressHUD showWithStatus:@"加载中"];
        [HCSNetHttp requestWithFoodCategoryGetFoodCategoryDetails:[data integerValue] completion:^(TYZRespondDataEntity *respond) {
            if (respond.errcode == respond_success || respond.errcode == respond_nodata)
            {
                [SVProgressHUD dismiss];
                MyRestaurantMenuEditViewController *menuVC = [[MyRestaurantMenuEditViewController alloc] initWithNibName:nil bundle:nil];
                menuVC.menuList = [NSMutableArray arrayWithArray:respond.data];
                menuVC.popResultBlock = completion;
                [menuVC initWithBackButton];
                menuVC.title = @"菜品";
                [self showWithBaseVC:vc pushVC:menuVC];
            }
            else
            {
                [UtilityObject svProgressHUDError:respond viewContrller:vc];
            }
        }];
    }
    else
    {
        MyRestaurantMenuEditViewController *menuEditVC = [[MyRestaurantMenuEditViewController alloc] initWithNibName:nil bundle:nil];
        menuEditVC.menuList = [NSMutableArray array];
        NSArray *array = data;
    //    debugLog(@"array.count=%d", (int)array.count);
        [menuEditVC.menuList addObjectsFromArray:array];
        menuEditVC.popResultBlock = completion;
        [self showWithBaseVC:vc pushVC:menuEditVC];
    }
}

/**
 *  显示添加餐厅菜品类别视图控制器
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithRestaurantAddFoodCategoryVC:(UIViewController *)vc  data:(id)data completion:(void(^)(id data))completion
{
    RestaurantAddFoodCategoryViewController *categoryVC = [[RestaurantAddFoodCategoryViewController alloc] initWithNibName:nil bundle:nil];
    categoryVC.categoryEntity = data;
    categoryVC.popResultBlock = completion;
    [self showWithBaseVC:vc pushVC:categoryVC];
}

/**
 *  显示添加餐厅添加菜品的视图控制器
 *
 *  @param vc
 *  @param data
 *  @param type 1表示添加；2表示编辑
 *  @param completion
 */
+ (void)showWithRestaurantAddFoodVC:(UIViewController *)vc data:(id)data type:(NSInteger)type foodEntity:(id)foodEntity completion:(void(^)(id data))completion
{
    ShopFoodDataEntity *foodEnt = foodEntity;
    RestaurantAddFoodViewController *addFoodVC = [[RestaurantAddFoodViewController alloc] initWithNibName:nil bundle:nil isStylePlain:NO firstShowRefresh:NO];
    addFoodVC.type = type;
    addFoodVC.menuList = [NSMutableArray array];
    addFoodVC.mouthList = [NSMutableArray array];
//    addFoodVC.foodEntity = foodEntity;
    [addFoodVC.menuList addObjectsFromArray:data];
    addFoodVC.popResultBlock = completion;
    if (type == 1 || type == 2)
    {// type 1表示添加；2表示编辑
        [SVProgressHUD showWithStatus:@"加载中"];
        if (type == 1)
        {// 添加
            [HCSNetHttp requestWithShopPrinterGetPrinters:[UserLoginStateObject getCurrentShopId] completion:^(id result) {
                TYZRespondDataEntity *resp = (TYZRespondDataEntity *)result;
                [SVProgressHUD dismiss];
                [addFoodVC.mouthList addObjectsFromArray:resp.data];
                [self showWithBaseVC:vc pushVC:addFoodVC];
            }];
        }
        else
        {// 编辑
            // 获取当前菜品数据
            [HCSNetHttp requestWithFood:foodEnt.id completion:^(id result) {
                TYZRespondDataEntity *respond = (TYZRespondDataEntity *)result;
                if (respond.errcode == respond_success)
                {
                    
                    // FONTSIZE_13
                    ShopFoodDataEntity *newFoodEnt = respond.data;
                    for (ShopFoodImageEntity *imgEnt in newFoodEnt.content)
                    {
                        imgEnt.descHeight = [UtilityObject mulFontHeights:objectNull(imgEnt.desc) font:FONTSIZE_13 maxWidth:[[UIScreen mainScreen] screenWidth] - 30];
                    }
                    
                    addFoodVC.foodEntity = respond.data;
                    [HCSNetHttp requestWithShopPrinterGetPrinters:[UserLoginStateObject getCurrentShopId] completion:^(id result) {
                        TYZRespondDataEntity *resp = (TYZRespondDataEntity *)result;
                        [SVProgressHUD dismiss];
                        [addFoodVC.mouthList addObjectsFromArray:resp.data];
                        [self showWithBaseVC:vc pushVC:addFoodVC];
                    }];
                }
                else
                {
                    [UtilityObject svProgressHUDError:respond viewContrller:vc];
                }
            }];
        }
    }
    else
    {
        [self showWithBaseVC:vc pushVC:addFoodVC];
    }
}

/**
 *  显示餐厅管理编辑视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithRestaurantManagerEditVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
//    [SVProgressHUD showWithStatus:@"加载中"];
    
    
    [SVProgressHUD showWithStatus:@"加载中"];
    NSInteger shopId = [UserLoginStateObject getCurrentShopId];
    //    debugLog(@"shopId=%d", (int)shopId);
    [HCSNetHttp requestWithUserGetEmployeeList:shopId completion:^(TYZRespondDataEntity *empRep) {
//        TYZRespondDataEntity *respond = result;
        if (empRep.errcode == respond_success || empRep.errcode == respond_nodata)
        {
            [HCSNetHttp requestWithUserGetTitleAndRoleConfigs:^(TYZRespondDataEntity *result) {
                if (result.errcode == respond_success)
                {
                    [SVProgressHUD dismiss];
                    MyRestaurantManagerEditViewController *managerEditVC = [[MyRestaurantManagerEditViewController alloc] initWithNibName:nil bundle:nil isStylePlain:YES firstShowRefresh:NO];
                    managerEditVC.list = empRep.data;
                    managerEditVC.postionAuthEntity = result.data;
                    managerEditVC.popResultBlock = completion;
                    [self showWithBaseVC:vc pushVC:managerEditVC];
                }
                else
                {
                    [UtilityObject svProgressHUDError:result viewContrller:vc];
                }
            }];
            
            
//            [SVProgressHUD dismiss];
//            MyRestaurantManagerViewController *managerVC = [[MyRestaurantManagerViewController alloc] initWithNibName:nil bundle:nil isStylePlain:YES firstShowRefresh:NO];
//            managerVC.empList = respond.data;
//            managerVC.popResultBlock = completion;
//            [self showWithBaseVC:vc pushVC:managerVC];
        }
        else
        {
            [UtilityObject svProgressHUDError:empRep viewContrller:vc];
        }
    }];
    
    
    
    
}

/**
 *  选择第三方支付方式视图控制器
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithPartPayChoiceVC:(UIViewController *)vc  data:(id)data completion:(void(^)(id data))completion
{
    ThridPartPayChoiceViewController *payChoiceVC = [[ThridPartPayChoiceViewController alloc] initWithNibName:nil bundle:nil];
    payChoiceVC.payEntity = data;
    payChoiceVC.popResultBlock = completion;
    [self showWithBaseVC:vc pushVC:payChoiceVC];
}


/**
 *  显示餐厅组图编辑视图控制器
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithRestaurantEditMainImageVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    RestaurantEditMainImageViewController *editImageVC = [[RestaurantEditMainImageViewController alloc] initWithNibName:nil bundle:nil isStylePlain:NO];
    editImageVC.detailEntity = data;
    editImageVC.popResultBlock = completion;
    [self showWithBaseVC:vc pushVC:editImageVC];
}

/**
 *  显示，选择菜品类别的视图控制器
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithChoiceFoodCategoryVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    ChoiceFoodCategoryViewController *choiceCategoryVC = [[ChoiceFoodCategoryViewController alloc] initWithNibName:nil bundle:nil isStylePlain:YES];
    choiceCategoryVC.categoryList = [NSMutableArray array];
    [choiceCategoryVC.categoryList addObjectsFromArray:data];
    choiceCategoryVC.popResultBlock = completion;
    [self showWithBaseVC:vc pushVC:choiceCategoryVC];
}

/**
 *  显示，选择档口视图控制器
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithChoicePrinterVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    ShopPrinterChoiceViewController *choicePrinterVC = [[ShopPrinterChoiceViewController alloc] initWithNibName:nil bundle:nil isStylePlain:YES];
    choicePrinterVC.shopPrintList = [NSMutableArray array];
    [choicePrinterVC.shopPrintList addObjectsFromArray:data];
    choicePrinterVC.popResultBlock = completion;
    [self showWithBaseVC:vc pushVC:choicePrinterVC];
}

/**
 *  添加价格和单位
 *
 *  @param vc
 *  @param price      价格
 *  @param uint       单位
 *  @param completion
 */
+ (void)showWithAddFoodPriceVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    [SVProgressHUD showWithStatus:@"加载中"];
    [HCSNetHttp requestWithFoodUnit:^(id result) {
        TYZRespondDataEntity *respond = result;
        if (respond.errcode == respond_success)
        {
//            NSDictionary *param = @{@"title":@"价格", @"data":str, @"unit":objectNull(_foodEntity.unit), @"placeholder":@"请输入价格"};
            [SVProgressHUD dismiss];
            AddFoodPriceViewController *addPriceVC = [[AddFoodPriceViewController alloc] initWithNibName:nil bundle:nil];
            addPriceVC.title = data[@"title"];
            addPriceVC.content = data[@"data"];
            addPriceVC.uint = data[@"unit"];
            addPriceVC.placeholder = data[@"placeholder"];
            addPriceVC.popResultBlock = completion;
            addPriceVC.uintList = respond.data;
            [self showWithBaseVC:vc pushVC:addPriceVC];
        }
        else
        {
            [UtilityObject svProgressHUDError:respond viewContrller:vc];
        }
    }];
}

/**
 *  添加菜品相关图片信息视图控制器
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithAddFoodRelatedInfoVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    AddFoodRelatedInfoViewController *addRelatedImageVC = [[AddFoodRelatedInfoViewController alloc] initWithNibName:nil bundle:nil];
    addRelatedImageVC.foodImageEntity = data;
    addRelatedImageVC.popResultBlock = completion;
    [self showWithBaseVC:vc pushVC:addRelatedImageVC];
}

/**
 *  显示餐厅详情预览视图控制器
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithRestaurantPreviewVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    [SVProgressHUD showWithStatus:@"加载中"];
    [HCSNetHttp requestWithShop:[UserLoginStateObject getCurrentShopId] completion:^(id result) {
        TYZRespondDataEntity *respond = result;
        if (respond.errcode == respond_success)
        {
            ShopDetailDataEntity *shopDetailEnt = respond.data;
            shopDetailEnt.details.sloganHeight = [UtilityObject mulFontHeights:objectNull(shopDetailEnt.details.slogan) font:FONTSIZE_15 maxWidth:[[UIScreen mainScreen] screenWidth] - 30];
            // 餐厅简介
            shopDetailEnt.details.introHeight = [UtilityObject mulFontHeights:objectNull(shopDetailEnt.details.intro) font:FONTSIZE_12 maxWidth:[[UIScreen mainScreen] screenWidth] - 30];
            
            // 厨师简介
            shopDetailEnt.topchef.introHeight = [UtilityObject mulFontHeights:objectNull(shopDetailEnt.topchef.intro) font:FONTSIZE_12 maxWidth:[[UIScreen mainScreen] screenWidth] - 30];
            NSInteger state = shopDetailEnt.details.state;
//            debugLog(@"detail=%@", [shopDetailEnt.details modelToJSONString]);
//            debugLog(@"state=%d", (int)state);
            shopDetailEnt.details.shopId = [UserLoginStateObject getCurrentShopId];
            if (state == EN_SHOP_NOTAUDIT_STATE || state == EN_SHOP_WAITINGAUDIT_STATE)
            {// 未审核、待审核
                [SVProgressHUD showErrorWithStatus:@"餐厅待审核中"];
                return;
            }
            [SVProgressHUD dismiss];
            MyRestaurantPreviewViewController *previewVC = [[MyRestaurantPreviewViewController alloc] initWithNibName:nil bundle:nil isStylePlain:YES firstShowRefresh:NO];
            previewVC.shopDetailEntity = shopDetailEnt;
            previewVC.popResultBlock = completion;
            [self showWithBaseVC:vc pushVC:previewVC];
        }
        else
        {
            [UtilityObject svProgressHUDError:respond viewContrller:nil];
        }
    }];
}
// MyRestaurantPreviewViewController

#pragma mark 食客端
/**
 *  显示预订餐厅视图控制器
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithRestaurantReservationVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    [SVProgressHUD showWithStatus:@"加载中"];
    RestaurantReservationInputEntity *ent = data;
    [HCSNetHttp requestWithShopSeatSetting:ent.shopId completion:^(id result) {
        TYZRespondDataEntity *respond = result;
        if (respond.errcode == respond_success)
        {
            [SVProgressHUD dismiss];
            
            RestaurantReservationViewController *shopResVC = [[RestaurantReservationViewController alloc] initWithNibName:nil bundle:nil isStylePlain:YES];
            shopResVC.inputEntity = data;
            shopResVC.seatLocList = respond.data;
            shopResVC.popResultBlock = completion;
            [self showWithBaseVC:vc pushVC:shopResVC];
        }
        else
        {
            [UtilityObject svProgressHUDError:respond viewContrller:vc];
        }
    }];
}

/**
 *  显示选择日期视图控制器
 *
 *  @param vc        vc
 *  @param days      选择的天数
 *  @param title     标题
 *  @param startDate 开始日期
 */
+ (void)showWithCalendarVC:(UIViewController *)vc days:(NSInteger)days title:(NSString *)title startDate:(NSString *)startDate multChoice:(BOOL)multChoice completion:(void (^)(NSArray *))completion
{
    WYXCalendarViewController *dateVC = [[WYXCalendarViewController alloc] initWithNibName:nil bundle:nil day:days selectDate:startDate multChoice:multChoice];
    dateVC.title = title;
    dateVC.calendarBlock = completion;
    [self showWithBaseVC:vc pushVC:dateVC];
}


/*
 NSMutableDictionary *categoryDict = [NSMutableDictionary new];
 NSInteger num = 0;
 NSInteger totalNum = 0;
 CGFloat totalPrice = 0;
 for (ShopingCartEntity *ent in _inputFoodEntity.foodList)
 {
 totalNum += ent.number;
 totalPrice = (ent.price * ent.number);
 if ([[categoryDict allKeys] containsObject:objectNull(ent.categoryName)])
 {
 num = [categoryDict[ent.categoryName] integerValue];
 num += ent.number;
 }
 else
 {
 num = ent.number;
 }
 categoryDict[objectNull(ent.categoryName)] = @(num);
 }
 NSArray *keys = [categoryDict allKeys];
 NSMutableString *mutStr = [NSMutableString new];
 for (NSInteger i=0; i<keys.count; i++)
 {
 NSString *key = keys[i];
 if (i == 0)
 {
 [mutStr appendFormat:@"%@%@道", key, categoryDict[key]];
 }
 else
 {
 [mutStr appendFormat:@" / %@%@道", key, categoryDict[key]];
 }
 }
 */

/**
 *  食客的订单详情视图控制器
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithDinersOrderDetailVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    [SVProgressHUD showWithStatus:@"加载中"];
    OrderDataEntity *orderEnt = data;
    [HCSNetHttp requestWithOrderShowWholeOrderTwo:orderEnt.order_id shopId:orderEnt.shop_id completion:^(id result) {
        TYZRespondDataEntity *respond = result;
        if (respond.errcode == respond_success)
        {
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
//                debugLog(@"--name=%@; number=%d", foodEnt.food_name, (int)foodEnt.allNumber);
                num += foodEnt.number;
            }
            
            /*
             number=2
             number=1
             number=1
             number=1
             number=3
             number=1
             number=2
             number=1
             number=1
             number=2
             number=1
             2016-08-31 11:11:07.949 ChefDating[1720:957885] number=1
             2016-08-31 11:11:07.950 ChefDating[1720:957885] number=1
             2016-08-31 11:11:07.950 ChefDating[1720:957885] number=1
             2016-08-31 11:11:07.950 ChefDating[1720:957885] number=1
             2016-08-31 11:11:07.951 ChefDating[1720:957885] number=1
             2016-08-31 11:11:07.951 ChefDating[1720:957885] number=1
             2016-08-31 11:11:07.951 ChefDating[1720:957885] number=1
             
             */
            
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
            [SVProgressHUD dismiss];
            DinersOrderDetailViewController *orderDetailVC = [[DinersOrderDetailViewController alloc] initWithNibName:nil bundle:nil isStylePlain:NO firstShowRefresh:NO];
            orderDetailVC.isFirst = YES;
            orderDetailVC.orderDetailEntity = respond.data;
            orderDetailVC.popResultBlock = completion;
            [self showWithBaseVC:vc pushVC:orderDetailVC];
        }
        else
        {
            [UtilityObject svProgressHUDError:respond viewContrller:vc];
        }
    }];
}

/**
 *  餐厅端订单详情视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithShopOrderDetailVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    [SVProgressHUD showWithStatus:@"加载中"];
    OrderDataEntity *orderEnt = data;
    
    [HCSNetHttp requestWithShopOrderDetail:orderEnt.order_id shopId:orderEnt.shop_id completion:^(TYZRespondDataEntity *respond) {
        if (respond.errcode == respond_success)
        {
            NSInteger num = 0;
            NSMutableDictionary *categoryDict = [NSMutableDictionary new];
            // CTCOrderDetailEntity
            // OrderDetailDataEntity
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
            
            [HCSNetHttp requestWithShopPrinter:orderEnt.shop_id completion:^(id result) {
                TYZRespondDataEntity *printerResp = result;
                if (printerResp.errcode == respond_success || printerResp.errcode == respond_nodata)
                {
                    [HCSNetHttp requestWithShopSeatSetting:orderEnt.shop_id completion:^(id result) {
                        TYZRespondDataEntity *sRespond = result;
                        if (sRespond.errcode == respond_success)
                        {
                            [SVProgressHUD dismiss];
                            
                            AppDelegate *app = [UtilityObject appDelegate];
                            [app hiddenWithTipView:YES isTop:NO];
                            
                            ShopOrderDetailViewController *orderDetailVC = [[ShopOrderDetailViewController alloc] initWithNibName:nil bundle:nil isStylePlain:NO firstShowRefresh:NO];
                            orderDetailVC.seatLocList = sRespond.data;
                            orderDetailVC.printerList = printerResp.data;
                            orderDetailVC.orderDetailEntity = respond.data;
                            orderDetailVC.popResultBlock = completion;
                            [self showWithBaseVC:vc pushVC:orderDetailVC];
                        }
                        else
                        {
                            [UtilityObject svProgressHUDError:respond viewContrller:vc];
                        }
                    }];
                }
                else
                {
                    [UtilityObject svProgressHUDError:printerResp viewContrller:vc];
                }
            }];
        }
        else
        {
            [UtilityObject svProgressHUDError:respond viewContrller:vc];
        }
    }];
    
    return;
    [HCSNetHttp requestWithOrderShowWholeOrderTwo:orderEnt.order_id shopId:orderEnt.shop_id completion:^(id result) {
        TYZRespondDataEntity *respond = result;
        if (respond.errcode == respond_success)
        {
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
            
            [HCSNetHttp requestWithShopPrinter:orderEnt.shop_id completion:^(id result) {
                TYZRespondDataEntity *printerResp = result;
                if (printerResp.errcode == respond_success)
                {
                    [HCSNetHttp requestWithShopSeatSetting:orderEnt.shop_id completion:^(id result) {
                        TYZRespondDataEntity *sRespond = result;
                        if (sRespond.errcode == respond_success)
                        {
                            [SVProgressHUD dismiss];
                            
                            AppDelegate *app = [UtilityObject appDelegate];
                            [app hiddenWithTipView:YES isTop:NO];
                            
                            ShopOrderDetailViewController *orderDetailVC = [[ShopOrderDetailViewController alloc] initWithNibName:nil bundle:nil isStylePlain:NO firstShowRefresh:NO];
                            orderDetailVC.seatLocList = sRespond.data;
                            orderDetailVC.printerList = printerResp.data;
                            orderDetailVC.orderDetailEntity = respond.data;
                            orderDetailVC.popResultBlock = completion;
                            [self showWithBaseVC:vc pushVC:orderDetailVC];
                        }
                        else
                        {
                            [UtilityObject svProgressHUDError:respond viewContrller:vc];
                        }
                    }];
                }
                else
                {
                    [UtilityObject svProgressHUDError:printerResp viewContrller:vc];
                }
            }];
        }
        else
        {
            [UtilityObject svProgressHUDError:respond viewContrller:vc];
        }
    }];
}


/**
 *  食客订单取消视图控制器
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithDinersCancelOrderVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    [SVProgressHUD showWithStatus:@"加载中"];
    [HCSNetHttp requestWithShopOrderCancelReasons:^(id result) {
        TYZRespondDataEntity *respond = result;
        if (respond.errcode == respond_success)
        {
            [SVProgressHUD dismiss];
            DinersCancelOrderViewController *cancelOrderVC = [[DinersCancelOrderViewController alloc] initWithNibName:nil bundle:nil isStylePlain:YES];
            cancelOrderVC.reasonList = respond.data;
            cancelOrderVC.orderDetailEntity = data;
            cancelOrderVC.popResultBlock = completion;
            [self showWithBaseVC:vc pushVC:cancelOrderVC];
        }
        else
        {
            [UtilityObject svProgressHUDError:respond viewContrller:vc];
        }
    }];
}

/**
 *  食客端预订完成订单详情视图控制器
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
/*+ (void)showWithReserveCompleteOrderVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
//    OrderDataEntity *orderEnt = data;
//    debugLog(@"orderEnt=%@", [orderEnt modelToJSONString]);
    UserReserveCompleteOrderViewController *rcOrderVC = [[UserReserveCompleteOrderViewController alloc] initWithNibName:nil bundle:nil isStylePlain:YES];
    rcOrderVC.popResultBlock = completion;
    [self showWithBaseVC:vc pushVC:rcOrderVC];
}*/



/**
 *  就餐完，结算清单
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithWantPayVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    OrderDetailDataEntity *orderDetail = data;
    UserPlaceEatingMeWantPayViewController *orderVC = [[UserPlaceEatingMeWantPayViewController alloc] initWithNibName:nil bundle:nil isStylePlain:NO];
    orderVC.orderDetailEntity = orderDetail;
    orderVC.popResultBlock = completion;
    [self showWithBaseVC:vc pushVC:orderVC];
}

/**
 *  显示支付方式视图控制器
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithPayWayVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    UserPayWayViewController *payWayVC = [[UserPayWayViewController alloc] initWithNibName:nil bundle:nil isStylePlain:NO];
    payWayVC.orderDetailEntity = data;
    payWayVC.popResultBlock = completion;
    [self showWithBaseVC:vc pushVC:payWayVC];
}

/**
 *  支付成功后，进入的订单视图控制器
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithPaySuccessOrderVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    UserPaySuccessOrderViewController *paySuccessVC = [[UserPaySuccessOrderViewController alloc] initWithNibName:nil bundle:nil isStylePlain:YES];
    paySuccessVC.orderDetailEnt = data;
    paySuccessVC.popResultBlock = completion;
    [self showWithBaseVC:vc pushVC:paySuccessVC];
}

/**
 *  支付完成后，点击进入评论视图控制器
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithEvaluationPaySucVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    [SVProgressHUD showWithStatus:@"加载中"];
    [HCSNetHttp requestWithShopClassifyConfig:4 completion:^(id result) {
        TYZRespondDataEntity *respond = result;
        if (respond.errcode == respond_success)
        {
            [SVProgressHUD dismiss];
//            NSArray *list = respond.data;
            UserEvaluationPaySucViewController *evaluationVC = [[UserEvaluationPaySucViewController alloc] initWithNibName:nil bundle:nil isStylePlain:NO];
            evaluationVC.boradTypeList = respond.data;
            evaluationVC.orderDetailEnt = data;
            evaluationVC.popResultBlock = completion;
            [self showWithBaseVC:vc pushVC:evaluationVC];
        }
        else
        {
            [UtilityObject svProgressHUDError:respond viewContrller:vc];
        }
    }];
}

/**
 *  食客获取菜谱，显示菜谱视图控制器
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithRecipeVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    [SVProgressHUD showWithStatus:@"加载"];
    RestaurantReservationInputEntity *inputEntity = data;
    
    [HCSNetHttp requestWithFoodCategoryGetUserFoodCategoryDetails:inputEntity.shopId completion:^(id result) {
        TYZRespondDataEntity *respond = result;
        if (respond.errcode == respond_success)
        {
            [SVProgressHUD dismiss];
            DinersRecipeViewController *recipeVC = [[DinersRecipeViewController alloc] initWithNibName:nil bundle:nil firstShowRefresh:NO];
            recipeVC.reservationInputEntity = inputEntity;
            recipeVC.cateList = respond.data;
            if (inputEntity.addType == 1)
            {// 创建订单
                recipeVC.shopingCartList = [NSMutableArray array];
                if (inputEntity.fixedShopingCartList)
                {
                    [recipeVC.shopingCartList addObjectsFromArray:inputEntity.fixedShopingCartList];
                }
            }
            else
            {// 修改
                recipeVC.shopingCartList = [NSMutableArray array];
                [recipeVC.shopingCartList addObjectsFromArray:inputEntity.fixedShopingCartList];
            }
            recipeVC.popResultBlock = completion;
            [self showWithBaseVC:vc pushVC:recipeVC];
        }
        else
        {
            [UtilityObject svProgressHUDError:respond viewContrller:vc];
        }
    }];
}

/**
 *  显示即时就餐视图控制器
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithEvenDiningVC:(UIViewController *)vc data:(id)data  completion:(void(^)(id data))completion
{
    EvenDiningViewController *evenDiningVC = [[EvenDiningViewController alloc] initWithNibName:nil bundle:nil isStylePlain:NO];
    evenDiningVC.shopDetailEntity = data;
    evenDiningVC.popResultBlock = completion;
    [self showWithBaseVC:vc pushVC:evenDiningVC];
}
// EvenDiningViewController

/**
 *  菜谱里面，进入菜品详情视图控制器，可以直接加入购物车
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithDinersRecipeFoodDetailVC:(UIViewController *)vc data:(id)data shopCartList:(NSArray *)shopCartList isBrowse:(BOOL)isBrowse completion:(void(^)(id data))completion
{
    [SVProgressHUD showWithStatus:@"加载中"];
    NSInteger foodId = [data integerValue];
    // 获取菜品详情
    [HCSNetHttp requestWithFood:foodId completion:^(id result) {
        TYZRespondDataEntity *respond = result;
        if (respond.errcode == respond_success)
        {
            [SVProgressHUD dismiss];
            ShopFoodDataEntity *foodEntity = respond.data;
            //_shopDetailEntity.details.favorite = [[TYZDBManager shareInstance] selectWithCollection:[UserLoginStateObject getUserId] shopId:_mealEntity.shop_id];
            for (ShopFoodImageEntity *ent in foodEntity.content)
            {
                ent.descHeight = [UtilityObject mulFontHeights:objectNull(ent.desc) font:FONTSIZE_13 maxWidth:[[UIScreen mainScreen] screenWidth]];
            }
//            foodEntity.standard.mode = @[@"烘烤", @"凉拌", @"清蒸", @"被地", @"水煮"];
//            foodEntity.remark = @"额我惹我额我认为而我玩儿玩儿玩儿额我而我热玩儿玩儿额我而我惹我人我惹我认为";
            // 备注
            UIImage *image = [UIImage imageNamed:@"order_icon_biaoqian"];
            foodEntity.remarkHeight = [UtilityObject mulFontHeights:objectNull(foodEntity.remark) font:FONTSIZE_13 maxWidth:[[UIScreen mainScreen]screenWidth] - 15*2 - image.size.width - 5];
            foodEntity.introHeight = [UtilityObject mulFontHeights:objectNull(foodEntity.intro) font:FONTSIZE_14 maxWidth:[[UIScreen mainScreen] screenWidth] - 30];
            if (foodEntity.standard.state == 1)
            {
//                CGFloat screenWidth = [[UIScreen mainScreen] screenWidth];
//                NSString *str = @"工艺：";
//                CGFloat titleWidth = [str widthForFont:FONTSIZE_15];
                NSInteger count = [foodEntity.standard.mode count];
                NSInteger col = ceilf(count / 3.0);
//                debugLog(@"count=%d; col=%d", (int)count, (int)col);
                CGFloat height = 30 * col + 10 * (col - 1);
                foodEntity.standard.modeHeight = height;
                
                count = [foodEntity.standard.taste count];
                col = ceilf(count / 3.0);
//                debugLog(@"count=%d; col=%d", (int)count, (int)col);
                height = 30 * col + 10 * (col - 1);
                foodEntity.standard.tasteHeight = height;
            }
            
            
            DinersRecipeFoodDetailViewController *foodDetailVC = [[DinersRecipeFoodDetailViewController alloc] initWithNibName:nil bundle:nil isStylePlain:YES firstShowRefresh:NO];
            foodDetailVC.isBrowse = isBrowse;
            foodDetailVC.foodDetailEntity = respond.data;
            foodDetailVC.shopingCartList = [NSMutableArray arrayWithArray:shopCartList];
            foodDetailVC.popResultBlock = completion;
            [self showWithBaseVC:vc pushVC:foodDetailVC];
        }
        else
        {
            [UtilityObject svProgressHUDError:respond viewContrller:vc];
        }
    }];
}

/**
 *  显示食客创建订单视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithDinersCreateOrderVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    [SVProgressHUD showWithStatus:@"加载中"];
    
    RestaurantReservationInputEntity *inputEntity = data;
//    debugLog(@"shopid=%d", (int)inputEntity.shopId);
//    debugLog(@"seatNumber=%@", inputEntity.tableNo);
//    return;
    
//    NSInteger shopId = [UserLoginStateObject getCurrentShopId];
//    debugLog(@"shopid=%d", (int)shopId);
    // 根据餐厅id获取所有档口及档口菜品数据
//    
    [HCSNetHttp requestWithShopPrinterGetPrintersByConfigType:inputEntity.shopId configType:1 seatName:objectNull(inputEntity.tableNo) completion:^(TYZRespondDataEntity *result) {
        if (result.errcode == respond_success || result.errcode == respond_nodata)
        {
            [SVProgressHUD dismiss];
            DinersCreateOrderViewController *createOrderVC = [[DinersCreateOrderViewController alloc] initWithNibName:nil bundle:nil isStylePlain:NO];
            createOrderVC.inputFoodEntity = inputEntity;
            createOrderVC.printerList = result.data;
            createOrderVC.popResultBlock = completion;
            [self showWithBaseVC:vc pushVC:createOrderVC];
        }
        else
        {
            [UtilityObject svProgressHUDError:result viewContrller:vc];
        }
    }];
//    [HCSNetHttp requestWithShopPrinter:shopId completion:^(TYZRespondDataEntity *result) {
//        
//    }];
    
    
}


/**
 *  显示档口编辑视图控制器
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithShopMouthEditVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    [SVProgressHUD showWithStatus:@"加载中"];
    [HCSNetHttp requestWithShopPrinterGetUnassortedFoods:[UserLoginStateObject getCurrentShopId] completion:^(id result) {
        TYZRespondDataEntity *respond = result;
        if (respond.errcode == respond_success || respond.errcode == respond_nodata)
        {
            [SVProgressHUD dismiss];
            MyRestaurantMouthEditViewController *mouthEditVC = [[MyRestaurantMouthEditViewController alloc] initWithNibName:nil bundle:nil];
            mouthEditVC.mouthList = [NSMutableArray arrayWithArray:data];
//            debugLog(@"data=%@", [respond.data modelToJSONString]);
            NSArray *list = respond.data;
            mouthEditVC.freeFoodList = [NSMutableArray array];
            [mouthEditVC.freeFoodList addObjectsFromArray:list];
//            debugLog(@"freelist=%@", [mouthEditVC.freeFoodList modelToJSONString]);
            [self showWithBaseVC:vc pushVC:mouthEditVC];
        }
        else
        {
            [UtilityObject svProgressHUDError:respond viewContrller:vc];
        }
    }];
    
}
// MyRestaurantMouthEditViewController


/**
 *  搜索视图控制器
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithDinersSearchVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    [SVProgressHUD showWithStatus:@"加载中"];
    CLLocation *location = [[HCSLocationManager shareInstance] userLocation];
    double lon = location.coordinate.longitude;
    double lat = location.coordinate.latitude;
    NSString *cityName = [[HCSLocationManager shareInstance] readCityName];
    [HCSNetHttp requestWithCitySearch:cityName completion:^(id result) {
        TYZRespondDataEntity *respond = result;
        if (respond.errcode == respond_success)
        {
            CityDataEntity *cityEnt = respond.data;
            [HCSNetHttp requestWithSearchHotKey:cityEnt.city_id lat:lat lng:lon completion:^(id result) {
                TYZRespondDataEntity *hRespond = result;
                if (hRespond.errcode == respond_success)
                {
                    [SVProgressHUD dismiss];
                    DinersSearchViewController *searchVC = [[DinersSearchViewController alloc] initWithNibName:nil bundle:nil isStylePlain:YES];
                    searchVC.hotKeyList = hRespond.data;
                    searchVC.popResultBlock = completion;
                    [self showWithBaseVC:vc pushVC:searchVC];
                }
                else
                {
                    [UtilityObject svProgressHUDError:hRespond viewContrller:vc];
                }
            }];
        }
        else
        {
            [UtilityObject svProgressHUDError:respond viewContrller:vc];
        }
    }];
}
// DinersSearchViewController

/**
 *  搜索结果视图控制器
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithDinersSearchResultVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    [SVProgressHUD showWithStatus:@"加载中"];
    [HCSNetHttp requestWithShopClassifyConfig:2 completion:^(id result) {// 获取菜品信息
        TYZRespondDataEntity *respond = result;
        if (respond.errcode == respond_success)
        {
            HCSLocationManager *locationManager = [HCSLocationManager shareInstance];
            NSString *cityName = [locationManager readCityName];
            [HCSNetHttp requestWithCitySearch:cityName completion:^(id result) {
                TYZRespondDataEntity *cityRespond = result;
                if (cityRespond.errcode == respond_success)
                {// 获取城市id
                    CityDataEntity *cityEnt = cityRespond.data;
                    [HCSNetHttp requestWithMallCityId:cityEnt.city_id completion:^(id result) {
                        TYZRespondDataEntity *mRespond = result;
                        if (mRespond.errcode == respond_success)
                        {// 根据城市id获取商圈信息
                            [SVProgressHUD dismiss];
                            CLLocation *location = [locationManager userLocation];
                            double lon = location.coordinate.longitude;
                            double lat = location.coordinate.latitude;
                            ShopSearchInputEntity *inputEntity = [ShopSearchInputEntity new];
                            inputEntity.city_id = cityEnt.city_id;
                            inputEntity.lat = lat;
                            inputEntity.lng = lon;
                            inputEntity.key = data;
                            inputEntity.page_index = 1;
                            DinersSearchResultViewController *searchResultVC = [[DinersSearchResultViewController alloc] initWithNibName:nil bundle:nil isStylePlain:NO firstShowRefresh:NO];
                            searchResultVC.searchInputEntity = inputEntity;
                            searchResultVC.cuisineEntity = respond.data;
                            searchResultVC.mallList = mRespond.data;
                            searchResultVC.popResultBlock = completion;
                            [self showWithBaseVC:vc pushVC:searchResultVC];
                        }
                        else
                        {
                            [UtilityObject svProgressHUDError:mRespond viewContrller:vc];
                        }
                    }];
                }
                else
                {
                    [UtilityObject svProgressHUDError:cityRespond viewContrller:vc];
                }
            }];
        }
        else
        {
            [UtilityObject svProgressHUDError:respond viewContrller:vc];
        }
    }];
}
// DinersSearchResultViewController

/**
 *  新的搜索结果视图控制器
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithDinersNewSearchResultVC:(UIViewController *)vc data:(id)data type:(NSInteger)type completion:(void(^)(id data))completion
{
    [SVProgressHUD showWithStatus:@"加载中"];
//    [HCSNetHttp requestWithUserFavorite:[UserLoginStateObject getUserId] completion:^(id result) {
//        TYZRespondDataEntity *frespond = result;
//        if (frespond.errcode == respond_success)
//        {// 获取收藏列表
            [HCSNetHttp requestWithShopClassifyConfig:2 completion:^(id result) {// 获取菜品信息
                TYZRespondDataEntity *respond = result;
                if (respond.errcode == respond_success)
                {// 获取菜系
                    HCSLocationManager *locationManager = [HCSLocationManager shareInstance];
                    NSString *cityName = objectNull([locationManager readCityName]);
                    if ([cityName isEqualToString:@""])
                    {
                        cityName = @"南京";
                    }
                    [HCSNetHttp requestWithCitySearch:cityName completion:^(id result) {
                        TYZRespondDataEntity *cityRespond = result;
                        if (cityRespond.errcode == respond_success)
                        {// 获取城市id
                            CityDataEntity *cityEnt = cityRespond.data;
                            [HCSNetHttp requestWithMallNearby:cityEnt.city_id completion:^(id result) {
                                TYZRespondDataEntity *mRespond = result;
                                if (mRespond.errcode == respond_success)
                                {// 根据城市id获取商圈信息
                                    [SVProgressHUD dismiss];
                                    
                                    CLLocation *location = [locationManager userLocation];
                                    double lon = location.coordinate.longitude;
                                    double lat = location.coordinate.latitude;
                                    ShopSearchInputEntity *inputEntity = [ShopSearchInputEntity new];
                                    inputEntity.city_id = cityEnt.city_id;
                                    inputEntity.lat = lat;
                                    inputEntity.lng = lon;
                                    inputEntity.page_index = 1;
                                    
                                    NSArray *array = [[TYZDBManager shareInstance] getWithAllCollectionList:[UserLoginStateObject getUserId]];
                                    DinersSearchResultNewViewController *searchResultVC = [[DinersSearchResultNewViewController alloc] initWithNibName:nil bundle:nil isStylePlain:YES firstShowRefresh:NO];
                                    if (type == 1)
                                    {// 表示传的是搜索的关键字key
                                        inputEntity.key = data;
                                        searchResultVC.title = data;
                                    }
                                    else if (type == 2)
                                    {// 表示只是标题
                                        searchResultVC.title = data;
                                    }
                                    else if (type == 3)
                                    {// OrderMealDataEntity
                                        OrderMealDataEntity *mealEnt = data;
                                        OrderMealContentEntity *contentEnt = mealEnt.content;
                                        searchResultVC.title = mealEnt.borad_name;
                                        inputEntity.classify_ids = [NSString stringWithFormat:@"%d", (int)contentEnt.class_id];
                                    }
                                    searchResultVC.favorites = [NSMutableArray array];
//                                    [searchResultVC.favorites addObjectsFromArray:frespond.data];
                                    [searchResultVC.favorites addObjectsFromArray:array];
                                    searchResultVC.searchInputEntity = inputEntity;
                                    searchResultVC.cuisineEntity = respond.data;
                                    NSMutableArray *mallList = [NSMutableArray arrayWithArray:mRespond.data];
//                                    MallDataEntity *mallEnt = [MallDataEntity new];
//                                    mallEnt.name = @"附近";
//                                    MallListDataEntity *mallListEnt = [MallListDataEntity new];
//                                    mallListEnt.name = @"附近（智能范围）";
//                                    mallEnt.malls = [NSArray arrayWithObjects:mallListEnt, nil];
//                                    [mallList insertObject:mallEnt atIndex:0];
                                    searchResultVC.mallList = mallList;
                                    searchResultVC.popResultBlock = completion;
                                    [self showWithBaseVC:vc pushVC:searchResultVC];
                                }
                                else
                                {
                                    [UtilityObject svProgressHUDError:mRespond viewContrller:vc];
                                }
                            }];
                        }
                        else
                        {
                            [UtilityObject svProgressHUDError:cityRespond viewContrller:vc];
                        }
                    }];
                }
                else
                {
                    [UtilityObject svProgressHUDError:respond viewContrller:vc];
                }
            }];
//        }
//        else
//        {
//            [UtilityObject svProgressHUDError:frespond viewContrller:vc];
//        }
//    }];
}
// DinersSearchResultNewViewController


/**
 *  显示退款订单详情视图控制器
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
/*+ (void)showWithDinersRefundOrderDetailVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    [SVProgressHUD showWithStatus:@"加载中"];
    OrderDataEntity *orderEnt = data;
    [HCSNetHttp requestWithOrderShowWholeOrder:orderEnt.order_id shopId:orderEnt.shop_id completion:^(id result) {
        TYZRespondDataEntity *respond = result;
        if (respond.errcode == respond_success)
        {
 

            [SVProgressHUD dismiss];
            DinersRefundOrderDetailViewController *orderDetailVC = [[DinersRefundOrderDetailViewController alloc] initWithNibName:nil bundle:nil isStylePlain:NO firstShowRefresh:NO];
            orderDetailVC.orderDetailEntity = respond.data;
//            orderDetailVC.orderDetailEntity.order.status = NS_ORDER_SHOP_SAB_STATE;
            orderDetailVC.popResultBlock = completion;
            [self showWithBaseVC:vc pushVC:orderDetailVC];
        }
        else
        {
            [UtilityObject svProgressHUDError:respond viewContrller:vc];
        }
    }];
}*/

/**
 *  餐厅评论列表视图控制器
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithShopCommentListVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    ShopCommentListViewController *commentListVC = [[ShopCommentListViewController alloc] initWithNibName:nil bundle:nil isStylePlain:YES firstShowRefresh:NO];
    commentListVC.shopId = [data integerValue];
    commentListVC.popResultBlock = completion;
    [self showWithBaseVC:vc pushVC:commentListVC];
}
// ShopCommentListViewController

/**
 *  获取待处理订单的视图
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithWaitingNoticeOrderVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    WaitingNoticeOrderViewController *waitingOrderVC = [[WaitingNoticeOrderViewController alloc] initWithNibName:nil bundle:nil isStylePlain:NO firstShowRefresh:NO];
    [self showWithBaseVC:vc pushVC:waitingOrderVC];
}
// WaitingNoticeOrderViewController

/**
 *  显示我的收藏视图控制器
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithMyCollectionListVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    [SVProgressHUD showWithStatus:@"加载中"];
    [HCSNetHttp requestWithUserFavoriteGetShopList:[UserLoginStateObject getUserId] completion:^(id result) {
        TYZRespondDataEntity *respond = result;
        if (respond.errcode == respond_success || respond.errcode == respond_nodata)
        {
            [SVProgressHUD dismiss];
            MyCollectionListViewController *myCollectionVC = [[MyCollectionListViewController alloc] initWithNibName:nil bundle:nil isStylePlain:YES firstShowRefresh:NO];
            myCollectionVC.collectionList = respond.data;
            myCollectionVC.popResultBlock = completion;
            [self showWithBaseVC:vc pushVC:myCollectionVC];
        }
        else
        {
            [UtilityObject svProgressHUDError:respond viewContrller:vc];
        }
    }];
    
}
// MyCollectionListViewController

/**
 *  我的钱包视图控制器
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithMyWalletVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    [SVProgressHUD showWithStatus:@"加载中"];
    [HCSNetHttp requestWithUserAccount:[UserLoginStateObject getUserId] completion:^(id result) {
        TYZRespondDataEntity *respond = result;
        if (respond.errcode == respond_success)
        {
            [SVProgressHUD dismiss];
            MyWalletViewController *walletVC = [[MyWalletViewController alloc] initWithNibName:nil bundle:nil isStylePlain:NO];
            walletVC.walletEntity = respond.data;
            walletVC.popResultBlock = completion;
            [self showWithBaseVC:vc pushVC:walletVC];
        }
        else
        {
            [UtilityObject svProgressHUDError:respond viewContrller:vc];
        }
    }];
    
}

/**
 *  我的钱包明细视图控制器
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithMyWalletDetailVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    MyWalletDetailViewController *drawalVC = [[MyWalletDetailViewController alloc] initWithNibName:nil bundle:nil isStylePlain:YES firstShowRefresh:NO];
    drawalVC.popResultBlock = completion;
    [self showWithBaseVC:vc pushVC:drawalVC];
}
// MyWalletDetailViewController

/**
 *  我的钱包支付方式的视图控制器
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithMyWalletPayWayVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    MyWalletThirdPayWayViewController *drawalVC = [[MyWalletThirdPayWayViewController alloc] initWithNibName:nil bundle:nil isStylePlain:YES];
    drawalVC.popResultBlock = completion;
    [self showWithBaseVC:vc pushVC:drawalVC];
}
// MyWalletThirdPayWayViewController

/**
 *  我的钱包充值视图控制器
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithMyWalletTopUpVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    MyWalletTopUpViewController *drawalVC = [[MyWalletTopUpViewController alloc] initWithNibName:nil bundle:nil isStylePlain:YES];
    drawalVC.popResultBlock = completion;
    [self showWithBaseVC:vc pushVC:drawalVC];
}
// MyWalletTopUpViewController

/**
 *  我的钱包提现视图控制器
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithMyWalletDrawalVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    MyWalletWithdrawalViewController *drawalVC = [[MyWalletWithdrawalViewController alloc] initWithNibName:nil bundle:nil isStylePlain:YES];
    drawalVC.popResultBlock = completion;
    [self showWithBaseVC:vc pushVC:drawalVC];
}
// MyWalletWithdrawalViewController

/**
 *  我的钱包流水详情视图控制器
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithMyWalletDetailStreamVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    MyWalletDetailStreamViewController *walletStreamVC = [[MyWalletDetailStreamViewController alloc] initWithNibName:nil bundle:nil isStylePlain:NO];
    walletStreamVC.consumeEntity = data;
    walletStreamVC.popResultBlock = completion;
    [self showWithBaseVC:vc pushVC:walletStreamVC];
}
// MyWalletDetailStreamViewController

/**
 *  显示加入推广视图控制器
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithJoinPromotionVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    MyJoinPromotionViewController *joinPromotionVC = [[MyJoinPromotionViewController alloc] initWithNibName:nil bundle:nil];
    joinPromotionVC.promotionType = [data integerValue];
    joinPromotionVC.popResultBlock = completion;
    [self showWithBaseVC:vc pushVC:joinPromotionVC];
}
// MyJoinPromotionViewController

/**
 *  显示我的设置视图控制器
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithMySettingsVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    MySettingsViewController *mySettingsVC = [[MySettingsViewController alloc] initWithNibName:nil bundle:nil isStylePlain:NO];
    [self showWithBaseVC:vc pushVC:mySettingsVC];
}
//  MySettingsViewController

/**
 *  显示关于视图控制器
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithMyAboutVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    MyAboutViewController *aboutVC = [[MyAboutViewController alloc] initWithNibName:nil bundle:nil];
    [self showWithBaseVC:vc pushVC:aboutVC];
}
// MyAboutViewController


/**
 *  补单管理视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithRepairVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    [SVProgressHUD showWithStatus:@"加载中"];
    CTCMealOrderDetailsEntity *orderDetailEnt = data;
    [HCSNetHttp requestWithShopOrderGetPrintBatchFoods:orderDetailEnt.order_id shopId:orderDetailEnt.shop_id completion:^(TYZRespondDataEntity *respond) {
        if (respond.errcode == respond_success)
        {
            [SVProgressHUD dismiss];
            ShopRepairManagerViewController *repairVC = [[ShopRepairManagerViewController alloc] initWithNibName:nil bundle:nil isStylePlain:YES];
            repairVC.batchFoods = respond.data;
            repairVC.orderDetailEnt = data;
            repairVC.popResultBlock = completion;
            [self showWithBaseVC:vc pushVC:repairVC];
            if (repairVC.popResultBlock)
            {
                repairVC.popResultBlock(@"success");
            }
        }
        else
        {
            [UtilityObject svProgressHUDError:respond viewContrller:vc];
        }
    }];
}
// ShopRepairManagerViewController

/**
 *  菜单列表
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithShopMenuVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    [SVProgressHUD showWithStatus:@"加载中"];
    [HCSNetHttp requestWithFoodCategoryGetFoodCategoryDetails:[data integerValue] completion:^(id result) {
        TYZRespondDataEntity *respond = result;
        if (respond.errcode == respond_success)
        {
            [SVProgressHUD dismiss];
            MyRestaurantMenuViewController *menuVC = [[MyRestaurantMenuViewController alloc] initWithNibName:nil bundle:nil];
            menuVC.menuList = [NSMutableArray arrayWithArray:respond.data];
//            debugLog(@"count=%d", (int)[menuVC.menuList count]);
            menuVC.popResultBlock = completion;
            [menuVC initWithBackButton];
            menuVC.title = @"菜品";
            [self showWithBaseVC:vc pushVC:menuVC];
        }
        else
        {
            [UtilityObject svProgressHUDError:respond viewContrller:vc];
        }
    }];
}
// MyRestaurantMenuViewController

/**
 *  空间编辑视图控制器
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithRoomSpaceVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    [SVProgressHUD showWithStatus:@"加载中"];
    NSInteger shopId = [UserLoginStateObject getCurrentShopId];
    [HCSNetHttp requestWithShopSeatSetting:shopId completion:^(id result) {
        TYZRespondDataEntity *respond = result;
        if (respond.errcode == respond_success || respond.errcode == respond_nodata)
        {
            [SVProgressHUD dismiss];
//            MyRestaurantRoomSpaceViewController *roomSpaceVC = [[MyRestaurantRoomSpaceViewController alloc] initWithNibName:nil bundle:nil isStylePlain:NO firstShowRefresh:NO];
//            roomSpaceVC.seatList = respond.data;
//            roomSpaceVC.popResultBlock = completion;
//            [self showWithBaseVC:vc pushVC:roomSpaceVC];
            
            
            MyRestaurantRoomSpaceEditViewController *roomSpaceEditVC = [[MyRestaurantRoomSpaceEditViewController alloc] initWithNibName:nil bundle:nil isStylePlain:NO firstShowRefresh:NO];
            roomSpaceEditVC.popResultBlock = completion;
            roomSpaceEditVC.roomSpaceList = [NSMutableArray arrayWithArray:respond.data];
            [self showWithBaseVC:vc pushVC:roomSpaceEditVC];
            
            
        }
        else
        {
            [UtilityObject svProgressHUDError:respond viewContrller:vc];
        }
    }];
}
// MyRestaurantRoomSpaceEditViewController

/**
 *  添加或者修改空间视图控制器
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithRSEditVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    MyRestaurantRoomSpaceAddViewController *editSpaceVC = [[MyRestaurantRoomSpaceAddViewController alloc] initWithNibName:nil bundle:nil];
    editSpaceVC.seatEntity = data;
    editSpaceVC.popResultBlock = completion;
    [self showWithBaseVC:vc pushVC:editSpaceVC];
}
// MyRestaurantRoomSpaceAddViewController

/**
 *  今日订单汇总
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithFinanceTodayOrderListVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    MyFinanceTodayOrderListViewController *orderListVC = [[MyFinanceTodayOrderListViewController alloc] initWithNibName:nil bundle:nil isStylePlain:YES firstShowRefresh:NO];
    orderListVC.popResultBlock = completion;
    [self showWithBaseVC:vc pushVC:orderListVC];
}
// MyFinanceTodayOrderListViewController


/**
 *  完成的订单详情视图控制器
 *
 *  @param vc
 *  @param data
 *  @param modeType   1表示餐厅端；2表示食客端
 *  @param completion
 */
+ (void)showWithFinishOrderDetailVC:(UIViewController *)vc data:(id)data modeType:(NSInteger)modeType completion:(void(^)(id data))completion
{
    
    [SVProgressHUD showWithStatus:@"加载中"];
    OrderDataEntity *orderEnt = data;
    // requestWithShopOrderDetail
    [HCSNetHttp requestWithShopOrderDetail:orderEnt.order_id shopId:orderEnt.shop_id completion:^(TYZRespondDataEntity *respond) {
        if (respond.errcode == respond_success)
        {
            CTCOrderDetailEntity *detailEntity = respond.data;
            
            NSInteger num = 0;
            NSMutableDictionary *categoryDict = [NSMutableDictionary new];
            for (OrderFoodInfoEntity *foodEnt in detailEntity.details)
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
            /*NSMutableString *mutStr = [NSMutableString new];
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
            }*/
//            orderDetailEnt.foodTotalDesc = mutStr;
//            orderDetailEnt.foodTotalDescHeight = [UtilityObject mulFontHeights:mutStr font:FONTSIZE_12 maxWidth:[[UIScreen mainScreen] screenWidth] - 30];
            detailEntity.totalCount = num;
            
            
            detailEntity.comment.contentHeight = [UtilityObject mulFontHeights:detailEntity.comment.content font:FONTSIZE_15 maxWidth:[[UIScreen mainScreen] screenWidth] - 30];
            detailEntity.comment.imgWidth = ([[UIScreen mainScreen] screenWidth] - 30 - 8 * 2) / 3.0;
            
            NSInteger row = 0;
            CGFloat maxWidth = [[UIScreen mainScreen] screenWidth] - 30;
            CGFloat singleHeight = 25;
            CGFloat midSpace = 20; // 列中间的space
            CGFloat rowSpace = 10; // 行之间的space
            CGFloat fontWidth = 0;
            CGFloat allWidth = 0;
            //            debugLog(@"count=%d", [orderDetailEnt.order.comment.classify count]);
            for (NSInteger i=0; i<[detailEntity.comment.classify count]; i++)
            {
                //                debugLog(@"i=%d", (int)i);
                // NSInteger num = arc4random() % 3;
                CommentClassifyEntity *classEnt = detailEntity.comment.classify[i];
                if (i == 0)
                {
                    classEnt.color = [UIColor colorWithHexString:@"#cce198"];
                }
                else if (i == 1)
                {
                    classEnt.color = [UIColor colorWithHexString:@"#facd89"];
                }
                else if (i == 2)
                {
                    classEnt.color = [UIColor colorWithHexString:@"#f19ec2"];
                }
                fontWidth = [classEnt.classify_name widthForFont:FONTSIZE_15] + 30;
                classEnt.classifyNameWidth = fontWidth;
                //                debugLog(@"fontWidth=%.2f", fontWidth);
                if (allWidth == 0)
                {
                    allWidth += fontWidth;
                }
                else
                {
                    allWidth += (fontWidth + midSpace);
                }
                //                debugLog(@"allWidth=%.2f", allWidth);
                if (allWidth > maxWidth)
                {
                    row += 1;
                    allWidth = fontWidth;
                }
            }
            if (row == 0)
            {
                row = 1;
            }
            detailEntity.comment.classifyRow = row;
            detailEntity.comment.classifyHeight = row * singleHeight + (row - 1) * rowSpace;
            //            debugLog(@"row=%d; height=%.2f", row, orderDetailEnt.order.comment.classifyHeight);
            [SVProgressHUD dismiss];
            FinishedOrderDetailViewController *finishOrderDetailVC = [[FinishedOrderDetailViewController alloc] initWithNibName:nil bundle:nil isStylePlain:NO firstShowRefresh:NO];
            finishOrderDetailVC.orderDetailEntity = detailEntity;
//            finishOrderDetailVC.modeType = modeType;
            [self showWithBaseVC:vc pushVC:finishOrderDetailVC];
        }
        else
        {
            [UtilityObject svProgressHUDError:respond viewContrller:vc];
        }
    }];
    
    
    return;
    
    
    
    /*[HCSNetHttp requestWithOrderShowWholeOrderTwo:orderEnt.order_id shopId:orderEnt.shop_id completion:^(id result) {
        TYZRespondDataEntity *respond = result;
        if (respond.errcode == respond_success)
        {
            [SVProgressHUD dismiss];
            OrderDetailDataEntity *orderDetailEnt = respond.data;
//            orderDetailEnt.order.comment.content
            orderDetailEnt.order.comment.contentHeight = [UtilityObject mulFontHeights:orderDetailEnt.order.comment.content font:FONTSIZE_15 maxWidth:[[UIScreen mainScreen] screenWidth] - 30];
            orderDetailEnt.order.comment.imgWidth = ([[UIScreen mainScreen] screenWidth] - 30 - 8 * 2) / 3.0;
            
            NSInteger row = 0;
            CGFloat maxWidth = [[UIScreen mainScreen] screenWidth] - 30;
            CGFloat singleHeight = 25;
            CGFloat midSpace = 20; // 列中间的space
            CGFloat rowSpace = 10; // 行之间的space
            CGFloat fontWidth = 0;
            CGFloat allWidth = 0;
//            debugLog(@"count=%d", [orderDetailEnt.order.comment.classify count]);
            for (NSInteger i=0; i<[orderDetailEnt.order.comment.classify count]; i++)
            {
//                debugLog(@"i=%d", (int)i);
                // NSInteger num = arc4random() % 3;
                CommentClassifyEntity *classEnt = orderDetailEnt.order.comment.classify[i];
                if (i == 0)
                {
                    classEnt.color = [UIColor colorWithHexString:@"#cce198"];
                }
                else if (i == 1)
                {
                    classEnt.color = [UIColor colorWithHexString:@"#facd89"];
                }
                else if (i == 2)
                {
                    classEnt.color = [UIColor colorWithHexString:@"#f19ec2"];
                }
                fontWidth = [classEnt.classify_name widthForFont:FONTSIZE_15] + 30;
                classEnt.classifyNameWidth = fontWidth;
//                debugLog(@"fontWidth=%.2f", fontWidth);
                if (allWidth == 0)
                {
                    allWidth += fontWidth;
                }
                else
                {
                    allWidth += (fontWidth + midSpace);
                }
//                debugLog(@"allWidth=%.2f", allWidth);
                if (allWidth > maxWidth)
                {
                    row += 1;
                    allWidth = fontWidth;
                }
            }
            if (row == 0)
            {
                row = 1;
            }
            orderDetailEnt.order.comment.classifyRow = row;
            orderDetailEnt.order.comment.classifyHeight = row * singleHeight + (row - 1) * rowSpace;
//            debugLog(@"row=%d; height=%.2f", row, orderDetailEnt.order.comment.classifyHeight);
            FinishedOrderDetailViewController *finishOrderDetailVC = [[FinishedOrderDetailViewController alloc] initWithNibName:nil bundle:nil isStylePlain:NO firstShowRefresh:NO];
            finishOrderDetailVC.orderDetailEntity = orderDetailEnt;
            finishOrderDetailVC.modeType = modeType;
            [self showWithBaseVC:vc pushVC:finishOrderDetailVC];
        }
        else
        {
            [UtilityObject svProgressHUDError:respond viewContrller:vc];
        }
    }];*/
}
//FinishedOrderDetailViewController

/**
 *  今日订单汇总视图控制器
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithTodayOrderSummaryVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    MyFinanceTodayOrderSummaryViewController *orderSummaryVC = [[MyFinanceTodayOrderSummaryViewController alloc] initWithNibName:nil bundle:nil];
    orderSummaryVC.date = data;
    orderSummaryVC.popResultBlock = completion;
    [self showWithBaseVC:vc pushVC:orderSummaryVC];
}
// MyFinanceTodayOrderSummaryViewController

/**
 *  日汇总视图控制器
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithAggregateVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    MyFinanceTodayAggregateViewController *orderSummaryVC = [[MyFinanceTodayAggregateViewController alloc] initWithNibName:nil bundle:nil];
    orderSummaryVC.date = data;
    orderSummaryVC.popResultBlock = completion;
    [self showWithBaseVC:vc pushVC:orderSummaryVC];
}
// MyFinanceTodayAggregateViewController


/**
 *  推广收益视图控制器
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithEarningVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    PromotionEarningViewController *earnVC = [[PromotionEarningViewController alloc] initWithNibName:nil bundle:nil];
    [self showWithBaseVC:vc pushVC:earnVC];
}
// PromotionEarningViewController

/**
 *  附近餐厅列表视图控制器
 *
 *  @param vc
 *  @param data
 *  @param completion
 */
+ (void)showWithNearShopVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    OMNearShopViewController *nearShopVC = [[OMNearShopViewController alloc] initWithNibName:nil bundle:nil firstShowRefresh:NO];
    nearShopVC.list = data;
    nearShopVC.popResultBlock = completion;
    [self showWithBaseVC:vc pushVC:nearShopVC];
}
// OMNearShopViewController




#pragma mark -
#pragma mark 新的

/**
 *  点菜下单视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithTakeOrderVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    [SVProgressHUD showWithStatus:@"加载中"];
    NSInteger shopId = [UserLoginStateObject getCurrentShopId];
    // 餐厅详情
    [HCSNetHttp requestWithShopShow:shopId completion:^(TYZRespondDataEntity *respondD) {
        if (respondD.errcode == respond_success)
        {
            // 餐位信息
            [HCSNetHttp requestWithShopSeatSetting:shopId completion:^(id result) {
                TYZRespondDataEntity *respond = result;
                if (respond.errcode == respond_success)
                {
                    [SVProgressHUD dismiss];
                    CTCRestaurantTakeOrderViewController *takeOrderVC = [[CTCRestaurantTakeOrderViewController alloc] initWithNibName:nil bundle:nil];
                    takeOrderVC.shopDetailEntity = respondD.data;
                    takeOrderVC.seatLocList = respond.data;
                    takeOrderVC.popResultBlock = completion;
                    [self showWithBaseVC:vc pushVC:takeOrderVC];
                }
                else
                {
                    [UtilityObject svProgressHUDError:respond viewContrller:vc];
                }
            }];
        }
        else
        {
            [UtilityObject svProgressHUDError:respondD viewContrller:vc];
        }
    }];
}
// CTCRestaurantTakeOrderViewController


/**
 *  餐中订单视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithMealingOrderVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    // requestWithShopOrderDiningSeats
    [SVProgressHUD showWithStatus:@"加载中"];
    NSInteger shopId = [UserLoginStateObject getCurrentShopId];
    debugLog(@"shopid=%d", (int)shopId);
    // 根据餐厅id获取所有档口及档口菜品数据
//    [HCSNetHttp requestWithShopPrinter:shopId completion:^(TYZRespondDataEntity *printerResp) {
//        if (printerResp.errcode == respond_success || printerResp.errcode == respond_nodata)
//        {
            // 获取所有的餐位信息
            [HCSNetHttp requestWithShopSeatSetting:shopId completion:^(TYZRespondDataEntity *respond) {
                if (respond.errcode == respond_success)
                {
                    // 获取餐中订单餐桌信息
                    [HCSNetHttp requestWithShopOrderDiningSeats:shopId completion:^(TYZRespondDataEntity *respondSeats) {
                        if (respondSeats.errcode ==  respond_success || respondSeats.errcode == respond_nodata)
                        {
                            NSArray *orderSeatArray = respondSeats.data;
                            if ([orderSeatArray count] != 0)
                            {
                                __block OrderDiningSeatEntity *firstEnt = orderSeatArray[0];
                                // 获取第一个餐位的订单详情
                                [HCSNetHttp requestWithShopOrderDiningDetails:firstEnt.order_id shopId:shopId completion:^(TYZRespondDataEntity *respondDetail) {
                                    if (respondDetail.errcode == respond_success || respondDetail.errcode == respond_nodata)
                                    {
                                        [SVProgressHUD dismiss];
                                        firstEnt.orderDetailEntity = respondDetail.data;
                                        CTCRestaurantMealingOrderViewController *mealingOrderVC = [[CTCRestaurantMealingOrderViewController alloc] initWithNibName:nil bundle:nil isStylePlain:YES];
                                        mealingOrderVC.selectedOrderSeatEntity = firstEnt;
                                        mealingOrderVC.orderSeatList = [NSMutableArray arrayWithArray:orderSeatArray];
                                        mealingOrderVC.seatLocList = respond.data;
//                                        mealingOrderVC.printerList = printerResp.data;
                                        mealingOrderVC.popResultBlock = completion;
                                        [self showWithBaseVC:vc pushVC:mealingOrderVC];
                                    }
                                    else
                                    {
                                        [UtilityObject svProgressHUDError:respondDetail viewContrller:vc];
                                    }
                                }];
                            }
                            else
                            {
//                                [SVProgressHUD showErrorWithStatus:@"暂无餐中订单"];
                                [SVProgressHUD dismiss];
                                CTCRestaurantMealingOrderViewController *mealingOrderVC = [[CTCRestaurantMealingOrderViewController alloc] initWithNibName:nil bundle:nil isStylePlain:YES];
//                                mealingOrderVC.selectedOrderSeatEntity = firstEnt;
                                mealingOrderVC.orderSeatList = [NSMutableArray arrayWithArray:orderSeatArray];
                                mealingOrderVC.seatLocList = respond.data;
                                mealingOrderVC.popResultBlock = completion;
                                [self showWithBaseVC:vc pushVC:mealingOrderVC];
                            }
                        }
                        else
                        {
                            debugLog(@"没有餐中订单餐桌信息");
                            [UtilityObject svProgressHUDError:respondSeats viewContrller:vc];
                        }
                    }];
                }
                else
                {
                    debugLog(@"没有餐位信息");
                    [UtilityObject svProgressHUDError:respond viewContrller:vc];
                }
            }];
//        }
//        else
//        {
//            debugLog(@"没有档口及档口菜品数据");
//            [UtilityObject svProgressHUDError:printerResp viewContrller:vc];
//        }
//    }];
}
// ShopMealingOrderViewController

/**
 *  预定订单视图控制器(预定订单)
 *
 *  @param vc vc
 *  @param data data
 *  @param type 1表示点击通知后，进入餐前订单；2表示预定订单
 *  @param completion block
 */
+ (void)showWithReservationOrderVC:(UIViewController *)vc data:(id)data type:(int)type completion:(void(^)(id data))completion
{
    // CTCRestaurantReserveOrderViewController
    CTCRestaurantReserveOrderViewController *reservationOrderVC = [[CTCRestaurantReserveOrderViewController alloc] initWithNibName:nil bundle:nil isStylePlain:NO firstShowRefresh:NO];
    reservationOrderVC.type = type;
    reservationOrderVC.popResultBlock = completion;
    [self showWithBaseVC:vc pushVC:reservationOrderVC];
}

/**
 *  餐前订单视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
//+ (void)showWithDinnerOrderVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;
// ShopReservationOrderViewController

/**
 *  历史订单视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithFinishOrderVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    CTCRestaurantHistoryOrderViewController *finishOrderVC = [[CTCRestaurantHistoryOrderViewController alloc] initWithNibName:nil bundle:nil isStylePlain:NO firstShowRefresh:NO];
    finishOrderVC.popResultBlock = completion;
    [self showWithBaseVC:vc pushVC:finishOrderVC];
}
// ShopFinishOrderViewController

/**
 *  餐厅资料视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithRestaurantInfoVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    [SVProgressHUD showWithStatus:@"加载中"];
    NSInteger shopId = [UserLoginStateObject getUserInfo].shop_id;
    [HCSNetHttp requestWithShopShow:shopId completion:^(id result) {
        TYZRespondDataEntity *respond = result;
        if (respond.errcode == respond_success)
        {
            RestaurantDetailDataEntity *detailEntity = respond.data;
            detailEntity.details.sloganHeight = [UtilityObject mulFontHeights:objectNull(detailEntity.details.slogan) font:FONTSIZE_15 maxWidth:[[UIScreen mainScreen] screenWidth] - 30];
            // 餐厅简介
            detailEntity.details.introHeight = [UtilityObject mulFontHeights:objectNull(detailEntity.details.intro) font:FONTSIZE_12 maxWidth:[[UIScreen mainScreen] screenWidth] - 30];
            
            // 厨师简介
            detailEntity.topchef.introHeight = [UtilityObject mulFontHeights:objectNull(detailEntity.topchef.intro) font:FONTSIZE_12 maxWidth:[[UIScreen mainScreen] screenWidth] - 30];
            [SVProgressHUD dismiss];
            MyRestaurantDataViewController *dataVC = [[MyRestaurantDataViewController alloc] initWithNibName:nil bundle:nil isStylePlain:YES firstShowRefresh:NO];
            dataVC.detailEntity = detailEntity;
            dataVC.popResultBlock = completion;
            [self showWithBaseVC:vc pushVC:dataVC];
        }
        else
        {
            [UtilityObject svProgressHUDError:respond viewContrller:vc];
        }
    }];
}
// MyRestaurantDataViewController

/**
 *  餐厅菜单菜品视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithRestaurantMenuVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    [SVProgressHUD showWithStatus:@"加载中"];
    NSInteger shopId = [UserLoginStateObject getCurrentShopId];
    [HCSNetHttp requestWithFoodCategoryGetFoodCategoryDetails:shopId completion:^(id result) {
        TYZRespondDataEntity *respond = result;
        if (respond.errcode == respond_success)
        {
            [SVProgressHUD dismiss];
            MyRestaurantMenuViewController *menuVC = [[MyRestaurantMenuViewController alloc] initWithNibName:nil bundle:nil];
//            [menuVC responseWithFoodCategoryDetails:respond];
            menuVC.popResultBlock = completion;
            [self showWithBaseVC:vc pushVC:menuVC];
        }
        else
        {
            [UtilityObject svProgressHUDError:respond viewContrller:vc];
        }
    }];
}
// MyRestaurantMenuViewController

/**
 *  餐厅空间视图控制器(餐位)
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithRestaurantRoomSpaceVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    [SVProgressHUD showWithStatus:@"加载中"];
    NSInteger shopId = [UserLoginStateObject getCurrentShopId];
    [HCSNetHttp requestWithShopSeatSetting:shopId completion:^(id result) {
        TYZRespondDataEntity *respond = result;
        if (respond.errcode == respond_success || respond.errcode == respond_nodata)
        {
            [SVProgressHUD dismiss];
            MyRestaurantRoomSpaceViewController *roomSpaceVC = [[MyRestaurantRoomSpaceViewController alloc] initWithNibName:nil bundle:nil isStylePlain:NO firstShowRefresh:NO];
            roomSpaceVC.seatList = respond.data;
            roomSpaceVC.popResultBlock = completion;
            [self showWithBaseVC:vc pushVC:roomSpaceVC];
        }
        else
        {
            [UtilityObject svProgressHUDError:respond viewContrller:vc];
        }
    }];
    
}
// MyRestaurantRoomSpaceViewController

/**
 *  餐厅员工管理视图控制器
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithRestaurantManagerVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    [SVProgressHUD showWithStatus:@"加载中"];
    NSInteger shopId = [UserLoginStateObject getCurrentShopId];
//    debugLog(@"shopId=%d", (int)shopId);
    [HCSNetHttp requestWithUserGetEmployeeList:shopId completion:^(id result) {
        TYZRespondDataEntity *respond = result;
        if (respond.errcode == respond_success || respond.errcode == respond_nodata)
        {
            [SVProgressHUD dismiss];
            MyRestaurantManagerViewController *managerVC = [[MyRestaurantManagerViewController alloc] initWithNibName:nil bundle:nil isStylePlain:YES firstShowRefresh:NO];
            managerVC.empList = respond.data;
            managerVC.popResultBlock = completion;
            [self showWithBaseVC:vc pushVC:managerVC];
        }
        else
        {
            [UtilityObject svProgressHUDError:respond viewContrller:vc];
        }
    }];
}
// MyRestaurantManagerViewController

/**
 *  餐厅档口视图控制器
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithRestaurantMouthVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    [SVProgressHUD showWithStatus:@"加载中"];
    NSInteger shopId = [UserLoginStateObject getCurrentShopId];
    [HCSNetHttp requestWithShopPrinterShow:shopId completion:^(id result) {
        TYZRespondDataEntity *respond = result;
        if (respond.errcode == respond_success || respond.errcode == respond_nodata)
        {
            [SVProgressHUD dismiss];
            MyRestaurantMouthViewController *mouthVC = [[MyRestaurantMouthViewController alloc] initWithNibName:nil bundle:nil isStylePlain:NO firstShowRefresh:NO];
            mouthVC.empList = respond.data;
//            [mouthVC responseWithShopPrinterShow:respond];
            mouthVC.popResultBlock = completion;
            [self showWithBaseVC:vc pushVC:mouthVC];
        }
        else
        {
            [UtilityObject svProgressHUDError:respond viewContrller:vc];
        }
    }];
    
    
}
// MyRestaurantMouthViewController

/**
 *  财务(收益)视图控制器
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithFinanceVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    MyFinanceViewController *myFinanceVC = [[MyFinanceViewController alloc] initWithNibName:nil bundle:nil];
    myFinanceVC.popResultBlock = completion;
    [self showWithBaseVC:vc pushVC:myFinanceVC];
}
//MyFinanceViewController

/**
 *  添加或者编辑员工信息视图控制器
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithShopManageEmployeVC:(UIViewController *)vc data:(id)data isAdd:(BOOL)isAdd positionAuth:(id)positionAuth completion:(void(^)(id data))completion
{
    CTCRestaurantManagerAddViewController *addVC = [[CTCRestaurantManagerAddViewController alloc] initWithNibName:nil bundle:nil isStylePlain:NO];
    addVC.isAdd = isAdd;
    addVC.managerEntity = data;
    addVC.postionAuthEntity = positionAuth;
    addVC.popResultBlock = completion;
    [self showWithBaseVC:vc pushVC:addVC];
}
//CTCRestaurantManagerAddViewController

/**
 *  员工权限说明视图控制器
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithShopManagePerMissVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    CTCRestaurantManagerPerMissViewController *permissVC = [[CTCRestaurantManagerPerMissViewController alloc] initWithNibName:nil bundle:nil];
    [self showWithBaseVC:vc pushVC:permissVC];
}
// CTCRestaurantManagerPerMissViewController


/**
 *  食客视图视图控制器
 *
 *  @param vc vc
 */
+ (void)showWithCustomerPayVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    [SVProgressHUD showWithStatus:@"加载中"];
    CTCMealOrderDetailsEntity *orderDetailEnt = data;
    
    [HCSNetHttp requestWithShopOrderPayChannel:^(TYZRespondDataEntity *respondCh) {
        if (respondCh.errcode == respond_success)
        {
            [HCSNetHttp requestWithShopOrderDiningDetails:orderDetailEnt.order_id shopId:orderDetailEnt.shop_id completion:^(TYZRespondDataEntity *result) {
                if (result.errcode == respond_success)
                {
                    [SVProgressHUD dismiss];
                    CTCCustomersPayViewController *payVC = [[CTCCustomersPayViewController alloc] initWithNibName:nil bundle:nil isStylePlain:YES];
                    payVC.payWayList = respondCh.data;
                    payVC.orderDetailEntity = result.data;
                    payVC.popResultBlock = completion;
                    [self showWithBaseVC:vc pushVC:payVC];
                }
                else
                {
                    [UtilityObject svProgressHUDError:result viewContrller:vc];
                }
            }];
        }
        else
        {
            [UtilityObject svProgressHUDError:respondCh viewContrller:vc];
        }
    }];
}
// CTCCustomersPayViewController
// CTCMealOrderDetailsEntity

/**
 *  管理员(老板)列表视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithRestaurantBossVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    [SVProgressHUD showWithStatus:@"加载中"];
    [HCSNetHttp requestWithSellerGetManageList:[UserLoginStateObject getUserInfo].seller_id completion:^(TYZRespondDataEntity *result) {
        if (result.errcode == respond_success || result.errcode == respond_nodata)
        {
            [SVProgressHUD dismiss];
            MyRestaurantManagerListViewController *managerVC = [[MyRestaurantManagerListViewController alloc] initWithNibName:nil bundle:nil isStylePlain:YES firstShowRefresh:NO];
            managerVC.managerList = result.data;
            managerVC.popResultBlock = completion;
            [self showWithBaseVC:vc pushVC:managerVC];
        }
        else
        {
            [UtilityObject svProgressHUDError:result viewContrller:vc];
        }
    }];
}
// MyRestaurantManagerListViewController

/**
 *  添加管理员(老板)视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithEditManagerVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    MyRestaurantAddManagerViewController *editManagerVC = [[MyRestaurantAddManagerViewController alloc] initWithNibName:nil bundle:nil isStylePlain:NO];
    editManagerVC.popResultBlock = completion;
    if (data)
    {
        editManagerVC.isAdd = NO;
        editManagerVC.managerEntity = data;
        editManagerVC.title = @"编辑";
    }
    else
    {
        editManagerVC.isAdd = YES;
        editManagerVC.title = @"添加";
    }
    [self showWithBaseVC:vc pushVC:editManagerVC];
}
// MyRestaurantAddManagerViewController

/**
 *  把餐厅分配给具体的人员
 *
 *  @param vc vc
 *  @param allShops 所有的餐厅
 *  @param selShops 选中的餐厅
 */
+ (void)showWithSelectShopVC:(UIViewController *)vc allShops:(NSArray *)allShops selShops:(NSArray *)selShops completion:(void(^)(id data))completion
{
    [SVProgressHUD showWithStatus:@"加载中"];
    NSInteger userId = [UserLoginStateObject getUserId];
    debugLog(@"userId=%d", (int)userId);
    [HCSNetHttp requestWithShopGetShopListbyUserId:userId sellerId:[UserLoginStateObject getUserInfo].seller_id completion:^(TYZRespondDataEntity *result) {
        if (result.errcode == respond_success)
        {
            [SVProgressHUD dismiss];
            MyRestaurantEditShopViewController *selShopsVC = [[MyRestaurantEditShopViewController alloc] initWithNibName:nil bundle:nil isStylePlain:YES];
            if (selShops)
            {
                selShopsVC.selectShopList = [NSMutableArray arrayWithArray:selShops];
            }
            else
            {
                selShopsVC.selectShopList = [NSMutableArray array];
            }
            
            NSMutableArray *list = [NSMutableArray new];
            for (ShopListDataEntity *shopEnt in result.data)
            {
                if (shopEnt.type == 1)
                {
                    [list addObject:shopEnt];
                }
            }
            
            selShopsVC.allShops = list;
            selShopsVC.popResultBlock = completion;
            [self showWithBaseVC:vc pushVC:selShopsVC];
        }
        else
        {
            [UtilityObject svProgressHUDError:result viewContrller:vc];
        }
    }];
}
// MyRestaurantEditShopViewController

/**
 *  管理员信息和他名下的餐厅视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithManagerInfoVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    [SVProgressHUD showWithStatus:@"加载中"];
    ShopManageNewDataEntity *mangeEnt = data;
    [HCSNetHttp requestWithSellerGetManageShop:mangeEnt.user_id sellerId:mangeEnt.seller_id completion:^(TYZRespondDataEntity *result) {
        if (result.errcode == respond_success || result.errcode == respond_nodata)
        {
            [SVProgressHUD dismiss];
            mangeEnt.shopList = result.data;
            MyRestaurantManagerInfoViewController *myanagerInfoVC = [[MyRestaurantManagerInfoViewController alloc] initWithNibName:nil bundle:nil isStylePlain:YES];
            myanagerInfoVC.manageEntity = mangeEnt;
            myanagerInfoVC.popResultBlock = completion;
            [self showWithBaseVC:vc pushVC:myanagerInfoVC];
        }
        else
        {
            [UtilityObject svProgressHUDError:result viewContrller:vc];
        }
    }];
}
// MyRestaurantManagerInfoViewController

/**
 *  外卖订单视图控制器
 *
 */
+ (void)showWithDeliveryOrdersVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    DeliveryOrdersViewController *deliveryOrderVC = [[DeliveryOrdersViewController alloc] init];
    [self showWithBaseVC:vc pushVC:deliveryOrderVC];
}
// DeliveryOrdersViewController

/**
 *  外卖设置视图控制器
 *
 */
+ (void)showWithDeliverySettingsVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    DeliverySettingsViewController *settingsVC = [[DeliverySettingsViewController alloc] initWithNibName:nil bundle:nil isStylePlain:NO];
    [self showWithBaseVC:vc pushVC:settingsVC];
}
// DeliverySettingsViewController

/**
 * 设置营业时间视图控制器
 */
+ (void)showWithDeliveryBusHoursVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion
{
    DeliveryBusinessHoursViewController *busHourVC = [[DeliveryBusinessHoursViewController alloc] initWithNibName:nil bundle:nil isStylePlain:NO];
    [self showWithBaseVC:vc pushVC:busHourVC];
}
// DeliveryBusinessHoursViewController

/**
 *  外卖，商家拒单视图控制器
 *
 *  @param type 1表示商家取消用户的订单；2表示商家取消达达的配送订单
 */
+ (void)showWithDeliveryCancelOrderVC:(UIViewController *)vc data:(id)data type:(int)type completion:(void(^)(id data))completion
{
    DeliveryCancelOrderViewController *cancelVC = [[DeliveryCancelOrderViewController alloc] initWithNibName:nil bundle:nil isStylePlain:NO];
    cancelVC.orderDetailEntity = data;
    cancelVC.type = type;
    cancelVC.popResultBlock = completion;
    if (type == 2)
    {// 取消达达配送
        [SVProgressHUD showWithStatus:@"加载中"];
        // sourceId = 73753 临时
        [HCSNetHttp requestWithDadaCancelOrderReq:@"73753" completion:^(TYZRespondDataEntity *result) {
            if (result.errcode == respond_success)
            {
                [SVProgressHUD dismiss];
                cancelVC.reasonList = result.data;
                [self showWithBaseVC:vc pushVC:cancelVC];
            }
            else
            {
                [UtilityObject svProgressHUDError:result viewContrller:vc];
            }
        }];
    }
    else
    {
        [self showWithBaseVC:vc pushVC:cancelVC];
    }
}
// DeliveryCancelOrderViewController

@end










