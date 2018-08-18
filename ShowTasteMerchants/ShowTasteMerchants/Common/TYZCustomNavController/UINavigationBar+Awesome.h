//
//  UINavigationBar+Awesome.h
//  51tour
//
//  Created by 唐斌 on 15/12/22.
//  Copyright © 2015年 51tour. All rights reserved.
//

#import <UIKit/UIKit.h>


#define NAVBAR_CHANGE_POINT (50)

@interface UINavigationBar (Awesome)

- (void)wyx_setBackgroundColor:(UIColor *)backgroundColor;

- (void)wyx_setElementsAlpha:(CGFloat)alpha;

- (void)wyx_setTranslationY:(CGFloat)translationY;

- (void)wyx_reset:(UIColor *)color;

@end





























