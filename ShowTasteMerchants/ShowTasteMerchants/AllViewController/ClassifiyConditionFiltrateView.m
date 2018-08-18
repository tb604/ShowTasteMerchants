//
//  ClassifiyConditionFiltrateView.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/3.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ClassifiyConditionFiltrateView.h"
#import "LocalCommon.h"

@interface ClassifiyConditionFiltrateView ()
{
    /**
     *  筛选按钮
     */
    UIButton *_btnFiltrate;
}

- (void)initWithBtnFiltrate;

@end

@implementation ClassifiyConditionFiltrateView

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
    
    self.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    
    [self initWithBtnFiltrate];
}

- (void)initWithBtnFiltrate
{
    if (!_btnFiltrate)
    {
        CGRect frame = CGRectMake(15, 0, [[UIScreen mainScreen] screenWidth] - 30, 30);
        _btnFiltrate = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"条件筛选" titleColor:[UIColor colorWithHexString:@"#ff5500"] titleFont:FONTSIZE_13 targetSel:@selector(clickedButton:)];
        _btnFiltrate.frame = frame;
        _btnFiltrate.centerY = kClassifiyConditionFiltrateViewHeight / 2;
        _btnFiltrate.backgroundColor = [UIColor whiteColor];
        _btnFiltrate.layer.masksToBounds = YES;
        _btnFiltrate.layer.cornerRadius = 4;
        [self addSubview:_btnFiltrate];
    }
}

- (void)clickedButton:(id)sender
{
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(nil);
    }
}

@end
















