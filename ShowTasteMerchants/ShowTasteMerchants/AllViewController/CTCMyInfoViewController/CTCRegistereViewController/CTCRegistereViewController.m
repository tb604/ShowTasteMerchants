/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCRegistereViewController.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/19 13:59
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCRegistereViewController.h"
#import "LocalCommon.h"
#import "CTCLoginTextView.h"

@interface CTCRegistereViewController () <UITextFieldDelegate>
{
    UIScrollView *_contentView;
    
    UIImageView *_topView;
    
    /// 查看协议
    UILabel *_checkAgreeLabel;
    
    /// 登录按钮
    UIButton *_btnLogin;
    
    /// 返回登录
    UILabel *_comeLoginLabel;
}

/// 手机号码
@property (nonatomic, strong) CTCLoginTextView *phoneCodeView;

/// 密码
@property (nonatomic, strong) CTCLoginTextView *passwordView;

/// 验证码
@property (nonatomic, strong) CTCLoginTextView *verCodeView;

- (void)initWithContentView;

- (void)initWithTopView;

/**
 *  初始化查看协议
 */
- (void)initWithCheckAgreeLabel;

/**
 *  初始化登录按钮
 */
- (void)initWithBtnLogin;

/**
 *  初始化进入登录
 */
- (void)initWithComeLoginLabel;

/**
 *  初始化手机号码
 */
- (void)initWithPhoneCodeView;

/**
 *  初始化密码
 */
- (void)initWithPasswordView;

/**
 *  初始化验证码
 */
- (void)initWithVerCodeView;

@end

@implementation CTCRegistereViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender 
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -
#pragma mark override

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithContentView];
    
    [self initWithTopView];
    
    // 初始化查看协议
    [self initWithCheckAgreeLabel];
    
    // 初始化登录按钮
    [self initWithBtnLogin];
    
    // 初始化进入登录
    [self initWithComeLoginLabel];
    
    // 初始化手机号码
    [self initWithPhoneCodeView];
    
    // 初始化密码
    [self initWithPasswordView];
    
    // 初始化验证码
    [self initWithVerCodeView];
}

- (void)clickedBack:(id)sender
{
    AppDelegate *app = [UtilityObject appDelegate];
    [app loadRootVC];
}

- (void)initWithContentView
{
    if (!_contentView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight]);
        _contentView = [[UIScrollView alloc] initWithFrame:frame];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_contentView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        [_contentView addGestureRecognizer:tap];
        
    }
}

- (void)initWithTopView
{
    if (!_topView)
    {
        NSInteger height = [[UIScreen mainScreen] screenWidth] / 1.5;
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], height);
        UIImage *image = [UIImage imageWithContentsOfFileName:@"login_top_bg.png"];
        _topView = [[UIImageView alloc] initWithFrame:frame];
        _topView.image = image;
        [_contentView addSubview:_topView];
        // login_top_bg
        
        image = [UIImage imageWithContentsOfFileName:@"login_icon_logo.png"];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
        [_topView addSubview:imgView];
        imgView.centerX = _topView.width / 2.;
        imgView.centerY = _topView.height / 2.;
        
    }
}

/**
 *  初始化查看协议
 */
- (void)initWithCheckAgreeLabel
{
    if (!_checkAgreeLabel)
    {
        NSInteger bottomSpace = 30;
        if (kiPhone4)
        {
            bottomSpace = 20;
        }
        NSString *str = @"* 注册则已同意协议《秀味协议》";
        float width = [str widthForFont:FONTSIZE_12];
        CGRect frame = CGRectMake(([[UIScreen mainScreen] screenWidth] - width)/2., [[UIScreen mainScreen] screenHeight] - (bottomSpace + 15), width, 15);
        _checkAgreeLabel = [TYZCreateCommonObject createWithLabel:_contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentCenter];
        NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] init];
        UIColor *color = [UIColor colorWithHexString:@"#646464"];
        NSAttributedString *bTitle = [[NSAttributedString alloc] initWithString:@"* 注册则已同意协议" attributes:@{NSFontAttributeName: FONTSIZE(12), NSForegroundColorAttributeName: color}];
        [mas appendAttributedString:bTitle];
        
        [UIColor colorWithHexString:@"#323232"];
        bTitle = [[NSAttributedString alloc] initWithString:@"《秀味协议》" attributes:@{NSFontAttributeName: FONTSIZE(12), NSForegroundColorAttributeName: color}];
        [mas appendAttributedString:bTitle];
        _checkAgreeLabel.attributedText = mas;
        _checkAgreeLabel.userInteractionEnabled = YES;
        __weak typeof(self)weakSelf = self;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
            debugLog(@"看协议");
        }];
        [_checkAgreeLabel addGestureRecognizer:tap];
    }
}

/**
 *  初始化登录按钮
 */
