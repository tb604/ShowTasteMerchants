/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: TYZScan
 * 文件名称: TYZQRCodeGenerator.m
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

#import "TYZQRCodeGenerator.h"
#import <CoreImage/CoreImage.h>

@implementation TYZQRCodeGenerator

/**
 *  生成二维码图片
 *
 *  @param string 字符串
 *  @param imageSize 图片大小
 */
+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGSize)imageSize
{
    if (![string length])
    {
        return nil;
    }
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    // 创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 回复默认
    [filter setDefaults];
    // 设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    // 获取输出的二维码
    CIImage *outputImage = filter.outputImage;
    
    CGFloat scale = imageSize.width / CGRectGetWidth(outputImage.extent);
//    NSLog(@"scale=%.2f", scale);
    CGAffineTransform transform = CGAffineTransformMakeScale(scale, scale);
    CIImage *transformImage = [outputImage imageByApplyingTransform:transform];
    UIImage *qrCodeImage = [UIImage imageWithCIImage:transformImage];
//    NSLog(@"size=%@", NSStringFromCGSize(qrCodeImage.size));
    return qrCodeImage;
}

@end



















