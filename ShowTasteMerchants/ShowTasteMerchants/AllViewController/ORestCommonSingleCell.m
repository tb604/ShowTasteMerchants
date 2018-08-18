//
//  ORestCommonSingleCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/13.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ORestCommonSingleCell.h"
#import "LocalCommon.h"


@interface ORestCommonSingleCell ()
{
    UILabel *_titleLabel;
    
    UIImageView *_thanImgView;
    
    UILabel *_valueLabel;
}

- (void)initWithTitleLabel;

- (void)initWithThanImgView;

- (void)initWithValueLabel;

@end

@implementation ORestCommonSingleCell

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
    
    [self initWithTitleLabel];
    
    [self initWithThanImgView];
    
    [self initWithValueLabel];
    
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:CGRectMake(15, (kORestCommonSingleCellHeight - 20) / 2, 40, 20) textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
//        _titleLabel.backgroundColor = [UIColor lightGrayColor];
    }
}

- (void)initWithThanImgView
{
    if (!_thanImgView)
    {
        UIImage *image = [UIImage imageNamed:@"kaicanting_btn_edit_nor"];
        CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
        _thanImgView = [[UIImageView alloc] initWithFrame:frame];
        _thanImgView.image = image;
        _thanImgView.right = [[UIScreen mainScreen] screenWidth] - 15;
        _thanImgView.centerY = _titleLabel.centerY;
        [self.contentView addSubview:_thanImgView];
    }
}

- (void)initWithValueLabel
{
    if (!_valueLabel)
    {
        CGRect frame = CGRectMake(_titleLabel.right + 10, (kORestCommonSingleCellHeight - 20) / 2, _thanImgView.left - _titleLabel.right - 10*2, 20);
        _valueLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
//        _valueLabel.backgroundColor = [UIColor lightGrayColor];
    }
}

/**
 *  修改信息
 *
 *  @param title             标题
 *  @param titleWidth        标题宽度
 *  @param value             值
 *  @param valueWidth        值的宽度
 *  @param hiddenThanImgView 是否隐藏三角
 */
- (void)updateWithTitle:(NSAttributedString *)title titleWidth:(CGFloat)titleWidth value:(NSAttributedString *)value hiddenThanImgView:(BOOL)hiddenThanImgView alignment:(NSTextAlignment)alignment
{
    _titleLabel.width = titleWidth;
    _titleLabel.attributedText = title;
    
    CGFloat width = 0.0;
    if (hiddenThanImgView)
    {
        width = [[UIScreen mainScreen] screenWidth] - _titleLabel.right - 10 - 15;
    }
    else
    {
        width = _thanImgView.left - _titleLabel.right - 10*2;
    }
    _valueLabel.width = width;
    _valueLabel.left = _titleLabel.right + 10;
    _valueLabel.textAlignment = alignment;
    _valueLabel.attributedText = value;
    _thanImgView.hidden = hiddenThanImgView;
    
}

@end


























