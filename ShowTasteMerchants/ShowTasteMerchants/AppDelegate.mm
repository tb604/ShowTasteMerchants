//
//  AppDelegate.m
//  ShowTasteMerchants
//
//  Created by 唐斌 on 16/9/28.
//  Copyright © 2016年 唐斌. All rights reserved.
//

// com.chinatopchef.ShowTasteMerchants
// com.chinatopchef.ShowTasteMerchants

#import "AppDelegate.h"
#import "ViewController.h"
#import "LocalCommon.h"
#import "HCSLocationManager.h" // 定位
#import "TYZCustomNavController.h"
#import "MyInfoViewController.h"
#import "UserLoginStateObject.h"
#import "WYXRongCloudMessage.h" // 融云
#import <ShareSDK/ShareSDK.h> // 第三方分享
#import "WXApi.h" // 微信
#import "WeiboSDK.h" // 新浪微博

#import "TYZDBManager.h"
// 分享import
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDKUI.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
// 第三方平台sdk头文件，根据需要的平台导入
// 以下分别对应微信、新浪微博、腾信微博
#import "WXApi.h"   // 微信
#import "WeiboSDK.h" // 新浪微博
//#import "WeiboApi.h" // 腾信微博

// 以下是腾讯QQ和QQ空间
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

#import <AlipaySDK/AlipaySDK.h> // 支付宝

#import "WXPayManager.h" // 微信支付

#import "WaitingNoticeOrderView.h" // 消息视图

#import "WaitingNoticeOrderViewController.h"
#import "OrderDataEntity.h"
#import "CTCMainPageViewController.h" // 首页视图控制器
#import "UserLoginViewController.h"
#import "CTCLoginChoiceUserViewController.h" // 选择老板或者员工
#import "CTCLoginViewController.h" // 登录视图控制器
#import "HungryBaseInfoObject.h" // 外卖订单


//#import "HungryOrderInputTableEntity.h"


@interface AppDelegate () <UITabBarControllerDelegate>
{
    
    /**
     *  0普通模式；1经营模式
     */
//    NSInteger _userMode;
    
    WaitingNoticeOrderView *_waitingNoticeOrderView;
}

/// 外卖订单object
@property (nonatomic, strong) HungryBaseInfoObject *hungryObject;

@property (nonatomic, assign) NSInteger selectIndex;

//@property (nonatomic, strong) TYZCustomTabBarController *rootViewController;

@property (nonatomic, strong) ManagerModeTabBarController *rootViewController;

@property (nonatomic, strong) TYZCustomNavController *nav;

/// 登录视图控制器
@property (nonatomic, strong) TYZCustomNavController *loginNav;

//@property (nonatomic, strong) UIViewController *navRootVC;

/**
 *  定位
 */
@property (nonatomic, strong) HCSLocationManager *locationManager;

/**
 *  待处理的订单
 */
@property (nonatomic, strong) NSArray *waitingOrderList;

/**
 *  启动时，初始化的信息
 */
- (void)initWithSetup:(UIApplication *)application;

/// 等待处理的订单更新
- (void)changeWithWaitingOrder:(NSNotification *)note;
@end

@implementation AppDelegate

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kWYXClientReceiveMessageNotification object:nil];
    
    // 更新等待处理通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kORDERWAITINGDEALNOTE object:nil];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
//    _userMode = [UserLoginStateObject getUserInfo].userMode;
    
//    float height = [[UITabBar appearance] bounds].size.height;
//    debugLog(@"tabHeight=%.2f", height);
    
//    debugLog(@"userid=%d", (int)[UserLoginStateObject getUserId]);
    
    [self loadRootVC];
    
    // 初始化推送
    [UtilityObject initWithRegisterForRemote:application];
    
    self.hungryObject = [HungryBaseInfoObject shareInstance];
    
    // 初始化
    [self performSelector:@selector(initWithSetup:) withObject:application afterDelay:5];
    
    
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    if (!_locationManager)
    {
        self.locationManager = [HCSLocationManager shareInstance];
    }
    __weak typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        CLLocationCoordinate2D coordinate = {0.0, 0.0};
        
        [weakSelf.locationManager locationGetCodeSearch:coordinate isiniSwitch:NO];
        
        // 通过订单获取订单详情
        [weakSelf.hungryObject orderIdToOrderDetail];
        
        // 获取用户信息
//        [HCSNetHttp requestWithUser:[UserLoginStateObject getUserId] completion:nil];
    });
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [UserLoginStateObject saveLoginState:EUserUnlogin];
}



