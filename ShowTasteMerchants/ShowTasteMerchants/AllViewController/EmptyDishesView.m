//
//  EmptyDishesView.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/24.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "EmptyDishesView.h"
#import "LocalCommon.h"

@interface EmptyDishesView ()
{
    UIImageView *_thumalImgView;
    
    UILabel *_titleLabel;
    
}

- (void)initWithThumalImgView;

- (void)initWithTitleLabel;

@end

@implementation EmptyDishesView

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
    
    [self initWithThumalImgView];
    
    [self initWithTitleLabel];
    
    self.userInteractionEnabled = NO;
}

- (void)initWithThumalImgView
{
    UIImage *image = [UIImage imageNamed:@"menu_icon_none"];
    CGRect frame = CGRectMake((self.width-image.size.width)/2, 0, image.size.width, image.size.height);
    _thumalImgView = [[UIImageView alloc] initWithFrame:frame];
    _thumalImgView.image = image;
    [self addSubview:_thumalImgView];
}

- (void)initWithTitleLabel
{
    CGRect frame = CGRectMake(10, _thumalImgView.bottom+5, self.width - 20, 20);
    _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentCenter];
    _titleLabel.text = @"无菜品，请添加";
}

// menu_icon_none


+ (CGFloat)getWithViewWidth;
{
    UIImage *image = [UIImage imageNamed:@"menu_icon_none"];
    return image.size.width * 1.5;
}

+ (CGFloat)getWithViewHeight
{
    UIImage *image = [UIImage imageNamed:@"menu_icon_none"];
    
    return image.size.height + 10 + 20;
}

@end
