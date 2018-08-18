//
//  TYZAnimatedImagesView.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/23.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZAnimatedImagesView.h"
#import "TYZWeakTimer.h"
#import "UIImageView+WebCache.h"
#import "TYZKit.h"

#if !__has_feature(objc_arc)
#error TYZAnimatedImagesView requires ARC enabled. Mark the .m file with the objc_arc linker flag.
#endif

static const NSUInteger TYZAnimatedImagesViewNoImageDisplayingIndex = -1;

static const CGFloat TYZAnimatedImagesViewImageViewsBorderOffset = 10;

@interface TYZAnimatedImagesView ()
{
    BOOL _animating;
    NSUInteger _totalImages;
    NSUInteger _currentlyDisplayingImageViewIndex;
    NSInteger _currentlyDisplayingImageIndex;
    
    NSArray *_imageViews;
}

// 停止的时间
@property (nonatomic, strong) NSDate *stopDate;

@property (nonatomic, strong) TYZWeakTimer *imageSwappingTimer;
@end

@implementation TYZAnimatedImagesView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self commonInit];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit
{
    NSMutableArray *imageViews = [NSMutableArray array];
    
    const NSUInteger numberOfImageViews = 2;
    
    for (int i = 0; i < numberOfImageViews; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectInset(self.bounds, -TYZAnimatedImagesViewImageViewsBorderOffset, -TYZAnimatedImagesViewImageViewsBorderOffset)];
        
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        
        [self addSubview:imageView];
        
        [imageViews addObject:imageView];
    }
    
    _imageViews = imageViews;
    
    _currentlyDisplayingImageIndex = TYZAnimatedImagesViewNoImageDisplayingIndex;
    _timePerImage = TYZAnimatedImagesViewDefaultTimePerImage;
    _transitionDuration = TYZAnimatedImagesViewDefaultImageSwappingAnimationDuration;
    _motionAnimationEnabled = TYZAnimatedImagesViewDefaultMotionAnimationEnabled;
}

#pragma mark - Animations

- (void)startAnimating
{
    NSLog(@"%s", __func__);
    NSAssert(self.dataSource != nil, @"You need to set the data source property");
    
    if (!_animating)
    {
        debugLog(@"!_animating");
        _animating = YES;
        [self.imageSwappingTimer fire];
    }
}

- (void)bringNextImage
{
    NSLog(@"%s", __func__);
    NSAssert(_totalImages > 1, @"There should be more than 1 image to swap");
    
    UIImageView *imageViewToHide = [_imageViews objectAtIndex:_currentlyDisplayingImageViewIndex];
    
    _currentlyDisplayingImageViewIndex = _currentlyDisplayingImageViewIndex == 0 ? 1 : 0;
    
    UIImageView *imageViewToShow = [_imageViews objectAtIndex:_currentlyDisplayingImageViewIndex];
    
    NSUInteger nextImageToShowIndex = _currentlyDisplayingImageIndex;
    
    do
    {
        nextImageToShowIndex = [[self class] randomNumberBetweenNumber:0 andNumber:_totalImages - 1];
    }
    while (nextImageToShowIndex == _currentlyDisplayingImageIndex);
    
    _currentlyDisplayingImageIndex = nextImageToShowIndex;
    
    NSString *imageToShow = [self.dataSource animatedImagesView:self imageAtIndex:nextImageToShowIndex];
    NSAssert(imageToShow != nil, @"Must return an image");
    debugLog(@"imageToShow=%@", imageToShow);
    if ([[imageToShow substringToIndex:4] isEqualToString:@"http"])
    {
        [imageViewToShow sd_setImageWithURL:[NSURL URLWithString:imageToShow] placeholderImage:[UIImage new]];
    }
    else
    {
        imageViewToShow.image = [UIImage imageWithContentsOfFileName:imageToShow];
    }
//    imageViewToShow.image = imageToShow;
    
    static const CGFloat kMovementAndTransitionTimeOffset = 0.1;
    
    /* Move image animation */
    if (self.motionAnimationEnabled)
    {
        [UIView animateWithDuration:self.timePerImage + self.transitionDuration + kMovementAndTransitionTimeOffset
                              delay:0.0
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseIn
                         animations:^
         {
             NSInteger randomTranslationValueX = [[self class] randomNumberBetweenNumber:0 andNumber:TYZAnimatedImagesViewImageViewsBorderOffset] - TYZAnimatedImagesViewImageViewsBorderOffset;
             NSInteger randomTranslationValueY = [[self class] randomNumberBetweenNumber:0 andNumber:TYZAnimatedImagesViewImageViewsBorderOffset] - TYZAnimatedImagesViewImageViewsBorderOffset;
             
             CGAffineTransform translationTransform = CGAffineTransformMakeTranslation(randomTranslationValueX, randomTranslationValueY);
             
             CGFloat randomScaleTransformValue = [[self class] randomNumberBetweenNumber:115 andNumber:120] / 100.0f;
             
             CGAffineTransform scaleTransform = CGAffineTransformMakeScale(randomScaleTransformValue, randomScaleTransformValue);
             
             imageViewToShow.transform = CGAffineTransformConcat(scaleTransform, translationTransform);
         }
                         completion:NULL];
    }
    
    /* Fade animation */
    [UIView animateWithDuration:self.transitionDuration
                          delay:kMovementAndTransitionTimeOffset
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseIn
                     animations:^
     {
         imageViewToShow.alpha = 1.0;
         imageViewToHide.alpha = 0.0;
     }
                     completion:^(BOOL finished)
     {
         if (finished)
         {
             imageViewToHide.transform = CGAffineTransformIdentity;
         }
     }];
}

