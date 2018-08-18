/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCRestaurantMealingOrderLeftView.h
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/17 16:11
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "TYZBaseView.h"

@interface CTCRestaurantMealingOrderLeftView : TYZBaseView

@property (nonatomic, copy) void (^selectOrderSeatBlock)(id data);

+ (NSInteger)getWithViewWidth;

- (void)updateViewData:(id)entity isReset:(BOOL)isReset;

@end





















