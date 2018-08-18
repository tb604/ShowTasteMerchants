/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: TYZScan
 * 文件名称: TYZQRCodeGenerator.h
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/29 12:27
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  生成二维码
 */
@interface TYZQRCodeGenerator : NSObject

/**
 *  生成二维码图片
 *
 *  @param string 字符串
 *  @param imageSize 图片大小
 */
+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGSize)imageSize;

@end























