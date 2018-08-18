/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCShopQualicationImageView.h
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/19 22:54
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import <UIKit/UIKit.h>

@interface CTCShopQualicationImageView : UIImageView

@property (nonatomic, copy) void (^touchWithBlock)();

- (void)hiddenWithTitle:(BOOL)hidden;

- (void)updateWithTitle:(NSString *)title;

@end















