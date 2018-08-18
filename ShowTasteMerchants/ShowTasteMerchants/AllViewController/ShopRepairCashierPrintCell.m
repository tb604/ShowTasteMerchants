//
//  ShopRepairCashierPrintCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/12.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopRepairCashierPrintCell.h"
#import "LocalCommon.h"

@interface ShopRepairCashierPrintCell ()
{
    /**
     *  打印
     */
    UIButton *_btnPrinter;
    
    UILabel *_titleLabel;
}

- (void)initWithBtnPrinter;

- (void)initWithTitleLabel;

@end



@implementation ShopRepairCashierPrintCell

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
    
    [self initWithBtnPrinter];
    
    [self initWithTitleLabel];
    
}

- (void)initWithBtnPrinter
{
    if (!_btnPrinter)
    {
        NSString *str = @"打印";
        CGFloat width = [str widthForFont:FONTSIZE_12] + 30;
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - 15 - width, (kShopRepairCashierPrintCellHeight - 26) / 2, width, 26);
        _btnPrinter = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:str titleColor:[UIColor colorWithHexString:@"#ff5500"] titleFont:FONTSIZE_14 targetSel:@selector(clickedWithPrinter:)];
        _btnPrinter.frame = frame;
        _btnPrinter.layer.borderColor = [UIColor colorWithHexString:@"#ff5500"].CGColor;
        _btnPrinter.layer.borderWidth = 1;
        _btnPrinter.layer.cornerRadius = 4;
        _btnPrinter.layer.masksToBounds = YES;
        [self.contentView addSubview:_btnPrinter];
    }
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        CGRect frame = CGRectMake(15, (kShopRepairCashierPrintCellHeight - 20)/2, [[UIScreen mainScreen] screenWidth] / 2, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
        _titleLabel.text = @"收银打印";
    }
}



- (void)clickedWithPrinter:(id)sender
{
    if (self.baseTableViewCellBlock)
    {
        self.baseTableViewCellBlock(nil);
    }
}

@end





























