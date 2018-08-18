
//
//  ShopPlacePrinterViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/12.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopPlacePrinterViewCell.h"
#import "LocalCommon.h"
#import "ShopMouthDataEntity.h"

@interface ShopPlacePrinterViewCell ()
{
    UILabel *_titleLabel;
}

@property (nonatomic, strong)ShopMouthDataEntity *printEntity;

- (void)initWithTitleLabel;

@end

@implementation ShopPlacePrinterViewCell

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
    
    CGFloat width = [[UIScreen mainScreen] screenWidth] / 3;
    [CALayer drawLine:self.contentView frame:CGRectMake(10, kShopPlacePrinterViewCellHeight, width - 20, 0.6) lineColor:[UIColor colorWithHexString:@"#e0e0e0"]];
    
    [self initWithTitleLabel];
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        CGFloat width = [[UIScreen mainScreen] screenWidth] / 3;
        CGRect frame = CGRectMake(10, (kShopPlacePrinterViewCellHeight-20)/2, width-20, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentCenter];
    }
}

- (void)updateCellData:(id)cellEntity selPrintEnt:(ShopMouthDataEntity *)selPrintEnt
{
    ShopMouthDataEntity *printEnt = cellEntity;
    
    self.printEntity = printEnt;
    _titleLabel.text = printEnt.printer_name;
    if (printEnt.id == selPrintEnt.id)
    {
        _titleLabel.textColor = [UIColor colorWithHexString:@"#ff5500"];
    }
    else
    {
        _titleLabel.textColor = [UIColor colorWithHexString:@"#323232"];
    }
}

@end
