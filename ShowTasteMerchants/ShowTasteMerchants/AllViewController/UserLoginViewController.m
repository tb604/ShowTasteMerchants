//
//  UserLoginViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/16.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "UserLoginViewController.h"
#import "LocalCommon.h"
#import "UserLoginTextFieldView.h" // 手机和密码输入框
#import "UserLoginStateObject.h"
//#import "KitchenCircleViewController.h"

@interface UserLoginViewController ()
{
    UIScrollView *_contentView;
    
    UIImageView *_logoImgView;
    
    UserLoginTextFieldView *_loginTextView;
    
    /**
     *  登录
     */
    UIButton *_btnLogin;
    
    /**
     *  注册
     */
    UIButton *_btnRegister;
    
    /**
     *  微信登录
     */
    UIButton *_btnWeixin;
    
    UILabel *_orLabel;
    
    /**
     *  忘记密码
     */
    UILabel *_forgotPswLabel;
}

- (void)initWithContentView;

- (void)initWithLogoImgView;

- (void)initWithLoginTextView;

- (void)initWithBtnLogin;

- (void)initWithBtnRegister;

- (void)initWithBtnWeixin;

- (void)initWithOrLabel;

/**
 *  忘记密码
 */
- (void)initWithForgotPswLabel;


- (void)tapGesture:(UITapGestureRecognizer *)tap;

/**
 *  忘记密码
 *
 *  @param tap tap
 */
- (void)tapForgotGesture:(UITapGestureRecognizer *)tap;

@end

@implementation UserLoginViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#ff5601"]] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#ff5601"]] forBarMetrics:UIBarMetricsDefault];
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)initWithVar
{
    [super initWithVar];
    
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    if (_type != 3)
    {
        [self initWithBackButton];
    }
    
    
    
    
    self.title = @"登录";
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithContentView];
    
    [self initWithLogoImgView];
    
    [self initWithLoginTextView];
    
    [self initWithForgotPswLabel];
    
    [self initWithBtnLogin];
    
    [self initWithBtnRegister];
    
//    [self initWithBtnWeixin];
    
//    [self initWithOrLabel];
}

- (void)clickedBack:(id)sender
{
//    if (_type == 3)
//    {
        AppDelegate *app = [UtilityObject appDelegate];
        [app loadRootVC];
//        return;
//    }
    /*if ([sender isKindOfClass:[NSNumber class]] && _type == 2)
    {
        // 获取圈子的认证信息
        [HCSNetHttp requestWithUserAuthorize:^(id result) {
            TYZRespondDataEntity *respond = result;
            if (respond.errcode == respond_success)
            {
                // 登陆后，给圈子发送通知，更改
//                [[NSNotificationCenter defaultCenter] postNotificationName:kKitchenCircleNote object:nil];
            }
        }];
        if (self.popResultBlock)
        {
            self.popResultBlock(sender);
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
        AppDelegate *app = [UtilityObject appDelegate];
        [app showWithUserInfoVC:NO];
    }*/
//    else
//    {
//        [super clickedBack:sender];
//    }
}

- (void)initWithContentView
{
    AppDelegate *app = [UtilityObject appDelegate];
    CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight] - app.rootViewController.appNavBarHeight - STATUSBAR_HEIGHT);
    _contentView = [[UIScrollView alloc] initWithFrame:frame];
//    _contentView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_contentView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [_contentView addGestureRecognizer:tap];
}

- (void)initWithLogoImgView
{
    if (!_logoImgView)
    {
        CGFloat top = 50;
        if (kiPhone4)
        {
            top = 10;
        }
        else if (kiPhone5)
        {
            top = 30;
        }
        UIImage *image = [UIImage imageNamed:@"login_icon_logo"];
        _logoImgView = [[UIImageView alloc] initWithImage:image];
        _logoImgView.size = image.size;
        _logoImgView.centerX = [[UIScreen mainScreen] screenWidth] / 2;
        _logoImgView.top = top;
        [_contentView addSubview:_logoImgView];
    }
}

- (void)initWithLoginTextView
{
    if (!_loginTextView)
    {
        CGFloat top = 50;
        if (kiPhone4)
        {
            top = 10;
        }
        else if (kiPhone5)
        {
            top = 30;
        }

        CGRect frame = CGRectMake(30, _logoImgView.bottom + top, [[UIScreen mainScreen] screenWidth] - 60, kUserLoginTextFieldViewHeight);
        _loginTextView = [[UserLoginTextFieldView alloc] initWithFrame:frame];
        [_contentView addSubview:_loginTextView];
    }
    __weak typeof(self)weakSelf = self;
    _loginTextView.viewCommonBlock = ^(id data)
    {
//        [weakSelf performSelector:@selector(userLogin) withObject:nil afterDelay:0.1];
         [weakSelf userLogin];
    };
}

/**
 *  忘记密码
 */
- (void)initWithForgotPswLabel
{
    if (!_forgotPswLabel)
    {
        NSString *str = @"忘记密码?";
        CGFloat width = [str widthForFont:FONTSIZE_12];
        
        NSMutableAttributedString *mas = [TYZCommonPushVC belowSingleLine:str font:FONTSIZE_12 textColor:[UIColor colorWithHexString:@"#323232"] lineColor:[UIColor colorWithHexString:@"#323232"]];
        
        CGRect frame = CGRectMake(0, _loginTextView.bottom + 2, width, 26);
        _forgotPswLabel = [TYZCreateCommonObject createWithLabel:_contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentRight];
//        _forgotPswLabel.backgroundColor = [UIColor lightGrayColor];
        _forgotPswLabel.right = _loginTextView.right;
        _forgotPswLabel.attributedText = mas;
        _forgotPswLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapForgotGesture:)];
        [_forgotPswLabel addGestureRecognizer:tap];
    }
}