#pragma mark -

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //        debugLog(@"ios8以上推送注册成功");
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
    // Handle the actions.
    if ([identifier isEqualToString:@"declineAction"])
    {
        
    }
    else if ([identifier isEqualToString:@"answerAction"])
    {
        
    }
}
#endif

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    //    debugMethod();
}

// 注册推送通知成功后调用(获取苹果推送权限成功)
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    debugLog(@"ios8以下的推送通知注册成功");
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    // 将token保存在本地
    debugLog(@"token=%@, len(token)=%d", token, (int)[token length]);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 设置融云推送的token
        [[WYXRongCloudMessage shareInstance] setDeviceTokend:token];
        
        // 保存相关信息到本地
        [UserLoginStateObject saveWithDeviceToken:token];
    });
    
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    debugMethod();
    /*
     key=aps; value={
     alert = "51tourapp\U8f6f\U4ef6";
     badge = 8;
     sound = default;
     }
     */
    
    // app 收到推送的通知
    //    [BPush handleNotification:userInfo];
    /*debugLog(@"userInfo_1=%@", userInfo);
     
     NSString *alertStr = nil;
     NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
     NSObject *alert = [apsInfo objectForKey:@"alert"];
     if ([alert isKindOfClass:[NSString class]])
     {
     alertStr = (NSString *)alert;
     }
     else if ([alert isKindOfClass:[NSDictionary class]])
     {
     NSDictionary *alertDict = (NSDictionary *)alert;
     alertStr = [alertDict objectForKey:@"body"];
     }*/
    
    //    if (alertStr)
    //    {
    //        PushInfoEntity *entity = [[PushInfoEntity alloc] init];
    //        entity.infoTitle = @"";
    //        entity.infoMsg = alertStr;
    //        entity.readState = 1;
    //        entity.regtime = [NSString stringWithFormat:@"%@", [NSDate getNowDateTime]];
    //        //        debugLog(@"pushInfo=%@", entity);
    //        [[TBDatabaseManager shareInstance] insertPushInfo:entity];
    //        CC_SAFE_RELEASE_NULL(entity);
    //    }
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

// 此方法是，用户点解了通知，应用在前台或者开启后台，并且应用在后台时，调用
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    debugMethod();
    
    // app 收到推送的通知
    //    [BPush handleNotification:userInfo];
    // $body = array("aps"=>array("content-available"=>1, "alert"=>"舒服舒服大夫说分手都发生奋斗对方身上地方地方", "badge"=>8, "sound"=>"default"));
    
    // 为了能够让软件后台的时候，也能让通知给软件收到，要加入："content-available"=>1
    debugLog(@"userInfo_2=%@", userInfo);
    //    debugMethod();
    
    /*NSString *alertStr = nil;
     NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
     NSObject *alert = [apsInfo objectForKey:@"alert"];
     if ([alert isKindOfClass:[NSString class]])
     {
     alertStr = (NSString *)alert;
     }
     else if ([alert isKindOfClass:[NSDictionary class]])
     {
     NSDictionary *alertDict = (NSDictionary *)alert;
     alertStr = [alertDict objectForKey:@"body"];
     }*/
    
    //    if (alertStr)
    //    {
    //        PushInfoEntity *entity = [[PushInfoEntity alloc] init];
    //        entity.infoTitle = @"";
    //        entity.infoMsg = alertStr;
    //        entity.readState = 1;
    //        entity.regtime = [NSString stringWithFormat:@"%@", [NSDate getNowDateTime]];
    //        //        debugLog(@"pushInfo=%@", entity);
    //        [[TBDatabaseManager shareInstance] insertPushInfo:entity];
    //        CC_SAFE_RELEASE_NULL(entity);
    //    }
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}


#pragma mark 如果使用SSO（可以简单理解成客户端授权），以下方法是必须要的



- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    //    debugMethod();
    NSString *scheme = [NSString stringWithFormat:@"%@", url.scheme];
    //    debugLog(@"scheme=%@", scheme);
    
    if ([[url scheme] isEqualToString:WXAPPID])
    {
        return [WXApi handleOpenURL:url delegate:[WXPayManager sharedManager]];
    }
    else if ([url.host isEqualToString:@"safepay"] && [scheme isEqualToString:@"alipayshowtaste"])
    {// 支付宝
        debugLog(@"支付宝返回1");
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            //            debugLog(@"%s--result=%@", __func__, resultDic);
        }];
        return YES;
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options
{
    //    debugMethod();
    NSString *scheme = [NSString stringWithFormat:@"%@", url.scheme];
    //    debugLog(@"scheme=%@", scheme);
    
    if ([[url scheme] isEqualToString:WXAPPID])
    {
        return [WXApi handleOpenURL:url delegate:[WXPayManager sharedManager]];
    }
    else if ([url.host isEqualToString:@"safepay"] && [scheme isEqualToString:@"alipayshowtaste"])
    {// 支付宝
        debugLog(@"支付宝返回2");
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            debugLog(@"result=%@", resultDic);
            [[NSNotificationCenter defaultCenter] postNotificationName:kAliPayNotification object:resultDic];
        }];
        return YES;
    }
    return YES;
}

// ios 4.2+
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //    debugMethod();
    //    debugLog(@"host=%@", url.host);
    NSString *scheme = [NSString stringWithFormat:@"%@", url.scheme];
    //    debugLog(@"scheme=%@", scheme);
    if ([url.host isEqualToString:@"safepay"] && [scheme isEqualToString:@"alipayshowtaste"])
    {// 支付宝
        debugLog(@"准备支付宝状态:url=%@", url.absoluteString);
        debugLog(@"支付宝返回3");
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //            debugLog(@"%s--result3=%@", __func__, resultDic);
            [[NSNotificationCenter defaultCenter] postNotificationName:kAliPayNotification object:resultDic];
        }];
        
        return YES;
    }
    else if ([[url scheme] isEqualToString:WXAPPID] && [url.host isEqualToString:@"pay"])
    {
        debugLog(@"微信支付");
        return [WXApi handleOpenURL:url delegate:[WXPayManager sharedManager]];
    }
    return YES;
}


/**
 *  启动时，初始化的信息
 */
- (void)initWithSetup:(UIApplication *)application
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 设置
        [UtilityObject setSvProgressHUD];
        
        // 初始化推送
        //        [UtilityObject initWithRegisterForRemote:application];
        
        // 写信息到本地
        if (![UserLoginStateObject getUserInfoDataKeyChain])
        {
            debugLog(@"用户基础信息未空");
            [UserLoginStateObject saveWithDeviceToken:@""];
        }
        
        // 初始化融云
        [[WYXRongCloudMessage shareInstance] connectRCIMServer];
        
        // 初始化分享
        [UtilityObject initWithShareSDK];
        
        // 初始化盟友
        [UtilityObject initWithMobClick];
        
        // 获取圈子的认证信息
//        [HCSNetHttp requestWithUserAuthorize:nil];
        
//        // 数据库
//        HungryOrderInputTableEntity *ent = [HungryOrderInputTableEntity new];
//        ent.userId = [UserLoginStateObject getUserId];
//        ent.shopId = [UserLoginStateObject getCurrentShopId];
//        ent.orderId = @"12345645";
//        ent.provider = 1;
//        ent.state = 0;
//        [[TYZDBManager shareInstance] insertWithOrderInfo:ent];
//        
//        NSArray *array = [[TYZDBManager shareInstance] getWithAllOrderInfo:[UserLoginStateObject getUserId]];
//        for (HungryOrderInputTableEntity *ent in array)
//        {
//            debugLog(@"ent.orderId=%@", ent.orderId);
//        }
        
        // 获取收藏列表
        /*[HCSNetHttp requestWithUserFavorite:[UserLoginStateObject getUserId] completion:^(id result) {
            TYZRespondDataEntity *respond = result;
            for (id cshopId in respond.data)
            {
                NSInteger shopId = [cshopId integerValue];
                [[TYZDBManager shareInstance] insertWithCollection:[UserLoginStateObject getUserId] shopId:shopId];
            }
        }];*/
        
        // 注册接收消息的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderWithReceivePushNote:) name:kWYXClientReceiveMessageNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeWithWaitingOrder:) name:kORDERWAITINGDEALNOTE object:nil];
    });
}


- (void)loadRootVC
{
    
    // 标题的font
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:19]}];
    //    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHexString:@"#00bbfc"]];
    // 去除自带的顶部阴影
