//
//  TYZTimeChoiceView.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/19.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZTimeChoiceView.h"
#import "LocalCommon.h"

@interface TYZTimeChoiceView () <UIPickerViewDataSource, UIPickerViewDelegate>
{
    UIPickerView *_timePicker;
    
    NSMutableArray *_hourLists;
    
    NSMutableArray *_minuteLists;
    
    UIView *_toolView;
}

@property (nonatomic, copy) NSString *hour;

@property (nonatomic, copy) NSString *minute;

- (void)initWithSubView;

- (void)initWithDatePicker;

- (void)initWithToolView;

@end

@implementation TYZTimeChoiceView

- (void)dealloc
{
    _timePicker.dataSource = nil;
    _timePicker.delegate = nil;
#if !__has_feature(objc_arc)
    CC_SAFE_RELEASE_NULL(_timePicker);
    CC_SAFE_RELEASE_NULL(_hour);
    CC_SAFE_RELEASE_NULL(_minute);
    CC_SAFE_RELEASE_NULL(_toolView);
    
    [super dealloc];
#endif
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self initWithSubView];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)initWithSubView
{
    _hourLists = [[NSMutableArray alloc] initWithCapacity:0];
    _minuteLists = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSInteger i=0; i<=60; i++)
    {
        NSString *str = nil;
        NSString *min = nil;
        if (i< 10)
        {
            str = [NSString stringWithFormat:@"0%d点", (int)i];
            min = [NSString stringWithFormat:@"0%d分", (int)i];
        }
        else
        {
            str = [NSString stringWithFormat:@"%d点", (int)i];
            min = [NSString stringWithFormat:@"%d分", (int)i];
        }
        
        if (i<=24)
        {
            [_hourLists addObject:str];
        }
        [_minuteLists addObject:min];
    }
    
    self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    
    [self initWithDatePicker];
    
    [self initWithToolView];
    
    [self initWithButtons];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], _toolView.top)];
    [self addSubview:bgView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [bgView addGestureRecognizer:tap];
#if !__has_feature(objc_arc)
    CC_SAFE_RELEASE_NULL(tap);
    CC_SAFE_RELEASE_NULL(bgView);
#endif
    
    [self updateCurrentTimeHour:nil minite:nil];
}

- (void)initWithDatePicker
{
    CGRect frame = CGRectMake(0.0f, 44.0f, [[UIScreen mainScreen] screenWidth], 216.0f);
    _timePicker = [[UIPickerView alloc] initWithFrame:frame];
    _timePicker.dataSource = self;
    _timePicker.delegate = self;
    _timePicker.backgroundColor = [UIColor whiteColor];
    _timePicker.bottom = self.bounds.size.height;
    [self addSubview:_timePicker];
}

- (void)initWithToolView
{
    _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], 44)];
    _toolView.backgroundColor = [UIColor whiteColor];
    _toolView.bottom = _timePicker.top;
    [self addSubview:_toolView];
}

- (void)initWithButtons
{
    UIButton *btnLeft = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"取消" titleColor:[UIColor colorWithHexString:@"#999999"] titleFont:FONTSIZE_15 targetSel:@selector(clickedButton:)];
    btnLeft.left = 5;
    btnLeft.tag = 100;
    btnLeft.size = CGSizeMake(60, 30);
    btnLeft.centerY = _toolView.height/2;
    //    btnLeft.backgroundColor = [UIColor orangeColor];
    [_toolView addSubview:btnLeft];
    
    CGRect frame = btnLeft.frame;
    UIButton *btnRight = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"确定" titleColor:[UIColor colorWithHexString:@"#999999"] titleFont:FONTSIZE_15 targetSel:@selector(clickedButton:)];
    btnRight.frame = frame;
    btnRight.right = [[UIScreen mainScreen] screenWidth] - 5;
    btnRight.tag = 101;
    //    btnRight.backgroundColor = [UIColor orangeColor];
    [_toolView addSubview:btnRight];
}

- (void)tapGesture:(UITapGestureRecognizer *)gesture
{
    if (_pickupTimeBlock)
    {
        _pickupTimeBlock(nil);
    }
    
}

- (void)clickedButton:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSString *str = nil;
    if (btn.tag == 100)
    {// 取消
        str = nil;
    }
    else
    {// 确定
        str = [NSString stringWithFormat:@"%@:%@", _hour, _minute];
        str = [str stringByReplacingOccurrencesOfString:@"点" withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@"分" withString:@""];
    }
    if (_pickupTimeBlock)
    {
        _pickupTimeBlock(str);
    }
}

- (void)updateCurrentTimeHour:(NSString *)hour_ minite:(NSString *)minite_
{
    NSDate *date = [NSDate date];
    if (!hour_)
    {
        NSInteger hour = date.hour;
        if (hour < 10)
        {
            self.hour = [NSString stringWithFormat:@"0%d点", (int)hour];
        }
        else
        {
            self.hour = [NSString stringWithFormat:@"%d点", (int)hour];
        }
    }
    else
    {
        self.hour = hour_;
    }
    
    if (!minite_)
    {
        NSInteger minute = date.minute;
        if (minute < 10)
        {
            self.minute = [NSString stringWithFormat:@"0%d分", (int)minute];
        }
        else
        {
            self.minute = [NSString stringWithFormat:@"%d分", (int)minute];
        }
    }
    else
    {
        self.minute = minite_;
    }
    [_timePicker selectRow:[_hourLists indexOfObject:_hour] inComponent:0 animated:YES];
    
    [_timePicker selectRow:[_minuteLists indexOfObject:_minute] inComponent:1 animated:YES];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return [_hourLists count];
    }
    return [_minuteLists count];
}

/*
 // 每列的宽度
 - (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
 {
 
 }*/

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        self.hour = _hourLists[row];
    }
    else
    {
        self.minute = _minuteLists[row];
    }
}

// 返回当前行的内容，此处是将数据中数值添加到滚动的那个现实栏上
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
    {
        return _hourLists[row];
    }
    return _minuteLists[row];
}



@end
