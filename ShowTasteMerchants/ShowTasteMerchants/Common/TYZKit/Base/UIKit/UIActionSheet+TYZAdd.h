/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ChefDating
 * 文件名称: UIActionSheet+TYZAdd.h
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/11/2 14:04
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import <UIKit/UIKit.h>

@interface UIActionSheet (TYZAdd) <UIActionSheetDelegate>

- (void)showInView:(UIView *)view block:(void(^)(NSInteger idx, NSString *buttonTitle))block;


@end













