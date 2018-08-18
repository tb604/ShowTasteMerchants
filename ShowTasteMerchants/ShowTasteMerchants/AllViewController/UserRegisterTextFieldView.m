//
//  UserRegisterTextFieldView.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/26.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "UserRegisterTextFieldView.h"
#import "LocalCommon.h"

@interface UserRegisterTextFieldView () <UITextFieldDelegate>
{
    UIImageView *_iphoneImgView;
    
    /**
     *  手机号码
     */
    UITextField *_iphoneTxtField;
    
    UIImageView *_verCodeImgView;
    
    /**
     *  验证码
     */
    UITextField *_verCodeTxtField;
    
    UIImageView *_passwordImgView;
    
    /**
     *  密码
     */
    UITextField *_passwordTxtField;
    
    /**
     *  获取验证码按钮
     */
    UIButton *_btnVerCode;
    
    /**
     *  显示密码
     */
    UIButton *_btnShowPsw;
    
    CGFloat _space;
}

@property (nonatomic, assign) NSInteger timeSecond;

@property (nonatomic, strong) CALayer *lineOne;

@property (nonatomic, strong) CALayer *lineTwo;

@property (nonatomic, strong) CALayer *lineThree;


- (void)initWithLineOne;

- (void)initWithTwo;

- (void)initWithThree;

- (void)initWithIphoneImgView;

- (void)initWithIphoneTxtField;

- (void)initWithVerCodeImgView;

- (void)initWithVerCodeTxtField;

- (void)initWithPasswordImgView;

- (void)initWithPasswordTxtField;

- (void)initWithBtnVerCode;

- (void)initWithBtnShowPsw;

@end

@implementation UserRegisterTextFieldView

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
    
    _space = 15;
    if (kiPhone4 || kiPhone5)
    {
        _space = 10;
    }
    
    [self initWithLineOne];
    
    [self initWithTwo];
    
    [self initWithThree];
    
    [self initWithIphoneImgView];
    
    [self initWithIphoneTxtField];
    
    [self initWithVerCodeImgView];
    
    [self initWithVerCodeTxtField];
    
    [self initWithPasswordImgView];
    
    [self initWithPasswordTxtField];
    
    [self initWithBtnVerCode];
    
    [self initWithBtnShowPsw];


}

- (void)initWithLineOne
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake(self.width - _space - 86, 0.8);
    line.left = 0;
    line.centerY = kUserRegisterTextFieldViewHeight/3;
    line.backgroundColor = [UIColor colorWithHexString:@"#1c1c1c"].CGColor;
    [self.layer addSublayer:line];
    self.lineOne = line;
}

- (void)initWithTwo
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake(self.width - _space - 86, 0.8);
    line.left = 0;
    line.centerY = kUserRegisterTextFieldViewHeight/3 * 2;
    line.backgroundColor = [UIColor colorWithHexString:@"#1c1c1c"].CGColor;
    [self.layer addSublayer:line];
    self.lineTwo = line;
}

- (void)initWithThree
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake(self.width, 0.8);
    line.left = 0;
    line.centerY = kUserRegisterTextFieldViewHeight;
    line.backgroundColor = [UIColor colorWithHexString:@"#1c1c1c"].CGColor;
    [self.layer addSublayer:line];
    self.lineThree = line;
}

- (void)initWithIphoneImgView
{
    if (!_iphoneImgView)
    {
        UIImage *image = [UIImage imageNamed:@"login_icon_phone"];
        _iphoneImgView = [[UIImageView alloc] initWithImage:image];
        _iphoneImgView.size = image.size;
        _iphoneImgView.centerY =(kUserRegisterTextFieldViewHeight / 3) / 2;
        _iphoneImgView.left = 0;
        [self addSubview:_iphoneImgView];
    }
}

