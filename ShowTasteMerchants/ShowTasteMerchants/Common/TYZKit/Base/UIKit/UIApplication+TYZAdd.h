//
//  UIApplication+TYZAdd.h
//  YYStudyDemo
//
//  Created by 唐斌 on 16/2/29.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Provides extensions for `UIApplication`.
 */
@interface UIApplication (TYZAdd)

/// "Documents" folder in this app's sandbox.
@property (nonatomic, readonly) NSURL *documentsURL;
@property (nonatomic, readonly) NSString *documentsPath;

/// "Caches" folder in this app's sandbox.
@property (nonatomic, readonly) NSURL *cachesURL;
@property (nonatomic, readonly) NSString *cachesPath;

/// "Library" folder in this app's sandbox.
@property (nonatomic, readonly) NSURL *libraryURL;
@property (nonatomic, readonly) NSString *libraryPath;

/// Application's Bundle Name (show in SpringBoard).
@property (nonatomic, readonly) NSString *appBundleName;

/// Application's Bundle ID.  e.g. "com.ibireme.MyApp"
@property (nonatomic, readonly) NSString *appBundleID;

/// Application's Version.  e.g. "1.2.0"
@property (nonatomic, readonly) NSString *appVersion;

/// Application's Build number. e.g. "123"
@property (nonatomic, readonly) NSString *appBuildVersion;

/// Whether this app is pirated (not install from appstore).(这款应用是否盗版)
@property (nonatomic, readonly) BOOL isPirated;

/// Whether this app is being debugged (debugger attached).
@property (nonatomic, readonly) BOOL isBeingDebugged;

/// Current thread real memory used in byte. (-1 when error occurs)(当前线程中使用的实际内存字节。)
@property (nonatomic, readonly) int64_t memoryUsage;

/// Current thread CPU usage, 1.0 means 100%. (-1 when error occurs)(cpu的使用率)
@property (nonatomic, readonly) float cpuUsage;

/**
 *  创建目录
 *
 *  @param path 目录
 */
+ (void)createWithDirectoryAtPath:(NSString *)path;

/**
 *  判断目录是否存在
 *
 *  @param path 目录
 *
 *  @return YES表示存在；NO表示不存在
 */
+ (BOOL)isPathExit:(NSString *)path;

/**
 *  拼接documents目录
 *
 *  @param pathFile 目录文件(ex:zip/tang.zip)
 *
 *  @return 返回完成的路径文件
 */
+ (NSString *)appendDocumentsPath:(NSString *)pathFile;

/**
 *  拼接caches目录
 *
 *  @param pathFile 目录文件(ex:zip/tang.zip)
 *
 *  @return 返回完成的路径文件
 */
+ (NSString *)appendCachesPath:(NSString *)pathFile;

/**
 *  拼接library目录
 *
 *  @param pathFile 目录文件(ex:zip/tang.zip)
 *
 *  @return 返回完成的路径文件
 */
+ (NSString *)appendLibraryPath:(NSString *)pathFile;

/**
 *  判断文件是否存在
 *
 *  @param pathFile 目录文件
 *
 *  @return YES表示存在；NO表示不存在
 */
+ (BOOL)isFileExit:(NSString *)pathFile;





/**
 Increments the number of active network requests.
 If this number was zero before incrementing, this will start animating the
 status bar network activity indicator.
 
 This method is thread safe.
 
 This method has no effect in App Extension.
 */
- (void)incrementNetworkActivityCount;

/**
 Decrements the number of active network requests.
 If this number becomes zero after decrementing, this will stop animating the
 status bar network activity indicator.
 
 This method is thread safe.
 
 This method has no effect in App Extension.
 */
- (void)decrementNetworkActivityCount;


/// Returns YES in App Extension.
+ (BOOL)isAppExtension;

/// Same as sharedApplication, but returns nil in App Extension.
+ (UIApplication *)sharedExtensionApplication;


/**
 * @brief 把缓冲数据存储到本地
 * @param arckey 键
 * @param filename文件名
 * @param said 存储到制定文件中的对象
 */
+ (void)saveCacheDataLocalKey:(NSString *)arckey saveFilename:(NSString *)filename saveid:(id)said;
/**
 * @brief 从本地读取缓存里面的数据
 * @param arckey 键
 * @param filename文件名
 */
+ (id)readCacheDataLocalKey:(NSString *)arckey saveFilename:(NSString *)filename;

@end
