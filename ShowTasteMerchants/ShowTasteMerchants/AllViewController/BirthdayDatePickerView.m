/*
 *   Copyright (c) 2015年 51tour. All rights reserved.
 *
 * 项目名称: 51tour
 * 文件名称: BirthdayDatePickerView.m
 * 文件标识:
 * 摘要描述: 修改用户生日视图
 *
 * 当前版本:
 * 作者姓名: xiang_ying
 * 创建日期: 15/2/15 下午3:30
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "BirthdayDatePickerView.h"
#import "LocalCommon.h"

@interface BirthdayDatePickerView ()
{
    /**
     *  是否是长时间；YES表示yyyy-mm-dd hh:mm；NO表示yyyy-mm-dd
     */
    BOOL _isLogTime;
}
@property (nonatomic, strong) UIToolbar *toolbar;

@property (nonatomic, strong) UIDatePicker *birthdayPicker;


- (void)initWithToolbar;

- (void)initWithBirthdayPicker;

- (void)clickedOk:(id)sender;

- (void)datePickerValueChanged:(UIDatePicker *)datePicker;

@end

@implementation BirthdayDatePickerView

- (void)dealloc
{
#if !__has_feature(objc_arc)
    CC_SAFE_RELEASE_NULL(_toolbar);
    CC_SAFE_RELEASE_NULL(_birthdayPicker);
    CC_SAFE_RELEASE_NULL(_TouchDateTimeBlock);
    [super dealloc];
#endif
}

- (id)initWithFrame:(CGRect)frame isLogTime:(BOOL)isLogTime
{
    _isLogTime = isLogTime;
    return [self initWithFrame:frame];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code
}
*/

#pragma mark start override
- (void)initWithVar
{
    [super initWithVar];
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    self.backgroundColor = [UIColor colorWithRed:242.0f/255 green:244.0f/255 blue:245.0f/255 alpha:1];
    
    [self initWithToolbar];
    
    [self initWithBirthdayPicker];
}
#pragma mark end override

- (void)setPersonBirthday:(NSString *)personBirthday_
{
#if !__has_feature(objc_arc)
    if (_personBirthday != personBirthday_)
    {
        [_personBirthday release], _personBirthday = nil;
        _personBirthday = [personBirthday_ copy];
    }
#else
    _personBirthday = personBirthday_;
#endif
    NSDate *birthday = nil;
    if (_personBirthday && ![_personBirthday isEqualToString:@""])
    {
        birthday = [NSDate dateWithString:_personBirthday format:@"yyyy-MM-dd"];
    }
    if (birthday)
    {
        [self.birthdayPicker setDate:birthday animated:YES];
    }
}

#pragma mark start private methods
- (void)initWithToolbar
{
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [[UIScreen mainScreen] screenWidth], 44.0f)];
//    _toolbar.backgroundColor = [UIColor blueColor];
    [self addSubview:_toolbar];
    
    UIBarButtonItem *btnspace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIButton *btnOk = [UIButton buttonWithType:UIButtonTypeCustom];
    btnOk.frame = CGRectMake(0.0f, 0.0f, 50.0f, 30.0f);
    [btnOk setTitle:@"确定" forState:UIControlStateNormal];
    [btnOk setTitleColor:kFontColorBlue forState:UIControlStateNormal];
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

- (void)initWithBirthdayPicker
{
    CGRect frame = CGRectMake(0.0f, 44.0f, [[UIScreen mainScreen] screenWidth], 216.0f);
    _birthdayPicker = [[UIDatePicker alloc] initWithFrame:frame];
    if (_isLogTime)
    {
        debugLog(@"日期和时间");
        _birthdayPicker.datePickerMode = UIDatePickerModeDateAndTime;
    }
    else
    {
        _birthdayPicker.datePickerMode = UIDatePickerModeDate;
    }
    // 设置日期选择控件的地区
    NSLocale *local = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"];
    [_birthdayPicker setLocale:local];
//    CC_SAFE_RELEASE_NULL(local);
    
    // 设置DatePicker的日历，当天
//    [_birthdayPicker setCalendar:[NSCalendar currentCalendar]];
    
    // 设置时区
//    _birthdayPicker.timeZone = [NSTimeZone defaultTimeZone];
    
    
//    _birthdayPicker.date = [NSDate date];
    if (!_isLogTime)
    {
        [_birthdayPicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    
    
//    [_birthdayPicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventAllTouchEvents];
    
    [self addSubview:_birthdayPicker];
}

- (void)clickedOk:(id)sender
{
//    debugLog(@"date12=%@", _birthdayPicker.date);
//    if (!_personBirthday)
//    {
        NSString *birthday = nil;
        if (_isLogTime)
        {
            birthday = [_birthdayPicker.date stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
        }
        else
        {
            birthday = [_birthdayPicker.date stringWithFormat:@"yyyy-MM-dd"];
        }
        self.personBirthday = birthday;
//    }
    if ([_delegate respondsToSelector:@selector(birthdaySubmit:)])
    {
        [_delegate birthdaySubmit:self.personBirthday];
    }
    
    
    if (_TouchDateTimeBlock)
    {
        _TouchDateTimeBlock(_personBirthday, YES);
    }
    [self updateDateLocal];
}

- (void)datePickerValueChanged:(UIDatePicker *)datePicker
{
    debugMethod();
//    NSDate *birthday = datePicker.date;
    NSString *birthday = [datePicker.date stringWithFormat:@"yyyy-MM-dd"];
    self.personBirthday = birthday;
    
    if (_TouchDateTimeBlock)
    {
        _TouchDateTimeBlock(_personBirthday, NO);
    }
}
#pragma mark end private methods

- (void)updateDateLocal
{
    debugMethod();
    NSLocale *local = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"];
    [_birthdayPicker setLocale:local];
//    CC_SAFE_RELEASE_NULL(local);
}

- (void)updatecurrentDate:(NSString *)strDate
{
    // yyyy-MM-dd HH:mm:ss
//    NSDate *date = [NSDate dateStrToDateTime:strDate];
    // HH:mm:ss
    NSDate *date = [NSDate dateWithString:strDate format:@"yyyy-MM-dd"];
    _birthdayPicker.date = date;
}

- (void)updateIsLogTime:(BOOL)isLogTime
{
    debugMethod();
    _isLogTime = isLogTime;
    if (_isLogTime)
    {
        _birthdayPicker.datePickerMode = UIDatePickerModeDateAndTime;
    }
    else
    {
        _birthdayPicker.datePickerMode = UIDatePickerModeDate;
    }
//    _birthdayPicker.datePickerMode = UIDatePickerModeTime
}

@end
