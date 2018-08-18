//
//  MyFinanceWeekTotalAmountCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/7.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyFinanceWeekTotalAmountCell.h"
#import "LocalCommon.h"

@interface MyFinanceWeekTotalAmountCell ()
{
    UILabel *_amountTitleLabel;
    
    UILabel *_amountLabel;
}

- (void)initWithAmountTitleLabel;

- (void)initWithAmountLabel;

@end

@implementation MyFinanceWeekTotalAmountCell

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
    
    self.backgroundView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    
    [CALayer drawLine:self.contentView frame:CGRectMake(15, kMyFinanceWeekTotalAmountCellHeight, [[UIScreen mainScreen] screenWidth] - 30, 0.6) lineColor:[UIColor colorWithHexString:@"#e1e1e1"]];
    
    [self initWithAmountTitleLabel];
    
    [self initWithAmountLabel];
    
}


- (void)initWithAmountTitleLabel
{
    if (!_amountTitleLabel)
    {
        NSString *str = @"营业总额(元)";
        float width = [str widthForFont:FONTSIZE_15];
        CGRect frame = CGRectMake(15, (kMyFinanceWeekTotalAmountCellHeight-20)/2, width, 20);
        _amountTitleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
        _amountTitleLabel.text = str;
    }
}

- (void)initWithAmountLabel
{
    if (!_amountLabel)
    {
        CGRect frame = _amountTitleLabel.frame;
        frame.size.width = [[UIScreen mainScreen] screenWidth] - _amountTitleLabel.right - 15 - 15;
        frame.origin.x = _amountTitleLabel.right + 15;
        _amountLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTBOLDSIZE(17) labelTag:0 alignment:NSTextAlignmentRight];
    }
}

- (void)updateCellData:(id)cellEntity
{
    
    _amountLabel.text = @"2323.21";
}


@end

















