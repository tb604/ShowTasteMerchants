//
//  NSFileManager+TYZAdd.m
//  51tourGuide
//
//  Created by 唐斌 on 16/4/29.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "NSFileManager+TYZAdd.h"

@implementation NSFileManager (TYZAdd)
/**
 * @brief 得到文件路径，
 * @param fileName 文件名，不包括扩展名
 * @param extType 扩展名类型
 * @param saveType 存储类型，0表示存储在Doc中；1表示存在cache中
 */
+ (NSString *)getPathByFileName:(NSString *)fileName ofType:(NSString *)extType saveType:(int)saveType
{
    NSString *path = nil;
    if (saveType == 0)
    {
        path = [self getFilePath];
    }
    else
    {
        path = [self getFileLibraryCachesPath];
    }
    NSString* fileDirectory = [[path stringByAppendingPathComponent:fileName]stringByAppendingPathExtension:extType];
    return fileDirectory;
}

/**
 生成文件路径
 @param _fileName 文件名
 @returns 文件路径
 */
+ (NSString *)getPathByFileName:(NSString *)fileName saveType:(int)saveType
{
    NSString *path = nil;
    if (saveType == 0)
    {
        path = [self getFilePath];
    }
    else
    {
        path = [self getFileLibraryCachesPath];
    }
    NSString* fileDirectory = [path stringByAppendingPathComponent:fileName];
    return fileDirectory;
}


// 得到Document的路径
+ (NSString *)getFilePath:(NSString *)filename
{
    //    NSString *strPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [[self getFilePath] stringByAppendingPathComponent:filename];
    return filePath;
}

+ (NSString *)getFilePath
{
    NSString *strPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return strPath;
}

+ (NSString *)getfilebulderPath:(NSString *)filename
{
    //    NSString *strPath = [[NSBundle mainBundle] bundlePath];
    NSString *strPath = [[self getfilebulderPath] stringByAppendingPathComponent:filename];
    return strPath;
}

+ (NSString *)getfilebulderPath
{
    NSString *strPath = [[NSBundle mainBundle] bundlePath];
    return strPath;
}

// 得到缓存文件夹的路径
+ (NSString *)getFileLibraryCachesPath:(NSString *)filename
{
    //    NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[self getFileLibraryCachesPath] stringByAppendingPathComponent:filename];
    
    //    NSString *strPath = [NSString stringWithFormat:@"%@/Caches", [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
    //    strPath = [strPath stringByAppendingPathComponent:filename];
    
    return filePath;
}

+ (NSString *)getFileLibraryCachesPath
{
    NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    return [paths objectAtIndex:0];
}

+ (NSString *)getFileLibraryPath:(NSString *)path
{
    return [[[self class] getFileLibraryPath] stringByAppendingPathComponent:path];
}
+ (NSString *)getFileLibraryPath
{
    NSArray *library = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [library objectAtIndex:0];
}

// 文件文件是否存在
+ (BOOL)isPathFileExit:(NSString *)filepathname
{
    BOOL bRet = NO;
    
    /*
     if ([[NSFileManager defaultManager] fileExistsAtPath:filepathname])
     {
     bRet = TRUE;
     }*/
    BOOL isDir;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepathname isDirectory:&isDir])
    {
        if (isDir)
        {
            //            表示目录存在，文件不存在
            bRet = NO;
        }
        else
        {
            //            表示文件存在
            bRet = YES;
        }
    }
    
    return bRet;
}

#pragma mark - 获取文件大小
+ (NSInteger)getFileSize:(NSString *)path
{
    //    NSLog(@"path=%@", path);
    NSFileManager *filemanager = [[NSFileManager alloc]init];
    if([self isPathFileExit:path])
    {
        //        NSLog(@"文件存在");
        NSDictionary * attributes = [filemanager attributesOfItemAtPath:path error:nil];
        NSNumber *theFileSize;
        if ((theFileSize = [attributes objectForKey:NSFileSize]))
        {
            return  [theFileSize intValue];
        }
        else
        {
            return -1;
        }
    }
    else
    {
        return -1;
    }
}

