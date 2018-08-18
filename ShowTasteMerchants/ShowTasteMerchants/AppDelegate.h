//
//  AppDelegate.h
//  ShowTasteMerchants
//
//  Created by 唐斌 on 16/9/28.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "TYZCustomTabBarController.h"
#import "ManagerModeTabBarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**
 *  食客端
 */
//@property (nonatomic, strong, readonly) TYZCustomTabBarController *rootViewController;

/**
 *  餐厅端
 */
@property (nonatomic, strong, readonly) ManagerModeTabBarController *rootViewController;

- (void)loadRootVC;

/**
 *  Description
 */
//- (void)loadRootVC;

- (void)showWithUserInfoVC:(BOOL)show;

- (CGFloat)tabBarHeight;

- (CGFloat)navBarHeight;

- (void)hiddenWithTipView:(BOOL)hidden isTop:(BOOL)isTop;

//- (void)updateWithNavType:(NSInteger)type;

@end