//    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    // 设置导航栏控制器颜色
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#393b40"]] forBarMetrics:UIBarMetricsDefault];
    //    debugLog(@"translucent=%d", [UINavigationBar appearance].translucent);
    if ([[UINavigationBar appearance] respondsToSelector:@selector(setTranslucent:)])
    {
        [[UINavigationBar appearance] setTranslucent:NO];
    }
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    if (!_nav)
    {
        CTCMainPageViewController *mainvc = [[CTCMainPageViewController alloc] initWithNibName:nil bundle:nil isStylePlain:NO];
        TYZCustomNavController *mainNav = [[TYZCustomNavController alloc] initWithRootViewController:mainvc];
        self.nav = mainNav;
    }
    
    if (!_loginNav)
    {
        _loginNav = [[TYZCustomNavController alloc] init];
    }
    
    // 1表示老板；2表示员工
    NSInteger type = [UserLoginStateObject readWithUserLoginType];
    debugLog(@"usertype=%d", (int)type);
    
    debugLog(@"loginstate=%d", (int)[UserLoginStateObject userLoginState]);
    
    UIViewController *loginVC = nil;
    if (type == 0)
    {
        loginVC = [[CTCLoginChoiceUserViewController alloc] initWithNibName:nil bundle:nil];
    }
    else
    {
        CTCLoginViewController *uloginVC = [[CTCLoginViewController alloc] initWithNibName:nil bundle:nil];
        uloginVC.userLoginType = type;
        loginVC = uloginVC;
    }
    
    
    [_loginNav setViewControllers:@[loginVC]];
    NSInteger loginState = [UserLoginStateObject userLoginState];
    debugLog(@"loginState=%d", (int)loginState);
    if (loginState == EUserUnlogin)
    {
        debugLog(@"登录");
        [self.window setRootViewController:_loginNav];
    }
    else
    {
        [self.window setRootViewController:_nav];
    }

    
//        [self initWithManagerRootVC];
//        [self.window setRootViewController:_rootViewController];
    
    
    
}

//- (void)loadRootVC
//{
////    _userMode = mode;
//    [self loadRootVC];
//}

//- (void)updateWithNavType:(NSInteger)type
//{
//    if (_userMode == 0)
//    {// 普通模式
//        [_rootViewController updateWithNavType:type];
//    }
//}

- (void)initWithManagerRootVC
{
    if (!_rootViewController)
    {
        _rootViewController = [[ManagerModeTabBarController alloc] initWithShowMiddleBtn:NO];
        _rootViewController.delegate = self;
        
        [self initWithWaitingNoticeOrderView];
    }
}

//- (void)initWithGeneralRootVC
//{
//    if (!_rootViewController)
//    {
//        _rootViewController = [[TYZCustomTabBarController alloc] initWithShowMiddleBtn:NO];
//        _rootViewController.delegate = self;
//    }
//}

- (CGFloat)tabBarHeight
{
    CGFloat height = _rootViewController.appTabBarHeight;
    if (height == 0.0)
    {
        height = 49.0;
    }
    return height;
}

- (CGFloat)navBarHeight
{
    CGFloat height = _rootViewController.appNavBarHeight;

    if (height == 0.0)
    {
        height = 44.0;
    }
    return height;
}

- (void)showWithUserInfoVC:(BOOL)show
{
    
    /*if (show)
    {
        debugLog(@"if");
        UIViewController *_navRootVC = [[UIViewController alloc] init];
        _nav = [[TYZCustomNavController alloc] initWithRootViewController:_navRootVC];
        _nav.navigationBarHidden = YES;
        _nav.view.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        
        [self.window addSubview:_nav.view];
        MyInfoViewController *vc = [[MyInfoViewController alloc] initWithNibName:nil bundle:nil];
        [_navRootVC.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        debugLog(@"else");
        [_nav.view removeFromSuperview];
    }*/
}

- (void)initWithWaitingNoticeOrderView
{
    if (!_waitingNoticeOrderView)
    {
        AppDelegate *app = [UtilityObject appDelegate];
        CGRect frame = CGRectMake(0, [[UIScreen mainScreen] screenHeight] - [app tabBarHeight] - 40, [[UIScreen mainScreen] screenWidth], 40);
        _waitingNoticeOrderView = [[WaitingNoticeOrderView alloc] initWithFrame:frame];
        [_rootViewController.view addSubview:_waitingNoticeOrderView];
        
        // 暂时
        _waitingNoticeOrderView.hidden = YES;
        NotifyMessageEntity *ent = [NotifyMessageEntity new];
        ent.notify_type = 1;
        
        NSNotification *note = [[NSNotification alloc] initWithName:kWYXClientReceiveMessageNotification object:ent userInfo:nil];
        [self orderWithReceivePushNote:note];
        
    }
    __weak typeof(self)weakSelf = self;
    _waitingNoticeOrderView.viewCommonBlock = ^(id data)
    {
        WaitingNoticeOrderViewController *waitingOrderVC = [[WaitingNoticeOrderViewController alloc] initWithNibName:nil bundle:nil isStylePlain:NO firstShowRefresh:NO];
        TYZCustomNavController *managerOrderNav = [[TYZCustomNavController alloc] initWithRootViewController:waitingOrderVC];
        [weakSelf.rootViewController presentViewController:managerOrderNav animated:YES completion:nil];
        waitingOrderVC.popResultBlock = ^(id data)
        {
            if (data)
            {
                weakSelf.waitingOrderList = data;
            }
            [weakSelf hiddenWithTipView:NO isTop:NO];
        };
    };
}

