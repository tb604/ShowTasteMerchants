//
//  UtilityObject.h
//  51tourGuide
//
//  Created by 唐斌 on 16/4/27.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import <UMMobClick/MObClick.h>

//#import "BPush.h" // 百度推送

@class UserDataKeyChain;
@class TYZCustomNavController;
//@class WYXEmptyContentView;
@class TYZRespondDataEntity;

@interface UtilityObject : NSObject

/**
 *  保存用户的基本信息，保存在手机上，就算是删除了app，这个信息也是存在的
 *
 *  @param token <#token description#>
 */
//+ (void)saveWithUserDataKeyObject:(NSString *)token;

/**
 *  读取
 *
 *  @return
 */
//+ (UserDataKeyChain *)readWithuserDataKeyObject;

/**
 *  初始化注册推送
 *
 *  @param application <#application description#>
 */
+ (void)initWithRegisterForRemote:(nullable UIApplication *)application;

+ (nullable TYZCustomNavController *)initWithRootVC;

/**
 * @brief 把缓冲数据存储到本地
 * @param arckey 键
 * @param filename 文件名
 * @param said 存储到制定文件中的对象
 */
+ (void)saveCacheDataLocalKey:(nonnull NSString *)arckey saveFilename:(nonnull NSString *)filename saveid:(nullable id)said;

/**
 * @brief 从本地读取缓存里面的数据
 * @param arckey 键
 * @param filename 文件名
 */
+ (nullable id)readCacheDataLocalKey:(nonnull NSString *)arckey saveFilename:(nonnull NSString *)filename;

/**
 * @brief 删除缓存里面的数据
 * @param arckey 键
 * @param filename 文件名
 */
+ (void)removeCacheDataLocalKey:(nullable NSString *)arckey fileName:(nullable NSString *)filename;

+ (nullable AppDelegate *)appDelegate;

//+ (WYXEmptyContentView *)showEmptContentView:(UIView *)superView;

/**
 *  图标的背景色
 *
 *  @param type “纯玩团”、“购物团”、“散拼团”、“愿拼团”、“自带车”、“整团”
 *
 *  @return color
 */
+ (nullable UIColor *)tripTypeBgColor:(nullable NSString *)type;

/**
 *  计算两个经纬度之间的距离
 *
 *  @param currLocation  当前位置
 *  @param otherLocation 商品所在位置
 *
 *  @return 返回距离
 */
+ (double)metersBetweenMapPoints:(CLLocationCoordinate2D)currLocation otherLocation:(CLLocationCoordinate2D)otherLocation;

/**
 *  把米转换为千米
 *
 *  @param meter <#meter description#>
 *
 *  @return <#return value description#>
 */
+ (nullable NSString *)meterToKilometer:(double)meter;

+ (void)svProgressHUDError:(nullable TYZRespondDataEntity *)respond viewContrller:(nullable UIViewController *)viewContrller;

+ (void)setSvProgressHUD;

/*** 生成随机数  时间+随机数值 */
+ (nullable NSString *)getTimeAndRandom;


/**
 *  当多行的时候，计算高度
 *
 *  @param title 标题
 *  @param value 值
 *
 *  @return 返回高度
 */
+ (CGFloat)mulFontHeight:(nonnull NSString *)title value:(nullable NSString *)value font:(nullable UIFont *)font;

+ (CGFloat)mulFontHeights:(nonnull NSString *)value font:(nullable UIFont *)font maxWidth:(CGFloat)maxWidth;

/**
 *  根据订单状态得到订单状态描述
 *
 *  @param state 状态
 *
 *  @return <#return value description#>
 */
+ (nullable NSString *)dinersWithOrderState:(NSInteger)state;

+ (nullable UIColor *)dinersWithOrderStateColor:(NSInteger)state;

/**
 *  初始化百度推送
 */
+ (void)initWithBaiduPush:(nullable NSDictionary *)launchOptions;

/**
 *  初始化分享sdk
 */
+ (void)initWithShareSDK;

/**
 *  显示分享视图
 */
+ (void)showWithShareView:(nullable UIView *)view shareImage:(nullable UIImage *)shareImage shareTitle:(nullable NSString *)shareTitle shareContent:(nullable NSString *)shareContent shareUrl:(nullable NSString *)shareUrl;

/**
 *  初始化友盟
 */
+ (void)initWithMobClick;

/**
 *  得到购物车缓存数据的，文件名
 *
 *  @return 文件
 */
+ (nullable NSString *)cacheShopingCartFileName;

/**
 *  得到缓存的key
 *
 *  @return <#return value description#>
 */
+ (nullable NSString *)cacheShopingCartData;

/**
 *  保存百度的channelId
 *
 *  @param channelId <#channelId description#>
 */
+ (void)saveWithBaiDuChannelId:(nullable NSString *)channelId;

/**
 *  获取百度的channelid
 *
 *  @return <#return value description#>
 */
+ (nullable NSString *)readWithBaiDuChannelId;

+ (void)saveWithBaiDuUserId:(nullable NSString *)pUserId;

+ (nullable NSString *)readWithBaiDuUserId;

+ (void)saveWithBaiDuAppId:(nullable NSString *)appId;

+ (nullable NSString *)readWithBaiDuAppId;

//[NSUserDefaults standardUserDefaults] setObject:<#(nullable id)#> forKey:<#(nonnull NSString *)#>

+ (void)saveWithCircleAuthorize:(nullable NSString *)token timestamp:(double)timestamp;
+ (nullable NSArray *)readWithCircleAuthorize;

/**
 *  保存外卖打印机IP
 */
+ (void)saveWithPrinterIP:(nullable NSString *)ip;

+ (nullable NSString *)readWithPrinterIP;

/**
 *  保存外卖打印机型号
 */
+ (void)saveWithPrinterModel:(nullable NSString *)model;

+ (nullable NSString *)readWithPrinterModel;

@end














