//
//  MyFinanceNavTitleView.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/6.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyFinanceNavTitleView.h"
#import "LocalCommon.h"

@interface MyFinanceNavTitleView ()
{
    /**
     *  日
     */
    UIButton *_btnDay;
    
    /**
     *  周
     */
    UIButton *_btnWeek;
    
    /**
     *  月
     */
    UIButton *_btnMonth;
}

@property (nonatomic, strong) NSArray *titleList;

/**
 *  日
 */
- (void)initWithBtnDay;

/**
 *  周
 */
- (void)initWithBtnWeek;

/**
 *  月
 */
- (void)initWithBtnMonth;


@end

@implementation MyFinanceNavTitleView

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
    
//    self.backgroundColor = [UIColor lightGrayColor];
    
    
    // 周
    [self initWithBtnWeek];
    
    // 日
    [self initWithBtnDay];
    
    // 月
    [self initWithBtnMonth];
    
}


/**
 *  周
 */
- (void)initWithBtnWeek
{
    if (!_btnWeek)
    {
        CGRect frame = CGRectMake(0, 0, 45, 30);
        _btnWeek = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnWeek.frame = frame;
        [_btnWeek setTitle:@"周" forState:UIControlStateNormal];
        [_btnWeek setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnWeek setTitleColor:[UIColor colorWithHexString:@"#ff5500"] forState:UIControlStateSelected];
        [_btnWeek setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#ff5500"]] forState:UIControlStateNormal];
        [_btnWeek setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#ffffff"]] forState:UIControlStateSelected];
        _btnWeek.center = CGPointMake(self.width / 2, self.height / 2);
        _btnWeek.tag = EN_FINANCE_BTN_WEEK_TAG;
        [_btnWeek addTarget:self action:@selector(clickedWithButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnWeek];
        _btnWeek.layer.cornerRadius = 15;
        _btnWeek.layer.masksToBounds = YES;
        
//        _btnWeek.selected = YES;
    }
}

/**
 *  日
 */
- (void)initWithBtnDay
{
    if (!_btnDay)
    {
        CGRect frame = _btnWeek.frame;
        
        _btnDay = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnDay.frame = frame;
        [_btnDay setTitle:@"日" forState:UIControlStateNormal];
        [_btnDay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnDay setTitleColor:[UIColor colorWithHexString:@"#ff5500"] forState:UIControlStateSelected];
        [_btnDay setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#ff5500"]] forState:UIControlStateNormal];
        [_btnDay setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#ffffff"]] forState:UIControlStateSelected];
        _btnDay.left = _btnWeek.left - 10 - frame.size.width;
        _btnDay.tag = EN_FINANCE_BTN_DAY_TAG;
        [_btnDay addTarget:self action:@selector(clickedWithButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnDay];
        _btnDay.layer.cornerRadius = 15;
        _btnDay.layer.masksToBounds = YES;
        _btnDay.selected = YES;
    }
}


/**
 *  月
 */
- (void)initWithBtnMonth
{
    if (!_btnMonth)
    {
        CGRect frame = _btnWeek.frame;
        
        _btnMonth = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnMonth.frame = frame;
        [_btnMonth setTitle:@"日" forState:UIControlStateNormal];
        [_btnMonth setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnMonth setTitleColor:[UIColor colorWithHexString:@"#ff5500"] forState:UIControlStateSelected];
        [_btnMonth setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#ff5500"]] forState:UIControlStateNormal];
        [_btnMonth setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#ffffff"]] forState:UIControlStateSelected];
        [_btnMonth addTarget:self action:@selector(clickedWithButton:) forControlEvents:UIControlEventTouchUpInside];
        _btnMonth.left = _btnWeek.right + 10;
        _btnMonth.tag = EN_FINANCE_BTN_MONTH_TAG;
        [self addSubview:_btnMonth];
        _btnMonth.layer.cornerRadius = 15;
        _btnMonth.layer.masksToBounds = YES;
//        _btnMonth.selected = YES;
    }
}

- (void)clickedWithButton:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(@(btn.tag));
    }
//    [self updateViewData:@(btn.tag - EN_FINANCE_BTN_DAY_TAG)];
    [self setSelectedIndex:btn.tag - EN_FINANCE_BTN_DAY_TAG];
}


- (void)updateViewData:(id)entity
{
    self.titleList = entity;
    [_btnDay setTitle:_titleList[0] forState:UIControlStateNormal];
    [_btnWeek setTitle:_titleList[1] forState:UIControlStateNormal];
    [_btnMonth setTitle:_titleList[2] forState:UIControlStateNormal];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    NSInteger index = selectedIndex + EN_FINANCE_BTN_DAY_TAG;
    
    UIButton *btn = (UIButton *)[self viewWithTag:index];
    _btnDay.selected = NO;
    _btnWeek.selected = NO;
    _btnMonth.selected = NO;
    btn.selected = YES;
    _selectedIndex = selectedIndex;
}

@end





















