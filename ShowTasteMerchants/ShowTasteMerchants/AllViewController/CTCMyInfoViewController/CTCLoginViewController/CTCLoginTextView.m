/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCLoginTextView.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/19 09:59
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCLoginTextView.h"
#import "LocalCommon.h"

@interface CTCLoginTextView () <UITextFieldDelegate>
{
    UIImageView *_iconImgView;
    
    /// 显示密码按钮
    UIButton *_btnShowPwd;
    
    /// 验证码按钮
    UIButton *_btnVerCode;
    
}

@property (nonatomic, assign) NSInteger timeSecond;

- (void)initWithIconImgView;

- (void)initWithBtnShowPwd;

- (void)initWithTxtField;

/**
 *  初始化验证码
 */
- (void)initWithBtnVerCode;

@end

@implementation CTCLoginTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code
}
*/



- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [CALayer drawLine:self frame:CGRectMake(0, kCTCLoginTextViewHeight - 0.5, self.width, 0.5) lineColor:[UIColor colorWithHexString:@"#323232"]];
    
    [self initWithIconImgView];
    
    [self initWithBtnShowPwd];
    
    [self initWithTxtField];
}

- (void)initWithIconImgView
{
    if (!_iconImgView)
    {
        UIImage *image = [UIImage imageWithContentsOfFileName:@"login_icon_shop.png"];
        CGRect frame = CGRectMake(0, (kCTCLoginTextViewHeight-image.size.height)/2. + 4, image.size.width, image.size.height);
        _iconImgView = [[UIImageView alloc] initWithFrame:frame];
        _iconImgView.image = image;
        [self addSubview:_iconImgView];
    }
}

- (void)initWithBtnShowPwd
{
    if (!_btnShowPwd)
    {
        UIImage *psdImg = [UIImage imageWithContentsOfFileName:@"login_btn_invisible.png"];
        CGRect frame = CGRectMake(self.width - 30, 0, 30, 30);
        _btnShowPwd = [TYZCreateCommonObject createWithButton:self imgNameNor:@"" imgNameSel:@"" targetSel:@selector(clickedWithShowPwd:)];
        _btnShowPwd.frame = frame;
        [_btnShowPwd setImage:psdImg forState:UIControlStateNormal];
        _btnShowPwd.centerY = _iconImgView.centerY;
        [self addSubview:_btnShowPwd];
    }
}

- (void)initWithTxtField
{
    if (!_txtField)
    {
        CGRect frame = CGRectMake(_iconImgView.right + 10, 0, _btnShowPwd.left - _iconImgView.right - 10 - 10, 30);
        _txtField = [[UITextField alloc] initWithFrame:frame];
        _txtField.font = FONTSIZE_15;
        
        _txtField.textColor = [UIColor colorWithHexString:@"#323232"];
//        _txtField.keyboardType = UIKeyboardTypeDecimalPad;
//        _txtField.returnKeyType = UIReturnKeyDone;
        _txtField.borderStyle = UITextBorderStyleNone;
        _txtField.textAlignment = NSTextAlignmentLeft;
        _txtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _txtField.bottom = _iconImgView.bottom;
        [self addSubview:_txtField];
    }
}

/**
 *  初始化验证码
 */
- (void)initWithBtnVerCode
{
    if (!_btnVerCode)
    {
        CGRect frame = CGRectMake(self.width - 75, 0, 75, 30);
        
        _btnVerCode = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"获取验证码" titleColor:[UIColor colorWithHexString:@"#ff5500"] titleFont:FONTSIZE_12 targetSel:@selector(clickedVerCode:)];
        _btnVerCode.frame = frame;
        _btnVerCode.layer.borderColor = [UIColor colorWithHexString:@"#ff5500"].CGColor;
        _btnVerCode.layer.borderWidth = 1;
        _btnVerCode.layer.masksToBounds = YES;
        _btnVerCode.layer.cornerRadius = 3;
        _btnVerCode.hidden = YES;
        _btnVerCode.bottom = _iconImgView.bottom;
        [self addSubview:_btnVerCode];
    }
}

/// 获取验证码
- (void)clickedVerCode:(id)sender
{
    if (_touchWithVerCodeBlock)
    {
        _touchWithVerCodeBlock(nil);
    }
}

- (void)clickedWithShowPwd:(id)sender
{
    _txtField.secureTextEntry = !_txtField.secureTextEntry;
}

- (void)updateWithIconImg:(UIImage *)iconImage placeholder:(NSString *)placeholder pwdRightImg:(UIImage *)pwdRightImg isVerCode:(BOOL)isVerCode
{
    _iconImgView.image = iconImage;
    _btnShowPwd.hidden = YES;
    if (pwdRightImg)
    {
        _btnShowPwd.hidden = NO;
    }
    
    _btnVerCode.hidden = YES;
    if (isVerCode)
    {
        // 初始化验证码
        [self initWithBtnVerCode];
        _btnVerCode.hidden = NO;
        
        CGRect frame = CGRectMake(_iconImgView.right + 10, 0, _btnVerCode.left - _iconImgView.right - 10 - 10, 30);
        _txtField.frame = frame;
        _txtField.bottom = _iconImgView.bottom;
    }
    
    UIColor *color = [UIColor colorWithHexString:@"#cccccc"];
    NSAttributedString *placeHolder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
//    _txtField.placeholder = placeholder;
    _txtField.attributedPlaceholder = placeHolder;
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

@end









