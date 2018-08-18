//
//  UINavigationController+TyZFullScreenPopGesture.h
//  51tourGuide
//
//  Created by 唐斌 on 16/3/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (TYZFullScreenPopGesture)
/**
 *  The gesture recognizer that actually handles interactive pop.
 */
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *tyz_fullscreenPopGestureRecognizer;

/**
 *  A view controller is able to control navigation bar's appearance by itself, rather than a global way, checking "fd_prefersNavigationBarHidden" property. Default to YES, disable it if you don't want so.
 */
@property (nonatomic, assign) BOOL tyz_viewControllerBasedNavigationBarAppearanceEnabled;

@end


/**
 *  Allows any view controller to disable interactive pop gesture, which might be necessary when the view controller itself handles pan gesture in some cases.
 */
@interface UIViewController (TYZFullScreenPopGesture)

/**
 *  Whether the interactive pop gesture is disabled when contained in a navigation stack.
 */
@property (nonatomic, assign) BOOL tyz_interactivePopDisabled;

/**
 *  Indicate this view controller prefers its navigation bar hidden or not, checked when view controller based navigation bar's appearance is enabled. Default to NO, bars are more likely to show.
 */
@property (nonatomic, assign) BOOL tyz_prefersNavigationBarHidden;

/**
 *  Max allowed initial distance to left edge when you begin the interactive pop gesture. 0 by default, which means it will ignore this limit.
 */
@property (nonatomic, assign) CGFloat tyz_interactivePopMaxAllowedInitialDistanceToLeftEdge;




@end



























