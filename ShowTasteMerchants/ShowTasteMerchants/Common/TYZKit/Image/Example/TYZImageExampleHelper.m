//
//  TYZImageExampleHelper.m
//  51tourGuide
//
//  Created by 唐斌 on 16/4/25.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZImageExampleHelper.h"

@implementation TYZImageExampleHelper
+ (void)addTapControlToAnimatedImageView:(TYZAnimatedImageView *)view
{
    if (!view) return;
    view.userInteractionEnabled = YES;
    __weak typeof(view) _view = view;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender)
    {
        if ([_view isAnimating]) [_view stopAnimating];
        else  [_view startAnimating];
        
        // add a "bounce" animation
        UIViewAnimationOptions op = UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionBeginFromCurrentState;
        [UIView animateWithDuration:0.1 delay:0 options:op animations:^{
            _view.layer.transformScale = 0.97;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 delay:0 options:op animations:^{
                _view.layer.transformScale = 1.008;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1 delay:0 options:op animations:^{
                    _view.layer.transformScale = 1;
                } completion:NULL];
            }];
        }];
    }];
    [view addGestureRecognizer:tap];
}

+ (void)addPanControlToAnimatedImageView:(TYZAnimatedImageView *)view
{
    if (!view) return;
    view.userInteractionEnabled = YES;
    __weak typeof(view) _view = view;
    __block BOOL previousIsPlaying;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithActionBlock:^(id sender) {
        UIImage<TYZAnimatedImage> *image = (id)_view.image;
        if (![image conformsToProtocol:@protocol(TYZAnimatedImage)]) return;
        UIPanGestureRecognizer *gesture = sender;
        CGPoint p = [gesture locationInView:gesture.view];
        CGFloat progress = p.x / gesture.view.width;
        if (gesture.state == UIGestureRecognizerStateBegan)
        {
            previousIsPlaying = [_view isAnimating];
            [_view stopAnimating];
            _view.currentAnimatedImageIndex = image.animatedImageFrameCount * progress;
        }
        else if (gesture.state == UIGestureRecognizerStateEnded ||
                   gesture.state == UIGestureRecognizerStateCancelled)
        {
            if (previousIsPlaying) [_view startAnimating];
        }
        else
        {
            _view.currentAnimatedImageIndex = image.animatedImageFrameCount * progress;
        }
    }];
    [view addGestureRecognizer:pan];
}

@end
