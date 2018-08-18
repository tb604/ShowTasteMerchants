//
//  RestaurantInfoHeaderView.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/12.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "RestaurantInfoHeaderView.h"
#import "LocalCommon.h"


@interface RestaurantInfoHeaderView ()
{
    UILabel *_titleLabel;
    
    UIImageView *_thanImgView;
}

- (void)initWithTitleLabel;

- (void)initWithThanImgView;

@end

@implementation RestaurantInfoHeaderView

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
    
    self.backgroundColor = [UIColor colorWithHexString:@"#e4e4e4"];//[UIColor whiteColor];
    
    [self initWithTitleLabel];
    
    [self initWithThanImgView];
    
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:CGRectMake(15, 12, [[UIScreen mainScreen] screenWidth] - 30, 20) textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
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
        [self addSubview:_thanImgView];
    }
}


- (void)updateViewData:(id)entity
{
    _titleLabel.attributedText = entity;
}

- (void)updateViewData:(id)entity hiddenThan:(BOOL)hiddenThan
{
    [self updateViewData:entity];
    _thanImgView.hidden = hiddenThan;
}

@end




















