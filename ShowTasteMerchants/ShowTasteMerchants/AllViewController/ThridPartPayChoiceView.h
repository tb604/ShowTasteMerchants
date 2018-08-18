/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: ThridPartPayChoiceView.h
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/27 23:07
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "TYZBaseView.h"

#define kThridPartPayChoiceViewHeight (198.0)

@interface ThridPartPayChoiceView : TYZBaseView

/// 支付账号
@property (nonatomic, strong) UITextField *payAccountTxtField;

///  上传二维码
@property (nonatomic, copy) void (^uploadQrcodeImageBlock)(id payEnt);

- (void)hiddenWithBottomLine:(BOOL)hidden;

@end










