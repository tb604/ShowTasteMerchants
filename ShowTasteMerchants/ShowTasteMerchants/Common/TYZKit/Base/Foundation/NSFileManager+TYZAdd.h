//
//  NSFileManager+TYZAdd.h
//  51tourGuide
//
//  Created by 唐斌 on 16/4/29.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSFileManager (TYZAdd)
/**
 * @brief 得到文件路径，
 * @param fileName 文件名，不包括扩展名
 * @param extType 扩展名类型
 * @param saveType 存储类型，0表示存储在Doc中；1表示存在cache中
 */
+ (NSString *)getPathByFileName:(NSString *)fileName ofType:(NSString *)extType saveType:(int)saveType;

/**
 * @brief 得到文件路径，
 * @param fileName 文件名，包括扩展名
 * @param saveType 存储类型，0表示存储在Doc中；1表示存在cache中
 */
+ (NSString *)getPathByFileName:(NSString *)fileName saveType:(int)saveType;

/** 得到Document的路径 */
+ (NSString *)getFilePath:(NSString *)filename;
+ (NSString *)getFilePath;

+ (NSString *)getfilebulderPath:(NSString *)filename;
+ (NSString *)getfilebulderPath;

/**
 * @brief 得到缓存文件夹的路径
 * @param filename 文件名。例如:readme.txt
 */
+ (NSString *)getFileLibraryCachesPath:(NSString *)filename;
+ (NSString *)getFileLibraryCachesPath;

+ (NSString *)getFileLibraryPath:(NSString *)path;
+ (NSString *)getFileLibraryPath;

/**
 * @brief 文件文件是否存在
 * @param filepathname 具体的文件路径
 */
+ (BOOL)isPathFileExit:(NSString *)filepathname;

/** 获取文件大小 */
+ (NSInteger) getFileSize:(NSString *)path;

/**
 *  创建目录文件
 *
 *  @param path 目录路径
 */
+ (void)makeWithDirectory:(NSString *)path;

/**
 *  删除目录文件
 *
 *  @param path 目录路径
 */
+ (void)removeWithDirectory:(NSString *)path;

/**
 *  得到目录下的文件数量
 *
 *  @param dir <#dir description#>
 *
 *  @return 返回文件数量
 */
+ (NSInteger)fileCountOfDirectory:(NSString *)dir;

/**
 *  计算本地缓存
 *
 *  @return 返回本地缓存大小(字节)
 */
+ (CGFloat)localCacheSize;

/**
 *  计算文件夹大小
 *
 *  @param path 文件夹目录
 *
 *  @return 此文件夹的大小(字节)
 */
+ (CGFloat)fileSizeForDir:(NSString *)path;

/**
 *  清除本地缓存
 */
+ (void)deleteLocalCache;

/**
 *  清除指定文件夹下的内容
 *
 *  @param path 清除的目录路径
 */
+ (void)deleteForDir:(NSString *)path;

@end
