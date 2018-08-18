//
//  TYZCustomTabBarController.h
//  TYZCustomTabBarController_1
//
//  Created by 唐斌 on 16/3/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYZCustomTabBarController : UITabBarController

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

- (void)updateWithNavType:(NSInteger)type;

@end
