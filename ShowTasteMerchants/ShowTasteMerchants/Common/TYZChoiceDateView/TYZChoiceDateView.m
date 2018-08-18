//
//  TYZChoiceDateView.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/3.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZChoiceDateView.h"
#import "TYZKit.h"


@interface TYZChoiceDateView ()

@property (nonatomic, strong) UIToolbar *toolbar;

@property (nonatomic, strong) UIDatePicker *datePicker;


- (void)initWithToolbar;

- (void)initWithDatePicker;

- (void)clickedOk:(id)sender;

- (void)datePickerValueChanged:(UIDatePicker *)datePicker;

@end

@implementation TYZChoiceDateView

- (void)initWithVar
{
    [super initWithVar];
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor colorWithRed:242.0f/255 green:244.0f/255 blue:245.0f/255 alpha:1];
    
    [self initWithToolbar];
    
    [self initWithDatePicker];
    
}


- (void)initWithToolbar
{
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [[UIScreen mainScreen] screenWidth], 44.0f)];
    //    _toolbar.backgroundColor = [UIColor blueColor];
    [self addSubview:_toolbar];
    
    UIBarButtonItem *btnspace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIButton *btnOk = [UIButton buttonWithType:UIButtonTypeCustom];
    btnOk.frame = CGRectMake(0.0f, 0.0f, 50.0f, 30.0f);
    [btnOk setTitle:@"确定" forState:UIControlStateNormal];
    [btnOk setTitleColor:[UIColor colorWithHexString:@"#ff5500"] forState:UIControlStateNormal];
    [btnOk addTarget:self action:@selector(clickedOk:) forControlEvents:UIControlEventTouchUpInside];
    btnOk.titleLabel.font = [UIFont systemFontOfSize:16];
    UIBarButtonItem *okItem = [[UIBarButtonItem alloc] initWithCustomView:btnOk];
    NSArray *array = [[NSArray alloc] initWithObjects:btnspace, okItem, nil];
    _toolbar.items = array;
#if !__has_feature(objc_arc)
    [btnspace release], btnspace = nil;
    [okItem release], okItem = nil;
    [array release], array = nil;
#endif
}

- (void)initWithDatePicker
{
    CGRect frame = CGRectMake(0.0f, 44.0f, [[UIScreen mainScreen] screenWidth], 216.0f);
_datePicker = [[UIDatePicker alloc] initWithFrame:frame];        _datePicker.datePickerMode = UIDatePickerModeDate;
    // 设置日期选择控件的地区
    NSLocale *local = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"];
    [_datePicker setLocale:local];
    [_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self addSubview:_datePicker];
}

- (void)clickedOk:(id)sender
{
    NSString *birthday = nil;
    birthday = [_datePicker.date stringWithFormat:@"yyyy-MM-dd"];
    
    if (_TouchDateBlock)
    {
        _TouchDateBlock(birthday, 1);
    }
}

- (void)updateDateLocal
{
    NSLocale *local = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"];
    [_datePicker setLocale:local];
}


- (void)datePickerValueChanged:(UIDatePicker *)datePicker
{
    NSString *birthday = [datePicker.date stringWithFormat:@"yyyy-MM-dd"];
    if (_TouchDateBlock)
    {
        _TouchDateBlock(birthday, -1);
    }
}


- (void)updateViewData:(id)entity
{
    NSDate *date = nil;
    if (!entity)
    {
        date = [NSDate date];
    }
    else
    {
        date = [NSDate dateWithString:entity format:@"yyyy-MM-dd"];
    }
    _datePicker.date = date;
}

@end
