//
//  TYZImageEditorViewController.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/8.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TYZImageEditorFrame

@required
@property (nonatomic, assign) CGRect cropRect;

@end

@class TYZImageEditorViewController;

typedef void(^TYZImageEditorDoneCallback)(UIImage *image, BOOL canceled);

/**
 *  图片编辑视图控制器
 */
@interface TYZImageEditorViewController : UIViewController <UIGestureRecognizerDelegate>

/**
 *
 */
@property (nonatomic, copy) TYZImageEditorDoneCallback doneCallback;

/**
 * 源图像
 */
@property (nonatomic, copy) UIImage *sourceImage;

/**
 * 预览图
 */
@property (nonatomic, copy) UIImage *previewImage;

/**
 * 裁剪的大小
 */
@property (nonatomic, assign) CGSize cropSize;

/**
 * 裁剪的frame
 */
@property (nonatomic, assign) CGRect cropRect;

/**
 *
 */
@property (nonatomic, assign) CGFloat outputWidth;

/**
 *
 */
@property (nonatomic, assign) CGFloat minimumScale;

/**
 *
 */
@property (nonatomic, assign) CGFloat maximumScale;

/**
 *  是否允许捏
 */
@property (nonatomic, assign) BOOL panEnabled;

/**
 * 是否允许旋转
 */
@property (nonatomic, assign) BOOL rotateEnabled;

/**
 * 是否允许缩放
 */
@property (nonatomic, assign) BOOL scaleEnabled;

/**
 *
 */
@property (nonatomic, assign) BOOL tapToResetEnabled;

/**
 *
 */
@property (nonatomic, assign) BOOL checkBounds;

/**
 *
 */
@property (nonatomic,readonly) CGRect cropBoundsInSourceImage;

/**
 *
 *
 *  @param animated YES动画；否则NO
 */
- (void)reset:(BOOL)animated;

- (void)squareWithAction;

- (void)landscapeWithAction;

- (void)portraitWithAction;


@end



























