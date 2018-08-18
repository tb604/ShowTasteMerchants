/*
 *   Copyright (c) 2015年 51tour. All rights reserved.
 *
 * 项目名称: 51tour
 * 文件名称: POAPinyin.h
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 15/4/22 上午10:14
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import <Foundation/Foundation.h>

@interface POAPinyin : NSObject

/**
 *  输入中文，返回拼音
 *
 *  @param hzString 中文
 *
 *  @return 返回拼音
 */
+ (NSString *)convert:(NSString *)hzString;

//  added by setimouse ( setimouse@gmail.com )
+ (NSString *)quickConvert:(NSString *)hzString;

+ (void)clearCache;
@end
