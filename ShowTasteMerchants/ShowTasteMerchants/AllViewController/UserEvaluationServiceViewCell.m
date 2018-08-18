//
//  UserEvaluationServiceViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "UserEvaluationServiceViewCell.h"
#import "LocalCommon.h"
#import "TYZStarRateView.h"
#import "CommentInputDataEntity.h"
#import "CommentDetailEntity.h"

@interface UserEvaluationServiceViewCell ()
{
    /**
     *  总体
     */
    UILabel *_overallLabel;
    
    TYZStarRateView *_overallStarView;
    
    /**
     *  口味
     */
    UILabel *_tasteLabel;
    
    TYZStarRateView *_tasteStarView;
    
    /**
     *  服务
     */
    UILabel *_serviceLabel;
    
    TYZStarRateView *_serviceStarView;
    
    /**
     *  环境
     */
    UILabel *_environmentLabel;
    
    TYZStarRateView *_environmentStarView;
    
    
}

@property (nonatomic, strong) CALayer *line;

/**
 *  总体
 */
- (void)initWithOverallLabel;

- (void)initWithOverallStarView;

/**
 *  口味
 */
- (void)initWithTasteLabel;

- (void)initWithTasteStarView;

/**
 * 服务
 */
- (void)initWithServiceLabel;

- (void)initWithServiceStarView;

/**
 *  环境
 */
- (void)initWithEnvironmentLabel;

- (void)initWithEnvironmentStarView;


@end

@implementation UserEvaluationServiceViewCell

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithLine];
    
    // 总体
    [self initWithOverallLabel];
    [self initWithOverallStarView];
    
    // 口味
    [self initWithTasteLabel];
    [self initWithTasteStarView];
    
    // 服务
    [self initWithServiceLabel];
    [self initWithServiceStarView];
    
    // 环境
    [self initWithEnvironmentLabel];
    [self initWithEnvironmentStarView];
}

- (void)initWithLine
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake([[UIScreen mainScreen] screenWidth], 0.8);
    line.left = 0;
    line.bottom = 50;
    line.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"].CGColor;
    [self.contentView.layer addSublayer:line];
    self.line = line;
}

/**
 *  总体
 */
- (void)initWithOverallLabel
{
    CGRect frame = CGRectMake(15, (50-20)/2.0, 80, 20);
    _overallLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
    _overallLabel.text = @"总体";
}

- (void)initWithOverallStarView
{
    // CGRect frame = CGRectMake(_nickNameLabel.left, 0, 15*5+2*(5-1), 15);
    __weak typeof(self)weakSelf = self;
    CGFloat space = 10; // 星之间的宽度
    NSInteger count = 5; // 星的数量
    CGFloat height = 20.0; // 星的高度
    
//    CGFloat space = 2; // 星之间的宽度
//    NSInteger count = 5; // 星的数量
//    CGFloat height = 15.0; // 星的高度
    
    CGFloat width = height * count + space * (count - 1);
    CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - width - 15, 0, width, height);
    _overallStarView = [[TYZStarRateView alloc] initWithFrame:frame numberOfStars:count isRecognizer:YES];
    _overallStarView.centerY = _overallLabel.centerY;
    [self.contentView addSubview:_overallStarView];
    _overallStarView.scorePercent = 1;
    _overallStarView.tag = 100;
    _overallStarView.scorePercentDidChangeBlock = ^(TYZStarRateView *starRateView, CGFloat newScorePercent)
    {
        [weakSelf scoeWithStarPercent:newScorePercent tag:starRateView.tag];
    };
}

/**
 *  口味
 */
- (void)initWithTasteLabel
{
    CGRect frame = CGRectMake(15, _line.bottom, 80, 40);
    _tasteLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
    _tasteLabel.text = @"口味";
}

