//
//  MyRestaurantManagerEditSingleView.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/28.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantManagerEditSingleView.h"
#import "LocalCommon.h"

@interface MyRestaurantManagerEditSingleView ()
{
    UILabel *_titleLabel;
    
    
    
}

- (void)initWithTitleLabel;

- (void)initWithValueTxtField;

@end

@implementation MyRestaurantManagerEditSingleView

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
    
    [self initWithTitleLabel];
    
    [self initWithValueTxtField];
}

- (void)initWithTitleLabel
{
    NSString *str = @"姓名";
    CGFloat width = [str widthForFont:FONTSIZE_12];
    CGRect frame = CGRectMake(15, 10, width, 20);
    _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
}

- (void)initWithValueTxtField
{
    CGRect frame = CGRectMake(_titleLabel.right + 30, 5, self.width - _titleLabel.right - 30 * 2 - 15 * 2, 30);
    _valueTxtField = [[UITextField alloc] initWithFrame:frame];
    _valueTxtField.font = FONTSIZE_15;
//    _valueTxtField.delegate = self;
    _valueTxtField.textAlignment = NSTextAlignmentCenter;
    _valueTxtField.textColor = [UIColor colorWithHexString:@"#323232"];
//    if (_isNumber)
//    {
//        NSString *str = [NSString stringWithFormat:@"%@", _data];
//        if ([str isEqualToString:@"0"])
//        {
//            str = nil;
//        }
//        _txtField.text = str;
//        _txtField.keyboardType = UIKeyboardTypeDecimalPad;
//    }
//    else
//    {
//        _txtField.keyboardType = UIKeyboardTypeDefault;
//        _txtField.text = _data;
//    }
//    _txtField.returnKeyType = UIReturnKeyDone;
    _valueTxtField.borderStyle = UITextBorderStyleNone;
    _valueTxtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    _valueTxtField.placeholder = _placeholder;
    _valueTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self addSubview:_valueTxtField];
}

- (void)updateWithTitle:(NSString *)title value:(NSString *)value placeholder:(NSString *)placeholder returnKeyType:(UIReturnKeyType)returnKeyType
{
    _titleLabel.text = title;
    
    _valueTxtField.placeholder = placeholder;
    _valueTxtField.returnKeyType = returnKeyType;
    _valueTxtField.text = value;
}

@end





















