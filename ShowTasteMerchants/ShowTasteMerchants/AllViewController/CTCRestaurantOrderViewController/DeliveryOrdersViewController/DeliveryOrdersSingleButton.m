//
//  DeliveryOrdersSingleButton.m
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/17.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DeliveryOrdersSingleButton.h"
#import "LocalCommon.h"

@interface DeliveryOrdersSingleButton ()

@property (nonatomic, strong) UIButton *btnMenu;

@property (nonatomic, copy) NSString *btnTitle;

@property (nonatomic, assign) float btnWidth;

- (void)initWithBtnMenu;

@end

@implementation DeliveryOrdersSingleButton

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
    
    [self initWithBtnMenu];
}

- (void)initWithBtnMenu
{
    CGRect frame = CGRectMake(0, (self.height - 30)/2., _btnWidth, 30);
    if (!_btnMenu)
    {
//        CGRect frame = CGRectMake(0, (self.height - 30)/2., _btnWidth, 30);
        _btnMenu = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnMenu.frame = frame;
        [_btnMenu setTitle:_btnTitle forState:UIControlStateNormal];
        _btnMenu.titleLabel.font = FONTSIZE_13;
        [_btnMenu setTitleColor:[UIColor colorWithHexString:@"#646464"] forState:UIControlStateNormal];
        [_btnMenu setTitleColor:[UIColor colorWithHexString:@"#ff5500"] forState:UIControlStateSelected];
        [_btnMenu setTitleColor:[UIColor colorWithHexString:@"#ff5500"] forState:UIControlStateHighlighted];
        [_btnMenu addTarget:self action:@selector(clickedWithButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnMenu];
    }
    [_btnMenu setTitle:_btnTitle forState:UIControlStateNormal];

    _btnMenu.frame = frame;
}

- (void)setSelectButton:(BOOL)selectButton
{
    _btnMenu.selected = selectButton;
    _selectButton = selectButton;
}

- (BOOL)selectButton
{
    return _selectButton;
}

- (void)clickedWithButton:(id)sender
{
    if (_selectButtonBlock)
    {
        _selectButtonBlock(self);
    }
}

- (void)updateViewData:(id)entity
{
    self.btnTitle = entity;
    [self initWithBtnMenu];
}

- (void)updateViewData:(id)entity buttonWidth:(float)buttonWidth
{
    self.btnWidth = buttonWidth;
    [self updateViewData:entity];
}

@end














