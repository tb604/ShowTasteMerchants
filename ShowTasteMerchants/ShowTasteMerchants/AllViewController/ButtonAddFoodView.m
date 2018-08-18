//
//  ButtonAddFoodView.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/25.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ButtonAddFoodView.h"
#import "LocalCommon.h"

@interface ButtonAddFoodView ()
{
    UILabel *_titleLabel;
}

- (void)initWithTitleLabel;

- (void)tapGesture:(UITapGestureRecognizer *)tap;

@end

@implementation ButtonAddFoodView

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithTitleLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self addGestureRecognizer:tap];
    
}

- (void)initWithTitleLabel
{
    CGRect frame = CGRectMake(2, (self.height - 20) / 2 - 2, self.width - 4, 20);
    _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE(30) labelTag:0 alignment:NSTextAlignmentCenter];
}

- (void)tapGesture:(UITapGestureRecognizer *)tap
{
    if (_clickedBlock)
    {
        _clickedBlock();
    }
}

- (void)updateWithTitleColor:(UIColor *)color
{
    _titleLabel.textColor = color;
}

- (void)updateViewData:(id)entity
{
    _titleLabel.text = entity;
}

@end
