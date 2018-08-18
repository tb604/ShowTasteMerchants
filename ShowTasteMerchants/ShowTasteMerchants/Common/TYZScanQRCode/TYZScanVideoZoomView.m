/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: TYZScan
 * 文件名称: TYZScanVideoZoomView.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/29 10:34
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "TYZScanVideoZoomView.h"

@interface TYZScanVideoZoomView ()

@property (nonatomic, strong) UISlider *slider;

@end

@implementation TYZScanVideoZoomView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code
    
    UIColor *colorLine = [UIColor whiteColor];
    
    CGColorRef color = colorLine.CGColor;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, color);
    CGContextSetLineWidth(ctx, 2.0);
    
    CGFloat borderDiff = 20;
    CGFloat w = borderDiff / 2.;
    CGFloat diff = 5;
    // 左边减号
    CGContextMoveToPoint(ctx, diff, CGRectGetHeight(self.frame) / 2.);
    CGContextAddLineToPoint(ctx, diff + w, CGRectGetHeight(self.frame) / 2);
    
    // 右边加号
    // 横
    CGFloat rx = CGRectGetWidth(self.frame) - borderDiff + diff;
    CGContextMoveToPoint(ctx, rx, CGRectGetHeight(self.frame) / 2.);
    CGContextAddLineToPoint(ctx, rx + w, CGRectGetHeight(self.frame) / 2.);
    
    // 竖
    CGFloat hDiff = CGRectGetHeight(self.frame) / 2. - w / 2.;
    CGContextMoveToPoint(ctx, rx + w / 2., hDiff);
    CGContextAddLineToPoint(ctx, rx + w / 2., CGRectGetHeight(self.frame) - hDiff);
    
    CGContextStrokePath(ctx);
}

- (UIImage *)toImage:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithRed:10 green:10 blue:10 alpha:0.2];
        [self.slider setThumbImage:[self toImage:[UIColor whiteColor] size:CGSizeMake(3, 12)] forState:UIControlStateNormal];
        self.slider.minimumTrackTintColor = [UIColor whiteColor];
        self.slider.maximumTrackTintColor = [UIColor colorWithRed:146/255.0 green:146/255.0 blue:146/255.0 alpha:1.0];
        [self.slider addTarget:self action:@selector(sliderValueChange) forControlEvents:UIControlEventValueChanged];
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 8.0;
    }
    return self;
}

- (void)sliderValueChange
{
    if (_block)
    {
        _block(self.slider.value);
    }
}

- (UISlider *)slider
{
    if (!_slider)
    {
        _slider = [[UISlider alloc] init];
        [self addSubview:_slider];
        _slider.minimumValue = 1.0;
        _slider.maximumValue = 50.0;
    }
    return _slider;
}

- (void)setMaximunValue:(CGFloat)value
{
    self.slider.maximumValue = value;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat borderDiff = 20.0;
    
    _slider.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.frame) - borderDiff * 2., CGRectGetHeight(self.frame));
    _slider.center = CGPointMake(CGRectGetWidth(self.frame) / 2., CGRectGetHeight(self.frame) / 2.);
}

@end


























