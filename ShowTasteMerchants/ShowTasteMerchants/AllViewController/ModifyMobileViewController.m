//
//  ModifyMobileViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/31.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ModifyMobileViewController.h"
#import "LocalCommon.h"
#import "UserUpdateInputEntity.h"
#import "ModifyMobileView.h"
#import "UserInfoModifyViewController.h"

@interface ModifyMobileViewController ()
{
    ModifyMobileView *_modifyMobileView;
}

//@property (nonatomic, strong) UserUpdateInputEntity *inputEnt;

- (void)initWithModifyMobileView;

@end

@implementation ModifyMobileViewController

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
    
//    _inputEnt = [[UserUpdateInputEntity alloc] init];
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    if (_updateEntity.smschannel == EN_SMS_CHANNEL_TYPE_CURPHONE)
    {// 验证当前手机
        self.title = @"短信验证";
    }
    else if (_updateEntity.smschannel == EN_SMS_CHANNEL_TYPE_BINDING)
    {
        self.title = @"绑定新手机号";
    }
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithModifyMobileView];
}

- (void)clickedBack:(id)sender
{
    if ([sender isKindOfClass:[NSString class]] && [sender isEqualToString:@"success"])
    {
        UserInfoModifyViewController *retVC = nil;
        for (UIViewController *vc in self.navigationController.viewControllers)
        {
            if ([vc isKindOfClass:[UserInfoModifyViewController class]])
            {
                retVC = (UserInfoModifyViewController *)vc;
            }
        }
        if (retVC)
        {
            [self.navigationController popToViewController:retVC animated:YES];
        }
    }
    else
    {
        [super clickedBack:sender];
    }
}

- (void)initWithModifyMobileView
{
    if (!_modifyMobileView)
    {
        CGFloat space = 30;
        CGFloat v = 75;
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

        CGRect frame = CGRectMake(space, v, [[UIScreen mainScreen] screenWidth] - space * 2, kModifyMobileViewAllHeight);
        _modifyMobileView = [[ModifyMobileView alloc] initWithFrame:frame];
        [self.view addSubview:_modifyMobileView];
    }
    [_modifyMobileView updateViewData:_updateEntity];
    __weak typeof(self)weakSelf = self;
    _modifyMobileView.viewCommonBlock = ^(id data)
    {
        [weakSelf userModifyMobileTxtField:data];
    };
}

// 获取验证码(vercode)、验证、确认
- (void)userModifyMobileTxtField:(id)data
{
    if ([data isEqualToString:@"vercode"])
    {// 获取验证码
        [self geteUserVerCode];
    }
    else if ([data isEqualToString:@"验证"])
    {// 验证旧的手机号是否正确
        [self validateOldPhone];
    }
    else if ([data isEqualToString:@"确认"])
    {// 确认新的手机号绑定。
        [self bindingPhone];
    }
}

/**
 *  获取验证码
 */
- (void)geteUserVerCode
{
    NSString *phone = [_modifyMobileView getPhone];
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
    else if (![_updateEntity.mobile isEqualToString:phone] && _updateEntity.smschannel == EN_SMS_CHANNEL_TYPE_CURPHONE)
    {
        [SVProgressHUD showErrorWithStatus:@"手机号码不一直！"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"获取验证码"];
    [HCSNetHttp requestWithSmsSendCode:phone smschannel:_updateEntity.smschannel completion:^(id result) {
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
        
        [_modifyMobileView updateTimeSecond:@(second)];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
}

/**
 *  验证旧的手机号码是否正确
 */
- (void)validateOldPhone
{
    NSString *phone = [_modifyMobileView getPhone];
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
    else if (![_updateEntity.mobile isEqualToString:phone])
    {
        [SVProgressHUD showErrorWithStatus:@"手机号码不一直！"];
        return;
    }
    
    NSString *code = [_modifyMobileView getCode];
    if (!code || [code isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入您收到的验证码！"];
        return;
    }
//    _updateEntity.mobile = phone;
    _updateEntity.smscode = code;
    [SVProgressHUD showWithStatus:@"旧手机验证中"];
    [HCSNetHttp requestWithSmsVerifyCode:phone smscode:code smschannel:EN_SMS_CHANNEL_TYPE_CURPHONE completion:^(id result) {
        [self responseWithPhoneAvlidate:result code:code];
    }];
}

- (void)responseWithPhoneAvlidate:(TYZRespondDataEntity *)respond code:(NSString *)code
{
    if (respond.errcode == respond_success)
    {
        [SVProgressHUD dismiss];
        
        NSDictionary *dict = respond.data;
        // "uuid": "46CF2AB4-6738-B379-1A8A-82497085BD5F"
        _updateEntity.uuid = dict[@"uuid"];
        _updateEntity.smschannel = EN_SMS_CHANNEL_TYPE_BINDING;
        [self.view endEditing:YES];
        [MCYPushViewController showWithModifyMobileVC:self data:_updateEntity completion:^(id data) {
            
        }];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
}

/**
 *  绑定新手机号码
 */
- (void)bindingPhone
{
    NSString *phone = [_modifyMobileView getPhone];
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
    
    NSString *code = [_modifyMobileView getCode];
    if (!code || [code isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入您收到的验证码！"];
        return;
    }
    _updateEntity.newmobile =  phone;
    _updateEntity.newsmscode = code;
    
    [SVProgressHUD showWithStatus:@"绑定中"];
    // 提交到服务端(绑定手机号码)
    [HCSNetHttp requestWithSmsBindNewMobile:_updateEntity completion:^(id result) {
        [self responseWithBindMobile:result phone:phone];
    }];
}
// 绑定手机，返回结果
- (void)responseWithBindMobile:(TYZRespondDataEntity *)respond phone:(NSString *)phone
{
    if (respond.errcode == respond_success)
    {
        [SVProgressHUD showSuccessWithStatus:@"绑定成功"];
        [UserLoginStateObject saveWithPhone:phone];
        [self performSelector:@selector(clickedBack:) withObject:@"success" afterDelay:2];
    }
    else
    {
        [UtilityObject svProgressHUDError: respond viewContrller:self];
    }
}

@end