- (void)initWithBtnLogin
{
    if (!_btnLogin)
    {
        NSInteger width = [[UIScreen mainScreen] screenWidth] / 1.25;
        float height = 40.;
        NSInteger bottomSpace = [[UIScreen mainScreen] screenWidth] / 2.67857143;
        if (kiPhone4)
        {
            bottomSpace = bottomSpace - 30;
        }
        CGRect frame = CGRectMake(([[UIScreen mainScreen] screenWidth] - width)/2., _contentView.height - bottomSpace - height, width, height);
        
        _btnLogin = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"注册" titleColor:[UIColor whiteColor] titleFont:FONTSIZE_16 targetSel:@selector(clickedWithButton:)];
//        _btnLogin.tag = EN_LOGIN_VC_BTN_LOGIN_TAG;
        _btnLogin.frame = frame;
        _btnLogin.backgroundColor = [UIColor colorWithHexString:@"#ff5500"];
        _btnLogin.layer.masksToBounds = YES;
        _btnLogin.layer.cornerRadius = height / 2.;
        [_contentView addSubview:_btnLogin];
    }
}

/**
 *  初始化进入登录
 */
- (void)initWithComeLoginLabel
{
    if (!_comeLoginLabel)
    {
        NSString *str = @"已有账号，去登录";
        float width = [str widthForFont:FONTBOLDSIZE(13)];
        float space = 15;
        if (kiPhone4)
        {
            space = 8;
        }
        CGRect frame = CGRectMake(0, _btnLogin.bottom + space, width, 30);
        _comeLoginLabel = [TYZCreateCommonObject createWithLabel:_contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentCenter];
        _comeLoginLabel.centerX = [[UIScreen mainScreen] screenWidth] / 2.;
        NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] init];
        UIColor *color = [UIColor colorWithHexString:@"#646464"];
        NSAttributedString *bTitle = [[NSAttributedString alloc] initWithString:@"已有账号，去" attributes:@{NSFontAttributeName: FONTSIZE(13), NSForegroundColorAttributeName: color}];
        [mas appendAttributedString:bTitle];
        
        [UIColor colorWithHexString:@"#323232"];
        bTitle = [[NSAttributedString alloc] initWithString:@"登录" attributes:@{NSFontAttributeName: FONTBOLDSIZE(13), NSForegroundColorAttributeName: color}];
        [mas appendAttributedString:bTitle];
        _comeLoginLabel.attributedText = mas;
        _comeLoginLabel.userInteractionEnabled = YES;
        __weak typeof(self)weakSelf = self;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
            debugLog(@"去登录");
            [weakSelf clickedBack:nil];
        }];
        [_comeLoginLabel addGestureRecognizer:tap];
    }
}

/**
 *  初始化手机号码
 */
- (void)initWithPhoneCodeView
{
    if (!_phoneCodeView)
    {
        NSInteger width = [[UIScreen mainScreen] screenWidth] / 1.25;
        NSInteger space = [[UIScreen mainScreen] screenWidth] / 10.714285;
        if (kiPhone4)
        {
            space = 10;
        }
        CGRect frame = CGRectMake(([[UIScreen mainScreen] screenWidth] - width)/2., _topView.bottom + space, width, kCTCLoginTextViewHeight);
        
        _phoneCodeView = [[CTCLoginTextView alloc] initWithFrame:frame];
        [_contentView addSubview:_phoneCodeView];
        UIImage *image = [UIImage imageWithContentsOfFileName:@"login_icon_phone.png"];
        [_phoneCodeView updateWithIconImg:image placeholder:@"请输入您的手机号" pwdRightImg:nil isVerCode:NO];
        
        _phoneCodeView.txtField.delegate = self;
        _phoneCodeView.txtField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _phoneCodeView.txtField.returnKeyType = UIReturnKeyNext;
    }
}

/**
 *  初始化密码
 */
- (void)initWithPasswordView
{
    
    if (!_passwordView)
    {
        CGRect frame = _phoneCodeView.frame;
        frame.origin.y = frame.origin.y + frame.size.height;
        _passwordView = [[CTCLoginTextView alloc] initWithFrame:frame];
        [_contentView addSubview:_passwordView];
        
        UIImage *image = [UIImage imageWithContentsOfFileName:@"login_icon_password.png"];
        UIImage *psdImg = [UIImage imageWithContentsOfFileName:@"login_btn_invisible.png"];
        [_passwordView updateWithIconImg:image placeholder:@"请输入您的密码" pwdRightImg:psdImg isVerCode:NO];
        
        _passwordView.txtField.delegate = self;
        _passwordView.txtField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _passwordView.txtField.returnKeyType = UIReturnKeyNext;
        _passwordView.txtField.secureTextEntry = YES;
    }
}

/**
 *  初始化验证码
 */
