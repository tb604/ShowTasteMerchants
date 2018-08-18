//
//  UIScrollView+TYZAdd.m
//  YYStudyDemo
//
//  Created by 唐斌 on 16/3/2.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "UIScrollView+TYZAdd.h"
#import "TYZKitMacro.h"

TYZSYNTH_DUMMY_CLASS(UIScrollView_TYZAdd)

@implementation UIScrollView (TYZAdd)

- (void)scrollToTop
{
    debugMethod();
    [self scrollToTopAnimated:YES];
}

- (void)scrollToBottom
{
    [self scrollToBottomAnimated:YES];
}

- (void)scrollToLeft
{
    [self scrollToLeftAnimated:YES];
}

- (void)scrollToRight
{
    [self scrollToRightAnimated:YES];
}

- (void)scrollToTopAnimated:(BOOL)animated
{
    CGPoint off = self.contentOffset;
//    debugLogPoint(off);
//    debugLog(@"contentInset.top=%.2f", self.contentInset.top);
    off.y = 0 - self.contentInset.top;
    [self setContentOffset:off animated:animated];
}

- (void)scrollToBottomAnimated:(BOOL)animated
{
    CGPoint off = self.contentOffset;
    off.y = self.contentSize.height - self.bounds.size.height + self.contentInset.bottom;
    [self setContentOffset:off animated:animated];
}

- (void)scrollToLeftAnimated:(BOOL)animated
{
    CGPoint off = self.contentOffset;
    off.x = 0 - self.contentInset.left;
    [self setContentOffset:off animated:animated];
}

- (void)scrollToRightAnimated:(BOOL)animated
{
    CGPoint off = self.contentOffset;
    off.x = self.contentSize.width - self.bounds.size.width + self.contentInset.right;
    [self setContentOffset:off animated:animated];
}

@end





























