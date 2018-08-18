//
//  ShopRepairPrinterFoodCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopRepairPrinterFoodCell.h"
#import "LocalCommon.h"
#import "OrderFoodInfoEntity.h"

@interface ShopRepairPrinterFoodCell ()
{
    /**
     *  多少分
     */
    UILabel *_unitLabel;
    
    UILabel *_titleLabel;
}

- (void)initWithUnitLabel;

- (void)initWithTitleLabel;

@end

@implementation ShopRepairPrinterFoodCell

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor colorWithHexString:@"#fafafa"];
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#fafafa"];
    self.backgroundColor = [UIColor colorWithHexString:@"#fafafa"];
    
    [self initWithUnitLabel];
    
    [self initWithTitleLabel];
    
    [CALayer drawLine:self.contentView frame:CGRectMake(_titleLabel.left, kShopRepairPrinterFoodCellHeight, [[UIScreen mainScreen] screenWidth] - _titleLabel.left, 0.6) lineColor:[UIColor colorWithHexString:@"#cdcdcd"]];
}

- (void)initWithUnitLabel
{
    if (!_unitLabel)
    {
        NSString *str = @"32份";
        float width = [str widthForFont:FONTSIZE_15];
        CGRect frame = CGRectMake(([[UIScreen mainScreen] screenWidth] - width)/2 + 30, (kShopRepairPrinterFoodCellHeight-20)/2, width, 20);
        _unitLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentCenter];
//        _unitLabel.backgroundColor = [UIColor lightGrayColor];
    }
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        UIImage *image = [UIImage imageNamed:@"budan_icon_sel"];
        CGRect frame = CGRectMake(image.size.width + 15 + 10, (kShopRepairPrinterFoodCellHeight-20)/2, _unitLabel.left - 30 - 10 - image.size.width, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
//        _titleLabel.backgroundColor = [UIColor lightGrayColor];
    }
}

- (void)updateCellData:(id)cellEntity
{
    OrderFoodInfoEntity *foodEntity = cellEntity;
    _titleLabel.text = foodEntity.food_name;
    
    _unitLabel.text = [NSString stringWithFormat:@"%d%@", (int)foodEntity.number, foodEntity.unit];
}

@end



















