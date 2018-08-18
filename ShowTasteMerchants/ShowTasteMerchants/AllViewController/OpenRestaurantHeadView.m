//
//  OpenRestaurantHeadView.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/7.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "OpenRestaurantHeadView.h"
#import "LocalCommon.h"

@interface OpenRestaurantHeadView ()
{
    UIImageView *_thumalImgView;
    
    UILabel *_titleLabel;
}

- (void)initWithThumalImgView;

- (void)initWithTitleLabel;

@end

@implementation OpenRestaurantHeadView

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
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithThumalImgView];
    
    [self initWithTitleLabel];
}

- (void)initWithThumalImgView
{
    UIImage *image = [UIImage imageNamed:@"kaicanting_icon_cuisine"];
    CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] / 4, kOpenRestaurantHeadViewHeight/2 - image.size.height/2, image.size.width, image.size.height);
    _thumalImgView = [[UIImageView alloc] initWithFrame:frame];
    _thumalImgView.image = image;
    [self addSubview:_thumalImgView];
}

- (void)initWithTitleLabel
{
    CGRect frame = CGRectMake(_thumalImgView.right + 10, kOpenRestaurantHeadViewHeight/2-20/2, [[UIScreen mainScreen] screenWidth] - _thumalImgView.right - 10 - 15, 20);
    _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
    _titleLabel.text = @"餐厅是什么类型的?";
}

@end
















