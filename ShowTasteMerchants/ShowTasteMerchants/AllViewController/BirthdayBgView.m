//
//  BirthdayBgView.m
//  51tourGuide
//
//  Created by 唐斌 on 16/4/29.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "BirthdayBgView.h"
#import "LocalCommon.h"
#import "BirthdayDatePickerView.h"

@interface BirthdayBgView ()

@property (nonatomic, strong) BirthdayDatePickerView *birthdayDatePicker;

- (void)initWithSubView;

@end

@implementation BirthdayBgView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        
        [self initWithSubView];
    }
    return self;
}

- (void)initWithSubView
{
    [self initWithBirthdayDatePicker];
    
    CGRect frame = CGRectMake(0, 0, _birthdayDatePicker.width, _birthdayDatePicker.top);
    UIView *view = [[UIView alloc]initWithFrame:frame];
    [self addSubview:view];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [view addGestureRecognizer:tap];
}

/**
 *  初始化修改生日的视图
 */
- (void)initWithBirthdayDatePicker
{
    CGRect frame = CGRectMake(0.0f, self.height - 216 - 44, [[UIScreen mainScreen] screenWidth], 216 + 44);
    _birthdayDatePicker = [[BirthdayDatePickerView alloc] initWithFrame:frame];
    [self addSubview:_birthdayDatePicker];
    __weak typeof(self)weakSelf = self;
    _birthdayDatePicker.TouchDateTimeBlock = ^(NSString *strDate, BOOL isSubmit)
    {
        debugLog(@"date=%@", strDate);
        if (weakSelf.TouchDateTimeBlock)
        {
            weakSelf.TouchDateTimeBlock(strDate, isSubmit);
        }
    };
}

- (void)updateWithBirthday:(NSString *)date isLogTime:(BOOL)isLogTime
{
    [_birthdayDatePicker updateIsLogTime:isLogTime];
    if (!date || [date isEqualToString:@""])
    {
        return;
    }
    [_birthdayDatePicker updatecurrentDate:date];
}

- (void)tapGesture:(UITapGestureRecognizer *)tap
{
    if (self.TouchDateTimeBlock)
    {
        _TouchDateTimeBlock(nil, NO);
    }
}


@end
