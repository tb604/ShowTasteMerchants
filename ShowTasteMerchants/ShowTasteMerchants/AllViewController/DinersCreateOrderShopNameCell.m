//
//  DinersCreateOrderShopNameCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/28.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DinersCreateOrderShopNameCell.h"
#import "LocalCommon.h"


@interface DinersCreateOrderShopNameCell ()
{
    UILabel *_shopNameLabel;
}
@property (nonatomic, strong) CALayer *line;

- (void)initWithShopNameLabel;

@end

@implementation DinersCreateOrderShopNameCell

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithLine];
    
    [self initWithShopNameLabel];
    
}

- (void)initWithLine
{
    if (!_line)
    {
        CALayer *line = [CALayer layer];
        line.size = CGSizeMake([[UIScreen mainScreen] screenWidth], 0.6);
        line.left = 0;
        line.bottom = kDinersCreateOrderShopNameCellHeight;
        line.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"].CGColor;
        [self.contentView.layer addSublayer:line];
        self.line = line;
    }
}

- (void)initWithShopNameLabel
{
    if (!_shopNameLabel)
    {
        CGRect frame = CGRectMake(15, 15, [[UIScreen mainScreen] screenWidth] - 30, 20);
        _shopNameLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_18 labelTag:0 alignment:NSTextAlignmentLeft];
    }
}

- (void)updateCellData:(id)cellEntity
{
    _shopNameLabel.text = cellEntity;
    
}


@end















