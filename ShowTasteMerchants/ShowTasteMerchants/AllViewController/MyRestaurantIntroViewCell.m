//
//  MyRestaurantIntroViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/23.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantIntroViewCell.h"
#import "LocalCommon.h"
#import "RestaurantBaseDataEntity.h"

@interface MyRestaurantIntroViewCell ()
{
    UILabel *_titleLabel;
    
    UILabel *_valueLabel;
}

@property (nonatomic, strong) CALayer *line;

- (void)initWithTitleLabel;

- (void)initWithValueLabel;


@end

@implementation MyRestaurantIntroViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithVarCell
{
    [super initWithVarCell];
    
}

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
//    [self initWithLine];
    
    [self initWithTitleLabel];
    
    [self initWithValueLabel];
    
}

- (void)initWithLine
{
    if (!_line)
    {
        CALayer *line = [CALayer layer];
        line.size = CGSizeMake([[UIScreen mainScreen] screenWidth] - 15, 0.6);
        line.left = 15;
        line.bottom = kMyRestaurantIntroViewCellHeight;
        line.backgroundColor = [UIColor colorWithHexString:@"#9a9a9a"].CGColor;
        [self.contentView.layer addSublayer:line];
        self.line = line;
    }
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        CGRect frame = CGRectMake(15, 15, [[UIScreen mainScreen] screenWidth] - 30, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
        _titleLabel.text = @"餐厅介绍";
    }
}

- (void)initWithValueLabel
{
    if (!_valueLabel)
    {
        CGRect frame = CGRectMake(15, _titleLabel.bottom + 10, [[UIScreen mainScreen] screenWidth] - 30, 20);
        _valueLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#a1a1a1"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
        _valueLabel.numberOfLines = 0;
    }
}

- (void)updateCellData:(id)cellEntity
{
    RestaurantBaseDataEntity *entity = cellEntity;
    
//    _titleLabel.text = @"餐厅介绍";
    
    _valueLabel.height = entity.introHeight;
    _valueLabel.text = entity.intro;
    
    _line.bottom = (kMyRestaurantIntroViewCellHeight - 20 + entity.introHeight);
    
}


@end