/**
 *  创建目录文件
 *
 *  @param path 目录路径
 */
+ (void)makeWithDirectory:(NSString *)path
{
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
}

/**
 *  删除目录文件
 *
 *  @param path 目录路径
 */
+ (void)removeWithDirectory:(NSString *)path
{
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager removeItemAtPath:path error:NULL];
}

/**
 *  得到目录下的文件数量
 *
 *  @param dir <#dir description#>
 *
 *  @return 返回文件数量
 */
+ (NSInteger)fileCountOfDirectory:(NSString *)dir
{
    NSFileManager *manager = [NSFileManager defaultManager];
    return [manager contentsOfDirectoryAtPath:dir error:NULL].count;
}

/**
 *  计算本地缓存
 *
 *  @return 返回本地缓存大小(字节)
 */
+ (CGFloat)localCacheSize
{
    CGFloat allSize = 0.0;
    NSString *cachePath = [[self class] getFileLibraryPath:@"Caches"];
    NSString *cookiesPath = [[self class] getFileLibraryPath:@"Cookies"];
    allSize += [[self class] fileSizeForDir:cachePath];
    allSize += [[self class] fileSizeForDir:cookiesPath];
    return allSize;
}

/**
 *  计算文件夹大小
 *
 *  @param path 文件夹目录
 *
 *  @return 此文件夹的大小(字节)
 */
+ (CGFloat)fileSizeForDir:(NSString *)path
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    CGFloat size = 0.0;
    NSArray *array = [fileManager contentsOfDirectoryAtPath:path error:nil];
    for(int i = 0; i<[array count]; i++)
    {
        NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
        if ([[array objectAtIndex:i] isEqualToString:identifier])
        {// 系统缓存
            continue;
        }
        NSString *fullPath = [path stringByAppendingPathComponent:[array objectAtIndex:i]];
        BOOL isDir;
        if ( !([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && isDir) )
        {// 文件
            NSDictionary *fileAttributeDic = [fileManager attributesOfItemAtPath:fullPath error:nil];
            size += fileAttributeDic.fileSize;
        }
        else
        {// 文件夹
            size += [self fileSizeForDir:fullPath];
        }
    }
#if !__has_feature(objc_arc)
    [fileManager release], fileManager = nil;
#endif
    
    return size;
}

/**
 *  清除本地缓存
 */
+ (void)deleteLocalCache
{
    NSString *cachePath = [[self class] getFileLibraryPath:@"Caches"];
    NSString *cookiesPath = [[self class] getFileLibraryPath:@"Cookies"];
    
    [self deleteForDir:cachePath];
    [self deleteForDir:cookiesPath];
}

/**
 *  清除指定文件夹下的内容
 *
 *  @param path 清除的目录路径
 */
+ (void)deleteForDir:(NSString *)path
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSArray *array = [fileManager contentsOfDirectoryAtPath:path error:nil];
    for(int i = 0; i<[array count]; i++)
    {
        NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
        if ([[array objectAtIndex:i] isEqualToString:identifier])
        {// 系统缓存
            continue;
        }
        NSString *fullPath = [path stringByAppendingPathComponent:[array objectAtIndex:i]];
        //        NSLog(@"fullPath=%@", fullPath);
        
//        if ([fullPath isEqualToString:UNZIPCACHEPATH] || [fullPath isEqualToString:ZIPCACHEPATH])
//        {
//            break;
//        }
        
        BOOL isDir;
        if ( !([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && isDir) )
        {// 文件
            [fileManager removeItemAtPath:fullPath error:NULL];
        }
        else
        {// 文件夹
            [self deleteForDir:fullPath];
        }
    }
#if !__has_feature(objc_arc)
    [fileManager release], fileManager = nil;
#endif
}
@end
