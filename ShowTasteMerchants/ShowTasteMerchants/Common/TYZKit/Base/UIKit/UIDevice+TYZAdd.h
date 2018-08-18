//
//  UIDevice+TYZAdd.h
//  TYZStudyDemo
//
//  Created by 唐斌 on 16/2/29.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Provides extensions for 'UIDevice'.
 */
@interface UIDevice (TYZAdd)

#pragma mark - Device Information
///=============================================================================
/// @name Device Information
///=============================================================================

/// Device system version (e.g. 8.1)(系统版本)
+ (float)systemVersion;

/// Whether the device is iPad/iPad mini.
@property (nonatomic, readonly) BOOL isPad;

/// Whether the device is a simulator.
@property (nonatomic, readonly) BOOL isSimulator;

/// Whether the device is jailbroken.(该设备是否越狱。)
@property (nonatomic, readonly) BOOL isJailbroken;

/// Whether the device can make phone calls.(设备是否能打电话。)
@property (nonatomic, readonly) BOOL canMakePhoneCalls NS_EXTENSION_UNAVAILABLE_IOS("");

/// The device's machine model.  e.g. "iPhone6,1" "iPad4,6"
/// @see http://theiphonewiki.com/wiki/Models
@property (nonatomic, readonly) NSString *machineModel;

/// The device's machine model name. e.g. "iPhone 5s" "iPad mini 2"
/// @see http://theiphonewiki.com/wiki/Models
@property (nullable, nonatomic, readonly) NSString  *machineModelName;

/// The System's startup time.(系统的启动时间。)
@property (nonatomic, readonly) NSDate *systemUptime;


#pragma mark - Network Information
///=============================================================================
/// @name Network Information
///=============================================================================

/// WIFI IP address of this device (can be nil). e.g. @"192.168.1.111"
@property (nonatomic, readonly) NSString *ipAddressWIFI;

/// Cell IP address of this device (can be nil). e.g. @"10.2.2.222"
@property (nonatomic, readonly) NSString *ipAddressCell;


/**
 Network traffic type:(网络流量类型。)
 
 WWAN: Wireless Wide Area Network.
 For example: 3G/4G.
 
 WIFI: Wi-Fi.
 
 AWDL: Apple Wireless Direct Link (peer-to-peer connection).
 For exmaple: AirDrop, AirPlay, GameKit.
 */
typedef NS_OPTIONS(NSUInteger, TYZNetworkTrafficType)
{
    TYZNetworkTrafficTypeWWANSent     = 1 << 0, ///< 无线广域网发送网络流量类型
    TYZNetworkTrafficTypeWWANReceived = 1 << 1, ///< 无线广域网接收网络流量类型
    TYZNetworkTrafficTypeWIFISent     = 1 << 2, //< WIFI网发送网络流量类型
    TYZNetworkTrafficTypeWIFIReceived = 1 << 3, ///< WIFI网接收网络流量类型
    TYZNetworkTrafficTypeAWDLSent     = 1 << 4,
    TYZNetworkTrafficTypeAWDLReceived = 1 << 5,
    
    TYZNetworkTrafficTypeWWAN = TYZNetworkTrafficTypeWWANSent | TYZNetworkTrafficTypeWWANReceived, ///< 无线广域网网络流量类型
    TYZNetworkTrafficTypeWIFI = TYZNetworkTrafficTypeWIFISent | TYZNetworkTrafficTypeWIFIReceived, ///< WIFI网网络流量类型
    TYZNetworkTrafficTypeAWDL = TYZNetworkTrafficTypeAWDLSent | TYZNetworkTrafficTypeAWDLReceived, ///< 网络流量类型AWDL
    
    TYZNetworkTrafficTypeALL = TYZNetworkTrafficTypeWWAN |
    TYZNetworkTrafficTypeWIFI |
    TYZNetworkTrafficTypeAWDL,
};

/**
 Get device network traffic bytes.(得到设备网络流量字节。)
 
 @discussion This is a counter since the device's last boot time.
 Usage:
 
 uint64_t bytes = [[UIDevice currentDevice] getNetworkTrafficBytes:TYZNetworkTrafficTypeALL];
 NSTimeInterval time = CACurrentMediaTime();
 
 uint64_t bytesPerSecond = (bytes - _lastBytes) / (time - _lastTime);
 
 _lastBytes = bytes;
 _lastTime = time;
 
 
 @param type traffic types
 @return bytes counter.
 */
- (uint64_t)getNetworkTrafficBytes:(TYZNetworkTrafficType)types;


#pragma mark - Disk Space
///=============================================================================
/// @name Disk Space
///=============================================================================

/// Total disk space in byte(磁盘空间的总字节数). (-1 when error occurs)
@property (nonatomic, readonly) int64_t diskSpace;

/// Free disk space in byte(磁盘空间的空闲字节数). (-1 when error occurs)
@property (nonatomic, readonly) int64_t diskSpaceFree;

/// Used disk space in byte(磁盘使用的字节数). (-1 when error occurs)
@property (nonatomic, readonly) int64_t diskSpaceUsed;


#pragma mark - Memory Information
///=============================================================================
/// @name Memory Information
///=============================================================================

/// Total physical memory in byte(总物理内存字节). (-1 when error occurs)
@property (nonatomic, readonly) int64_t memoryTotal;

/// Used (active + inactive + wired) memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t memoryUsed;

/// Free memory in byte(空闲内存的字节。). (-1 when error occurs)
@property (nonatomic, readonly) int64_t memoryFree;

/// Acvite memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t memoryActive;

/// Inactive memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t memoryInactive;

/// Wired memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t memoryWired;

/// Purgable memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t memoryPurgable;

#pragma mark - CPU Information
///=============================================================================
/// @name CPU Information
///=============================================================================

/// Avaliable CPU processor count(CPU处理器数量).
@property (nonatomic, readonly) NSUInteger cpuCount;

/// Current CPU usage(当前的CPU使用率), 1.0 means 100%. (-1 when error occurs)
@property (nonatomic, readonly) float cpuUsage;

/// Current CPU usage per processor(当前的CPU使用率每处理器) (array of NSNumber), 1.0 means 100%. (nil when error occurs)
@property (nullable, nonatomic, readonly) NSArray *cpuUsagePerProcessor;
@end

NS_ASSUME_NONNULL_END

#ifndef kSystemVersion
#define kSystemVersion [UIDevice systemVersion]
#endif

#ifndef kiOS6Later
#define kiOS6Later (kSystemVersion >= 6)
#endif

#ifndef kiOS7Later
#define kiOS7Later (kSystemVersion >= 7)
#endif

#ifndef kiOS8Later
#define kiOS8Later (kSystemVersion >= 8)
#endif

#ifndef kiOS9Later
#define kiOS9Later (kSystemVersion >= 9)
#endif

#ifndef kiPhone4
#define kiPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#endif

#ifndef kiPhone5
#define kiPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#endif

#ifndef kiPhone6
#define kiPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#endif

#ifndef kiPhone6Plus
#define kiPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#endif

#ifndef kiPod4
#define kiPod4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#endif

#ifndef kiPod3
#define kiPod3 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(320, 480), [[UIScreen mainScreen] currentMode].size) : NO)
#endif
