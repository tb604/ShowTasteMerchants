//
//  CALayer+TYZAdd.h
//  YYStudyDemo
//
//  Created by 唐斌 on 16/3/2.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (TYZAdd)
/**
 Take snapshot without transform, image's size equals to bounds.
 */
- (nullable UIImage *)snapshotImage;

/**
 Take snapshot without transform, PDF's page size equals to bounds.
 */
- (nullable NSData *)snapshotPDF;

/**
 Shortcut to set the layer's shadow
 
 @param color  Shadow Color
 @param offset Shadow offset
 @param radius Shadow radius
 */
- (void)setLayerShadow:(UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius;

/**
 Remove all sublayers.
 */
- (void)removeAllSublayers;

@property (nonatomic, assign) CGFloat left;        ///< Shortcut for frame.origin.x.
@property (nonatomic, assign) CGFloat top;         ///< Shortcut for frame.origin.y
@property (nonatomic, assign) CGFloat right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic, assign) CGFloat bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic, assign) CGFloat width;       ///< Shortcut for frame.size.width.
@property (nonatomic, assign) CGFloat height;      ///< Shortcut for frame.size.height.
@property (nonatomic, assign) CGPoint center;      ///< Shortcut for center.
@property (nonatomic, assign) CGFloat centerX;     ///< Shortcut for center.x
@property (nonatomic, assign) CGFloat centerY;     ///< Shortcut for center.y
@property (nonatomic, assign) CGPoint origin;      ///< Shortcut for frame.origin.
@property (nonatomic, assign, getter=frameSize, setter=setFrameSize:) CGSize  size; ///< Shortcut for frame.size.


@property (nonatomic, assign) CGFloat transformRotation;     ///< key path "tranform.rotation"
@property (nonatomic, assign) CGFloat transformRotationX;    ///< key path "tranform.rotation.x"
@property (nonatomic, assign) CGFloat transformRotationY;    ///< key path "tranform.rotation.y"
@property (nonatomic, assign) CGFloat transformRotationZ;    ///< key path "tranform.rotation.z"
@property (nonatomic, assign) CGFloat transformScale;        ///< key path "tranform.scale"
@property (nonatomic, assign) CGFloat transformScaleX;       ///< key path "tranform.scale.x"
@property (nonatomic, assign) CGFloat transformScaleY;       ///< key path "tranform.scale.y"
@property (nonatomic, assign) CGFloat transformScaleZ;       ///< key path "tranform.scale.z"
@property (nonatomic, assign) CGFloat transformTranslationX; ///< key path "tranform.translation.x"
@property (nonatomic, assign) CGFloat transformTranslationY; ///< key path "tranform.translation.y"
@property (nonatomic, assign) CGFloat transformTranslationZ; ///< key path "tranform.translation.z"

/**
 Shortcut for transform.m34, -1/1000 is a good value.
 It should be set before other transform shortcut.
 */
@property (nonatomic, assign) CGFloat transformDepth;

/**
 Wrapper for `contentsGravity` property.
 */
@property (nonatomic, assign) UIViewContentMode contentMode;

/**
 Add a fade animation to layer's contents when the contents is changed.
 
 @param duration Animation duration
 @param curve    Animation curve.
 */
- (void)addFadeAnimationWithDuration:(NSTimeInterval)duration curve:(UIViewAnimationCurve)curve;

/**
 Cancel fade animation which is added with "-addFadeAnimationWithDuration:curve:".
 */
- (void)removePreviousFadeAnimation;

/**
 *  画线条
 *
 *  @param view      父视图
 *  @param frame     frame
 *  @param lineColor line color
 *
 *  @return
 */
+ (CALayer *)drawLine:(UIView *)view frame:(CGRect)frame lineColor:(UIColor *)lineColor;

/**
 *  绘制虚线到view
 *
 *  @param view        父视图
 *  @param frame       frame
 *  @param lineSpacing 虚线之间的间隔
 *  @param lineColor   颜色
 *
 *  @return
 */
+ (CAShapeLayer *)drawDashLine:(UIView *)view frame:(CGRect)frame lineSpacing:(CGFloat)lineSpacing lineColor:(UIColor *)lineColor lineWidth:(CGFloat)lineWidth;

/**
 *  视图部分边缘圆角(在矩形中，可以针对四角中的某个角加圆角, 一般用于设置某个视图的顶端两角为圆形)
 *
 *  @param bounds 视图的bounds
 *  @param cornerRadii 圆角的大小
 *  @param roundingCorners 枚举值，可以选择某个角
 */
+ (CAShapeLayer *)bezierPathRound:(CGRect)bounds cornerRadii:(CGSize)cornerRadii roundingCorners:(UIRectCorner)roundingCorners;


@end

NS_ASSUME_NONNULL_END


/*
 CAShapeLayer *styleLayer =[CAShapeLayer layer];
 UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRoundedRect:_acserTagLabel.bounds byRoundingCorners:(UIRectCornerTopRight|UIRectCornerBottomRight) cornerRadii:CGSizeMake(10.0, 10.0)];
 styleLayer.path = shadowPath.CGPath;
 _acserTagLabel.layer.mask = styleLayer;
 */




















