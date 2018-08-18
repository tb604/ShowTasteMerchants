//
//  UINavigationController+TyZFullScreenPopGesture.m
//  51tourGuide
//
//  Created by 唐斌 on 16/3/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "UINavigationController+TyZFullScreenPopGesture.h"
#import <objc/runtime.h>

@interface _TYZFullscreenPopGestureRecognizerDelegate : NSObject <UIGestureRecognizerDelegate>
@property (nonatomic, weak) UINavigationController *navigationController;
@end

@implementation _TYZFullscreenPopGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    // ignore when no view controller is pushed into the navigation stack.(当没有视图控制器在nav pushed里面的时候，忽略)
    if ([_navigationController.viewControllers count] <= 1)
    {
        return NO;
    }
    
    // ignore when the active view controller doesn't allow interactive pop.
    UIViewController *topViewController = _navigationController.viewControllers.lastObject;
    if (topViewController.tyz_interactivePopDisabled)
    {
        return NO;
    }
    
    // ignore when the beginning location is beyond max allowed initial distance to left edge.
    CGPoint beginningLocation = [gestureRecognizer locationInView:gestureRecognizer.view];
    CGFloat maxAllowedInitialDistance = topViewController.tyz_interactivePopMaxAllowedInitialDistanceToLeftEdge;
    if (maxAllowedInitialDistance > 0 && beginningLocation.x > maxAllowedInitialDistance)
    {
        return NO;
    }
    
    // ignore pan gesture when the navigation controller is currently in transition.
    if ([[_navigationController valueForKey:@"_isTransitioning"] boolValue])
    {
        return NO;
    }
    
    // prevent calling the handler when the gesture begins in an opposite direction.
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.x <= 0)
    {
        return NO;
    }
    
    return YES;
}

@end

typedef void(^_TYZViewControllerWillAppearInjectBlock)(UIViewController *viewController, BOOL animated);

@interface UIViewController (TYZFullScreenPopGesturePrivate)
@property (nonatomic, copy) _TYZViewControllerWillAppearInjectBlock tyz_willAppearInjectBlock;
@end

@implementation UIViewController (TYZFullScreenPopGesturePrivate)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSel = @selector(viewWillAppear:);
        SEL swizzledSel = @selector(tyz_viewWillAppear:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSel);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSel);
        
        BOOL success = class_addMethod(class, originalSel, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success)
        {
            class_replaceMethod(class, swizzledSel, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        }
        else
        {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)tyz_viewWillAppear:(BOOL)animated
{
    [self tyz_viewWillAppear:animated];
    
    if (self.tyz_willAppearInjectBlock)
    {
        self.tyz_willAppearInjectBlock(self, animated);
    }
}

- (_TYZViewControllerWillAppearInjectBlock)tyz_willAppearInjectBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTyz_willAppearInjectBlock:(_TYZViewControllerWillAppearInjectBlock)block
{
    objc_setAssociatedObject(self, @selector(tyz_willAppearInjectBlock), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end


@implementation UINavigationController (TYZFullScreenPopGesture)

+ (void)load
{
    
}

- (void)tyz_pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.tyz_fullscreenPopGestureRecognizer])
    {
        // Add our own gesture recognizer to where the onboard screen edge pan gesture recognizer is attached to.
        [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.tyz_fullscreenPopGestureRecognizer];
        
        // Forward the gesture events to the private handler of the onboard gesture recognizer.
        NSArray *internalTargets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
        id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
        SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
        self.tyz_fullscreenPopGestureRecognizer.delegate = self.tyz_popGestureRecognizerDelegate;
        [self.tyz_fullscreenPopGestureRecognizer addTarget:internalTarget action:internalAction];
        
        // disable the onboard gesture recognizer.
        self.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)fd_setupViewControllerBasedNavigationBarAppearanceIfNeeded:(UIViewController *)appearingViewController
{
    if (!self.tyz_viewControllerBasedNavigationBarAppearanceEnabled)
    {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    _TYZViewControllerWillAppearInjectBlock block = ^(UIViewController *viewController, BOOL animated)
    {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf)
        {
            [strongSelf setNavigationBarHidden:viewController.tyz_prefersNavigationBarHidden animated:animated];
        }
    };
    
    // Setup will appear inject block to appearing view controller.
    // Setup disappearing view controller as well, because not every view controller is added into
    // stack by pushing, maybe by "-setViewControllers:".
    appearingViewController.tyz_willAppearInjectBlock = block;
    UIViewController *disappearingViewController = self.viewControllers.lastObject;
    if (disappearingViewController && !disappearingViewController.tyz_willAppearInjectBlock)
    {
        disappearingViewController.tyz_willAppearInjectBlock = block;
    }
}

- (_TYZFullscreenPopGestureRecognizerDelegate *)tyz_popGestureRecognizerDelegate
{
    _TYZFullscreenPopGestureRecognizerDelegate *delegate = objc_getAssociatedObject(self, _cmd);
    
    if (!delegate)
    {
        delegate = [[_TYZFullscreenPopGestureRecognizerDelegate alloc] init];
        delegate.navigationController = self;
        
        objc_setAssociatedObject(self, _cmd, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return delegate;
}

- (UIPanGestureRecognizer *)tyz_fullscreenPopGestureRecognizer
{
    UIPanGestureRecognizer *panGestureRecognizer = objc_getAssociatedObject(self, _cmd);
    
    if (!panGestureRecognizer)
    {
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
        panGestureRecognizer.maximumNumberOfTouches = 1;
        
        objc_setAssociatedObject(self, _cmd, panGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return panGestureRecognizer;
}

- (BOOL)tyz_viewControllerBasedNavigationBarAppearanceEnabled
{
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if (number)
    {
        return number.boolValue;
    }
    self.tyz_viewControllerBasedNavigationBarAppearanceEnabled = YES;
    return YES;
}

- (void)setTyz_viewControllerBasedNavigationBarAppearanceEnabled:(BOOL)enabled
{
    SEL key = @selector(tyz_viewControllerBasedNavigationBarAppearanceEnabled);
    objc_setAssociatedObject(self, key, @(enabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end


@implementation UIViewController (TYZFullScreenPopGesture)

- (BOOL)tyz_interactivePopDisabled
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setTyz_interactivePopDisabled:(BOOL)disabled
{
    objc_setAssociatedObject(self, @selector(tyz_interactivePopDisabled), @(disabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)tyz_prefersNavigationBarHidden
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setTyz_prefersNavigationBarHidden:(BOOL)hidden
{
    objc_setAssociatedObject(self, @selector(tyz_prefersNavigationBarHidden), @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)tyz_interactivePopMaxAllowedInitialDistanceToLeftEdge
{
#if CGFLOAT_IS_DOUBLE
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
#else
    return [objc_getAssociatedObject(self, _cmd) floatValue];
#endif
}

- (void)setTyz_interactivePopMaxAllowedInitialDistanceToLeftEdge:(CGFloat)distance
{
    objc_setAssociatedObject(self, @selector(tyz_interactivePopMaxAllowedInitialDistanceToLeftEdge), @(MAX(0, distance)), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

























