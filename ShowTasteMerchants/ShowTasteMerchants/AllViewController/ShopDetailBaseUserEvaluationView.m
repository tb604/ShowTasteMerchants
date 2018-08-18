//
//  ShopDetailBaseUserEvaluationView.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/1.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopDetailBaseUserEvaluationView.h"
#import "LocalCommon.h"
#import "ShopBaseInfoDataEntity.h"
#import "TYZStarRateView.h"
#import "RestaurantBaseDataEntity.h"

@interface ShopDetailBaseUserEvaluationView ()
{
    /**
     *  人均消费
     */
    UILabel *_averageLabel;
    
    /**
     *  星的等级
     */
    TYZStarRateView *_starRateView;
    
    /**
     *  票数
     */
    UILabel *_voteLabel;
    
    /**
     *  服务情况
     */
    UILabel *_scoreLabel;
}

/**
 *  星的等级
 */
//@property (nonatomic, strong) TYZStarRateView *starRateView;

@property (nonatomic, strong) CALayer *line;

- (void)initWithAverageLabel;

/**
 *  初始化星星
 */
- (void)initWithStarRateView;

- (void)initWithVoteLabel;

- (void)initWithScoreLabel;



@end

@implementation ShopDetailBaseUserEvaluationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithLine];
    
    [self initWithLineTwo];
    
    
    [self initWithAverageLabel];
    
    /**
     *  初始化星星
     */
    [self initWithStarRateView];
    
    [self initWithVoteLabel];
    
    [self initWithScoreLabel];

}

- (void)initWithLine
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake([[UIScreen mainScreen] screenWidth] - 30, 0.6);
    line.left = 15;
    line.bottom = kShopDetailBaseUserEvaluationViewHeight;
    line.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"].CGColor;
    [self.layer addSublayer:line];
    self.line = line;
}

- (void)initWithLineTwo
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake([[UIScreen mainScreen] screenWidth] - 30, 1.0);
    line.left = 15;
    line.bottom = _line.bottom - 2;
    line.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"].CGColor;
    [self.layer addSublayer:line];
}


- (void)initWithAverageLabel
{
    if (!_averageLabel)
    {
        CGRect frame = CGRectMake(15, 10, [[UIScreen mainScreen] screenWidth] - 30, 20);
        _averageLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
    }
}

- (void)initWithStarRateView
{
    if (!_starRateView)
    {
        UIImage *image = [UIImage imageNamed:@"star_nor"];
        CGRect frame = CGRectMake(_averageLabel.left, _averageLabel.bottom + 10, image.size.width*5+2*(5-1), image.size.height);
        _starRateView = [[TYZStarRateView alloc] initWithFrame:frame numberOfStars:5 isRecognizer:NO];
        [self addSubview:_starRateView];
        _starRateView.scorePercent = 1;
    }
}

- (void)initWithVoteLabel
{
    if (!_voteLabel)
    {
        CGRect frame = CGRectMake(_starRateView.right + 10, 0, [[UIScreen mainScreen] screenWidth] - _starRateView.right - 10 - 15, 16);
        _voteLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
        _voteLabel.centerY = _starRateView.centerY;
    }
}

- (void)initWithScoreLabel
{
    if (!_scoreLabel)
    {
        CGRect frame = CGRectMake(15, _starRateView.bottom + 10, [[UIScreen mainScreen] screenWidth] - 30, 18);
        _scoreLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
    }
}

- (void)updateViewData:(id)entity
{
    NSInteger average = 0;
    NSInteger vote = 0;
    NSInteger comments = 0;
    NSInteger score1 = 0;
    NSInteger score2 = 0;
    NSInteger score3 = 0;
    if ([entity isKindOfClass:[RestaurantBaseDataEntity class]])
    {
        RestaurantBaseDataEntity *shopEntity = entity;
//        debugLog(@"shopEnt=%@", [shopEntity modelToJSONString]);
        /*
         {"mall_id":3,"city_id":1,"introHeight":57.28125,"average":59,"shopId":0,"score2":0,"intro":"天黑号和老婆搜一至音容让我失望一松这种是幺四五上网搜搜主要是五月慧眼识英雄一十一松破工作朋友一土哦婆婆松坡去是要请我迫切幺三幺三四五是想让我婆婆说朋友是想让我婆婆说朋友一起若只如我婆婆婆婆婆公共其实我也是是想让我婆婆破哦婆婆","sloganHeight":0,"lng":118.741074,"city_name":"南京","mall_name":"草场门\/龙江","name":"jiajia第二个店","state":3,"slogan":"音乐餐厅，音乐主题","classify":"川菜 苏菜 素食 东南亚菜","score1":0,"mobile":"15001718862","lat":0,"comments":0,"vip":0,"vote":0,"score3":0,"address":"海德北岸城"}
         */
        average = shopEntity.average;
        vote = shopEntity.vote;
        comments = shopEntity.comments;
        score1 = shopEntity.score1;
        score2 = shopEntity.score2;
        score3 = shopEntity.score3;
    }
    else if ([entity isKindOfClass:[ShopBaseInfoDataEntity class]])
    {
       ShopBaseInfoDataEntity *shopEntity = entity;
        average = (int)shopEntity.average;
        vote = shopEntity.vote;
        comments = shopEntity.comments;
        score1 = shopEntity.score1;
        score2 = shopEntity.score2;
        score3 = shopEntity.score3;
    }
    
    
    // 人均消费
    NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] init];
    NSString *straverage = [NSString stringWithFormat:@"￥%d", (int)average];
    UIColor *color = [UIColor colorWithHexString:@"#ff5500"];
    NSAttributedString *butedStr = [[NSAttributedString alloc] initWithString:straverage attributes:@{NSFontAttributeName: FONTSIZE(24), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:butedStr];
    color = [UIColor colorWithHexString:@"#323232"];
    butedStr = [[NSAttributedString alloc] initWithString:@" 元/人均" attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:butedStr];
    _averageLabel.attributedText = mas;
    
    // 评级、票数
    NSInteger score = 0;
    if (comments != 0)
    {
        score = vote / comments;
    }
    debugLog(@"vote=%d; comments=%d", (int)vote, (int)comments);
    _starRateView.scorePercent = score;
    _voteLabel.text = [NSString stringWithFormat:@"%d票", (int)vote];
    
    
    // 口味、环境、服务
    mas = [[NSMutableAttributedString alloc] init];
    color = [UIColor colorWithHexString:@"#646464"];
    butedStr = [[NSAttributedString alloc] initWithString:@"口味：" attributes:@{NSFontAttributeName: FONTSIZE(12), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:butedStr];
    color = [UIColor colorWithHexString:@"#ff5500"];
    butedStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", (int)score1] attributes:@{NSFontAttributeName: FONTSIZE(12), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:butedStr];
    
    color = [UIColor colorWithHexString:@"#646464"];
    butedStr = [[NSAttributedString alloc] initWithString:@"  环境：" attributes:@{NSFontAttributeName: FONTSIZE(12), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:butedStr];
    color = [UIColor colorWithHexString:@"#ff5500"];
    butedStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", (int)score3] attributes:@{NSFontAttributeName: FONTSIZE(12), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:butedStr];
    
    color = [UIColor colorWithHexString:@"#646464"];
    butedStr = [[NSAttributedString alloc] initWithString:@"  服务：" attributes:@{NSFontAttributeName: FONTSIZE(12), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:butedStr];
    color = [UIColor colorWithHexString:@"#ff5500"];
    butedStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", (int)score2] attributes:@{NSFontAttributeName: FONTSIZE(12), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:butedStr];

    
    _scoreLabel.attributedText = mas;
}


@end





























