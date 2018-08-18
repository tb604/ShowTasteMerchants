/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: TYZScan
 * 文件名称: ScanResultViewController.h
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/11/1 09:27
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import <UIKit/UIKit.h>

/// 二维码扫描结果
@interface ScanResultViewController : UIViewController

@property (nonatomic, strong) UIImage *imgScan;
@property (nonatomic, copy) NSString *strScan;

@property (nonatomic,copy)NSString *strCodeType;

@end
