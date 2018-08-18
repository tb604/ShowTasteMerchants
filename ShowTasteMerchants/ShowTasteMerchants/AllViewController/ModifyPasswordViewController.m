//
//  ModifyPasswordViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/30.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ModifyPasswordViewController.h"
#import "LocalCommon.h"
#import "ModifyPasswordView.h"

@interface ModifyPasswordViewController ()
{
    ModifyPasswordView *_modifyPasswordView;
}

- (void)initWithModifyPasswordView;

@end

@implementation ModifyPasswordViewController

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
    
    self.title = @"修改密码";
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    
    [self initWithModifyPasswordView];
}

- (void)initWithModifyPasswordView
{
    if (!_modifyPasswordView)
    {
        CGRect frame = CGRectMake(30, 38.0, [[UIScreen mainScreen] screenWidth] - 60, kModifyPasswordViewHeight);
        _modifyPasswordView = [[ModifyPasswordView alloc] initWithFrame:frame];
        [self.view addSubview:_modifyPasswordView];
    }
    __weak typeof(self)weakSelf = self;
    _modifyPasswordView.viewCommonBlock = ^(id data)
    {
        [weakSelf updatePassword];
    };
}

- (void)updatePassword
{
    NSString *oldPsw = [_modifyPasswordView getOldPsw];
    if (!oldPsw || [oldPsw isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入旧密码！"];
        return;
    }
    NSString *newPsw = [_modifyPasswordView getNewPsw];
    
    NSString *subPsw = [_modifyPasswordView getSubPsw];
    
    if (!newPsw || [newPsw isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入新密码！"];
        return;
    }
    if (!subPsw || [subPsw isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入确认密码！"];
        return;
    }
    if (![newPsw isEqualToString:subPsw])
    {
        [SVProgressHUD showErrorWithStatus:@"新密码和确认密码不一致！"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"修改中"];
    [HCSNetHttp requestWithUserUpdateUserPassword:[UserLoginStateObject getUserId] mobile:[UserLoginStateObject getUserMobile] password:oldPsw newPassword:newPsw completion:^(id result) {
        [self responseWithUpdatePassword:result newPassword:newPsw];
    }];
}

- (void)responseWithUpdatePassword:(TYZRespondDataEntity *)respond  newPassword:(NSString *)newPassword
{
    if (respond.errcode == respond_success)
    {
        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
        if (self.popResultBlock)
        {
            self.popResultBlock(newPassword);
        }
        _userInfoEntity.password = newPassword;
        [UserLoginStateObject saveWithUserInfo:_userInfoEntity];
        [self performSelector:@selector(clickedBack:) withObject:nil afterDelay:1];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
}

@end
