//
//  CustomNavBarView.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/31.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "CustomNavBarView.h"
#import "LocalCommon.h"

@interface CustomNavBarView ()
{
    UILabel *_titleLabel;
}

- (void)initWithTitleLabel;

@end

@implementation CustomNavBarView

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithTitleLabel];
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        CGRect frame = CGRectMake(10, (self.height - 20)/2, self.width - 20, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#ffffff"] fontSize:FONTBOLDSIZE(19) labelTag:0 alignment:NSTextAlignmentCenter];
    }
}

- (void)updateViewData:(id)entity titleColor:(UIColor *)titleColor
{
    _titleLabel.text = entity;
    if (titleColor)
    {
        _titleLabel.textColor = titleColor;
    }
}

@end
