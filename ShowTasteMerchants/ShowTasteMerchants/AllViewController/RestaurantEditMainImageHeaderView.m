//
//  RestaurantEditMainImageHeaderView.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/4.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "RestaurantEditMainImageHeaderView.h"
#import "LocalCommon.h"

@interface RestaurantEditMainImageHeaderView ()
{
    UILabel *_titleLabel;
}

- (void)initWithTitleLabel;

@end

@implementation RestaurantEditMainImageHeaderView

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
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithTitleLabel];
}


- (void)initWithTitleLabel
{
    CGRect frame = CGRectMake(15, (kRestaurantEditMainImageHeaderViewHeight - 20) / 2, [[UIScreen mainScreen] screenWidth] - 30, 20);
    _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
}

- (void)updateViewData:(id)entity
{
    _titleLabel.attributedText = entity;
}

@end
