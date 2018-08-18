//
//  ManagerModeTabBarController.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/7.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  经营模式
 */
@interface ManagerModeTabBarController : UITabBarController

@property (nonatomic, assign) CGFloat appNavBarHeight;

@property (nonatomic, assign) CGFloat appTabBarHeight;

/**
 *  初始化
 *
 *  @param showMiddleBtn 是否显示中间的凸出的按钮
 *
 *  @return id
 */
- (instancetype)initWithShowMiddleBtn:(BOOL)showMiddleBtn;


- (instancetype)init UNAVAILABLE_ATTRIBUTE;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil UNAVAILABLE_ATTRIBUTE;

/**
 *  是否隐藏下面的视图
 *
 *  @return bool
 */
- (BOOL)hiddenWithWaitView;

@end
