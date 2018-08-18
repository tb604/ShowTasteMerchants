//
//  UIView+TYZText.m
//  51tourGuide
//
//  Created by 唐斌 on 16/3/18.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "UIView+TYZText.h"
#import "TYZKitMacro.h"

TYZSYNTH_DUMMY_CLASS(UIView_TYZText)

@implementation UIView (TYZText)

- (UIViewController *)tyz_viewController
{
    for (UIView *view = self; view; view = view.superview)
    {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (CGFloat)tyz_visibleAlpha
{
    if ([self isKindOfClass:[UIWindow class]])
    {
        if (self.hidden) return 0;
        return self.alpha;
    }
    if (!self.window) return 0;
    CGFloat alpha = 1;
    UIView *v = self;
    while (v)
    {
        if (v.hidden)
        {
            alpha = 0;
            break;
        }
        alpha *= v.alpha;
        v = v.superview;
    }
    return alpha;
}

- (CGPoint)tyz_convertPoint:(CGPoint)point toViewOrWindow:(UIView *)view
{
    if (!view)
    {
        if ([self isKindOfClass:[UIWindow class]])
        {
            return [((UIWindow *)self) convertPoint:point toWindow:nil];
        }
        else
        {
            return [self convertPoint:point toView:nil];
        }
    }
    
    UIWindow *from = [self isKindOfClass:[UIWindow class]] ? (id)self : self.window;
    UIWindow *to = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    if ((!from || !to) || (from == to)) return [self convertPoint:point toView:view];
    point = [self convertPoint:point toView:from];
    point = [to convertPoint:point fromWindow:from];
    point = [view convertPoint:point fromView:to];
    return point;
}

- (CGPoint)tyz_convertPoint:(CGPoint)point fromViewOrWindow:(UIView *)view
{
    if (!view)
    {
        if ([self isKindOfClass:[UIWindow class]])
        {
            return [((UIWindow *)self) convertPoint:point fromWindow:nil];
        }
        else
        {
            return [self convertPoint:point fromView:nil];
        }
    }
    
    UIWindow *from = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    UIWindow *to = [self isKindOfClass:[UIWindow class]] ? (id)self : self.window;
    if ((!from || !to) || (from == to)) return [self convertPoint:point fromView:view];
    point = [from convertPoint:point fromView:view];
    point = [to convertPoint:point fromWindow:from];
    point = [self convertPoint:point fromView:to];
    return point;
}

- (CGRect)tyz_convertRect:(CGRect)rect toViewOrWindow:(UIView *)view {
    if (!view)
    {
        if ([self isKindOfClass:[UIWindow class]])
        {
            return [((UIWindow *)self) convertRect:rect toWindow:nil];
        }
        else
        {
            return [self convertRect:rect toView:nil];
        }
    }
    
    UIWindow *from = [self isKindOfClass:[UIWindow class]] ? (id)self : self.window;
    UIWindow *to = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    if (!from || !to) return [self convertRect:rect toView:view];
    if (from == to) return [self convertRect:rect toView:view];
    rect = [self convertRect:rect toView:from];
    rect = [to convertRect:rect fromWindow:from];
    rect = [view convertRect:rect fromView:to];
    return rect;
}

- (CGRect)tyz_convertRect:(CGRect)rect fromViewOrWindow:(UIView *)view
{
    if (!view)
    {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *)self) convertRect:rect fromWindow:nil];
        }
        else
        {
            return [self convertRect:rect fromView:nil];
        }
    }
    
    UIWindow *from = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    UIWindow *to = [self isKindOfClass:[UIWindow class]] ? (id)self : self.window;
    if ((!from || !to) || (from == to)) return [self convertRect:rect fromView:view];
    rect = [from convertRect:rect fromView:view];
    rect = [to convertRect:rect fromWindow:from];
    rect = [self convertRect:rect fromView:to];
    return rect;
}


@end
