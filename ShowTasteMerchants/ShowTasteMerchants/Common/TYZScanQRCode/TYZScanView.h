/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: TYZScan
 * 文件名称: TYZScanView.h
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/31 10:30
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import <UIKit/UIKit.h>
#import "TYZScanLineAnimation.h"
#import "TYZScanNetAnimation.h"
#import "TYZScanViewStyle.h"

// github:https://github.com/MxABC/LBXScan
// ZXing

/**
 *  扫码区域显示效果
 */
@interface TYZScanView : UIView

/**
 *  @brief  初始化
 *
 *  @param frame 位置大小
 *  @param style 类型
 *  @return instancetype
 */
-(id)initWithFrame:(CGRect)frame style:(TYZScanViewStyle *)style;

/**
 *  设备启动中文字提示
 */
- (void)startDeviceReadyingWithText:(NSString *)text;

/**
 *  设备启动完成
 */
- (void)stopDeviceReadying;

/**
 *  开始扫描动画
 */
- (void)startScanAnimation;

/**
 *  结束扫描动画
 */
- (void)stopScanAnimation;

/**
 *  @brief  根据矩形区域，获取识别兴趣区域
 *  @param view  视频流显示UIView
 *  @param style 效果界面参数
 *  @return 识别区域
 */
+ (CGRect)getScanRectWithPreView:(UIView *)view style:(TYZScanViewStyle *)style;

@end















