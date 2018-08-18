//
//  TYZStarRateView.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/2.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"

@interface TYZStarRateView : TYZBaseView

@property (nonatomic, copy) void (^scorePercentDidChangeBlock)(TYZStarRateView *starRateView, CGFloat newScorePercent);

/**
 *  是否允许触摸，改变星的数目
 */
@property (nonatomic, assign) BOOL isRecognizer;

/**
 *  得分值，返回为：0～1，默认为1
 */
@property (nonatomic, assign) CGFloat scorePercent;

/**
 *  是否允许动画，默认为NO
 */
@property (nonatomic, assign) BOOL hasAnimation;

/**
 *  评分时，是否允许是整星，默认为NO
 */
@property (nonatomic, assign) BOOL allowIncompleteStar;

/**
 *  初始化
 *
 *  @param frame         视图的frame
 *  @param numberOfStars 星的数量
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars isRecognizer:(BOOL)Recognizer_;



@end
