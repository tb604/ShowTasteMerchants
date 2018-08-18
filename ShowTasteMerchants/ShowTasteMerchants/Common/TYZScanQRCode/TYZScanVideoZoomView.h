/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: TYZScan
 * 文件名称: TYZScanVideoZoomView.h
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/29 10:34
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import <UIKit/UIKit.h>

/**
 *  扫描视频缩放视图
 */
@interface TYZScanVideoZoomView : UIView

/// 控件值变化
@property (nonatomic, copy) void (^block)(float value);

- (void)setMaximunValue:(CGFloat)value;

@end

















