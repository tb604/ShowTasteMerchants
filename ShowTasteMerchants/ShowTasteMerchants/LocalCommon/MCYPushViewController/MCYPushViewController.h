//
//  MCYPushViewController.h
//  ChefDating
//
//  Created by 唐斌 on 16/5/12.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZCommonPushVC.h"
#import <CoreLocation/CoreLocation.h>

@interface MCYPushViewController : TYZCommonPushVC

/**
 *  显示登录视图控制器
 *
 *  @param vc         vc
 *  @param data       传入参数
 *  @param completion block
 */
+ (void)showWithUserLoginVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;

/**
 *  显示注册视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithUserRegisterVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;

/**
 *  显示找回密码视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithUserForgotPswVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;

/**
 *  重置密码视图控制器
 *
 *  @param vc vc
 *  @param data ，手机号码(phone)、验证码(code)
 *  @param completion block
 */
+ (void)showWithResetPasswordVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;


/**
 *  显示首页分类视图控制器
 *
 *  @param vc         vc description
 *  @param data       data description
 *  @param completion completion description
 */
+ (void)showWithRestaurantClassVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;

/**
 *  显示用户信息视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithUserInfoVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;

/**
 *  显示用户信息编辑视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithUserInfoModifyVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;

/**
 *  修改用户姓名
 *
 *  @param vc vc
 *  @param data data
 *  @param completion (data ({@"familyName":@"tang", @"lastName":@"bin"}))
 */
+ (void)showWithModifyUserNameVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;

/**
 *  修改信息
 *
 *  @param vc vc
 *  @param param data
 *  @param completion block
 */
+ (void)showWithModifyInfoVC:(UIViewController *)vc data:(NSDictionary *)param completion:(void(^)(id data))completion;

/**
 *  修改密码视图控制器
 *
 *  @param vc         vc description
 *  @param data       data
 *  @param completion block
 */
+ (void)showWithModifyPswVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;

/**
 *  显示修改手机视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithModifyMobileVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;

/**
 *  显示餐厅详情视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithShopDetailVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;

/**
 *  根据地址显示在地图上的位置
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithPositionMapVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;

/**
 *  绑定身份证视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithBindCardIdVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;
//CTCBindCardIdViewController

/**
 *  开餐厅第零步，检测是否有餐厅
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithOpenRestaurantZeroVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;
// CTCNoShopViewController

/**
 *  开餐厅第一步，选择餐厅菜的类别
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithOpenRestaurantFirstVC:(UIViewController *)vc data:(id)data inputEnt:(id)inputEnt completion:(void(^)(id data))completion;

/**
 *  开餐厅第二步，餐厅地址(暂时不要，改成餐厅城市)
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithOpenRestaurantAddressVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;

/**
 *  开餐厅第二步，餐厅城市
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithOpenRestaurantCityVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;

/**
 *  开餐厅第三部，餐厅名称
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithOpenRestaurantNameVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;

/**
 *  餐厅资质
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithShopQualificationVC:(UIViewController *)vc data:(id)data shopId:(NSInteger)shopId completion:(void(^)(id data))completion;
// CTCShopQualificationViewController

/**
 *  餐厅信息编辑视图
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithOpenRestaurantInfoVC:(UIViewController *)vc inputData:(id)inputData data:(id)data completion:(void(^)(id data))completion;

/**
 *  开餐厅的列表视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithOpenRestaurantListVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;

/**
 *  编辑多文本信息视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithRestaurantIntroEditVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;

/**
 *  编辑单文本信息视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithRestaurantSingleEditVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;

/**
 *  修改餐厅商圈的视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithRestaurantMallEditVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;

/**
 *  修改餐厅地址视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithRestaurantAddressEditVC:(UIViewController *)vc data:(id)data completion:(void(^)(NSString *name, NSString *address, CLLocationCoordinate2D coordinate))completion;

/**
 *  编辑餐厅菜单视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithResaurantMenuEditVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;

/**
 *  显示添加餐厅菜品类别视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithRestaurantAddFoodCategoryVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;

/**
 *  显示添加餐厅添加菜品的视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param type 1表示添加；2表示编辑
 *  @param foodEntity 菜品
 *  @param completion block
 */
+ (void)showWithRestaurantAddFoodVC:(UIViewController *)vc data:(id)data type:(NSInteger)type foodEntity:(id)foodEntity completion:(void(^)(id data))completion;

