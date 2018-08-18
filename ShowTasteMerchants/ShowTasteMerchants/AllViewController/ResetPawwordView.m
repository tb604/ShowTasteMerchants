//
//  ResetPawwordView.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/27.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ResetPawwordView.h"
#import "LocalCommon.h"

@interface ResetPawwordView () <UITextFieldDelegate>
{
    UIImageView *_passwordImgView;
    
    /**
     *  密码
     */
    UITextField *_passwordTxtField;
    
    
    /**
     *  显示密码
     */
    UIButton *_btnShowPsw;
    
    CGFloat _space;
}

- (void)initWithPasswordImgView;

- (void)initWithPasswordTxtField;

- (void)initWithBtnShowPsw;


@property (nonatomic, strong) CALayer *lineThree;


- (void)initWithThree;

@end

@implementation ResetPawwordView

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
    
    [self initWithThree];
    
    [self initWithPasswordImgView];
    
    [self initWithPasswordTxtField];
    
    [self initWithBtnShowPsw];
}

- (void)initWithThree
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake(self.width, 0.8);
    line.left = 0;
    line.centerY = kResetPawwordViewHeight;
    line.backgroundColor = [UIColor colorWithHexString:@"#1c1c1c"].CGColor;
    [self.layer addSublayer:line];
    self.lineThree = line;
}

- (void)initWithPasswordImgView
{
    if (!_passwordImgView)
    {
        UIImage *image = [UIImage imageNamed:@"login_icon_password"];
        _passwordImgView = [[UIImageView alloc] initWithImage:image];
        _passwordImgView.size = image.size;
        _passwordImgView.left = 0;
        _passwordImgView.centerY =kResetPawwordViewHeight / 2;
        [self addSubview:_passwordImgView];
    }
}

- (void)initWithPasswordTxtField
{
    if (!_passwordTxtField)
    {
        UIImage *image = [UIImage imageNamed:@"login_btn_invisible"];
        NSAttributedString *butedStr = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{NSFontAttributeName: FONTSIZE_15, NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#cccccc"]}];
        CGRect frame = CGRectMake(_passwordImgView.right + _space, 0, _lineThree.width - _passwordImgView.right - _space - image.size.width - _space, 30);
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
//        _btnShowPsw.tag = 101;
        [self addSubview:_btnShowPsw];
    }
}

- (void)clickedButton:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    _passwordTxtField.secureTextEntry = _btnShowPsw.selected;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(nil);
    }
    return YES;
}

- (NSString *)getWithPassword
{
    return objectNull(_passwordTxtField.text);
}


@end
