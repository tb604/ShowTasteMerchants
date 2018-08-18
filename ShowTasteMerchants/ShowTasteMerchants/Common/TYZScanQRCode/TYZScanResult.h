/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: TYZScan
 * 文件名称: TYZScanResult.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYZScanResult : NSObject

/**
 *  @brief 初始化
 *
 *  @param str 扫码字符串
 *  @param image 扫码图像
 *  @param type 扫码类型
 */
- (instancetype)initWithScanString:(NSString *)str imgScan:(UIImage *)image barCodeType:(NSString *)type;

/**
 *  @brief 扫描字符串
 */
@property (atomic, copy) NSString *strScanned;

/**
 *  @brief 扫码图像
 */
@property (nonatomic, strong) UIImage *imgScanned;

/**
 @brief  扫码码的类型,AVMetadataObjectType  如AVMetadataObjectTypeQRCode，AVMetadataObjectTypeEAN13Code等
 如果使用ZXing扫码，返回类型也已经转换成对应的AVMetadataObjectType
 */
@property (nonatomic, copy) NSString *strBarCodeType;

@end

NS_ASSUME_NONNULL_END























