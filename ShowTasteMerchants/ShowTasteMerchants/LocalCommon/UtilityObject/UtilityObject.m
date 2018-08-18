//
//  UtilityObject.m
//  51tourGuide
//
//  Created by 唐斌 on 16/4/27.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "UtilityObject.h"
#import "UserDataKeyChain.h"
#import "TYZUserDataManager.h"
#import "UserLoginStateObject.h"
#import "SvUDIDTools.h"
#import "TYZKit.h"
//#import "GetTheOrderViewController.h"
#import "TYZCustomNavController.h"
//#import "WYXEmptyContentView.h"
#import "SVProgressHUD.h"
#import "LocalCommon.h"


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

#import "WXPayManager.h"

@interface UtilityObject () <WXApiDelegate>

@end

@implementation UtilityObject

/**
 *  保存用户的基本信息，保存在手机上，就算是删除了app，这个信息也是存在的
 *
 *  @param token <#token description#>
 */
//+ (void)saveWithUserDataKeyObject:(NSString *)token
//{
//    UserDataKeyChain *userData = [TYZUserDataManager readUserData];
//    if (!userData)
//    {
//        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[SvUDIDTools UDID], @"userIdentifity", token, @"userDeviceToken", @(0), @"loginState", @"", @"userPhone", @"", @"travelersToken", @(0), @"userId", @"", @"userPsw", nil];
//        userData = [UserDataKeyChain modelWithDictionary:dict];
//    }
//    if (token)
//    {
//        userData.userDeviceToken = token;
//    }
//    [TYZUserDataManager saveUserData:userData];
//}

/**
 *  读取
 *
 *  @return
 */
//+ (UserDataKeyChain *)readWithuserDataKeyObject
//{
//    UserDataKeyChain *userData = [TYZUserDataManager readUserData];
//    return userData;
//}

/** 初始化注册推送 */
+ (void)initWithRegisterForRemote:(UIApplication *)application
{
    //注册推送
    if (kiOS8Later)
    {// 在ios8下注册苹果推送，申请推送权限
        debugLog(@"ios8以上");
        UIUserNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        //        application.applicationIconBadgeNumber = 0;
    }
    else
    {
        //        debugLog(@"ios8以下");
        // 注册苹果推送，申请推送权限
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
}

+ (TYZCustomNavController *)initWithRootVC
{
    /*GetTheOrderViewController *tripVC = [[GetTheOrderViewController alloc] initWithNibName:nil bundle:nil isStylePlain:NO firstShowRefresh:NO];
    TYZCustomNavController *rootViewController = [[TYZCustomNavController alloc] initWithRootViewController:tripVC];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];
    //    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHexString:@"#00bbfc"]];
    // 设置导航栏控制器颜色
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#00bbfc"]] forBarMetrics:UIBarMetricsDefault];
    //    debugLog(@"translucent=%d", [UINavigationBar appearance].translucent);
    if ([[UINavigationBar appearance] respondsToSelector:@selector(setTranslucent:)])
    {
        [[UINavigationBar appearance] setTranslucent:NO];
    }
    return rootViewController;
     */
    return nil;
}

/**
 * @brief 把缓冲数据存储到本地
 * @param arckey 键
 * @param filename文件名
 * @param said 存储到制定文件中的对象
 */
+ (void)saveCacheDataLocalKey:(NSString *)arckey saveFilename:(NSString *)filename saveid:(id)said
{
    NSMutableData *mutdata = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:mutdata];
    [archiver encodeObject:said forKey:arckey];
    [archiver finishEncoding];
    NSString *filePath = [UIApplication appendDocumentsPath:filename];
    [mutdata writeToFile:filePath atomically:YES];
}

/**
 * @brief 从本地读取缓存里面的数据
 * @param arckey 键
 * @param filename文件名
 */
