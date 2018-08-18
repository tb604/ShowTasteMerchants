//
//  TYZAnimatedImagesView.h
//  ChefDating
//
//  Created by 唐斌 on 16/9/23.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat TYZAnimatedImagesViewDefaultTimePerImage = 5.0f;
static const CGFloat TYZAnimatedImagesViewDefaultImageSwappingAnimationDuration = 1.0f;
static const BOOL TYZAnimatedImagesViewDefaultMotionAnimationEnabled = YES;

@protocol TYZAnimatedImagesViewDataSource;

@interface TYZAnimatedImagesView : UIView

@property (nonatomic, weak) id<TYZAnimatedImagesViewDataSource> dataSource;

/**
 Time between image transitions.
 @note The default value is `JSAnimatedImagesViewDefaultTimePerImage`
 */
@property (nonatomic, assign) NSTimeInterval timePerImage;

/**
 The time it takes for images to fade out.
 @note The default value is `JSAnimatedImagesViewDefaultImageSwappingAnimationDuration`
 */
@property (nonatomic, assign) NSTimeInterval transitionDuration;

/**
 Indicates weather the image should be zoomed and moved during display time.
 Setting this property affects only upcoming images if the animation has already been started.
 @note The default value is `JSAnimatedImagesViewDefaultMotionAnimationEnabled`
 */
@property (nonatomic, assign) BOOL motionAnimationEnabled;

/**
 The view starts animating automatically when it becomes visible, but you can use this method to start the animations again if you stop them using the `stopAnimating`.
 */
- (void)startAnimating;

/**
 The view automatically stops animating when it goes out of the screen, but you can choose to stop it manually using this method. You can re-start the animation using `startAnimating`.
 */
- (void)stopAnimating;

/**
 Forces `JSAnimatedImagesView` to call the data source methods again.
 You can use this method if the number of images has changed.
 */
- (void)reloadData;

@end


@protocol TYZAnimatedImagesViewDataSource

/**
 Implement this method to tell `JSAnimatedImagesView` how many images it has to display.
 @param animatedImagesView The view that is requesting the number of images.
 */
- (NSUInteger)animatedImagesNumberOfImages:(TYZAnimatedImagesView *)animatedImagesView;

/**
 Implement this method to provide an image for `JSAnimatedImagesView` to display inmediately after.
 @param animatedImagesView The view that is requesting the image object.
 @param index The index of the image to return. This is a value between `0` and `totalNumberOfImages - 1` (@see `animatedImagesNumberOfImages:`).
 */
- (NSString *)animatedImagesView:(TYZAnimatedImagesView *)animatedImagesView imageAtIndex:(NSUInteger)index;

@end
