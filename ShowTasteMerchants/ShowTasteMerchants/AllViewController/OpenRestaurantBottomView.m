//
//  OpenRestaurantBottomView.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/7.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "OpenRestaurantBottomView.h"
#import "LocalCommon.h"


@interface OpenRestaurantBottomView ()
{
    UIButton *_btnNext;
}

- (void)initWithBtnNext;

@end

@implementation OpenRestaurantBottomView

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
    
    [self initWithBtnNext];
    
}

- (void)initWithBtnNext
{
    CGRect frame = CGRectMake(0, self.height/2-30.0/2, [[UIScreen mainScreen] screenWidth], 30);
    _btnNext = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"下一步" titleColor:[UIColor whiteColor] titleFont:FONTSIZE_16 targetSel:@selector(clickedNext:)];
    _btnNext.frame = frame;
    [self addSubview:_btnNext];
    _btnNext.centerX = self.width / 2;
}

- (void)clickedNext:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(btn.titleLabel.text);
    }
}

- (void)updateViewData:(id)entity
{
    [_btnNext setTitle:entity forState:UIControlStateNormal];
}

@end


