- (void)hiddenWithTipView:(BOOL)hidden isTop:(BOOL)isTop
{
//    if (_userMode == 0)
//    {// 普通用户
//        _waitingNoticeOrderView.hidden = YES;
//        return;
//    }
    NSInteger count = [_waitingOrderList count];
    debugLog(@"count=%d", (int)count);
    if (!hidden)
    {
        if (count == 0)
        {
            hidden = YES;
        }
        else
        {
            hidden = NO;
        }
    }
    _waitingNoticeOrderView.hidden = hidden;
    NSString *strNum = [NSString stringWithFormat:@"%d", (int)count];
    [_waitingNoticeOrderView updateViewData:strNum];
    
    if ([_rootViewController hiddenWithWaitView] && isTop)
    {
        _waitingNoticeOrderView.hidden = YES;
    }
}

/**
 *  推送的时候，接收到通知
 *
 *  @param note note
 */
- (void)orderWithReceivePushNote:(NSNotification *)note
{
//    if (_userMode == 0)
//    {
//        _waitingNoticeOrderView.hidden = YES;
//        return;
//    }
    debugMethod();
    id msgEnt = [note object];
    if (![msgEnt isKindOfClass:[NotifyMessageEntity class]])
    {
        return;
    }
    NotifyMessageEntity *notifyMsg = (NotifyMessageEntity *)msgEnt;
    debugLog(@"type=%d", (int)notifyMsg.notify_type);
    
    if (notifyMsg.notify_type == 1)
    {// 消息通知
        [HCSNetHttp requestWithOrderWaitProcessOrders:[UserLoginStateObject getCurrentShopId] completion:^(id result) {
            TYZRespondDataEntity *respond = result;
            if (respond.errcode == respond_success)
            {
                NSArray *list = respond.data;
                self.waitingOrderList = list;
                if ([list count] != 0)
                {
                    [self hiddenWithTipView:NO isTop:YES];
                }
                else
                {
                    [self hiddenWithTipView:YES isTop:NO];
                }
            }
        }];
        
    }
}

- (void)changeWithWaitingOrder:(NSNotification *)note
{
    //debugMethod();
    OrderDataEntity *orderEnt = (OrderDataEntity *)[note object];
    //debugLog(@"orderEnt.state=%d", (int)orderEnt.status);
    // NS_ORDER_WAITING_PAY_DEPOSIT_STATE 110 已接单
    // waitingOrderList
    NSMutableArray *orderList = [NSMutableArray arrayWithArray:_waitingOrderList];
    OrderDataEntity *deleteEnt = nil;
    for (OrderDataEntity *ent in orderList)
    {
        //debugLog(@"for.orderId=%@; orderId=%@", ent.order_id, orderEnt.order_id);
        if ([orderEnt.order_id isEqualToString:ent.order_id])
        {
            deleteEnt = ent;
            break;
        }
    }
    if (deleteEnt)
    {
        [orderList removeObject:deleteEnt];
    }
    self.waitingOrderList = orderList;
    NSInteger count = [_waitingOrderList count];
    if (count != 0)
    {
        [self hiddenWithTipView:NO isTop:YES];
    }
    else
    {
        [self hiddenWithTipView:YES isTop:NO];
    }
}


#pragma mark start UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (tabBarController.selectedIndex == 3)
    {
        [self showWithUserInfoVC:YES];
        
        tabBarController.selectedIndex = _selectIndex;
    }
    else
    {
        _selectIndex = tabBarController.selectedIndex;
    }
    
    //    debugLog(@"selectindex=%d", (int)_selectIndex);
}
#pragma mark end UITabBarControllerDelegate


@end