/**
 *  显示餐厅管理编辑视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithRestaurantManagerEditVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;

/**
 *  选择第三方支付方式视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithPartPayChoiceVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;

/**
 *  显示餐厅组图编辑视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithRestaurantEditMainImageVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;

/**
 *  显示，选择菜品类别的视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithChoiceFoodCategoryVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;

/**
 *  显示，选择档口视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithChoicePrinterVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;

/**
 *  添加价格和单位
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithAddFoodPriceVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;

/**
 *  添加菜品相关图片信息视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithAddFoodRelatedInfoVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;

/**
 *  显示餐厅详情预览视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithRestaurantPreviewVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;

#pragma mark 食客端
/**
 *  显示预订餐厅视图控制器
 *
 *  @param vc vc
 *  @param data 数据
 *  @param completion block
 */
+ (void)showWithRestaurantReservationVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;


/**
 *  显示选择日期视图控制器
 *
 *  @param vc        vc
 *  @param days      选择的天数
 *  @param title     标题
 *  @param startDate 开始日期
 */
+ (void)showWithCalendarVC:(UIViewController *)vc days:(NSInteger)days title:(NSString *)title startDate:(NSString *)startDate multChoice:(BOOL)multChoice completion:(void (^)(NSArray *))completion;

/**
 *  食客的订单详情视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithDinersOrderDetailVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;

/**
 *  餐厅端订单详情视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithShopOrderDetailVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;
// ShopOrderDetailViewController

/**
 *  食客订单取消视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithDinersCancelOrderVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;

/**
 *  食客端预订完成订单详情视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
//+ (void)showWithReserveCompleteOrderVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;

/**
 *  就餐完，结算清单
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithWantPayVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;

/**
 *  显示支付方式视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithPayWayVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;

/**
 *  支付成功后，进入的订单视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithPaySuccessOrderVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;

/**
 *  支付完成后，点击进入评论视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithEvaluationPaySucVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;

/**
 *  食客获取菜谱，显示菜谱视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithRecipeVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;
// DinersRecipeViewController

/**
 *  显示即时就餐视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithEvenDiningVC:(UIViewController *)vc data:(id)data  completion:(void(^)(id data))completion;

/**
 *  菜谱里面，进入菜品详情视图控制器，可以直接加入购物车
 *
 *  @param vc vc
 *  @param data data
 *  @param shopCartList 购物车列表
 *  @param isBrowse 是否是预览
 *  @param completion block
 */
+ (void)showWithDinersRecipeFoodDetailVC:(UIViewController *)vc data:(id)data shopCartList:(NSArray *)shopCartList isBrowse:(BOOL)isBrowse completion:(void(^)(id data))completion;

/**
 *  显示食客创建订单视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithDinersCreateOrderVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;

/**
 *  显示档口编辑视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithShopMouthEditVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;
// MyRestaurantMouthEditViewController

/**
 *  搜索视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithDinersSearchVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;
// DinersSearchViewController

/**
 *  搜索结果视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithDinersSearchResultVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;

/**
 *  新的搜索结果视图控制器
 *
 *  @param vc vc
 *  @param data data
    @param type 1表示data是key；2表示data是标题；3表示data是对象
 *  @param completion block
 */
+ (void)showWithDinersNewSearchResultVC:(UIViewController *)vc data:(id)data type:(NSInteger)type completion:(void(^)(id data))completion;
// DinersSearchResultNewViewController

/**
 *  显示退款订单详情视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
//+ (void)showWithDinersRefundOrderDetailVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;
// DinersRefundOrderDetailViewController

/**
 *  餐厅评论列表视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithShopCommentListVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;
// ShopCommentListViewController

/**
 *  获取待处理订单的视图
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithWaitingNoticeOrderVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;
// WaitingNoticeOrderViewController


#pragma mark 我的
/**
 *  显示我的收藏视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithMyCollectionListVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;
// MyCollectionListViewController

/**
 *  我的钱包视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithMyWalletVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;

/**
 *  我的钱包明细视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithMyWalletDetailVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;
// MyWalletDetailViewController

/**
 *  我的钱包支付方式的视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithMyWalletPayWayVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;
// MyWalletThirdPayWayViewController

/**
 *  我的钱包充值视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithMyWalletTopUpVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;
// MyWalletTopUpViewController

/**
 *  我的钱包提现视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithMyWalletDrawalVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;
// MyWalletWithdrawalViewController

/**
 *  我的钱包流水详情视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithMyWalletDetailStreamVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;
// MyWalletDetailStreamViewController

/**
 *  显示加入推广视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithJoinPromotionVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;
// MyJoinPromotionViewController

/**
 *  显示我的设置视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithMySettingsVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;
//  MySettingsViewController

/**
 *  显示关于视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithMyAboutVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;
// MyAboutViewController


/**
 *  补单管理视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithRepairVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;
// ShopRepairManagerViewController

/**
 *  菜单列表
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithShopMenuVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;
// MyRestaurantMenuViewController

/**
 *  空间编辑视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithRoomSpaceVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;
// MyRestaurantRoomSpaceEditViewController

/**
 *  添加或者修改空间视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithRSEditVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;
// MyRestaurantRoomSpaceAddViewController

/**
 *  今日订单汇总
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithFinanceTodayOrderListVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;
// MyFinanceTodayOrderListViewController

/**
 *  完成的订单详情视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param modeType   1表示餐厅端；2表示食客端
 *  @param completion block
 */
