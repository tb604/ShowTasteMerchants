/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: TYZScan
 * 文件名称: TYZScanLineAnimation.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/29 21:59
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "TYZScanLineAnimation.h"

@interface TYZScanLineAnimation ()
{
    int num;
    BOOL down;
    NSTimer *timer;
    BOOL isAnimationing;
}

@property (nonatomic, assign) CGRect animationRect;

@end

@implementation TYZScanLineAnimation

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code
}
*/

- (void)stepAnimation
{
    if (!isAnimationing)
    {
        return;
    }
    
    CGFloat leftX = _animationRect.origin.x + 5;
    CGFloat width = _animationRect.size.height - 10;
    
    self.frame = CGRectMake(leftX, _animationRect.origin.y + 8, width, 8);
    
    self.alpha = 0.0;
    
    self.hidden = NO;
    
    __weak __typeof(self)weakSelf = self;
    
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
    
    [UIView animateWithDuration:3 animations:^{
        CGFloat leftx = _animationRect.origin.x + 5;
        CGFloat width = _animationRect.size.width - 10;
        
        weakSelf.frame = CGRectMake(leftx, _animationRect.origin.y + _animationRect.size.height - 8, width, 4);
    } completion:^(BOOL finished) {
        weakSelf.hidden = YES;
        [weakSelf performSelector:@selector(stepAnimation) withObject:nil afterDelay:0.3];
    }];
}

- (void)startAnimatingWithRect:(CGRect)animationRect inView:(UIView *)parentView image:(UIImage *)image
{
    if (isAnimationing)
    {
//        NSLog(@"返回");
        return;
    }
    
//    NSLog(@"rect=%@", NSStringFromCGRect(animationRect));
    
    isAnimationing = YES;
//    NSLog(@"start animation");
    self.animationRect = animationRect;
    down = YES;
    num = 0;
    
    CGFloat centery = CGRectGetMinY(animationRect) + CGRectGetHeight(animationRect)/2;
    CGFloat leftx = animationRect.origin.x + 5;
    CGFloat width = animationRect.size.width - 10;
    
    self.frame = CGRectMake(leftx, centery+2*num, width, 2);
    self.image = image;
    
    [parentView addSubview:self];
    
    [self startAnimating_UIViewAnimation];
}

- (void)startAnimating_UIViewAnimation
{
    [self stepAnimation];
}

- (void)startAnimating_NSTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(scanLineAnimation) userInfo:nil repeats:YES];
}

-(void)scanLineAnimation
{
    CGFloat centery = CGRectGetMinY(_animationRect) + CGRectGetHeight(_animationRect)/2;
    CGFloat leftx = _animationRect.origin.x + 5;
    CGFloat width = _animationRect.size.width - 10;
    
    if (down)
    {
        num++;
        
        self.frame = CGRectMake(leftx, centery+2*num, width, 2);
        
        if (centery+2*num > (CGRectGetMinY(_animationRect) + CGRectGetHeight(_animationRect) - 5))
        {
            down = NO;
        }
    }
    else
    {
        num --;
        self.frame = CGRectMake(leftx, centery+2*num, width, 2);
        if (centery+2*num < (CGRectGetMinY(_animationRect) + 5))
        {
            down = YES;
        }
    }
}

- (void)dealloc
{
    [self stopAnimating];
}

- (void)stopAnimating
{
    if (isAnimationing)
    {
        
        isAnimationing = NO;
        
        if (timer)
        {
            [timer invalidate];
            timer = nil;
        }
        
        [self removeFromSuperview];
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}


@end



















