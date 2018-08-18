//
//  TYZCreateCommonObject.h
//  ChefDating
//
//  Created by 唐斌 on 16/5/10.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TYZCreateCommonObject : NSObject

/**
 *  创建UITapGestureRecognizer(superClass和superView可能相同)
 *
 *  @param superClass 视图控制器或者视图
 *  @param superView  父视图
 *  @param selMethod  点击后的回调方法
 *  @param isDelegate 是否有代理
 *
 *  @return UITapGestureRecognizer
 */
+ (UITapGestureRecognizer *)createWithTapScrollView:(id)superClass superView:(UIView *)superView selMethod:(SEL)selMethod isDelegate:(BOOL)isDelegate;

/**
 *  创建按钮，只有文字的，没有图片的
 *
 *  @param superClass <#superClass description#>
 *  @param btnTitle   <#btnTitle description#>
 *  @param titleColor <#titleColor description#>
 *  @param titleFont  <#titleFont description#>
 *  @param targetSel  <#targetSel description#>
 *
 *  @return UIButton
 */
+ (UIButton *)createWithNotImageButton:(id)superClass btnTitle:(NSString *)btnTitle titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont targetSel:(SEL)targetSel;

/**
 *  创建一个UIButton
 *
 *  @param superClass 视图控制器
 *  @param imgNameNor normal状态下的图片
 *  @param imgNameSel selected状态下的图片
 *  @param targetSel  回调方法
 *
 *  @return UIButton
 */
+ (UIButton *)createWithButton:(id)superClass imgNameNor:(NSString *)imgNameNor imgNameSel:(NSString *)imgNameSel targetSel:(SEL)targetSel;

/**
 *  创建label
 *
 *  @param supperClass 父视图
 *  @param labelFrame  frame CGRect
 *  @param textColor   文字的颜色
 *  @param fontSize    文字的大小
 *  @param labelTag    tag
 *
 *  @return UILabel
 */
+ (UILabel *)createWithLabel:(id)supperClass labelFrame:(CGRect)labelFrame textColor:(UIColor *)textColor fontSize:(UIFont *)fontSize labelTag:(NSInteger)labelTag alignment:(NSTextAlignment)alignment;



@end
