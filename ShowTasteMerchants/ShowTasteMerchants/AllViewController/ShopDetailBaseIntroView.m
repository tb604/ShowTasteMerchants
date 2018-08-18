//
//  ShopDetailBaseIntroView.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/1.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopDetailBaseIntroView.h"
#import "LocalCommon.h"
#import "ShopBaseInfoDataEntity.h"
#import "RestaurantBaseDataEntity.h"

@interface ShopDetailBaseIntroView ()
{
    UILabel *_titleLabel;
    
    UILabel *_detailLabel;
}
@property (nonatomic, strong) CALayer *line;

- (void)initWithTitleLabel;

- (void)initWithDetailLabel;

@end

@implementation ShopDetailBaseIntroView

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
    
    [self initWithTitleLabel];
    
    [self initWithDetailLabel];
}

- (void)initWithLine
{
    CALayer *line = [CALayer drawLine:self frame:CGRectMake(0, kShopDetailBaseIntroViewHeight, [[UIScreen mainScreen] screenWidth], 0.6) lineColor:[UIColor colorWithHexString:@"#e0e0e0"]];
//    CALayer *line = [CALayer layer];
//    line.size = CGSizeMake([[UIScreen mainScreen] screenWidth], 0.8);
//    line.left = 0;
//    line.bottom = kShopDetailBaseIntroViewHeight;
//    line.backgroundColor = [UIColor colorWithHexString:@"#999999"].CGColor;
//    [self.layer addSublayer:line];
    self.line = line;
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        CGRect frame = CGRectMake(15, 10, [[UIScreen mainScreen] screenWidth] - 30, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
        _titleLabel.text = @"餐厅介绍";
    }
}

- (void)initWithDetailLabel
{
    if (!_detailLabel)
    {
        CGRect frame = CGRectMake(15, _titleLabel.bottom + 10, [[UIScreen mainScreen] screenWidth] - 30, 20);
        _detailLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
        _detailLabel.numberOfLines = 0;
    }

}


- (void)updateViewData:(id)entity
{
    NSString *intro = @"";
    CGFloat introHeight = 0.0;
    if ([entity isKindOfClass:[RestaurantBaseDataEntity class]])
    {
        RestaurantBaseDataEntity *shopEntity = entity;
        intro = shopEntity.intro;
        introHeight = shopEntity.introHeight;
    }
    else if ([entity isKindOfClass:[ShopBaseInfoDataEntity class]])
    {
        ShopBaseInfoDataEntity *shopEntity = entity;
        intro = shopEntity.intro;
        introHeight = shopEntity.introHeight;
    }
    
    
    CGRect frame = _detailLabel.frame;
    frame.size.height = introHeight;
    _detailLabel.frame = frame;
    _detailLabel.text = intro;
    
    CGFloat bottom =  (kShopDetailBaseIntroViewHeight - 20 + introHeight);
    _line.bottom = bottom;
}

@end


