- (void)reloadData
{
    _totalImages = [self.dataSource animatedImagesNumberOfImages:self];
    
    // Using the ivar directly. If there's no timer, it's because the animations are stopped.
    [_imageSwappingTimer fire];
}

- (void)stopAnimating
{
    NSLog(@"%s", __func__);
    if (_animating)
    {
        self.imageSwappingTimer = nil;
        
        // Fade all image views out
        [UIView animateWithDuration:self.transitionDuration
                              delay:0.0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^
         {
             for (UIImageView *imageView in _imageViews)
             {
                 imageView.alpha = 0.0;
             }
         }
                         completion:^(BOOL finished)
         {
             _currentlyDisplayingImageIndex = TYZAnimatedImagesViewNoImageDisplayingIndex;
             _animating = NO;
         }];
    }
}

#pragma mark - Parameters

- (void)setDataSource:(id<TYZAnimatedImagesViewDataSource>)dataSource
{
    if (dataSource != _dataSource)
    {
        _dataSource = dataSource;
        _totalImages = [_dataSource animatedImagesNumberOfImages:self];
    }
}

#pragma mark - Getters

- (TYZWeakTimer *)imageSwappingTimer
{
    if (!_imageSwappingTimer)
    {
        debugLog(@"创建对象");
        _imageSwappingTimer = [TYZWeakTimer scheduledTimerWithTimeInterval:self.timePerImage
                                                                   target:self
                                                                 selector:@selector(bringNextImage)
                                                                 userInfo:nil
                                                                  repeats:YES
                                                            dispatchQueue:dispatch_get_main_queue()];
    }
    
    return _imageSwappingTimer;
}

#pragma mark - View Life Cycle

- (void)didMoveToWindow
{
    debugMethod();
    const BOOL didAppear = (self.window != nil);
//    debugLog(@"didAppear=%d", didAppear);
    if (didAppear)
    {
        if (_stopDate && _animating)
        {
            NSDate *now = [NSDate date];
            NSString *strStopDate = [_stopDate stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *strNow = [now stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
            long long second = [NSDate secondsWithDateStringDiffer:strStopDate endDate:strNow format:@"yyyy-MM-dd HHM:mm:ss"];
            debugLog(@"secon=%lld", second);
            [self performSelector:@selector(startAnimating) withObject:nil afterDelay:self.transitionDuration + 1];
            self.stopDate = nil;
        }
        else
        {
            [self startAnimating];
        }
    }
    else
    {
        [self stopAnimating];
        self.stopDate = [NSDate date];
    }
}

#pragma mark - Random Numbers

+ (NSUInteger)randomNumberBetweenNumber:(NSUInteger)minNumber andNumber:(NSUInteger)maxNumber
{
    if (minNumber > maxNumber)
    {
        return [self randomNumberBetweenNumber:maxNumber andNumber:minNumber];
    }
    
    NSUInteger randomInt = (arc4random_uniform((u_int32_t)(maxNumber - minNumber + 1))) + minNumber;
    
    return randomInt;
}


@end


























