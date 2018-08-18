//
//  ShopDetailRecommendTitleViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/2.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopDetailRecommendTitleViewCell.h"
#import "LocalCommon.h"

@interface ShopDetailRecommendTitleViewCell ()
{
    UILabel *_titleLabel;
    
    UILabel *_descLabel;
}

- (void)initWithTitleLabel;

- (void)initWithDescLabel;

@end

@implementation ShopDetailRecommendTitleViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
//    [CALayer drawLine:self.contentView frame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], 0.6) lineColor:[UIColor colorWithHexString:@"#e0e0e0"]];
    
    [self initWithTitleLabel];
    
    [self initWithLine];
    
    [self initWithDescLabel];
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        NSString *str = @"名厨推荐";
        CGFloat width = [str widthForFont:FONTSIZE_15];
        _titleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:CGRectMake(0, 10, width, 20) textColor:[UIColor colorWithHexString:@"#1a1a1a"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentCenter];
//        _titleLabel.center = CGPointMake([[UIScreen mainScreen] screenWidth] / 2, kShopDetailRecommendTitleViewCellHeight/2);
        _titleLabel.centerX = [[UIScreen mainScreen] screenWidth] / 2;
        _titleLabel.text = str;
    }
}

- (void)initWithLine
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake(_titleLabel.width, 0.5);
    line.left = _titleLabel.left;
    line.top = _titleLabel.bottom+2;
    line.backgroundColor = [UIColor colorWithHexString:@"#646464"].CGColor;
    [self.contentView.layer addSublayer:line];
    
    CALayer *lineTwo = [CALayer layer];
    lineTwo.size = line.size;
    lineTwo.left = _titleLabel.left;
    lineTwo.top = line.bottom+1;
    lineTwo.backgroundColor = [UIColor colorWithHexString:@"#646464"].CGColor;
    [self.contentView.layer addSublayer:lineTwo];
}

- (void)initWithDescLabel
{
    if (!_descLabel)
    {
        
        _descLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:CGRectMake(0, 20, [[UIScreen mainScreen] screenWidth] - 40, 20) textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE_10 labelTag:0 alignment:NSTextAlignmentCenter];
        _descLabel.bottom = kShopDetailRecommendTitleViewCellHeight - 12;
        _descLabel.text = @"RECOMMEND";
        _descLabel.centerX = [[UIScreen mainScreen] screenWidth] / 2;
    }
}

@end












