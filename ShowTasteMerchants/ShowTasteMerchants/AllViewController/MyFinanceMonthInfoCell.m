//
//  MyFinanceMonthInfoCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/8.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyFinanceMonthInfoCell.h"
#import "LocalCommon.h"

@interface MyFinanceMonthInfoCell ()
{
    UILabel *_titleLabel;
    
    UILabel *_amountLabel;
    
    UILabel *_noteLabel;
}

- (void)initWithTitleLabel;

- (void)initWithAmountLabel;

- (void)initWithNoteLabel;

@end

@implementation MyFinanceMonthInfoCell

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
    
    [self initWithTitleLabel];
    
    [self initWithAmountLabel];
    
    [self initWithNoteLabel];
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        CGRect frame = CGRectMake(15, 15, [[UIScreen mainScreen] screenWidth] - 30, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
    }
}

- (void)initWithAmountLabel
{
    if (!_amountLabel)
    {
        CGRect frame = _titleLabel.frame;
//        frame.origin.y = frame.origin.y + frame.size.height + 20;
        frame.size.height = 40;
        _amountLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE(50) labelTag:0 alignment:NSTextAlignmentLeft];
        _amountLabel.centerY = kMyFinanceMonthInfoCellHeight / 2;
    }
}

- (void)initWithNoteLabel
{
    if (!_noteLabel)
    {
        CGRect frame = _titleLabel.frame;
        _noteLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
        _noteLabel.bottom = kMyFinanceMonthInfoCellHeight - 15;
    }
}

- (void)updateCellData:(id)cellEntity
{
    
    _titleLabel.text = @"8月份营业额(元)";
    
    _amountLabel.text = @"215434.90";
    
    NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] init];
    UIColor *color = [UIColor colorWithHexString:@"#999999"];
    NSAttributedString *bTitle = [[NSAttributedString alloc] initWithString:@"截至到2016-08-29 11:32" attributes:@{NSFontAttributeName: FONTSIZE(12), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:bTitle];
    
    color = [UIColor colorWithHexString:@"#646464"];
    bTitle = [[NSAttributedString alloc] initWithString:@" 共完成1324单" attributes:@{NSFontAttributeName: FONTSIZE(12), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:bTitle];
    _noteLabel.attributedText = mas;
}

@end





