- (void)initWithTasteStarView
{
    __weak typeof(self)weakSelf = self;
    NSInteger count = 5;
    CGRect frame = _overallStarView.frame;
    _tasteStarView = [[TYZStarRateView alloc] initWithFrame:frame numberOfStars:count isRecognizer:YES];
    _tasteStarView.centerY = _tasteLabel.centerY;
    [self.contentView addSubview:_tasteStarView];
    _tasteStarView.scorePercent = 1;
    _tasteStarView.tag = 101;
    _tasteStarView.scorePercentDidChangeBlock = ^(TYZStarRateView *starRateView, CGFloat newScorePercent)
    {
        [weakSelf scoeWithStarPercent:newScorePercent tag:starRateView.tag];
    };
}

/**
 * 服务
 */
- (void)initWithServiceLabel
{
    CGRect frame = CGRectMake(15, _tasteLabel.bottom, 80, 40);
    _serviceLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
    _serviceLabel.text = @"服务";
}

- (void)initWithServiceStarView
{
    __weak typeof(self)weakSelf = self;
    NSInteger count = 5;
    CGRect frame = _overallStarView.frame;
    _serviceStarView = [[TYZStarRateView alloc] initWithFrame:frame numberOfStars:count isRecognizer:YES];
    _serviceStarView.centerY = _serviceLabel.centerY;
    [self.contentView addSubview:_serviceStarView];
    _serviceStarView.scorePercent = 1;
    _serviceStarView.tag = 102;
    _serviceStarView.scorePercentDidChangeBlock = ^(TYZStarRateView *starRateView, CGFloat newScorePercent)
    {
        [weakSelf scoeWithStarPercent:newScorePercent tag:starRateView.tag];
    };

}

/**
 *  环境
 */
- (void)initWithEnvironmentLabel
{
    CGRect frame = CGRectMake(15, _serviceLabel.bottom, 80, 40);
    _environmentLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
    _environmentLabel.text = @"环境";
}

- (void)initWithEnvironmentStarView
{
    __weak typeof(self)weakSelf = self;
    NSInteger count = 5;
    CGRect frame = _overallStarView.frame;
    _environmentStarView = [[TYZStarRateView alloc] initWithFrame:frame numberOfStars:count isRecognizer:YES];
    _environmentStarView.centerY = _environmentLabel.centerY;
    [self.contentView addSubview:_environmentStarView];
    _environmentStarView.scorePercent = 1;
    _environmentStarView.tag = 103;
    _environmentStarView.scorePercentDidChangeBlock = ^(TYZStarRateView *starRateView, CGFloat newScorePercent)
    {
        [weakSelf scoeWithStarPercent:newScorePercent tag:starRateView.tag];
    };
}

- (void)scoeWithStarPercent:(CGFloat)percent tag:(NSInteger)tag
{
    if (_scoreWithStarPercentBlock)
    {
        _scoreWithStarPercentBlock(percent, tag);
    }
}

- (void)updateCellData:(id)cellEntity
{
    NSInteger vote = 0;
    NSInteger score1 = 0;
    NSInteger score2 = 0;
    NSInteger score3 = 0;
    
    [_overallStarView setIsRecognizer:YES];
    [_tasteStarView setIsRecognizer:YES];
    [_serviceStarView setIsRecognizer:YES];
    [_environmentStarView setIsRecognizer:YES];
    
    if ([cellEntity isKindOfClass:[CommentInputDataEntity class]])
    {
        CommentInputDataEntity *commentEnt = cellEntity;
        vote = commentEnt.vote;
        score1 = commentEnt.score1;
        score2 = commentEnt.score2;
        score3 = commentEnt.score3;
    }
    else if ([cellEntity isKindOfClass:[CommentDetailEntity class]])
    {
        CommentDetailEntity *commentEnt = cellEntity;
        vote = commentEnt.score;
        score1 = commentEnt.score1;
        score2 = commentEnt.score2;
        score3 = commentEnt.score3;
//        debugLog(@"vote=%d", (int)vote);
    }
    
    
    // 总体
    _overallStarView.scorePercent = vote * 0.2;
    
    // 口味
    _tasteStarView.scorePercent = score1 * 0.2;
    
    // 服务
    _serviceStarView.scorePercent = score2 * 0.2;
    
    // 环境
    _environmentStarView.scorePercent = score3 * 0.2;
}

@end
