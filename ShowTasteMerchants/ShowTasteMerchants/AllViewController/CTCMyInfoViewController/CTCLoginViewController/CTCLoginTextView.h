/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCLoginTextView.h
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/19 09:59
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "TYZBaseView.h"

#define kCTCLoginTextViewHeight (kiPhone4?40:50.0)

@interface CTCLoginTextView : TYZBaseView

@property (nonatomic, copy) void (^touchWithVerCodeBlock)(id data);

@property (nonatomic, strong) UITextField *txtField;


/**
 *  更新
 *
 *  @param iconImage 图片
 *  @param placeholder place
 *  @param pwdRightImg 右边的图片
 *  @param isVerCode 是否是验证码
 *
 */
- (void)updateWithIconImg:(UIImage *)iconImage placeholder:(NSString *)placeholder pwdRightImg:(UIImage *)pwdRightImg isVerCode:(BOOL)isVerCode;

/**
 *  设置时间，更新时间，描述
 *
 *  @param second    秒数
 */
- (void)updateTimeSecond:(NSNumber *)second;

@end

















