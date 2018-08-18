//
//  UserRegisterViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/16.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "UserRegisterViewController.h"
#import "LocalCommon.h"
#import "UserRegisterTextFieldView.h"
#import "UserLoginStateObject.h"
#import "UserLoginViewController.h"
#import "MyInfoViewController.h"
//#import "KitchenCircleViewController.h" // 圈子视图控制器

@interface UserRegisterViewController ()
{
    UIScrollView *_contentView;
    
    UIImageView *_logoImgView;
    
    UserRegisterTextFieldView *_registerTxtView;
    
    /**
     *  注册&登录
     */
    UIButton *_btnRegisterLogin;
}

- (void)initWithContentView;

- (void)initWithLogoImgView;

- (void)initWithRegisterTxtView;

/**
 *  注册&登录
 */
- (void)initWithBtnRegisterLogin;

@end

@implementation UserRegisterViewController

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
    
    [self initWithBackButton];
    
    self.title = @"注册";
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithContentView];
    
    [self initWithLogoImgView];
    
    [self initWithRegisterTxtView];
    
    /**
     *  注册&登录
     */
    [self initWithBtnRegisterLogin];
}

- (void)clickedBack:(id)sender
{
    if ([sender isKindOfClass:[NSNumber class]])
    {
        if ([sender integerValue] == EUserLogined)
        {// 注册、登录成功
            /*MyInfoViewController *loginVC = nil;
            for (UIViewController *vc in self.navigationController.viewControllers)
            {
                if ([vc isKindOfClass:[MyInfoViewController class]])
                {
                    loginVC = (MyInfoViewController *)vc;
                }
            }
            if (loginVC)
            {
                [self.navigationController popToViewController:loginVC animated:YES];
            }*/
            
            // 获取圈子的认证信息
            [HCSNetHttp requestWithUserAuthorize:^(id result) {
                TYZRespondDataEntity *respond = result;
                if (respond.errcode == respond_success)
                {
                    // 登陆后，给圈子发送通知，更改
//                    [[NSNotificationCenter defaultCenter] postNotificationName:kKitchenCircleNote object:nil];
                }
            }];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            AppDelegate *app = [UtilityObject appDelegate];
            [app showWithUserInfoVC:NO];
            

        }
    }
    else
    {
        [super clickedBack:sender];
    }
}

- (void)initWithContentView
{
    AppDelegate *app = [UtilityObject appDelegate];
    
    CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight] - [app navBarHeight] - STATUSBAR_HEIGHT);
    _contentView = [[UIScrollView alloc] initWithFrame:frame];
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

- (void)initWithRegisterTxtView
{
    if (!_registerTxtView)
    {
        CGFloat space = 30;
        CGFloat v = 60;
        if (kiPhone5)
        {
            space = 20;
            v = 30;
        }
        else if (kiPhone4)
        {
            space = 20;
            v = 5;
        }
        CGRect frame = CGRectMake(space, _logoImgView.bottom + v, [[UIScreen mainScreen] screenWidth] - space * 2, kUserRegisterTextFieldViewHeight);
        _registerTxtView = [[UserRegisterTextFieldView alloc] initWithFrame:frame];
//        _registerTxtView.backgroundColor = [UIColor lightGrayColor];
        [_contentView addSubview:_registerTxtView];
    }
    __weak typeof(self)weakSelf = self;
    _registerTxtView.viewCommonBlock = ^(id data)
    {
        [weakSelf userRegisterTxtField:data];
    };
}

// 获取验证码(vercode)、确定(done)
- (void)userRegisterTxtField:(id)data
{
    if ([data isEqualToString:@"vercode"])
    {// 获取验证码
        [self geteUserVerCode];
    }
    else if ([data isEqualToString:@"done"])
    {// 确定
        [self clickedButton:nil];
    }
}

/**
 *  注册&登录
 */
- (void)initWithBtnRegisterLogin
{
    if (!_btnRegisterLogin)
    {
        CGFloat top = 60;
        if (kiPhone4)
        {
            top = 30;
        }
        CGRect frame = CGRectMake(_registerTxtView.left, _registerTxtView.bottom + top, _registerTxtView.width, 40);
        _btnRegisterLogin = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"注册&登录" titleColor:[UIColor whiteColor] titleFont:FONTSIZE_16 targetSel:@selector(clickedButton:)];
        _btnRegisterLogin.frame = frame;
        _btnRegisterLogin.tag = 100;
        _btnRegisterLogin.backgroundColor = [UIColor colorWithHexString:@"#ff5601"];
        [_contentView addSubview:_btnRegisterLogin];
    }
}

/**
 *  获取验证码
 */
- (void)geteUserVerCode
{
    NSString *phone = [_registerTxtView getPhone];
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
//            debugLog(@"ts=%d", (int)second);
        }
        
        [_registerTxtView updateTimeSecond:@(second)];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
}

- (void)clickedButton:(id)sender
{
    [self.view endEditing:YES];
    NSString *phone = [_registerTxtView getPhone];
    NSString *verCode = [_registerTxtView getVerCode];
    NSString *password = [_registerTxtView getPassword];
    
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
    
    if (!verCode || [verCode isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入您收到的验证码！"];
        return;
    }
    
    if (!password || [password isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入密码！"];
        return;
    }
    
    
    [SVProgressHUD showWithStatus:@"注册中"];
//    [HCSNetHttp requestWithUserRegister:phone smscode:verCode smschannel:1 password:password completion:^(id result) {
//        [self responseWithUserRegister:result];
//    }];
}

- (void)responseWithUserRegister:(TYZRespondDataEntity *)respond
{
//    debugLog(@"respond=%@", [respond modelToJSONString]);
    if (respond.errcode == respond_success)
    {
        
        [SVProgressHUD showSuccessWithStatus:@"注册成功"];
//        debugLog(@"userInfo=%@", [respond.data modelToJSONString]);
        UserInfoDataEntity *userInfo = respond.data;
        // 保存用户信息
        [UserLoginStateObject saveWithUserInfo:userInfo];
        // 保存登录状态
        [UserLoginStateObject saveLoginState:EUserLogined];
        
        [self performSelector:@selector(clickedBack:) withObject:@(EUserLogined) afterDelay:2];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
}

- (void)tapGesture:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}



@end













