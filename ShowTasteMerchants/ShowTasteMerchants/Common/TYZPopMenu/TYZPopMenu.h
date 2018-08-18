/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: TYZPopMenu.h
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/18 10:27
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class TYZPopMenuView, TYZPopMenuItem, TYZPopMenuConfiguration;

typedef void (^TYZPopMenuItemAction)(TYZPopMenuItem * __nullable item);

typedef NS_ENUM(NSUInteger, TYZPopMenuAnimationStyle)
{
    TYZPopMenuAnimationStyleNone, ///< 没有动画
    TYZPopMenuAnimationStyleFade, ///< 扁平动画
    TYZPopMenuAnimationStyleScale, ///< 缩放动画
    TYZPopMenuAnimationStyleWeiXin, ///< 微信动画
};

@interface TYZPopMenu : NSObject

+ (void)showMenuInView:(UIView * __nullable)inView
              withView:(UIView * __nonnull)view
             menuItems:(NSArray<__kindof TYZPopMenuItem *> * __nonnull)menuItems
           withOptions:(TYZPopMenuConfiguration * __nullable)options;

+ (void)showMenuWithView:(UIView * __nonnull)view
               menuItems:(NSArray<__kindof TYZPopMenuItem *> * __nonnull)menuItems
             withOptions:(TYZPopMenuConfiguration * __nullable)options;

+ (void)dismissMenu;

@end



@interface TYZPopMenuConfiguration : NSObject

@property (nonatomic, assign) TYZPopMenuAnimationStyle style; ///< 动画风格
@property (nonatomic, assign) CGFloat arrowSize; ///< 箭头大小
@property (nonatomic, assign) CGFloat arrowMargin; ///< 手动设置箭头和目标view的距离
@property (nonatomic, assign) CGFloat marginXSpacing; ///< MenuItem左右边距
@property (nonatomic, assign) CGFloat marginYSpacing; ///< MenuItem上下边距
@property (nonatomic, assign) CGFloat intervalSpacing; ///< MenuItemImage与MenuItemTitle的间距
@property (nonatomic, assign) CGFloat menuCornerRadius; ///< 菜单圆角半径
@property (nonatomic, assign) CGFloat menuScreenMinMargin; ///< 菜单和屏幕最小间距
@property (nonatomic, assign) CGFloat menuMaxHeight; ///< 菜单最大高度
@property (nonatomic, assign) CGFloat separatorInsetLeft; ///< 分割线左侧Insets
@property (nonatomic, assign) CGFloat separatorInsetRight; ///< 分割线右侧Insets
@property (nonatomic, assign) CGFloat separatorHeight; ///< 分割线高度
@property (nonatomic, assign) CGFloat fontSize; ///< 字体大小
@property (nonatomic, assign) CGFloat itemHeight; ///< 单行高度
@property (nonatomic, assign) CGFloat itemMaxWidth; ///< 单行最大宽度
@property (nonatomic, assign) NSTextAlignment alignment; ///< 文字对齐方式
@property (nonatomic, assign) BOOL shadowOfMenu; ///< 是否添加菜单阴影
@property (nonatomic, assign) BOOL hasSeparatorLine; ///< 是否设置分割线

@property (nonatomic, strong) UIColor *titleColor; ///< menuItem字体颜色
@property (nonatomic, strong) UIColor *separatorColor; ///< 分割线颜色
@property (nonatomic, strong) UIColor *shadowColor; ///< 阴影颜色
@property (nonatomic, strong) UIColor *menuBackgroundColor; ///< 菜单的底色
@property (nonatomic, strong) UIColor *selectedColor; ///< menuItem选中颜色
@property (nonatomic, strong) UIColor *maskBackgroundColor; ///< 遮罩颜色

+ (instancetype)defaultConfiguration;

@end

@interface TYZPopMenuItem : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign, readonly) SEL action;
@property (nonatomic,   weak, readonly) id target;
@property (nonatomic,   copy, readonly) TYZPopMenuItemAction block;

- (instancetype)initWithTitle:(NSString *)title
                        image:(UIImage *)image
                       target:(id)target
                       action:(SEL)action;

- (instancetype)initWithTitle:(NSString *)title
                        image:(UIImage *)image
                        block:(TYZPopMenuItemAction)block;
@end


NS_ASSUME_NONNULL_END




