+ (void)showWithFinishOrderDetailVC:(UIViewController *)vc data:(id)data modeType:(NSInteger)modeType completion:(void(^)(id data))completion;
//FinishedOrderDetailViewController

/**
 *  今日订单汇总视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithTodayOrderSummaryVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;
// MyFinanceTodayOrderSummaryViewController

/**
 *  日汇总视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithAggregateVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;
// MyFinanceTodayAggregateViewController

/**
 *  推广收益视图控制器
 *
 *  @param vc vc
 *  @param data vc
 *  @param completion block
 */
+ (void)showWithEarningVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;
// PromotionEarningViewController

/**
 *  附近餐厅列表视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithNearShopVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;
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
+ (void)showWithTakeOrderVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;
// CTCRestaurantTakeOrderViewController


/**
 *  餐中订单视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithMealingOrderVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;
// ShopMealingOrderViewController

/**
 *  餐前订单视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param type 1表示点击通知后，进入餐前订单；2表示预定订单
 *  @param completion block
 */
+ (void)showWithReservationOrderVC:(UIViewController *)vc data:(id)data type:(int)type completion:(void(^)(id data))completion;
// ShopReservationOrderViewController

/**
 *  历史订单视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithFinishOrderVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;
// ShopFinishOrderViewController


/**
 *  餐厅资料视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithRestaurantInfoVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;
// MyRestaurantDataViewController

/**
 *  餐厅菜单菜品视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithRestaurantMenuVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;
// MyRestaurantMenuViewController

/**
 *  餐厅空间视图控制器(餐位)
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithRestaurantRoomSpaceVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;
// MyRestaurantRoomSpaceViewController

/**
 *  餐厅员工管理视图控制器
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithRestaurantManagerVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;
// MyRestaurantManagerViewController

/**
 *  餐厅档口视图控制器
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithRestaurantMouthVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;
// MyRestaurantMouthViewController

/**
 *  财务(收益)视图控制器
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithFinanceVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;
//MyFinanceViewController

/**
 *  添加或者编辑员工信息视图控制器
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithShopManageEmployeVC:(UIViewController *)vc data:(id)data isAdd:(BOOL)isAdd positionAuth:(id)positionAuth completion:(void(^)(id data))completion;
//CTCRestaurantManagerAddViewController

/**
 *  员工权限说明视图控制器
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithShopManagePerMissVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;
// CTCRestaurantManagerPerMissViewController




// CTCUserInfoViewController

/**
 *  食客视图视图控制器
 *
 *  @param vc vc
 */
+ (void)showWithCustomerPayVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;
// CTCCustomersPayViewController

/**
 *  管理员(老板)列表视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithRestaurantBossVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;
// MyRestaurantManagerListViewController

/**
 *  添加管理员(老板)视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithEditManagerVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;
// MyRestaurantAddManagerViewController

/**
 *  把餐厅分配给具体的人员
 *
 *  @param vc vc
 *  @param allShops 所有的餐厅
 *  @param selShops 选中的餐厅
 */
+ (void)showWithSelectShopVC:(UIViewController *)vc allShops:(NSArray *)allShops selShops:(NSArray *)selShops completion:(void(^)(id data))completion;
// MyRestaurantEditShopViewController

/**
 *  管理员信息和他名下的餐厅视图控制器
 *
 *  @param vc vc
 *  @param data data
 *  @param completion block
 */
+ (void)showWithManagerInfoVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;
// MyRestaurantManagerInfoViewController

/**
 *  外卖订单视图控制器
 *
 */
+ (void)showWithDeliveryOrdersVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;
// DeliveryOrdersViewController

/**
 *  外卖设置视图控制器
 *
 */
+ (void)showWithDeliverySettingsVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;
// DeliverySettingsViewController

/**
 * 设置营业时间视图控制器(外卖)
 */
+ (void)showWithDeliveryBusHoursVC:(UIViewController *)vc data:(id)data completion:(void(^)(id data))completion;
// DeliveryBusinessHoursViewController

/**
 *  外卖，商家拒单视图控制器
 *
 *  @param type 1表示商家取消用户的订单；2表示商家取消达达的配送订单
 */
+ (void)showWithDeliveryCancelOrderVC:(UIViewController *)vc data:(id)data type:(int)type completion:(void(^)(id data))completion;
// DeliveryCancelOrderViewController

@end















