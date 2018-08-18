//
//  ShopPrinterChoiceViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/11.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopPrinterChoiceViewCell.h"
#import "LocalCommon.h"
#import "ShopMouthDataEntity.h"

@interface ShopPrinterChoiceViewCell ()
{
    UILabel *_titleLabel;
}

- (void)initWithTitleLabel;

@end

@implementation ShopPrinterChoiceViewCell

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithLine];
    
    [self initWithTitleLabel];
}

- (void)initWithLine
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake([[UIScreen mainScreen] screenWidth], 0.8);
    line.left = 0;
    line.bottom = kShopPrinterChoiceViewCellHeight;
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"].CGColor;
    [self.layer addSublayer:line];
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        CGRect frame = CGRectMake(15, (kShopPrinterChoiceViewCellHeight - 20) / 2, [[UIScreen mainScreen] screenWidth] - 30, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
    }
}

- (void)updateCellData:(id)cellEntity
{
    ShopMouthDataEntity *categoryEnt = cellEntity;
    
    _titleLabel.text = categoryEnt.printer_name;
}


@end
