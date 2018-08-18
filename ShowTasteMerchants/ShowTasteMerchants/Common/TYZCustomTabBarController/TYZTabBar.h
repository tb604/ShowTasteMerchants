//
//  TYZTabBar.h
//  TYZCustomTabBarController_1
//
//  Created by 唐斌 on 16/3/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYZTabBar : UITabBar

/**
 *  初始化
 *
 *  @param showMiddleBtn 是否显示中间的凸出的按钮
 *
 *  @return id
 */
- (instancetype)initWithShowMiddleBtn:(BOOL)showMiddleBtn;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;

- (instancetype)initWithFrame:(CGRect)frame UNAVAILABLE_ATTRIBUTE; // 设置init系统函数不可用


@end
