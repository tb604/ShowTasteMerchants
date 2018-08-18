//
//  TYZImageEditorBottomView.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/11.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZImageEditorBottomView.h"
#import "TYZKit.h"

@interface TYZImageEditorBottomView ()
{
    UIButton *_btnCancel;
    
    UIButton *_btnChoice;
}


- (void)initWithSubView;

- (void)initWithBtnCancel;

- (void)initWithBtnChoice;

@end

@implementation TYZImageEditorBottomView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initWithSubView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initWithSubView];
    }
    return self;
}

- (void)initWithSubView
{
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    
    [self initWithBtnCancel];
    
    [self initWithBtnChoice];
}

- (void)initWithBtnCancel
{
    CGRect frame = CGRectMake(15, (self.height - 36) / 2.0, 60, 36);
    _btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnCancel.frame = frame;
    [_btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [_btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnCancel.tag = 100;
    [_btnCancel.titleLabel setFont:FONTSIZE_18];
    [_btnCancel addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btnCancel];
}

- (void)initWithBtnChoice
{
    CGRect frame = _btnCancel.frame;
    _btnChoice = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnChoice.frame = frame;
    [_btnChoice setTitle:@"选取" forState:UIControlStateNormal];
    [_btnChoice setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnChoice.tag = 101;
    _btnChoice.right = [[UIScreen mainScreen] screenWidth] - 15;
    [_btnChoice.titleLabel setFont:FONTSIZE_18];
    [_btnChoice addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btnChoice];
}

- (void)clickedButton:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (_touchCancelSubmitBlock)
    {
        _touchCancelSubmitBlock((int)button.tag);
    }
}

@end
