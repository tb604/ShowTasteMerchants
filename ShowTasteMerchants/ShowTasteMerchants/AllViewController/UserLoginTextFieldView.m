//
//  UserLoginTextFieldView.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/26.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "UserLoginTextFieldView.h"
#import "LocalCommon.h"

@interface UserLoginTextFieldView () <UITextFieldDelegate>
{
    UIImageView *_iphoneImgView;
    
    UITextField *_iphoneTxtField;
    
    UIImageView *_passwordImgView;
    
    UITextField *_passwordTxtField;
    

}

- (void)initWithIphoneImgView;

- (void)initWithIphoneTxtField;

- (void)initWithPasswordImgView;

- (void)initWithPasswordTxtField;

@property (nonatomic, strong) CALayer *line;

@end

@implementation UserLoginTextFieldView

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
    
    self.layer.borderColor= [UIColor colorWithHexString:@"#1a1a1a"].CGColor;
    self.layer.borderWidth = 1;
    
    [self initWithLine];
    
    [self initWithIphoneImgView];
    
    [self initWithIphoneTxtField];
    
    [self initWithPasswordImgView];
    
    [self initWithPasswordTxtField];
}

- (void)initWithLine
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake(self.width - 30, 0.8);
    line.left = 15;
    line.centerY = kUserLoginTextFieldViewHeight / 2;
    line.backgroundColor = [UIColor colorWithHexString:@"#1c1c1c"].CGColor;
    [self.layer addSublayer:line];
    self.line = line;
}

- (void)initWithIphoneImgView
{
    if (!_iphoneImgView)
    {
        UIImage *image = [UIImage imageNamed:@"login_icon_phone"];
        _iphoneImgView = [[UIImageView alloc] initWithImage:image];
        _iphoneImgView.size = image.size;
        _iphoneImgView.centerY =kUserLoginTextFieldViewHeight / 4;
        _iphoneImgView.left = 15;
        [self addSubview:_iphoneImgView];
    }
}

- (void)initWithIphoneTxtField
{
    if (!_iphoneTxtField)
    {
        NSAttributedString *butedStr = [[NSAttributedString alloc] initWithString:@"请输入手机号码" attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#cccccc"]}];
        CGRect frame = CGRectMake(_iphoneImgView.right + 15, 0, _line.width - _iphoneImgView.right - 15, 30);
        _iphoneTxtField = [[UITextField alloc] initWithFrame:frame];
        _iphoneTxtField.borderStyle = UITextBorderStyleNone;
        _iphoneTxtField.attributedPlaceholder = butedStr;
        _iphoneTxtField.textAlignment = NSTextAlignmentLeft;
        _iphoneTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _iphoneTxtField.keyboardType = UIKeyboardTypeNumberPad;
        _iphoneTxtField.returnKeyType = UIReturnKeyNext;
        _iphoneTxtField.delegate = self;
        _iphoneTxtField.centerY = _iphoneImgView.centerY;
        [self addSubview:_iphoneTxtField];
    }
}

- (void)initWithPasswordImgView
{
    if (!_passwordImgView)
    {
        UIImage *image = [UIImage imageNamed:@"login_icon_password"];
        _passwordImgView = [[UIImageView alloc] initWithImage:image];
        _passwordImgView.size = image.size;
        _passwordImgView.left = 15;
        _passwordImgView.centerY = _line.bottom + (kUserLoginTextFieldViewHeight / 4);
        [self addSubview:_passwordImgView];
    }
}

- (void)initWithPasswordTxtField
{
    if (!_passwordTxtField)
    {
        NSAttributedString *butedStr = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{NSFontAttributeName: FONTSIZE_15, NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#cccccc"]}];
        CGRect frame = _iphoneTxtField.frame;
        _passwordTxtField = [[UITextField alloc] initWithFrame:frame];
        _passwordTxtField.borderStyle = UITextBorderStyleNone;
        _passwordTxtField.attributedPlaceholder = butedStr;
        _passwordTxtField.textAlignment = NSTextAlignmentLeft;
        _passwordTxtField.secureTextEntry = YES;
        _passwordTxtField.delegate = self;
        _passwordTxtField.returnKeyType = UIReturnKeyDone;
        _passwordTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordTxtField.centerY = _passwordImgView.centerY;
        [self addSubview:_passwordTxtField];
    }
}

- (NSString *)userPhone
{
    return _iphoneTxtField.text;
}

- (NSString *)userPsw
{
    return _passwordTxtField.text;
}


#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self endEditing:YES];
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(nil);
    }
    return YES;
}


@end
