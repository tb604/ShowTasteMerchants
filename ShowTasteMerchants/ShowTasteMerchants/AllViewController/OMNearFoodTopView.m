//
//  OMNearFoodTopView.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "OMNearFoodTopView.h"
#import "LocalCommon.h"

@interface OMNearFoodTopView ()
{
    UILabel *_titleLabel;
    
    // home_triangle
    UIImageView *_thanImgView;
    
}

- (void)initWithTitleLabel;

- (void)initWithThanImgView;

- (void)tapGesture:(UITapGestureRecognizer *)tap;

@end

@implementation OMNearFoodTopView

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
    
    [self initWithTitleLabel];
    
    [self initWithThanImgView];
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:CGRectMake(15, (kOMNearFoodTopViewHeight-30)/2, [[UIScreen mainScreen] screenWidth] - 60, 30) textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE(17) labelTag:0 alignment:NSTextAlignmentCenter];
//        _titleLabel.text = @"附近美食";
        _titleLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        [_titleLabel addGestureRecognizer:tap];
    }
}

- (void)initWithThanImgView
{
    if (!_thanImgView)
    {
        UIImage *image = [UIImage imageNamed:@"home_triangle"];
        CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
        _thanImgView = [[UIImageView alloc] initWithFrame:frame];
        _thanImgView.image = image;
        _thanImgView.centerY = _titleLabel.centerY;
        [self addSubview:_thanImgView];
    }
}

- (void)tapGesture:(UITapGestureRecognizer *)tap
{
    if (self.touchWithMoreInfoBlock)
    {
        self.touchWithMoreInfoBlock();
    }
}

- (void)updateViewData:(id)entity
{
    NSString *str = entity;
    CGFloat width = [str widthForFont:_titleLabel.font];
    _titleLabel.width = width;
    _titleLabel.centerX = [[UIScreen mainScreen] screenWidth] / 2;
    _titleLabel.text = entity;
    
    _thanImgView.left = _titleLabel.right + 5;
}


@end
