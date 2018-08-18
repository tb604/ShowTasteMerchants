/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: TYZScan
 * 文件名称: TYZScanNetAnimation.h
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/29 21:40
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import <UIKit/UIKit.h>

/**
 *  扫描网格效果
 */
@interface TYZScanNetAnimation : UIView

/**
 *  开始扫码网格效果
 *
 *  @param animationRect 显示在parentView中的区域
 *  @param parentView 动画显示在UIView
 *  @param image 扫码线的图像
 */
- (void)startAnimatingWithRect:(CGRect)animationRect inView:(UIView *)parentView image:(UIImage *)image;

/**
 *  停止动画
 */
- (void)stopAnimating;

@end
