- (void)initWithBtnLogin
{
    if (!_btnLogin)
    {
        CGFloat top = 40;
//        if (kiPhone4)
//        {
//            top = 20;
//        }
        CGRect frame = CGRectMake(_loginTextView.left, _loginTextView.bottom + top, _loginTextView.width, 40);
        _btnLogin = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"登录" titleColor:[UIColor whiteColor] titleFont:FONTSIZE_16 targetSel:@selector(clickedButton:)];
        _btnLogin.frame = frame;
        _btnLogin.tag = 100;
        _btnLogin.backgroundColor = [UIColor colorWithHexString:@"#ff5601"];
        [_contentView addSubview:_btnLogin];
    }
}

- (void)initWithBtnRegister
{
    if (!_btnRegister)
    {
        CGRect frame = _btnLogin.frame;
        frame.origin.y = _btnLogin.bottom + 15;
        _btnRegister = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"新用户注册" titleColor:[UIColor colorWithHexString:@"#323232"] titleFont:FONTSIZE_16 targetSel:@selector(clickedButton:)];
        _btnRegister.frame = frame;
        _btnRegister.tag = 101;
        _btnRegister.layer.borderWidth = 1;
        _btnRegister.layer.borderColor = [UIColor colorWithHexString:@"#1c1c1c"].CGColor;
        [_contentView addSubview:_btnRegister];
    }
}

- (void)initWithBtnWeixin
{
    if (!_btnWeixin)
    {
        UIImage *image = [UIImage imageNamed:@"login_btn_weixin"];
        CGRect frame = CGRectMake(0, _contentView.height - 20 - image.size.height, image.size.width, image.size.height);
        _btnWeixin = [TYZCreateCommonObject createWithButton:self imgNameNor:@"login_btn_weixin" imgNameSel:@"login_btn_weixin" targetSel:@selector(clickedButton:)];
        _btnWeixin.frame = frame;
        _btnWeixin.tag = 102;
        _btnWeixin.centerX = _contentView.width / 2;
        [_contentView addSubview:_btnWeixin];
    }
}

- (void)initWithOrLabel
{
    if (!_orLabel)
    {
        CGFloat top = 15;
        if (kiPhone4)
        {
            top = 10;
        }
        NSString *str = @"OR";
        CGFloat width = [str widthForFont:FONTSIZE_20];
        CGRect frame = CGRectMake(0, _btnWeixin.top - top - 20, width, 20);
        _orLabel = [TYZCreateCommonObject createWithLabel:_contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#333333"] fontSize:FONTSIZE_20 labelTag:0 alignment:NSTextAlignmentCenter];
        _orLabel.text = str;
        _orLabel.centerX = _btnWeixin.centerX;
        
        
        
        CALayer *leftLine = [CALayer layer];
        leftLine.size = CGSizeMake((_btnLogin.width - _orLabel.width - 20)/2, 0.8);
        leftLine.left = _btnLogin.left;
        leftLine.centerY = _orLabel.centerY;
        leftLine.backgroundColor = [UIColor colorWithHexString:@"#1b1b1b"].CGColor;
        [_contentView.layer addSublayer:leftLine];
        
        CALayer *rightLine = [CALayer layer];
        rightLine.size = CGSizeMake((_btnLogin.width - _orLabel.width - 20)/2, 0.8);
        rightLine.left = _orLabel.right + 10;
        rightLine.centerY = _orLabel.centerY;
        rightLine.backgroundColor = [UIColor colorWithHexString:@"#1b1b1b"].CGColor;
        [_contentView.layer addSublayer:rightLine];
    }
}

- (void)clickedButton:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 100)
    {// 登录
        [self userLogin];
    }
    else if (btn.tag == 101)
    {// 新用户注册
        [self userRegister];
    }
    else if (btn.tag == 102)
    {// 微信登录
        [self userWeixin];
    }
}

/**
 *  用户登录
 */
- (void)userLogin
{
    [self.view endEditing:YES];
    NSString *phone = [_loginTextView userPhone];
    if (!phone || [phone isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号码！"];
        return;
    }
    if ([phone length] != 11)
    {
        [SVProgressHUD showErrorWithStatus:@"您收入的号码位数不正确！"];
        return;
    }
    
    NSString *psw = [_loginTextView userPsw];
    if (!psw || [psw isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入密码！"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"登录中"];
    [HCSNetHttp requestWithUserLogin:phone password:psw completion:^(id result) {
        [self responseWithUserLogin:result password:psw];
    }];
}

/**
 *  用户注册
 */
- (void)userRegister
{
    [MCYPushViewController showWithUserRegisterVC:self data:nil completion:^(id data) {
        
    }];
}

/**
 *  用户微信登录
 */
- (void)userWeixin
{
    
}

- (void)tapGesture:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}


/**
 *  忘记密码
 *
 *  @param tap tap
 */
- (void)tapForgotGesture:(UITapGestureRecognizer *)tap
{
    [MCYPushViewController showWithUserForgotPswVC:self data:nil completion:nil];
}

/**
 *  登录后，返回的结果
 *
 *  @param respond  <#respond description#>
 *  @param password <#password description#>
 */
- (void)responseWithUserLogin:(TYZRespondDataEntity *)respond password:(NSString *)password
{
    if (respond.errcode == respond_success)
    {
        [SVProgressHUD showSuccessWithStatus:@"登录成功"];
        UserInfoDataEntity *userInfo = respond.data;
        userInfo.shop_state = [UserLoginStateObject getUserInfo].shop_state;
        [UserLoginStateObject saveWithUserInfo:userInfo];
        [UserLoginStateObject saveLoginState:EUserLogined];
        
        [self performSelector:@selector(clickedBack:) withObject:@(1) afterDelay:2];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
}

@end





























