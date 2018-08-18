//
//  ModifyMobileView.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/31.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ModifyMobileView.h"
#import "LocalCommon.h"
#import "UserUpdateInputEntity.h"

@interface ModifyMobileView () <UITextFieldDelegate>
{
    /**
     *  手机号码
     */
    UITextField *_iphoneTxtField;

    /**
     *  验证码
     */
    UITextField *_verCodeTxtField;
    
    /**
     *  获取验证码按钮
     */
    UIButton *_btnVerCode;
    
    CGFloat _space;
    
    UIButton *_btnSubmit;
    
    UILabel *_noticeLabel;
}
@property (nonatomic, assign) NSInteger timeSecond;

@property (nonatomic, strong) CALayer *lineOne;

@property (nonatomic, strong) CALayer *lineTwo;


- (void)initWithLineOne;

- (void)initWithLineTwo;

- (void)initWithIphoneTxtField;

- (void)initWithVerCodeTxtField;

- (void)initWithBtnVerCode;

- (void)initWithBtnSubmit;

- (void)initWithNoticeLabel;

@end

@implementation ModifyMobileView

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
    
    [self initWithLineTwo];
    
    [self initWithIphoneTxtField];
//
    [self initWithVerCodeTxtField];
//
    [self initWithBtnVerCode];
    
    [self initWithBtnSubmit];
    
    [self initWithNoticeLabel];
    
}

- (void)initWithLineOne
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake(self.width - _space - 86, 0.8);
    line.left = 0;
    line.centerY = kModifyMobileViewHeight/2;
    line.backgroundColor = [UIColor colorWithHexString:@"#9a9a9a"].CGColor;
    [self.layer addSublayer:line];
    self.lineOne = line;
}

- (void)initWithLineTwo
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake(self.width, 0.8);
    line.left = 0;
    line.bottom = kModifyMobileViewHeight;
    line.backgroundColor = [UIColor colorWithHexString:@"#9a9a9a"].CGColor;
    [self.layer addSublayer:line];
    self.lineTwo = line;
}

- (void)initWithIphoneTxtField
{
    if (!_iphoneTxtField)
    {
        NSAttributedString *butedStr = [[NSAttributedString alloc] initWithString:@"请输入手机号码" attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#cccccc"]}];
        CGRect frame = CGRectMake(0, ((kModifyMobileViewHeight/2) - 30)/2, _lineOne.width, 30);
        _iphoneTxtField = [[UITextField alloc] initWithFrame:frame];
        _iphoneTxtField.borderStyle = UITextBorderStyleNone;
        _iphoneTxtField.font = FONTSIZE_15;
        _iphoneTxtField.textColor = [UIColor colorWithHexString:@"#323232"];
        _iphoneTxtField.attributedPlaceholder = butedStr;
        _iphoneTxtField.textAlignment = NSTextAlignmentLeft;
        _iphoneTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _iphoneTxtField.keyboardType = UIKeyboardTypeNumberPad;
        _iphoneTxtField.returnKeyType = UIReturnKeyNext;
        _iphoneTxtField.delegate = self;
        [self addSubview:_iphoneTxtField];
    }
}

- (void)initWithVerCodeTxtField
{
    if (!_verCodeTxtField)
    {
        NSAttributedString *butedStr = [[NSAttributedString alloc] initWithString:@"请输入短信验证码" attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#cccccc"]}];
        CGRect frame = CGRectMake(0, 0, _lineOne.width, 30);
        _verCodeTxtField = [[UITextField alloc] initWithFrame:frame];
        _verCodeTxtField.borderStyle = UITextBorderStyleNone;
        _verCodeTxtField.font = FONTSIZE_15;
        _verCodeTxtField.textColor = [UIColor colorWithHexString:@"#323232"];
        _verCodeTxtField.attributedPlaceholder = butedStr;
        _verCodeTxtField.textAlignment = NSTextAlignmentLeft;
        _verCodeTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _verCodeTxtField.keyboardType = UIKeyboardTypeNumberPad;
        _verCodeTxtField.returnKeyType = UIReturnKeyNext;
        _verCodeTxtField.delegate = self;
        _verCodeTxtField.bottom = kModifyMobileViewHeight - 5;
        [self addSubview:_verCodeTxtField];
    }
}

- (void)initWithBtnVerCode
{
    if (!_btnVerCode)
    {
        CGRect frame = CGRectMake(_verCodeTxtField.right+ 10, 0, 86, 30);
        _btnVerCode = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"获取验证码" titleColor:[UIColor colorWithHexString:@"#ff5601"] titleFont:FONTSIZE_15 targetSel:@selector(clickedButton:)];
        _btnVerCode.frame = frame;
        _btnVerCode.centerY = _iphoneTxtField.centerY;
        _btnVerCode.tag = 100;
        _btnVerCode.layer.borderColor = [UIColor colorWithHexString:@"#ff5601"].CGColor;
        _btnVerCode.layer.borderWidth = 1;
        [self addSubview:_btnVerCode];
    }
}

- (void)initWithBtnSubmit
{
    if (!_btnSubmit)
    {
        CGRect frame = CGRectMake(0, 0, self.width, 40);
        _btnSubmit = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"提交&保存" titleColor:[UIColor colorWithHexString:@"#646464"] titleFont:FONTSIZE_14 targetSel:@selector(clickedButton:)];
        _btnSubmit.frame = frame;
        _btnSubmit.tag = 101;
        _btnSubmit.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
        [self addSubview:_btnSubmit];
        _btnSubmit.bottom = self.height;
    }
}

- (void)initWithNoticeLabel
{
    if (!_noticeLabel)
    {
        CGRect frame = CGRectMake(10, _lineTwo.bottom+5, _lineTwo.width - 20, 15);
        _noticeLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#ffb6a3"] fontSize:FONTSIZE_10 labelTag:0 alignment:NSTextAlignmentLeft];
        _noticeLabel.text = @"*重新绑定后，之前绑定的手机号将不能作为登录凭证";
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
    else
    {
        if (self.viewCommonBlock)
        {
            self.viewCommonBlock(btn.titleLabel.text);
        }
    }
}

- (NSString *)getPhone
{
    return [_iphoneTxtField text];
}

- (NSString *)getCode
{
    return [_verCodeTxtField text];
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
    [self clickedButton:_btnSubmit];
    return YES;
}

- (void)updateViewData:(id)entity
{
    UserUpdateInputEntity *userEnt = entity;
    if (userEnt.smschannel == 2)
    {
        _iphoneTxtField.text = userEnt.mobile;
        [_btnSubmit setTitle:@"验证" forState:UIControlStateNormal];
        _noticeLabel.hidden = YES;
    }
    else
    {
        [_btnSubmit setTitle:@"确认" forState:UIControlStateNormal];
        _noticeLabel.hidden = NO;
    }
}




@end
