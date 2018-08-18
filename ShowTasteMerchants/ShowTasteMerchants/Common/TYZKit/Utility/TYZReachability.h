//
//  TYZReachability.h
//  YYStudyDemo
//
//  Created by 唐斌 on 16/2/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>

NS_ASSUME_NONNULL_BEGIN

/*
 reach = [TYZReachability reachabilityWithHostName:@"www.baidu.com"];
 [reach setNotifyBlock:^(TYZReachability *reac) {
 // 状态改变的时候，会调用
 NSLog(@"status=%d", (int)reac.status);
 }];
 */


typedef NS_ENUM(NSUInteger, TYZReachabilityStatus)
{
    TYZReachabilityStatusNone = 0, ///< Not Reachable
    TYZReachabilityStatusWWAN = 1, ///< Reachable via WWAN (2G/3G/4G)
    TYZReachabilityStatusWiFi = 2, ///< Reachable via WiFi
};

typedef NS_ENUM(NSUInteger, TYZReachabilityWWANStatus)
{
    TYZReachabilityWWANStatusNone = 0, ///< Not Reachable vis WWAN
    TYZReachabilityWWANStatus2G = 2, ///< Reachable via 2G(GPRS/EDGE)10~100Kbps
    TYZReachabilityWWANStatus3G = 3, ///< Reachable via 3G(WCDMA/HSDPA/...)1~10Mbps
    TYZReachabilityWWANStatus4G = 4, ///< Reachable via 4G(eHRPD/LTE) 100Mbps
};


/**
 *  'TYZReachability' can used to monitor the network status of an iOS device.(“TYZReachability”可以用于监控一个iOS设备的网络状态。)
 */
@interface TYZReachability : NSObject

@property (nonatomic, assign, readonly) SCNetworkReachabilityFlags flags; ///< current flags.

@property (nonatomic, assign, readonly) TYZReachabilityStatus status; ///< current status.(当前网络的状态)

@property (nonatomic, assign, readonly) TYZReachabilityWWANStatus wwanStatus NS_AVAILABLE_IOS(7_0); ///< current wwan status.

@property (nonatomic, assign, readonly, getter=isReachable) BOOL reachable; ///< Current reachable status.

/**
 *  notify block which will be called on main thread when network changed.(通知阻塞主线程将呼吁当网络发生了变化。)
 */
@property (nullable, nonatomic, copy) void (^notifyBlock)(TYZReachability *reachability);

/**
 *  Create an object to check the reachability of the default route.
 */
+ (instancetype)reachability;

/**
 *  检测当前网络是否能够连接上本地wifi
 *
 *  @return 
 */
+ (instancetype)reachabilityForLocalWifi DEPRECATED_MSG_ATTRIBUTE("unnecessary and potentially harmful");

/**
 *  通过域名设定一个目标地址，比如：www.apple.com
 *
 *  @param hostName 域名地址
 *
 *  @return 
 */
+ (nullable instancetype)reachabilityWithHostName:(NSString *)hostName;

/**
 *  通过ip地址设定一个目标的地址，可以加端口号。
 *
 *  @param hostAddress
 *
 *  @return 
 */
+ (nullable instancetype)reachabilityWithAddress:(const struct sockaddr *)hostAddress;

@end

NS_ASSUME_NONNULL_END



























