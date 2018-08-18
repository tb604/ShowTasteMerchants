//
//  TYZCommonPushVC.h
//  51tourGuide
//
//  Created by 唐斌 on 16/4/19.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CommonWebViewController.h"

@interface TYZCommonPushVC : NSObject


#pragma mark - 公用部分

/**
 *  拨打电话
 *
 *  @param vc       vc
 *  @param phoneNum 电话号码
 */
+ (void)callWithPhone:(UIViewController *)vc phone:(NSString *)phoneNum;

/**
 * 重新刷新tableview
 *
 *  @param tableView tableview
 *  @param indexPath indexpath
 *  @param reloadType 1：reloadTableView；2：reloadsection；3：reloadRow
 */
+ (void)reloadWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath reloadType:(NSInteger)reloadType;

/**
 *  给字符串的中间画上一条横线
 *
 *  @param text      字符串
 *  @param font      字的大小
 *  @param textColor 字的颜色
 *  @param lineColor 线条的颜色
 *
 *  @return 属性字符串
 */
+ (NSMutableAttributedString *)middleSingleLine:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor lineColor:(UIColor *)lineColor;

/**
 *  文字的下面画线
 *
 *  @param text      <#text description#>
 *  @param font      <#font description#>
 *  @param textColor <#textColor description#>
 *  @param lineColor <#lineColor description#>
 *
 *  @return <#return value description#>
 */
+ (NSMutableAttributedString *)belowSingleLine:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor lineColor:(UIColor *)lineColor;


#pragma mark - push VC

+ (void)showWithBaseVC:(UIViewController *)navVC pushVC:(UIViewController *)pushVC;

/**
 *  显示web视图控制器
 *
 *  @param vc       <#vc description#>
 *  @param title    <#title description#>
 *  @param data     <#data description#>
 *  @param complete <#complete description#>
 */
+ (void)showWithCommonWebVC:(UIViewController *)vc title:(NSString *)title data:(id)data complete:(void(^)(id data))complete;




@end