- (void)initWithVerCodeView
{
    if (!_verCodeView)
    {
        CGRect frame = _passwordView.frame;
        frame.origin.y = frame.origin.y + frame.size.height;
        _verCodeView = [[CTCLoginTextView alloc] initWithFrame:frame];
        [_contentView addSubview:_verCodeView];
        
        UIImage *image = [UIImage imageWithContentsOfFileName:@"login_icon_verification-code.png"];
        [_verCodeView updateWithIconImg:image placeholder:@"请输入短信验证码" pwdRightImg:nil isVerCode:YES];
        
        _verCodeView.txtField.delegate = self;
        _verCodeView.txtField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _verCodeView.txtField.returnKeyType = UIReturnKeyDone;
    }
    __weak typeof(self)weakSelf = self;
    _verCodeView.touchWithVerCodeBlock = ^(id data)
    {// 获取验证码
        [weakSelf geteUserVerCode];
    };
}



#pragma mark -
#pragma mark private 

/**
 *  获取验证码
 */
- (void)geteUserVerCode
{
    NSString *phone = objectNull(_phoneCodeView.txtField.text);
    if (!phone || [phone isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号码！"];
        return;
    }
    if ([phone length] != 11)
    {
        [SVProgressHUD showErrorWithStatus:@"您输入的号码位数不正确！"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"获取验证码"];
    [HCSNetHttp requestWithSmsSendCode:phone smschannel:EN_SMS_CHANNEL_TYPE_REGISTER completion:^(id result) {
        [self responseWithSmsSendCode:result];
    }];
}

- (void)responseWithSmsSendCode:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success)
    {
        [SVProgressHUD dismiss];
        
        NSInteger second = 90;
        if ([respond.data isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dict = respond.data;
            second = [dict[@"ts"] integerValue];
            debugLog(@"ts=%d", (int)second);
        }
        
        [self.verCodeView updateTimeSecond:@(second)];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
}

- (void)tapGesture:(UITapGestureRecognizer *)tap
{
    _contentView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view endEditing:YES];
}

// 注册
- (void)clickedWithButton:(id)sender
{
    // 手机号码
    NSString *phone = objectNull(_phoneCodeView.txtField.text);
    if ([phone isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号码"];
        return;
    }
    
    // 密码
    NSString *password = objectNull(_passwordView.txtField.text);
    if ([password isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    
    // 验证码
    NSString *code = objectNull(_verCodeView.txtField.text);
    if ([code isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入您收到的验证码"];
        return;
    }
    
    
    [SVProgressHUD showWithStatus:@"注册中"];
    [HCSNetHttp requestWithUserRegister:phone smscode:[code integerValue] password:password completion:^(TYZRespondDataEntity *respond) {
        if (respond.errcode == respond_success)
        {
            [SVProgressHUD showSuccessWithStatus:@"注册成功"];
            //        debugLog(@"userInfo=%@", [respond.data modelToJSONString]);
            UserInfoDataEntity *userInfo = respond.data;
            // 保存用户信息
            [UserLoginStateObject saveWithUserInfo:userInfo];
            // 保存登录状态
            [UserLoginStateObject saveLoginState:EUserLogined];
            
            // 绑定身份
            [MCYPushViewController showWithBindCardIdVC:self data:nil completion:^(id data) {
                [self performSelector:@selector(clickedBack:) withObject:@(EUserLogined) afterDelay:2];
            }];
            
        }
        else
        {
            [UtilityObject svProgressHUDError:respond viewContrller:self];
        }
    }];
    
    return;
    
}


#pragma mark -
#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([_phoneCodeView.txtField isEqual:textField])
    {
        debugLog(@"手机号");
        if (kiPhone4)
        {
            _contentView.contentInset = UIEdgeInsetsMake(-120, 0, 0, 0);
        }
    }
    else if ([_passwordView.txtField isEqual:textField])
    {
        debugLog(@"密码");
        if (kiPhone5)
        {
            _contentView.contentInset = UIEdgeInsetsMake(-90, 0, 0, 0);
        }
        else if (kiPhone4)
        {
            _contentView.contentInset = UIEdgeInsetsMake(-120, 0, 0, 0);
        }
    }
    else if ([_verCodeView.txtField isEqual:textField])
    {
        debugLog(@"验证码");
        if (kiPhone5)
        {
            _contentView.contentInset = UIEdgeInsetsMake(-90, 0, 0, 0);
        }
        else if (kiPhone4)
        {
            _contentView.contentInset = UIEdgeInsetsMake(-120, 0, 0, 0);
        }
        else if (kiPhone6)
        {
            _contentView.contentInset = UIEdgeInsetsMake(-60, 0, 0, 0);
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([_phoneCodeView.txtField isEqual:textField])
    {
        debugLog(@"re手机号");
        [_passwordView.txtField becomeFirstResponder];
    }
    else if ([_passwordView.txtField isEqual:textField])
    {
        debugLog(@"re密码");
        [_verCodeView.txtField becomeFirstResponder];
    }
    else if ([_verCodeView.txtField isEqual:textField])
    {
        debugLog(@"re验证码");
        [self tapGesture:nil];
        _contentView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return YES;
}

@end















