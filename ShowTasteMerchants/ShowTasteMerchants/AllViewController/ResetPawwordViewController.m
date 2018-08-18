//
//  ResetPawwordViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/26.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ResetPawwordViewController.h"
#import "LocalCommon.h"
#import "ResetPawwordView.h"
//#import "UserLoginViewController.h" // 登陆
#import "CTCLoginViewController.h"

@interface ResetPawwordViewController ()
{
    ResetPawwordView *_resetPswView;
    
    UIButton *_btnSubmit;
}

@property (nonatomic, strong) UserUpdateInputEntity *inputEntity;

- (void)initWithResetPswView;

- (void)initWithBtnSubmit;

@end

@implementation ResetPawwordViewController

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
    
    
    /*
     NSDictionary *param = @{@"phone":phone, @"code":code, @"uuid":uuid};
     */
    _inputEntity = [UserUpdateInputEntity new];
    _inputEntity.userId = [UserLoginStateObject getUserId];
    _inputEntity.uuid = _pswCodeDict[@"uuid"];
    _inputEntity.mobile = _pswCodeDict[@"phone"];
    _inputEntity.smscode = _pswCodeDict[@"code"];
    _inputEntity.smschannel = 4;
    
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = @"重置密码";
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initWithResetPswView];
    
    [self initWithBtnSubmit];
}

- (void)initWithResetPswView
{
    if (!_resetPswView)
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
        CGRect frame = CGRectMake(space,70, [[UIScreen mainScreen] screenWidth] - space * 2, kResetPawwordViewHeight);
        _resetPswView = [[ResetPawwordView alloc] initWithFrame:frame];
        [self.view addSubview:_resetPswView];
    }
    
    __weak typeof(self)weakSelf = self;
    _resetPswView.viewCommonBlock = ^(id data)
    {
//        [weakSelf forgotPasswordTxtField:data];
        [weakSelf clickedButton:nil];
    };

}

- (void)initWithBtnSubmit
{
    if (!_btnSubmit)
    {
        CGFloat top = 112;
        CGRect frame = CGRectMake(_resetPswView.left, _resetPswView.bottom + top, _resetPswView.width, 40);
        _btnSubmit = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"提交&保存" titleColor:[UIColor whiteColor] titleFont:FONTSIZE_16 targetSel:@selector(clickedButton:)];
        _btnSubmit.frame = frame;
//        _btnSubmit.tag = 100;
        _btnSubmit.backgroundColor = [UIColor colorWithHexString:@"#ff5601"];
        [self.view addSubview:_btnSubmit];
    }
}

- (void)clickedButton:(id)sender
{
//    debugMethod();
    
    _inputEntity.password = [_resetPswView getWithPassword];
    if ([_inputEntity.password isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入新密码！"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"重置中"];
    [HCSNetHttp requestWithSmsFindPassword:_inputEntity completion:^(id result) {
        [self responseWithSmsFindPassword:result];
    }];
}

- (void)responseWithSmsFindPassword:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success)
    {
        [SVProgressHUD dismiss];
        CTCLoginViewController *loginVC = nil;
        NSArray *array = self.navigationController.viewControllers;
        for (id vc in array)
        {
            if ([vc isKindOfClass:[CTCLoginViewController class]])
            {
                loginVC = vc;
                break;
            }
        }
        if (loginVC)
        {
            [self.navigationController popToViewController:loginVC animated:YES];
        }
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
}


@end
