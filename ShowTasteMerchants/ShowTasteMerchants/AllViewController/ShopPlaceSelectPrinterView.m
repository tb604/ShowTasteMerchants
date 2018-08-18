//
//  ShopPlaceSelectPrinterView.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/12.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopPlaceSelectPrinterView.h"
#import "LocalCommon.h"

@interface ShopPlaceSelectPrinterView ()
{
    UIImageView *_thanImgView;
    
    UILabel *_titleLabel;
}

- (void)initWithThanImgView;

- (void)initWithTitleLabel;

- (void)tapGesture:(UITapGestureRecognizer *)tap;

@end

@implementation ShopPlaceSelectPrinterView

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
    
    [self initWithThanImgView];
    
    [self initWithTitleLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self addGestureRecognizer:tap];
}

- (void)initWithThanImgView
{
    if (!_thanImgView)
    {
        UIImage *image = [UIImage imageNamed:@"menu_btn_choose"];
        CGRect frame = CGRectMake(self.width - image.size.width, (kShopPlaceSelectPrinterViewHeight-image.size.height)/2, image.size.width, image.size.height);
        _thanImgView = [[UIImageView alloc] initWithFrame:frame];
        _thanImgView.image = image;
        [self addSubview:_thanImgView];
    }
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        CGRect frame = CGRectMake(0, (kShopPlaceSelectPrinterViewHeight-20)/2, _thanImgView.left - 5, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
    }
}

- (void)tapGesture:(UITapGestureRecognizer *)tap
{
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(_titleLabel.text);
    }
}

- (void)updateViewData:(id)entity
{
    _thanImgView.right = self.width;
    
    _titleLabel.text = entity;
    CGRect frame = CGRectMake(0, (kShopPlaceSelectPrinterViewHeight-20)/2, _thanImgView.left - 5, 20);
    _titleLabel.frame = frame;
}

@end
