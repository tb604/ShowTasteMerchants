//
//  UserForgotPasswordViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/26.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "UserForgotPasswordViewController.h"
#import "LocalCommon.h"
#import "UserForgotPasswordView.h" // 输入框

@interface UserForgotPasswordViewController ()
{
    UserForgotPasswordView *_forgotPswView;
    
    UIButton *_btnVerCode;
}

- (void)initWithForgotPswView;

- (void)initWithBtnVerCode;

@end

@implementation UserForgotPasswordViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
    
    [self initWithBackButton];
    
    self.title = @"找回密码";
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initWithForgotPswView];
 
    [self initWithBtnVerCode];
}

- (void)initWithForgotPswView
{
    if (!_forgotPswView)
    {
        CGFloat space = 30;
        if (kiPhone5)
        {
            space = 20;
        }
        else if (kiPhone4)
        {
            space = 20;
        }
        CGRect frame = CGRectMake(space,72, [[UIScreen mainScreen] screenWidth] - space * 2, kUserForgotPasswordViewHeight);
        _forgotPswView = [[UserForgotPasswordView alloc] initWithFrame:frame];
        [self.view addSubview:_forgotPswView];
    }
    
    __weak typeof(self)weakSelf = self;
    _forgotPswView.viewCommonBlock = ^(id data)
    {
        [weakSelf forgotPasswordTxtField:data];
    };
}

- (void)initWithBtnVerCode
{
    if (!_btnVerCode)
    {
        CGFloat top = 65;
        CGRect frame = CGRectMake(_forgotPswView.left, _forgotPswView.bottom + top, _forgotPswView.width, 40);
        _btnVerCode = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"验证" titleColor:[UIColor whiteColor] titleFont:FONTSIZE_16 targetSel:@selector(clickedButton:)];
        _btnVerCode.frame = frame;
        _btnVerCode.tag = 100;
        _btnVerCode.backgroundColor = [UIColor colorWithHexString:@"#ff5500"];
        [self.view addSubview:_btnVerCode];
    }
}

- (void)forgotPasswordTxtField:(id)data
{
    if ([data isEqualToString:@"vercode"])
    {// 获取验证码
        [self getUserVerCode];
    }
    else if ([data isEqualToString:@"done"])
    {// 确定
        [self clickedButton:nil];
    }
}

// 获取验证码
- (void)getUserVerCode
{
    NSString *phone = [_forgotPswView getPhone];
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
    [HCSNetHttp requestWithSmsSendCode:phone smschannel:EN_SMS_CHANNEL_TYPE_FORGOT completion:^(id result) {
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
//            debugLog(@"ts=%d", (int)second);
        }
        
        [_forgotPswView updateTimeSecond:@(second)];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
}


- (void)clickedButton:(id)sender
{
    debugMethod();
    // showWithResetPasswordVC
    
    NSString *phone = [_forgotPswView getPhone];
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
    NSString *code = [_forgotPswView getVerCode];
    if (!code || [code isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"您收入的号码位数不正确！"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"验证中"];
    [HCSNetHttp requestWithSmsVerifyCode:phone smscode:code smschannel:EN_SMS_CHANNEL_TYPE_FORGOT completion:^(id result) {
        [self responseWithSmsVerifyCode:result];
    }];
}

- (void)responseWithSmsVerifyCode:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success)
    {
        if ([respond.data isKindOfClass:[NSDictionary class]])
        {
            [SVProgressHUD dismiss];
            NSDictionary *dict = respond.data;
            NSString *uuid = dict[@"uuid"];
            NSString *phone = [_forgotPswView getPhone];
            NSString *code = [_forgotPswView getVerCode];
            NSDictionary *param = @{@"phone":phone, @"code":code, @"uuid":uuid};
            debugLog(@"param===%@", param);
            
            [MCYPushViewController showWithResetPasswordVC:self data:param completion:^(id data) {
                
            }];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"信息有问题。"];
        }
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
}

@end














