//
//  OMHotFoodTopView.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "OMHotFoodTopView.h"
#import "LocalCommon.h"


@interface OMHotFoodTopView ()
{
    UILabel *_titleLabel;
}

- (void)initWithTitleLabel;

@end

@implementation OMHotFoodTopView

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
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:CGRectMake(30, 0, [[UIScreen mainScreen] screenWidth] - 60, 20) textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE(32/2) labelTag:0 alignment:NSTextAlignmentCenter];
        _titleLabel.text = @"热卖美食";
        _titleLabel.centerY = kOMHotFoodTopViewHeight / 2;
    }
}

- (void)updateViewData:(id)entity
{
    _titleLabel.text = entity;
}

@end

















