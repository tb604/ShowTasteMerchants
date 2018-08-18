/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: TYZScan
 * 文件名称: TYZScanNetAnimation.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/29 21:40
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "TYZScanNetAnimation.h"

@interface TYZScanNetAnimation ()
{
    BOOL isAnimationing;
}

@property (nonatomic, assign) CGRect animationRect;

@property (nonatomic, strong) UIImageView *scanImageView;

@end

@implementation TYZScanNetAnimation

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code
}
*/

- (instancetype)init
{
    if (self = [super init])
    {
        self.clipsToBounds = YES;
        [self addSubview:self.scanImageView];
    }
    return self;
}

- (UIImageView *)scanImageView
{
    if (!_scanImageView)
    {
        _scanImageView = [[UIImageView alloc] init];
    }
    return _scanImageView;
}

- (void)stepAnimation
{
    if (!isAnimationing)
    {
        return;
    }
    
    self.frame = _animationRect;
    
    CGFloat scanNetImageViewW = CGRectGetWidth(self.frame);
    CGFloat scanNetImageViewH = self.frame.size.height;

    __weak typeof(self)weakSelf = self;
    self.alpha = 0.5;
    _scanImageView.frame = CGRectMake(0.0f, -scanNetImageViewH, scanNetImageViewW, scanNetImageViewH);
    [UIView animateWithDuration:1.4 animations:^{
        weakSelf.alpha = 1.0;
        
        _scanImageView.frame = CGRectMake(0.0f, scanNetImageViewW - scanNetImageViewH, scanNetImageViewW, scanNetImageViewH);
    } completion:^(BOOL finished) {
        [weakSelf performSelector:@selector(stepAnimation) withObject:nil afterDelay:0.3];
    }];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self performSelector:@selector(stepAnimation) withObject:nil afterDelay:0.3];
}

- (void)startAnimatingWithRect:(CGRect)animationRect inView:(UIView *)parentView image:(UIImage *)image
{
    [self.scanImageView setImage:image];
    
    self.animationRect = animationRect;
    
    [parentView addSubview:self];
    
    self.hidden = NO;
    
    isAnimationing = YES;
    
    [self stepAnimation];
}

- (void)dealloc
{
    [self stopAnimating];
}

- (void)stopAnimating
{
    self.hidden = YES;
    
    isAnimationing = NO;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

@end




















