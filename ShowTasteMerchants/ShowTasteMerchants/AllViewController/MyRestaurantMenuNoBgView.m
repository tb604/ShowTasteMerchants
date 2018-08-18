//
//  MyRestaurantMenuNoBgView.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/27.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantMenuNoBgView.h"
#import "LocalCommon.h"

@interface MyRestaurantMenuNoBgView ()
{
    UILabel *_descLabel;
    
    UIImageView *_thumalImgView;
}

- (void)initWithDescLabel;

- (void)initWithThumalImgView;

@end

@implementation MyRestaurantMenuNoBgView

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
    // menu_bg_none
    
    [self initWithDescLabel];
    
    [self initWithThumalImgView];
    
    self.userInteractionEnabled = NO;
}

- (void)initWithDescLabel
{
    CGRect frame = CGRectMake(10, 0, self.width - 20, 20);
    _descLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentCenter];
    _descLabel.text = @"无内容，请添加";
}

- (void)initWithThumalImgView
{
    UIImage *image = [UIImage imageNamed:@"menu_bg_none"];
    CGRect frame = CGRectMake(0, _descLabel.bottom+5, image.size.width, image.size.height);
    _thumalImgView = [[UIImageView alloc] initWithFrame:frame];
    _thumalImgView.image = image;
    _thumalImgView.centerX = _descLabel.centerX;
    [self addSubview:_thumalImgView];
}

+ (CGFloat)getWithMenuNoBgViewHeight
{
    UIImage *image = [UIImage imageNamed:@"menu_bg_none"];
    return 25 + image.size.height;
}

+ (CGFloat)getWithMenuNoBgViewWidth
{
    UIImage *image = [UIImage imageNamed:@"menu_bg_none"];
    return image.size.width;
}

@end
