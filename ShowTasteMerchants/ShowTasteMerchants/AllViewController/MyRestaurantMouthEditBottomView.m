//
//  MyRestaurantMouthEditBottomView.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/4.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantMouthEditBottomView.h"
#import "LocalCommon.h"

@interface MyRestaurantMouthEditBottomView ()
{
    UIButton *_btnCancel;
    
    UIButton *_btnSave;
}

- (void)initWithBtnCancel;

- (void)initWithBtnSave;

@end

@implementation MyRestaurantMouthEditBottomView

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithBtnCancel];
    
    [self initWithBtnSave];
}

- (void)initWithBtnCancel
{
    if (!_btnCancel)
    {
        CGRect frame = CGRectMake(0, 1, [[UIScreen mainScreen] screenWidth] / 2, self.height - 2);
        _btnCancel = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"取消" titleColor:[UIColor colorWithHexString:@"#323232"] titleFont:FONTSIZE_16 targetSel:@selector(clickedWithButton:)];
        _btnCancel.frame = frame;
        [self addSubview:_btnCancel];
    }
}

- (void)initWithBtnSave
{
    if (!_btnSave)
    {
        CGRect frame = CGRectMake(_btnCancel.right, 1, [[UIScreen mainScreen] screenWidth] / 2, self.height - 2);
        _btnSave = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"保存" titleColor:[UIColor colorWithHexString:@"#323232"] titleFont:FONTSIZE_16 targetSel:@selector(clickedWithButton:)];
        _btnSave.frame = frame;
        [self addSubview:_btnSave];
    }
}

- (void)clickedWithButton:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSString *title = btn.titleLabel.text;
    if (self.bottomClickedBlock)
    {
        self.bottomClickedBlock(title, btn.tag);
    }
}

@end












