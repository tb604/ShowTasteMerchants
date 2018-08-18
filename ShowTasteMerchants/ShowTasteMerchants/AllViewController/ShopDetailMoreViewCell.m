//
//  ShopDetailMoreViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopDetailMoreViewCell.h"
#import "LocalCommon.h"

@interface ShopDetailMoreViewCell ()
{
    UILabel *_titleLabel;
    
    UIImageView *_thanImgView;
}

- (void)initWithTitleLabel;

- (void)initWithThanImgView;

@end

@implementation ShopDetailMoreViewCell

//UIImage *image = [UIImage imageNamed:@"hall_icon_zhuan"];
//UIImageView *thanImgView = [[UIImageView alloc] initWithImage:image];

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithVarCell
{
    [super initWithVarCell];
    
}

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    [CALayer drawLine:self.contentView frame:CGRectMake(0, kShopDetailMoreViewCellHeight-0.6, [[UIScreen mainScreen] screenWidth], 0.6) lineColor:[UIColor colorWithHexString:@"#e0e0e0"]];
    
    [self initWithTitleLabel];
    
    [self initWithThanImgView];
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        CGRect frame = CGRectMake(15, (kShopDetailMoreViewCellHeight-20)/2, 100, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentCenter];
    }
}

- (void)initWithThanImgView
{
    if (!_thanImgView)
    {
        UIImage *image = [UIImage imageNamed:@"hall_icon_zhuan"];
        CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
        _thanImgView = [[UIImageView alloc] initWithFrame:frame];
        _thanImgView.image = image;
        _thanImgView.centerY = _titleLabel.centerY;
        [self.contentView addSubview:_thanImgView];
    }
}

- (void)updateCellData:(id)cellEntity
{
    NSString *str = cellEntity;
    CGFloat width = [str widthForFont:_titleLabel.font];
    _titleLabel.width = width;
    _titleLabel.centerX = [[UIScreen mainScreen] screenWidth] / 2;
    _titleLabel.text = cellEntity;
    
    _thanImgView.left = _titleLabel.right + 5;
}

@end
