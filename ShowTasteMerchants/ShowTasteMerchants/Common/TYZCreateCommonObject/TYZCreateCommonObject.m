//
//  TYZCreateCommonObject.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/10.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZCreateCommonObject.h"
#import "TYZKit.h"

@implementation TYZCreateCommonObject
- (void)dealloc
{
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

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
+ (UITapGestureRecognizer *)createWithTapScrollView:(id)superClass superView:(UIView *)superView selMethod:(SEL)selMethod isDelegate:(BOOL)isDelegate
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:superClass action:selMethod];
    tap.numberOfTapsRequired = 1;
    if (isDelegate)
    {
        tap.delegate = superClass;
    }
    [superView addGestureRecognizer:tap];
#if !__has_feature(objc_arc)
    return [tap autorelease];
#else
    return tap;
#endif
}

+ (UIButton *)createWithNotImageButton:(id)superClass btnTitle:(NSString *)btnTitle titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont targetSel:(SEL)targetSel
{
    float width = [btnTitle widthForFont:titleFont height:30];
    CGRect frame = CGRectMake(0.0, 0.0, width, 30);
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    //    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //    button.frame = frame;
    [button setTitle:btnTitle forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.titleLabel.font = titleFont;
    [button addTarget:superClass action:targetSel forControlEvents:UIControlEventTouchUpInside];
#if !__has_feature(objc_arc)
    return [button autorelease];
#else
    return button;
#endif
}

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
+ (UIButton *)createWithButton:(id)superClass imgNameNor:(NSString *)imgNameNor imgNameSel:(NSString *)imgNameSel targetSel:(SEL)targetSel
{
    UIImage *image = [UIImage imageNamed:imgNameNor];
    CGRect frame = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
    UIButton *btnTravelNote = [[UIButton alloc] initWithFrame:frame];
    [btnTravelNote setImage:image forState:UIControlStateNormal];
    [btnTravelNote setImage:[UIImage imageNamed:imgNameSel] forState:UIControlStateSelected];
    [btnTravelNote addTarget:superClass action:targetSel forControlEvents:UIControlEventTouchUpInside];
    
#if !__has_feature(objc_arc)
    return [btnTravelNote autorelease];
#else
    return btnTravelNote;
#endif
}

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
+ (UILabel *)createWithLabel:(id)supperClass labelFrame:(CGRect)labelFrame textColor:(UIColor *)textColor fontSize:(UIFont *)fontSize labelTag:(NSInteger)labelTag alignment:(NSTextAlignment)alignment
{
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = alignment;
    label.textColor = textColor;
    label.font = fontSize;
    label.tag = labelTag;
    [supperClass addSubview:label];
    
#if !__has_feature(objc_arc)
    return [label autorelease];
#else
    return label;
#endif
}

@end
