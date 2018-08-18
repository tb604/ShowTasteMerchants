/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ChefDating
 * 文件名称: TYZAlertAction.h
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/11/2 14:09
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import <Foundation/Foundation.h>

/**
 *  @brief  封装UIAlertView、UIActionSheet、UIAlertController
 根据不同系统版本，对应选择，方便调用
 */
@interface TYZAlertAction : NSObject

/**
 @brief  模式对话框，选择一项（UIAlertView与与UIAlertController封装，根据不同ios版本对应选择调用方法）
 @param title        标题
 @param msg          提示内容
 @param block        返回点击的按钮index,按照buttonsStatement按钮的顺序，从0开始
 @param cancelString 取消按钮 文本，必须以nil结束
 */
+ (void)showAlertWithTitle:(NSString *)title msg:(NSString *)msg chooseBlock:(void (^)(NSInteger buttonIdx))block  buttonsStatement:(NSString *)cancelString, ...;

//增加延时消失入口



/**
 *  @brief  显示UIActionSheet模式对话框，UIActionSheet与UIAlertController封装，根据不同ios版本对应选择调用方法。
 *  @param title                  标题
 *  @param message                消息内容,大于ios8.0才会显示
 *  @param block                  返回block,buttonIdx:cancelString,destructiveButtonTitle分别为0、1,
 otherButtonTitle从后面开始，如果destructiveButtonTitle没有，buttonIndex1开始，反之2开始
 *  @param cancelString           取消文本
 *  @param destructiveButtonTitle 特殊标记按钮，默认红色文字显示
 *  @param otherButtonTitle       其他选项,必须以nil结束
 */
+ (void)showActionSheetWithTitle:(NSString *)title message:(NSString *)message chooseBlock:(void (^)(NSInteger buttonIdx))block
               cancelButtonTitle:(NSString *)cancelString destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitle:(NSString *)otherButtonTitle,...;

@end