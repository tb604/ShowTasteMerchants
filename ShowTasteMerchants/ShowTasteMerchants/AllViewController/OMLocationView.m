//
//  OMLocationView.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "OMLocationView.h"
#import "LocalCommon.h"

@interface OMLocationView ()
{
    UIImageView *_iconImgView;
    UILabel *_titleLabel;
    UIImageView *_thanImgView;
    
}

- (void)initWithIconImgView;

- (void)initWithTitleLabel;

- (void)initWithThanImgView;

@end

@implementation OMLocationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithSubView
{
    [super initWithSubView];
    
//    self.backgroundColor = [UIColor purpleColor];
    
    [self initWithIconImgView];
    
    [self initWithTitleLabel];
    
    [self initWithThanImgView];
}

- (void)initWithIconImgView
{
    // home_icon_add
    if (!_iconImgView)
    {
        UIImage *image = [UIImage imageNamed:@"home_icon_add"];
        _iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        _iconImgView.image = image;
        _iconImgView.centerY = self.height / 2;
        [self addSubview:_iconImgView];
        _iconImgView.hidden = YES;
    }
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        UIImage *image = [UIImage imageNamed:@"home_btn_dizhixiala"];
        _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:CGRectMake(_iconImgView.width+10, 0, self.width - _iconImgView.width-10 - image.size.width - 2, 20) textColor:[UIColor whiteColor] fontSize:[UIFont ac_systemFontOfSize:30.0] labelTag:0 alignment:NSTextAlignmentLeft];
//        _titleLabel.backgroundColor = [UIColor redColor];
        _titleLabel.centerY = self.height / 2;
    }
}

- (void)initWithThanImgView
{
    // home_btn_dizhixiala
    if (!_thanImgView)
    {
        UIImage *image = [UIImage imageNamed:@"home_btn_dizhixiala"];
        _thanImgView = [[UIImageView alloc] initWithFrame:CGRectMake(_titleLabel.right+2, 0, image.size.width, image.size.height)];
        _thanImgView.image = image;
        _thanImgView.centerY = self.height / 2;
        [self addSubview:_thanImgView];
        _thanImgView.hidden = YES;
    }
}

- (void)updateViewData:(id)entity
{
    _titleLabel.text = entity;
    if ([objectNull(_titleLabel.text) isEqualToString:@""])
    {
        _iconImgView.hidden = YES;
        _thanImgView.hidden = YES;
    }
    else
    {
        _iconImgView.hidden = NO;
        _thanImgView.hidden = NO;
    }
}

@end
















