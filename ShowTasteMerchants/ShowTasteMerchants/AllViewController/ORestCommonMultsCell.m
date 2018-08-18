//
//  ORestCommonMultsCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/13.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ORestCommonMultsCell.h"
#import "LocalCommon.h"

@interface ORestCommonMultsCell ()
{
    UILabel *_titleLabel;
    
    UIImageView *_thanImgView;
    
    UILabel *_valueLabel;
}

- (void)initWithTitleLabel;

- (void)initWithThanImgView;

- (void)initWithValueLabel;


@end

@implementation ORestCommonMultsCell

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
        _titleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:CGRectMake(15, 12, 40, 20) textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
//        _titleLabel.backgroundColor = [UIColor lightGrayColor];
    }}

- (void)initWithThanImgView
{
    if (!_thanImgView)
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
}

- (void)initWithValueLabel
{
    if (!_valueLabel)
    {
        _valueLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:CGRectMake(15, _titleLabel.bottom + 8, [[UIScreen mainScreen] screenWidth] - 30, 20) textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
        _valueLabel.numberOfLines = 0;
//        _valueLabel.backgroundColor = [UIColor lightGrayColor];
    }
}

/**
 *  修改信息
 *
 *  @param title             标题
 *  @param value             值
 *  @param hiddenThanImgView 是否隐藏三角
 */
- (void)updateWithTitle:(NSAttributedString *)title value:(NSAttributedString *)value hiddenThanImgView:(BOOL)hiddenThanImgView valueHeight:(CGFloat)valueHeight
{
    if (hiddenThanImgView)
    {
        _titleLabel.width = [[UIScreen mainScreen] screenWidth] - 30;
    }
    else
    {
        _titleLabel.width = _thanImgView.left - 15 - 10;
    }
    _thanImgView.hidden = hiddenThanImgView;
    _titleLabel.attributedText = title;
    
    _valueLabel.height = valueHeight;
    _valueLabel.attributedText = value;
}
@end





















