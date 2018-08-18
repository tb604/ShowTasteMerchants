//
//  UserInfoViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/27.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "UserInfoViewCell.h"
#import "LocalCommon.h"

@interface UserInfoViewCell ()
{
    UILabel *_titleLabel;
    
    UILabel *_detailLabel;
}

@property (nonatomic, strong) CALayer *line;


- (void)initWithTitleLabel;

- (void)initWithDetailLabel;

@end

@implementation UserInfoViewCell

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
    
    [self initWithThree];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithTitleLabel];
    
    [self initWithDetailLabel];
    
}


- (void)initWithThree
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake([[UIScreen mainScreen] screenWidth] - 15, 0.8);
    line.left = 15;
    line.bottom = kUserInfoViewCellHeight;
    line.backgroundColor = [UIColor colorWithHexString:@"#cacaca"].CGColor;
    [self.layer addSublayer:line];
    self.line = line;
}


- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:CGRectZero textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE_14 labelTag:0 alignment:NSTextAlignmentLeft];
        _titleLabel.size = CGSizeMake(20, 20);
        _titleLabel.left = 15;
        _titleLabel.centerY = kUserInfoViewCellHeight / 2;
    }
}

- (void)initWithDetailLabel
{
    if (!_detailLabel)
    {
        _detailLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:CGRectZero textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE_14 labelTag:0 alignment:NSTextAlignmentLeft];
        _detailLabel.size = CGSizeMake(20, 20);
        _detailLabel.numberOfLines = 0;
    }
}


/**
*  更新信息
*
*  @param title        标题
*  @param titleWidth   标题的宽度，如果为0表示实际标题字的宽度
*  @param attri        value
*  @param alignment
*  @param detailHeight 高度
*/
- (void)updateCellData:(NSAttributedString *)title titleWidth:(CGFloat)titleWidth attri:(NSAttributedString *)attri alignment:(NSTextAlignment)alignment detailHeight:(CGFloat)detailHeight
{
    CGFloat fontWidth = titleWidth;
    if (title)
    {
        if (fontWidth == 0.0)
        {
            fontWidth = [[title string] widthForFont:_titleLabel.font height:20];
        }
        
        _titleLabel.width = fontWidth;
        _titleLabel.attributedText = title;
    }
    else
    {
        _titleLabel.text = nil;
    }
    if (title)
    {
        _detailLabel.size = CGSizeMake([[UIScreen mainScreen] screenWidth] - _titleLabel.right - 10 - 15, detailHeight);
        _detailLabel.left = _titleLabel.right + 15;
        _detailLabel.top = _titleLabel.top;
    }
    else
    {
        _detailLabel.size = CGSizeMake([[UIScreen mainScreen] screenWidth] -10 * 2, detailHeight);
        _detailLabel.left = 10;
        _detailLabel.centerY = kUserInfoViewCellHeight / 2;
    }
    _detailLabel.attributedText = attri;
    _detailLabel.textAlignment = alignment;
}

- (void)updateHiddenLine:(BOOL)hidden
{
    _line.hidden = hidden;
}

@end
