//
//  RestaurantMenuBottomView.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/24.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "RestaurantMenuBottomView.h"
#import "LocalCommon.h"

@interface RestaurantMenuBottomView ()
{
    /**
     *  添加类别
     */
    UIButton *_btnAddCategory;
    
    /**
     *  添加菜品
     */
    UIButton *_btnAddDishes;
}

- (void)initWithBtnAddCategory;

- (void)initWithBtnAddDishes;

@end

@implementation RestaurantMenuBottomView

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
    
    self.backgroundColor = [UIColor colorWithHexString:@"#ff5601"];
    
    [self topLineWithHidden:YES];
    
    [self initWithLine];
    
    [self initWithBtnAddCategory];
    
    [self initWithBtnAddDishes];
}

- (void)initWithLine
{
    AppDelegate *app = [UtilityObject appDelegate];
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake(1.0, [app tabBarHeight] - 20);
    line.top = 10;
    line.centerX = [[UIScreen mainScreen] screenWidth] / 2;
    line.backgroundColor = [UIColor colorWithHexString:@"#ffffff"].CGColor;
    [self.layer addSublayer:line];
}


- (void)initWithBtnAddCategory
{
    if (!_btnAddCategory)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth] / 2, self.height);
        _btnAddCategory = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"添加类别" titleColor:[UIColor whiteColor] titleFont:FONTSIZE_16 targetSel:@selector(clickedButton:)];
        _btnAddCategory.frame = frame;
        _btnAddCategory.tag = 100;
        [self addSubview:_btnAddCategory];
    }
}

- (void)initWithBtnAddDishes
{
    if (!_btnAddDishes)
    {
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] / 2, 0, [[UIScreen mainScreen] screenWidth] / 2, self.height);
        _btnAddDishes = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"添加菜品" titleColor:[UIColor whiteColor] titleFont:FONTSIZE_16 targetSel:@selector(clickedButton:)];
        _btnAddDishes.frame = frame;
        _btnAddDishes.tag = 101;
        [self addSubview:_btnAddDishes];
    }
}

- (void)clickedButton:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger tag = btn.tag;
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(@(tag));
    }
}

- (void)updateBottomCancel:(NSString *)cancelTitle submitTitle:(NSString *)submitTitle
{
    
}

@end
