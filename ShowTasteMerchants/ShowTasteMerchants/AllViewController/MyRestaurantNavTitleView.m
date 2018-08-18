//
//  MyRestaurantNavTitleView.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/16.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantNavTitleView.h"
#import "LocalCommon.h"

@interface MyRestaurantNavTitleView ()
{
    UILabel *_titleLabel;
    
    /**
     *  hall_head-name_btn_change
     */
    UIImageView *_thanImgView;
}

- (void)initWithTitleLabel;

- (void)initWithThanImgView;

- (void)tapGesture:(UITapGestureRecognizer *)tap;

@end

@implementation MyRestaurantNavTitleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithVar
{
    [super initWithVar];
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithTitleLabel];
    
    [self initWithThanImgView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self addGestureRecognizer:tap];
    
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        CGRect frame = CGRectMake(0, 0, 60, 30);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor whiteColor] fontSize:FONTBOLDSIZE_18 labelTag:0 alignment:NSTextAlignmentCenter];
        _titleLabel.center = CGPointMake(self.width/2, self.height / 2);
    }
}

- (void)initWithThanImgView
{
    if (!_thanImgView)
    {
        UIImage *image = [UIImage imageNamed:@"hall_head-name_btn_change"];
        CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
        _thanImgView = [[UIImageView alloc]initWithFrame:frame];
        _thanImgView.image = image;
        _thanImgView.centerY = _titleLabel.centerY;
        [self addSubview:_thanImgView];
    }
}

- (void)tapGesture:(UITapGestureRecognizer *)tap
{
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(nil);
    }
}

- (void)updateViewData:(id)entity
{
    NSString *str = entity;
    CGFloat width = [str widthForFont:_titleLabel.font height:_titleLabel.height];
    _titleLabel.width = width;
    _titleLabel.text = str;
    _thanImgView.left = _titleLabel.right + 10;
}

@end

