- (void)initWithIphoneTxtField
{
    if (!_iphoneTxtField)
    {
        NSAttributedString *butedStr = [[NSAttributedString alloc] initWithString:@"请输入手机号码" attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#cccccc"]}];
        CGRect frame = CGRectMake(_iphoneImgView.right + _space, 0, _lineOne.width - _iphoneImgView.right - _space, 30);
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

- (void)initWithVerCodeImgView
{
    if (!_verCodeImgView)
    {
        UIImage *image = [UIImage imageNamed:@"login_icon_verify"];
        _verCodeImgView = [[UIImageView alloc] initWithImage:image];
        _verCodeImgView.size = image.size;
        _verCodeImgView.centerY =kUserRegisterTextFieldViewHeight / 2;
        _verCodeImgView.left = 0;
        [self addSubview:_verCodeImgView];
    }
}

- (void)initWithVerCodeTxtField
{
    if (!_verCodeTxtField)
    {
        NSAttributedString *butedStr = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#cccccc"]}];
        CGRect frame = CGRectMake(_verCodeImgView.right + _space, 0, _lineOne.width - _verCodeImgView.right - _space, 30);
        _verCodeTxtField = [[UITextField alloc] initWithFrame:frame];
        _verCodeTxtField.borderStyle = UITextBorderStyleNone;
        _verCodeTxtField.attributedPlaceholder = butedStr;
        _verCodeTxtField.textAlignment = NSTextAlignmentLeft;
        _verCodeTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _verCodeTxtField.keyboardType = UIKeyboardTypeNumberPad;
        _verCodeTxtField.returnKeyType = UIReturnKeyNext;
        _verCodeTxtField.delegate = self;
        _verCodeTxtField.centerY = _verCodeImgView.centerY;
        [self addSubview:_verCodeTxtField];
    }
}

- (void)initWithPasswordImgView
{
    if (!_passwordImgView)
    {
        UIImage *image = [UIImage imageNamed:@"login_icon_password"];
        _passwordImgView = [[UIImageView alloc] initWithImage:image];
        _passwordImgView.size = image.size;
        _passwordImgView.left = 0;
        _passwordImgView.centerY = (kUserRegisterTextFieldViewHeight / 6) * 5;
        [self addSubview:_passwordImgView];
    }
}

- (void)initWithPasswordTxtField
{
    if (!_passwordTxtField)
    {
        UIImage *image = [UIImage imageNamed:@"login_btn_invisible"];
        NSAttributedString *butedStr = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{NSFontAttributeName: FONTSIZE_15, NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#cccccc"]}];
        CGRect frame = _iphoneTxtField.frame;
        frame.size.width = _lineThree.width - _passwordImgView.right - _space * 2 - image.size.width;
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

- (void)initWithBtnVerCode
{
    if (!_btnVerCode)
    {
        CGRect frame = CGRectMake(_verCodeTxtField.right+ 10, 0, 86, 30);
        _btnVerCode = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"获取验证码" titleColor:[UIColor colorWithHexString:@"#ff5601"] titleFont:FONTSIZE_15 targetSel:@selector(clickedButton:)];
        _btnVerCode.frame = frame;
        _btnVerCode.centerY = _verCodeTxtField.centerY;
        _btnVerCode.tag = 100;
        _btnVerCode.layer.borderColor = [UIColor colorWithHexString:@"#ff5601"].CGColor;
        _btnVerCode.layer.borderWidth = 1;
        [self addSubview:_btnVerCode];
    }
}

- (void)initWithBtnShowPsw
{
    if (!_btnShowPsw)
    {
        UIImage *image = [UIImage imageNamed:@"login_btn_invisible"];
        CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
//        [UIImage imageNamed:@"login_btn_visible"]
        _btnShowPsw = [TYZCreateCommonObject createWithButton:self imgNameNor:@"login_btn_invisible" imgNameSel:@"login_btn_visible" targetSel:@selector(clickedButton:)];
        _btnShowPsw.frame = frame;
        _btnShowPsw.right = self.width;
        _btnShowPsw.centerY = _passwordTxtField.centerY;
        _btnShowPsw.tag = 101;
        [self addSubview:_btnShowPsw];
    }
}

- (void)clickedButton:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 100)
    {// 获取验证码
        if (self.viewCommonBlock)
        {
            self.viewCommonBlock(@"vercode");
        }
    }
    else if (btn.tag == 101)
    {
        btn.selected = !btn.selected;
        _passwordTxtField.secureTextEntry = _btnShowPsw.selected;
    }
}


/**
 *  手机号码
 *
 *  @return <#return value description#>
 */
- (NSString *)getPhone
{
    return [_iphoneTxtField text];
}

/**
 *  验证码
 *
 *  @return
 */
- (NSString *)getVerCode
{
    return [_verCodeTxtField text];
}

/**
 *  密码
 *
 *  @return <#return value description#>
 */
- (NSString *)getPassword
{
    return [_passwordTxtField text];
}

- (void)updateTimeSecond:(NSNumber *)second
{
    if ([second integerValue] != 0)
    {
        self.timeSecond = [second integerValue];
        _btnVerCode.userInteractionEnabled = NO;
    }
    
    if (self.timeSecond < 0)
    {// 停止
        [_btnVerCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        _btnVerCode.userInteractionEnabled = YES;
    }
    else
    {
        [_btnVerCode setTitle:[NSString stringWithFormat:@"%ld", (long)_timeSecond] forState:UIControlStateNormal];
        [self performSelector:@selector(updateTimeSecond:) withObject:@(0) afterDelay:1];
    }
    _timeSecond--;
}


#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self endEditing:YES];
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(@"done");
    }
    return YES;
}

@end

























