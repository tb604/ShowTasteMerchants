//
//  TYZStarRateView.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/2.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZStarRateView.h"

// 选中的图片
#define FOREGROUND_STAR_IMAGE_NAME @"star_nor"

// 没有选中的图片
#define BACKGROUND_STAR_IMAGE_NAME @"star_empty"

// 星的个数
#define DEFALUT_STAR_NUMBER 5

// 动画时间
#define ANIMATION_TIME_INTERVAL 0.2

@interface TYZStarRateView ()

/**
 *  选中星的视图
 */
@property (nonatomic, strong) UIView *foregroundStarView;

/**
 *  未选中星的视图
 */
@property (nonatomic, strong) UIView *backgroundStarView;

/**
 *  星的个数
 */
@property (nonatomic, assign) NSInteger numberOfStars;




- (UIView *)createStarViewWithImage:(NSString *)imageName;

- (void)userTapRateView:(UITapGestureRecognizer *)gesture;



@end

@implementation TYZStarRateView

- (void)dealloc
{
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (instancetype)init
{
    NSAssert(NO, @"You should never call this method in this class. Use initWithFrame: instead!");
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame numberOfStars:DEFALUT_STAR_NUMBER isRecognizer:YES];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        _numberOfStars = DEFALUT_STAR_NUMBER;
        
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars isRecognizer:(BOOL)Recognizer_
{
    self.numberOfStars = numberOfStars;
    self.isRecognizer = Recognizer_;
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}

- (void)setIsRecognizer:(BOOL)isRecognizer
{
    _isRecognizer = isRecognizer;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

#pragma mark start override
- (void)initWithVar
{
    [super initWithVar];
    
    // 默认为1.0f
    _scorePercent = 1.0f;
    
    // 默认为NO
    _hasAnimation = NO;
    
    // 默认为NO；
    _allowIncompleteStar = NO;
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.foregroundStarView = [self createStarViewWithImage:FOREGROUND_STAR_IMAGE_NAME];
    self.backgroundStarView = [self createStarViewWithImage:BACKGROUND_STAR_IMAGE_NAME];
    [self addSubview:self.backgroundStarView];
    [self addSubview:self.foregroundStarView];
    
    if (self.isRecognizer)
    {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapRateView:)];
        tapGesture.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGesture];
#if !__has_feature(objc_arc)
        [tapGesture release], tapGesture = nil;
#endif
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    __typeof (&*self) __block weakSelf = self;
    //    __weak TBStarRateView *weakSelf = self;
    CGFloat animationTimeInterval = self.hasAnimation ? ANIMATION_TIME_INTERVAL : 0;
    [UIView animateWithDuration:animationTimeInterval animations:^{
        weakSelf.foregroundStarView.frame = CGRectMake(0.0f, 0.0f, weakSelf.bounds.size.width * weakSelf.scorePercent, weakSelf.bounds.size.height);
    }];
    //    NSLog(@"frame=%@", NSStringFromCGRect(self.foregroundStarView.frame));
}
#pragma mark end override

#pragma mark start setter and getter
- (void)setScorePercent:(CGFloat)scorePercent
{
    if (_scorePercent == scorePercent)
    {
        return;
    }
    
    if (scorePercent < 0)
    {
        _scorePercent = 0;
    }
    else if (scorePercent > 1)
    {
        _scorePercent = 1;
    }
    else
    {
        _scorePercent = scorePercent;
    }
    
    if (_scorePercentDidChangeBlock)
    {
        _scorePercentDidChangeBlock(self, scorePercent);
    }
    //    if ([_delegate respondsToSelector:@selector(starRateView:scorePercentDidChange:)])
    //    {
    //        [_delegate starRateView:self scorePercentDidChange:scorePercent];
    //    }
    
    [self setNeedsLayout];
}
#pragma mark end setter and getter

#pragma mark start private methods
#pragma mark start init
#pragma mark end init
- (UIView *)createStarViewWithImage:(NSString *)imageName
{
    //    NSLog(@"%s--numberOfStars=%d", __func__, self.numberOfStars);
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    // 子视图比父视图大，clipsToBounds设置为YES，就会隐藏超出的部分。
    view.clipsToBounds = YES;
    view.backgroundColor = [UIColor clearColor];
    for (NSInteger i=0; i<self.numberOfStars; i++)
    {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imgView.frame = CGRectMake(i * self.bounds.size.width / self.numberOfStars, 0.0f, self.bounds.size.width / self.numberOfStars, self.bounds.size.height);
        //        NSLog(@"imgv.frame=%@", NSStringFromCGRect(imgView.frame));
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imgView];
#if !__has_feature(objc_arc)
        [imgView release], imgView = nil;
#endif
    }
#if !__has_feature(objc_arc)
    return [view autorelease];
#else
    return view;
#endif
}

- (void)userTapRateView:(UITapGestureRecognizer *)gesture
{
    if (!_isRecognizer)
    {
        return;
    }
    CGPoint tapPoint = [gesture locationInView:self];
    CGFloat offset = tapPoint.x;
    CGFloat realStarScore = offset / (self.bounds.size.width / self.numberOfStars);
    CGFloat starScore = self.allowIncompleteStar ? realStarScore : ceilf(realStarScore);
    self.scorePercent = starScore / self.numberOfStars;
}
#pragma mark end private methods



@end
