//
//  MallSelectedTableViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/23.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MallSelectedTableViewCell.h"
#import "LocalCommon.h"
#import "MallListDataEntity.h"

@interface MallSelectedTableViewCell ()
{
    UILabel *_titleLabel;
}

@property (nonatomic, strong) MallListDataEntity *dataEntity;

- (void)initWithTitleLabel;

@end

@implementation MallSelectedTableViewCell

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
    
    self.backgroundView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    
    [self initWithLine];
    
    [self initWithTitleLabel];
    
}

- (void)initWithLine
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake([[UIScreen mainScreen] screenWidth], 0.8);
    line.left = 0;
    line.bottom = kMallSelectedTableViewCellHeight;
    line.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"].CGColor;
    [self.layer addSublayer:line];
}


- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        CGRect frame = CGRectMake(15, (kMallSelectedTableViewCellHeight - 20)/2, [[UIScreen mainScreen] screenWidth] - 30, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
    }
}

- (void)updateCellData:(id)cellEntity
{
    self.dataEntity = cellEntity;
    _titleLabel.text = _dataEntity.name;
}

- (void)updateWithTitleColor:(UIColor *)color
{
    _titleLabel.textColor = color;
}

@end
