//
//  MyWalletDetailStreamViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/25.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyWalletDetailStreamViewCell.h"
#import "LocalCommon.h"

@interface MyWalletDetailStreamViewCell ()
{
    CGFloat _titleWidth;
    
    UILabel *_titleLabel;
    
    UILabel *_valueLabel;
}

- (void)initWithTitleLabel;

- (void)initWithValueLabel;

@end

@implementation MyWalletDetailStreamViewCell

- (void)initWithVarCell
{
    [super initWithVarCell];
    
    NSString *str = @"入账明细";
    _titleWidth = [str widthForFont:FONTSIZE_15];
}

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    [CALayer drawLine:self.contentView frame:CGRectMake(15, kMyWalletDetailStreamViewCellHeight, [[UIScreen mainScreen] screenWidth] - 30, 0.6) lineColor:[UIColor colorWithHexString:@"#e0e0e0"]];
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        CGRect frame = CGRectMake(15, (kMyWalletDetailStreamViewCellHeight-20)/2, _titleWidth, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
        //        _titleLabel.backgroundColor = [UIColor lightGrayColor];
    }
}

- (void)initWithValueLabel
{
    if (!_valueLabel)
    {
        CGRect frame =CGRectMake(_titleLabel.right + 10, _titleLabel.top, [[UIScreen mainScreen] screenWidth] - _titleLabel.right - 15 - 10, 20);
        
        _valueLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentRight];
        //        _valueLabel.backgroundColor = [UIColor lightGrayColor];
    }
}


- (void)updateCellData:(NSAttributedString *)title value:(NSAttributedString *)value
{
    [self initWithTitleLabel];
    
    [ self initWithValueLabel];
    
    _titleLabel.attributedText = title;
    _valueLabel.attributedText = value;
}

@end
















