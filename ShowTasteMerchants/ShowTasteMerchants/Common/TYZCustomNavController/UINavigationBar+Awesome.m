//
//  UINavigationBar+Awesome.m
//  51tour
//
//  Created by 唐斌 on 15/12/22.
//  Copyright © 2015年 51tour. All rights reserved.
//

#import "UINavigationBar+Awesome.h"
#import <objc/runtime.h>
#import "LocalCommon.h"

@implementation UINavigationBar (Awesome)
static char overlayKey;

- (UIView *)overlay
{
    return objc_getAssociatedObject(self, &overlayKey);
}

- (void)setOverlay:(UIView *)overlay
{
    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)wyx_setBackgroundColor:(UIColor *)backgroundColor
{
    if (!self.overlay)
    {
        debugLog(@"33333");
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        CGRect frame = CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, CGRectGetHeight(self.bounds) + 20);
        debugLogFrame(frame);
        self.overlay = [[UIView alloc] initWithFrame:frame];
        self.overlay.userInteractionEnabled = NO;
        self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//        self.overlay.backgroundColor = [UIColor purpleColor];
        [self insertSubview:self.overlay atIndex:0];
    }
    self.overlay.backgroundColor = backgroundColor;
    
}

//- (void)wyx_setTitleColor:(UIColor *)color
//{
//    NSLog(@"%@", NSStringFromSelector(_cmd));
//    [self setTitleTextAttributes:@{NSForegroundColorAttributeName:color}];
//    self.barTintColor = color;
//    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName: [UIFont boldSystemFontOfSize:18]}];
//}

- (void)wyx_setElementsAlpha:(CGFloat)alpha
{
    [[self valueForKey:@"_leftViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
        view.alpha = alpha;
    }];
    
    [[self valueForKey:@"_rightViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
        view.alpha = alpha;
    }];
    
    UIView *titleView = [self valueForKey:@"_titleView"];
    titleView.alpha = alpha;
}

- (void)wyx_setTranslationY:(CGFloat)translationY
{
    self.transform = CGAffineTransformMakeTranslation(0, translationY);
}

- (void)wyx_reset:(UIColor *)color
{
    UIImage *image = nil;
    if (color)
    {
        image = [UIImage imageWithColor:color];
    }
    
    [self setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.overlay removeFromSuperview];
    self.overlay = nil;
}

@end






























