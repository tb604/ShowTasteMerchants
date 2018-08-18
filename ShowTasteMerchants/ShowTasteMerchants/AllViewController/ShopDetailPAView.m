//
//  ShopDetailPAView.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/2.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopDetailPAView.h"
#import "LocalCommon.h"

@interface ShopDetailPAView ()
{
    UIImageView *_iconImgView;
    
    UIImageView *_thanImgView;
    
    UILabel *_descLabel;
    
}

- (void)initWithIconImgView;

- (void)initWithThanImgView;

- (void)initWithDescLabel;

- (void)tapGesture:(UITapGestureRecognizer *)tap;

@end

@implementation ShopDetailPAView

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
    
    [self initWithIconImgView];
    
    [self initWithThanImgView];
    
    [self initWithDescLabel];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self addGestureRecognizer:tap];
}

- (void)initWithIconImgView
{
    UIImage *image = [UIImage imageNamed:@"hall_icon_phone"];
    if (!_iconImgView)
    {
        CGRect frame = CGRectMake(15, 0, image.size.width, image.size.height);
        _iconImgView = [[UIImageView alloc] initWithFrame:frame];
        _iconImgView.centerY = kShopDetailPAViewHeight / 2;
        [self addSubview:_iconImgView];
    }
}

- (void)initWithThanImgView
{
    if (!_thanImgView)
    {
        UIImage *image = [UIImage imageNamed:@"hall_icon_zhuan"];
        _thanImgView = [[UIImageView alloc] initWithImage:image];
        _thanImgView.size = image.size;
        _thanImgView.right = [[UIScreen mainScreen] screenWidth] - 15;
        _thanImgView.centerY = kShopDetailPAViewHeight / 2;
        [self addSubview:_thanImgView];
    }
}

- (void)initWithDescLabel
{
    if (!_descLabel)
    {
        CGRect frame = CGRectMake(_iconImgView.right + 10, 0, _thanImgView.left - _iconImgView.right - 20, 20);
        _descLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
        _descLabel.centerY = kShopDetailPAViewHeight / 2;
    }
}

- (void)tapGesture:(UITapGestureRecognizer *)tap
{
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(@(self.tag));
    }
}

- (void)updateViewData:(id)entity imageIcon:(UIImage *)imageIcno
{
    CGSize size = imageIcno.size;
    _iconImgView.size = size;
    _iconImgView.centerY = kShopDetailPAViewHeight / 2;
    _iconImgView.image = imageIcno;
    _descLabel.text = entity;
}

@end















