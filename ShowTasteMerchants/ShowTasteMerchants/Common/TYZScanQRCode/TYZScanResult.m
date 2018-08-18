/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: TYZScan
 * 文件名称: TYZScanResult.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/29 11:11
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "TYZScanResult.h"

@implementation TYZScanResult

- (instancetype)initWithScanString:(NSString *)str imgScan:(UIImage *)image barCodeType:(NSString *)type
{
    self = [super init];
    if (self)
    {
        self.strScanned = str;
        self.imgScanned = image;
        self.strBarCodeType = type;
    }
    return self;
}

@end






