+ (id)readCacheDataLocalKey:(NSString *)arckey saveFilename:(NSString *)filename
{
    id calid = nil;
    NSString *filePath = [UIApplication appendDocumentsPath:filename];
    if ([UIApplication isFileExit:filePath])
    {
        NSData *data = [[NSMutableData alloc] initWithContentsOfFile:filePath];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        calid = [unarchiver decodeObjectForKey:arckey];
        [unarchiver finishDecoding];
//        CC_SAFE_RELEASE_NULL(unarchiver);
//        CC_SAFE_RELEASE_NULL(data);
    }
    return calid;
}

/**
 * @brief 删除缓存里面的数据
 * @param arckey 键
 * @param filename文件名
 */
+ (void)removeCacheDataLocalKey:(NSString *)arckey fileName:(NSString *)filename
{
    NSString *filePath = [UIApplication appendDocumentsPath:filename];
    if ([UIApplication isFileExit:filePath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
}

+ (AppDelegate *)appDelegate
{
    return(AppDelegate *) [UIApplication sharedApplication].delegate;
}

//+ (WYXEmptyContentView *)showEmptContentView:(UIView *)superView
//{
//    WYXEmptyContentView *view = [[WYXEmptyContentView alloc] initWithFrame:CGRectMake(0.0f, 40.0f, [[UIScreen mainScreen] screenWidth], 105.0f)];
//    [superView addSubview:view];
//    return view;
//}

/**
 *  图标的背景色
 *
 *  @param type “纯玩团”、“购物团”、“散拼团”、“愿拼团”、“自带车”、“整团”
 *
 *  @return
 */
+ (UIColor *)tripTypeBgColor:(NSString *)type
{
    UIColor *color = [UIColor lightGrayColor];
    if ([type isEqualToString:@"纯玩团"])
    {
        color = [UIColor colorWithHexString:@"#f541b8"];
    }
    else if ([type isEqualToString:@"购物团"])
    {
        color = [UIColor colorWithHexString:@"#86bf0b"];
    }
    else if ([type isEqualToString:@"散拼团"])
    {
        color = [UIColor colorWithHexString:@"#8957a1"];
    }
    else if ([type isEqualToString:@"愿拼团"])
    {
        color = [UIColor colorWithHexString:@"#0db24b"];
    }
    else if ([type isEqualToString:@"自带车"])
    {
        color = [UIColor colorWithHexString:@"#887ff9"];
    }
    else if ([type isEqualToString:@"整团"])
    {
        color = [UIColor colorWithHexString:@"#09b7a5"];
    }
    return color;
}

/**
 *  计算两个经纬度之间的距离
 *
 *  @param currLocation  当前位置
 *  @param otherLocation 商品所在位置
 *
 *  @return 返回距离
 */
+ (double)metersBetweenMapPoints:(CLLocationCoordinate2D)currLocation otherLocation:(CLLocationCoordinate2D)otherLocation
{
    /*BMKMapPoint currentPoint = BMKMapPointForCoordinate(currLocation);
    BMKMapPoint otherPoint = BMKMapPointForCoordinate(otherLocation);
    CLLocationDistance meters = BMKMetersBetweenMapPoints(currentPoint, otherPoint);
    return meters;
     */
    return 0.0;
}


/**
 *  把米转换为千米
 *
 *  @param meter <#meter description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)meterToKilometer:(double)meter
{
    NSString *strMeter = nil;
    if (meter < 1000)
    {
        strMeter = [NSString stringWithFormat:@"%.0fm", meter];
    }
    else if (meter >= 1000 && meter < 10000)
    {
        strMeter = [NSString stringWithFormat:@"%.2fkm", meter / 1000];
    }
    else
    {
        strMeter = [NSString stringWithFormat:@"%.0fkm", meter / 1000];
    }
    return strMeter;
}

+ (void)svProgressHUDError:(TYZRespondDataEntity *)respond viewContrller:(UIViewController *)viewContrller
{
    /*
     100 用户认证未通过
     200 用户认证过期
     1000 系统错误
     */
    if (respond.errcode == respond_nodata)
    {
        [SVProgressHUD showErrorWithStatus:@"暂无数据"];
    }
    else if (respond.errcode == respond_nonet)
    {
        [SVProgressHUD showErrorWithStatus:@"没有网络"];
    }
//    else if (respond.errcode == 100)
//    {// 用户认证未通过
//        
//    }
    else if (respond.errcode == 200)
    {// 用户认证过期
        // 提示用户登录
//        [SVProgressHUD dismiss];
        [UserLoginStateObject saveLoginState:EUserUnlogin];
        [SVProgressHUD showErrorWithStatus:@"请重新登录"];
        [MCYPushViewController showWithUserLoginVC:viewContrller data:@(1) completion:nil];
    }
//    else if (respond.errcode == 1000)
//    {// 系统错误
//        [SVProgressHUD showErrorWithStatus:@""];
//    }
    else
    {
        [SVProgressHUD showErrorWithStatus:respond.msg];
    }
}


+ (void)setSvProgressHUD
{
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
}

/*** 生成随机数  时间+随机数值 */
+ (NSString *)getTimeAndRandom
{
    int iRandom=arc4random();
    if (iRandom<0)
    {
        iRandom=-iRandom;
    }
    
    //    NSDateFormatter *tFormat=[[[NSDateFormatter alloc] init] autorelease];
    //    [tFormat setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *date = [NSDate date];
    NSString *str = [date stringWithFormat:@"yyyyMMddHHmmssSSS"];
    NSString *tResult=[NSString stringWithFormat:@"%@%d",str, iRandom];
    return tResult;
}

+ (CGFloat)mulFontHeight:(NSString *)title value:(NSString *)value font:(UIFont *)font
{
    CGFloat fontHeight = 20;
    CGFloat titleWidth = 0;
    CGFloat maxWidth = [[UIScreen mainScreen] screenWidth];
    titleWidth = [title widthForFont:font];
    if (title)
    {
        maxWidth = maxWidth - 20 - 15 - titleWidth;
    }
    else
    {
        maxWidth = maxWidth - 20;
    }
    fontHeight = [value heightForFont:font width:maxWidth];
    fontHeight = (fontHeight> 20? fontHeight:20);
    return fontHeight;
}

+ (CGFloat)mulFontHeights:(NSString *)value font:(UIFont *)font maxWidth:(CGFloat)maxWidth
{
    CGFloat fontHeight = 20;
    fontHeight = [value heightForFont:font width:maxWidth];
    fontHeight = (fontHeight> 20? fontHeight:20);
    return fontHeight;
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

/**
 *  根据订单状态得到订单状态描述
 *
 *  @param state 状态
 *  @param type 1商家；2表示食客
 *
 *  @return <#return value description#>
 */
+ (NSString *)dinersWithOrderState:(NSInteger)state
{
    NSString *str = @"";
    switch (state)
    {
        case NS_ORDER_WAITING_CONFIRMATION_STATE:
        {
            str = @"待确认";
        } break;
        case NS_ORDER_WAITING_PAY_DEPOSIT_STATE:
        {
            str = @"已接单";//@"待支付订金";
        } break;
        case NS_ORDER_COMPLETED_BOOKING_STATE:
        {
            str = @"预订完成";
        } break;
        case NS_ORDER_DINING_STATE:
        {
            str = @"就餐中";
        } break;
        case NS_ORDER_IN_CHECKOUT_STATE:
        {
            str = @"结账中";
        } break;
//        case NS_ORDER_PAYAMOUNTCONFIRMED_STATE:
//        {
//            str = @"待支付";
//        } break;
        case NS_ORDER_PAY_COMPLETE_STATE:
        {
            str = @"支付完成";
        } break;
        case NS_ORDER_ORDER_COMPLETE_STATE:
        {
            str = @"已完成";
        } break;
        case NS_ORDER_SHOP_SAB_STATE:
        {
            str = @"退单申请中";
        } break;
        case NS_ORDER_SHOP_REFUNDING_STATE:
        {
            str = @"退款中";
        } break;
        case NS_ORDER_ORDER_CANCELED_STATE:
        {
            str = @"已取消";
        } break;
        case NS_ORDER_RETREAT_SINGLE_COMPLETE_STATE:
        {
            str = @"退单完成";
        } break;
        case NS_ORDER_SHOP_REFUSED_STATE:
        {
            str = @"拒单";
        } break;
        case NS_ORDER_ORDER_NOT_ACTIVE_STATE:
        {
            str = @"未激活";
        } break;
        default:
            break;
    }
    return str;
}

+ (UIColor *)dinersWithOrderStateColor:(NSInteger)state
{
    UIColor *color = [UIColor colorWithHexString:@"#ff5500"];
    switch (state)
    {
        case NS_ORDER_WAITING_CONFIRMATION_STATE:
        {// 待确认
            
        } break;
//        case NS_ORDER_CONFIRMED_STATE:
//        {// 已确认
//            color = [UIColor colorWithHexString:@"#00cc66"];
//        } break;
        case NS_ORDER_WAITING_PAY_DEPOSIT_STATE:
        {// 待支付订金
            color = [UIColor colorWithHexString:@"#00cc66"];
        } break;
        case NS_ORDER_COMPLETED_BOOKING_STATE:
        {// 预订完成
            color = [UIColor colorWithHexString:@"#00cc66"];
        } break;
//        case NS_ORDER_WAITING_ORDER_STATE:
//        {// 待下单
//            
//        } break;
        case NS_ORDER_DINING_STATE:
        {// 就餐中
            
        } break;
        case NS_ORDER_IN_CHECKOUT_STATE:
        {// 结账中
            
        } break;
        case NS_ORDER_PAY_COMPLETE_STATE:
        {// 支付完成
            
        } break;
        case NS_ORDER_ORDER_COMPLETE_STATE:
        {
            
        } break;
        case NS_ORDER_SHOP_SAB_STATE:
        {// 退单申请中
            
        } break;
        case NS_ORDER_ORDER_CANCELED_STATE:
        {// 已取消
            
        } break;
        case NS_ORDER_SHOP_REFUSED_STATE:
        {// 已拒绝
            color = [UIColor colorWithHexString:@"#ff3333"];
        } break;
        case NS_ORDER_ORDER_NOT_ACTIVE_STATE:
        {// 未激活
            
        } break;
        default:
            break;
    }
    return color;
}

/**
 *  初始化百度推送
 */
+ (void)initWithBaiduPush:(NSDictionary *)launchOptions
{
//    debugMethod();
    // 在App启动时注册百度云推送服务，需要提供appikey
    /*[BPush registerChannel:launchOptions apiKey:@"Ir5s4gmyzIDy7R5bjirmGPxx" pushMode:BPushModeDevelopment withFirstAction:@"打开" withSecondAction:@"回复" withCategory:@"test" useBehaviorTextInput:YES isDebug:YES];
    
    // 禁用地理位置推送， 需要再绑定接口前调用
    [BPush disableLbs];
    
    // App 用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo)
    {
        debugLog(@"userInfo");
        [BPush handleNotification:userInfo];
    }
    // 角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
     */
}

/**
 *  初始化分享sdk
 */
+ (void)initWithShareSDK
{
    /*
     渠道			应用		key/id				secret
     新浪微博		导游版	2724321676			991e8211f3e3b69ea698b667c20145fb
     qq安卓		导游版	1105367696			tZhJ12eiIT3HIjVn
     qqIOS		导游版	1105367818			8mwF6nnEqBLzCr3n
     微信			导游版	wx41161bf0d227cc07	f5ddd72ff48831342d09945293e73991
     */
    // wx41161bf0d227cc07
    
    /*
     sinaweibosso2724321676, wx41161bf0d227cc07, tencent1105367818, QQ41A3F985
     
     http://www.cabbao.com/
     */
    
//    NSString *url = nil;//@"http://www.cabbao.com/";
    NSArray *platforms = @[
//                           @(SSDKPlatformTypeSinaWeibo),
                           //                           @(SSDKPlatformTypeTencentWeibo),
//                           @(SSDKPlatformSubTypeQZone),
                           @(SSDKPlatformTypeSMS),
//                           @(SSDKPlatformTypeWechat),
                           @(SSDKPlatformSubTypeWechatSession),
                           @(SSDKPlatformSubTypeWechatTimeline),
//                           @(SSDKPlatformSubTypeQQFriend),
                           //                           @(SSDKPlatformTypeWechat),
//                           @(SSDKPlatformTypeQQ)
                           ];
    [ShareSDK registerApp:kSHARESDK_KEY activePlatforms:platforms onImport:^(SSDKPlatformType platformType) {
        //        debugLog(@"platformType=%d", (int)platformType);
        switch (platformType)
        {
            case SSDKPlatformTypeSinaWeibo:
            {
                [ShareSDKConnector connectWeibo:[WeiboSDK class]];
            } break;
            case SSDKPlatformTypeWechat:
            {
                [ShareSDKConnector connectWeChat:[WXApi class] delegate:[WXPayManager sharedManager]];
            } break;
            case SSDKPlatformTypeQQ:
            {
                /**
                 *  连接QQAPI以供ShareSDK可以正常使用QQ或者QQ空间客户端来授权或者分享内容。
                 *
                 *  @param qqApiInterfaceClass QQSDK中的类型，应先导入TencentOpenAPI.framework，再传入[QQApiInterface class]到此参数。
                 *  @param tencentOAuthClass   QQSDK中的类型，应先导入TencentOpenAPI.framework，再传入[TencentOAuth class]到此参数。
                 */
                
                [ShareSDKConnector connectQQ:[QQApiInterface class]
                           tencentOAuthClass:[TencentOAuth class]];
            } break;
            default:
                break;
        }
    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        /*
         AppID: wx89349cb6a0cd650a
         AppSecret:7835314f8044ce60e971f7fa7e8cd881
         */
        //        debugLog(@"---=%d", (int)platformType);
        switch (platformType)
        {
            case SSDKPlatformTypeSinaWeibo:
                //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
//                [appInfo SSDKSetupSinaWeiboByAppKey:@"2724321676"
//                                          appSecret:@"991e8211f3e3b69ea698b667c20145fb"
//                                        redirectUri:url
//                                           authType:SSDKAuthTypeBoth];
                break;
                //            case SSDKPlatformTypeTencentWeibo:
                //                //设置腾讯微博应用信息，其中authType设置为只用Web形式授权
                //                [appInfo SSDKSetupTencentWeiboByAppKey:@"1105367818"
                //                                             appSecret:@"8mwF6nnEqBLzCr3n"
                //                                           redirectUri:url];
                //                break;
                /*
                 AppID: wx89349cb6a0cd650a
                 AppSecret:82b788e2f5386cb9fcae7cb1e123877f
                 */
            case SSDKPlatformTypeWechat:
                [appInfo SSDKSetupWeChatByAppId:@"wx89349cb6a0cd650a" appSecret:@"82b788e2f5386cb9fcae7cb1e123877f"];
                break;
            case SSDKPlatformTypeQQ:
                // qqIOS		导游版	1105367818			8mwF6nnEqBLzCr3n
//                [appInfo SSDKSetupQQByAppId:@"1105367818"
//                                     appKey:@"8mwF6nnEqBLzCr3n"
//                                   authType:SSDKAuthTypeBoth];
                break;
            default:
                break;
        }
    }];
}

/**
 *  显示分享视图
 */
+ (void)showWithShareView:(UIView *)view shareImage:(UIImage *)shareImage shareTitle:(NSString *)shareTitle shareContent:(NSString *)shareContent shareUrl:(NSString *)shareUrl
{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray *imageArray = nil;
    if (shareImage)
    {
        imageArray = @[shareImage];
    }
    NSString *title = @"秀味";
    if (shareTitle)
    {
        title = shareTitle;
    }
    // [NSURL URLWithString:kAppUrl]
//    debugLog(@"shareCon=%@", shareContent);
    [shareParams SSDKSetupShareParamsByText:objectNull(shareContent) images:imageArray url:[NSURL URLWithString:shareUrl] title:title type:SSDKContentTypeAuto];
    [ShareSDK showShareActionSheet:view items:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
        //        debugLog(@"error=%@", [error description]);
        switch (state)
        {
            case SSDKResponseStateBegin:
            {
                
            } break;
            case SSDKResponseStateSuccess:
            {
                [SVProgressHUD showSuccessWithStatus:@"分享成功"];
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alertView show];
            } break;
            case SSDKResponseStateFail:
            {
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alertView show];
                [SVProgressHUD showErrorWithStatus:@"分享失败"];
            } break;
            case SSDKResponseStateCancel:
            {
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alertView show];
            } break;
            default:
                break;
        }
    }];
}


