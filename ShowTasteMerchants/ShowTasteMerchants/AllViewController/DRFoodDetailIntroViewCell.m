//
//  DRFoodDetailIntroViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/27.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DRFoodDetailIntroViewCell.h"
#import "LocalCommon.h"
#import "ShopFoodDataEntity.h"

@interface DRFoodDetailIntroViewCell ()
{
    UILabel *_titleLabel;
    
    UILabel *_introLabel;
}

@property (nonatomic, strong) CALayer *line;

- (void)initWithTitleLabel;

- (void)initWithIntroLabel;

@end

@implementation DRFoodDetailIntroViewCell

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithTitleLabel];
    
    [self initWithIntroLabel];
    
}

- (void)initWithLine
{
    if (!_line)
    {
        CALayer *line = [CALayer layer];
        line.size = CGSizeMake([[UIScreen mainScreen] screenWidth], 0.6);
        line.left = 0;
        line.bottom = kDRFoodDetailIntroViewCellHeight - 20 + _introLabel.height;
        line.backgroundColor = [UIColor colorWithHexString:@"#cacaca"].CGColor;
        [self.contentView.layer addSublayer:line];
    }
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        CGRect frame = CGRectMake(15, 10, 100, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
        _titleLabel.text = @"简介";
    }
}

- (void)initWithIntroLabel
{
    if (!_introLabel)
    {
        CGRect frame = CGRectMake(15, _titleLabel.bottom + 5, [[UIScreen mainScreen] screenWidth] - 30, 20);
        _introLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_14 labelTag:0 alignment:NSTextAlignmentLeft];
    }
}

- (void)updateCellData:(id)cellEntity
{
    ShopFoodDataEntity *foodEntity = cellEntity;
    _introLabel.height = foodEntity.introHeight;
    _introLabel.text = foodEntity.intro;
    
    [self initWithLine];
}

@end




