/**
 *  初始化友盟
 */
+ (void)initWithMobClick
{
    UMConfigInstance.appKey = @"57b3e0b967e58e75b00004e6";
//    UMConfigInstance.token = @"";//[UserLoginStateObject deviceToken];
    //    UMConfigInstance.secret = @"secretstringaldfkals";
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];
    //    [MobClick setLogEnabled:YES];
}


/**
 *  得到购物车缓存数据的，文件名
 *
 *  @return 文件
 */
+ (NSString *)cacheShopingCartFileName
{
    NSString *fileName = [NSString stringWithFormat:@"csct%@.plist", [UserLoginStateObject getUserMobile]];
    return fileName;
}

/**
 *  得到缓存的key
 *
 *  @return <#return value description#>
 */
+ (NSString *)cacheShopingCartData
{
    NSString *cacheKey = [NSString stringWithFormat:@"CacheShopingCart%@", [UserLoginStateObject getUserMobile]];
    return cacheKey;
}



+ (void)saveWithBaiDuChannelId:(NSString *)channelId
{
    [[NSUserDefaults standardUserDefaults] setObject:channelId forKey:@"baiduchannelid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)readWithBaiDuChannelId
{
    NSString *channelId = [[NSUserDefaults standardUserDefaults] objectForKey:@"baiduchannelid"];
    return channelId;
}

+ (void)saveWithBaiDuUserId:(NSString *)pUserId
{
    [[NSUserDefaults standardUserDefaults] setObject:pUserId forKey:@"baiduuserid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)readWithBaiDuUserId
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"baiduuserid"];
    return userId;
}

+ (void)saveWithBaiDuAppId:(NSString *)appId
{
    [[NSUserDefaults standardUserDefaults] setObject:appId forKey:@"baiduappid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)readWithBaiDuAppId
{
    NSString *appId = [[NSUserDefaults standardUserDefaults] objectForKey:@"baiduappid"];
    return appId;
}

//[NSUserDefaults standardUserDefaults] setObject:<#(nullable id)#> forKey:<#(nonnull NSString *)#>



/*
 #define kCacheShopingCartFileName @"CacheShopingCart.plist"
 #define kCacheShopingCartData @"CacheShopingCartData"
 
 
 */

+ (void)saveWithCircleAuthorize:(NSString *)token timestamp:(double)timestamp
{
    NSArray *array = @[token, @(timestamp)];
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"circleAuthorize"];
}
+ (NSArray *)readWithCircleAuthorize
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"circleAuthorize"];
}

/**
 *  保存外卖打印机IP
 */
+ (void)saveWithPrinterIP:(NSString *)ip
{
    [[NSUserDefaults standardUserDefaults] setObject:ip forKey:kPrinterIP];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)readWithPrinterIP
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kPrinterIP];
}

/**
 *  保存外卖打印机型号
 */
+ (void)saveWithPrinterModel:(NSString *)model
{
    [[NSUserDefaults standardUserDefaults] setObject:model forKey:kPrinterModel];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)readWithPrinterModel
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kPrinterModel];
}


@end


























