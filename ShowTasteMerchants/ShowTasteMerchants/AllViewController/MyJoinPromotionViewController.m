//
//  MyJoinPromotionViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/25.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyJoinPromotionViewController.h"
#import "LocalCommon.h"
#import "MyJoinPromotionTopView.h"
#import "UserLoginStateObject.h"

@interface MyJoinPromotionViewController () <UITextFieldDelegate>
{
    UIScrollView *_contentView;
    
    MyJoinPromotionTopView *_topView;
    
    UITextField *_codeTxtField;
    
    
    UIButton *_btnSubmit;
    
    /**
     *  是否加入成功；1表示加入成功
     */
    NSInteger _joinSuc;
}

@property (nonatomic, strong) UIView *codeBgView;

- (void)initWithContentView;

- (void)initWithTopView;

- (void)initWithCodeTxtField;

- (void)initWithBtnSubmit;

@end

@implementation MyJoinPromotionViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    self.navigationController.navigationBarHidden = NO;
    
    
}


- (void)initWithVar
{
    [super initWithVar];
    
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    if (_promotionType == 1)
    {
        self.title = @"加入推广";
    }
    else if (_promotionType == 2)
    {
        self.title = @"邀请好友";
    }
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithContentView];
    
    [self initWithTopView];
    
    [self initWithCodeTxtField];
    
    [self initWithBtnSubmit];
}

- (void)clickedBack:(id)sender
{
    if (_joinSuc == 1)
    {
        if (self.popResultBlock)
        {
            self.popResultBlock(@(_joinSuc));
        }
    }
    [super clickedBack:sender];
}

- (void)initWithContentView
{
    if (!_contentView)
    {
        AppDelegate *app = [UtilityObject appDelegate];
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight] - [app navBarHeight] - STATUSBAR_HEIGHT);
        _contentView = [[UIScrollView alloc] initWithFrame:frame];
//        _contentView.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:_contentView];
    }
}

- (void)initWithTopView
{
    if (!_topView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [MyJoinPromotionTopView getWithHeight]);
        _topView = [[MyJoinPromotionTopView alloc] initWithFrame:frame];
        [_contentView addSubview:_topView];
    }
    [_topView updateViewData:@(_promotionType)];
}

- (void)initWithCodeTxtField
{
    if (!_codeTxtField)
    {
        CGFloat space = 50;
        if (kiPhone4)
        {
            space = 30;
        }
        CGRect frame = CGRectMake(15, _topView.bottom + space, [[UIScreen mainScreen] screenWidth] - 30, 40);
        UIView *view = [[UIView alloc] initWithFrame:frame];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 4;
        view.layer.borderColor = [UIColor colorWithHexString:@"#cccccc"].CGColor;
        view.layer.borderWidth = 1;
        [_contentView addSubview:view];
        
        
        frame = CGRectMake(15, 5, view.width - 30, 30);
        _codeTxtField = [[UITextField alloc] initWithFrame:frame];
        _codeTxtField.font = FONTSIZE_15;
        _codeTxtField.delegate = self;
        _codeTxtField.textColor = [UIColor colorWithHexString:@"#323232"];
        
        _codeTxtField.keyboardType = UIKeyboardTypeDefault;
        _codeTxtField.returnKeyType = UIReturnKeyDone;
        _codeTxtField.borderStyle = UITextBorderStyleNone;
        _codeTxtField.textAlignment = NSTextAlignmentCenter;
        _codeTxtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _codeTxtField.placeholder = @"请输入邀请码";
        _codeTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [view addSubview:_codeTxtField];
        self.codeBgView = view;
    }
    
    if (_promotionType == 2)
    {// 邀请好友
        UserInfoDataEntity *userInfo = [UserLoginStateObject getUserInfo];
        _codeTxtField.text = userInfo.invite_code;
    }
    
}

- (void)initWithBtnSubmit
{
    if (!_btnSubmit)
    {
        CGRect frame = CGRectMake(0, _codeBgView.bottom + 30, 200, 40);
        _btnSubmit = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"分享" titleColor:[UIColor whiteColor] titleFont:FONTSIZE_16 targetSel:@selector(clickedWithSubmit:)];
        _btnSubmit.frame = frame;
        _btnSubmit.backgroundColor = [UIColor colorWithHexString:@"#ff5500"];
        _btnSubmit.layer.cornerRadius = 4;
        _btnSubmit.layer.masksToBounds = YES;
        _btnSubmit.centerX = _contentView.width / 2;
        [_contentView addSubview:_btnSubmit];
    }
    
    if (_promotionType == 1)
    {
        [_btnSubmit setTitle:@"绑定" forState:UIControlStateNormal];
    }
    else if (_promotionType == 2)
    {
        [_btnSubmit setTitle:@"分享" forState:UIControlStateNormal];
    }
}

- (void)clickedWithSubmit:(id)sender
{
    // 57be9b53
    
    NSString *code = objectNull(_codeTxtField.text);
    if ([code length] < 8)
    {
        [SVProgressHUD showErrorWithStatus:@"您输入的邀请码有误！"];
        return;
    }
    
    if (_promotionType == 1)
    {// 加入推广
        [SVProgressHUD showWithStatus:@"加入中"];
        UserInfoDataEntity *userInfo = [UserLoginStateObject getUserInfo];
        [HCSNetHttp requestWithUserSetInviteCode:userInfo.user_id inviteCode:code completion:^(id result) {
            TYZRespondDataEntity *respond = result;
            if (respond.errcode == respond_success)
            {
                [SVProgressHUD showSuccessWithStatus:@"加入成功"];
                userInfo.invite_code = respond.data;
                [UserLoginStateObject saveWithUserInfo:userInfo];
                _joinSuc = 1;
            }
            else
            {
                _joinSuc = 0;
                [UtilityObject svProgressHUDError:respond viewContrller:self];
            }
        }];
    }
    else if (_promotionType == 2)
    {// 邀请好友(分享)
        [UtilityObject showWithShareView:self.view shareImage:nil shareTitle:@"秀味" shareContent:@"邀请好友" shareUrl:nil];
    }
}

#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    // UIEdgeInsets
//    UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
    // 260
    CGFloat space = 260 - (_contentView.height - _codeBgView.bottom) + 41;
//    debugLog(@"space=%.2f", space);
    _contentView.contentInset = UIEdgeInsetsMake(-space, 0, 0, 0);
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    _contentView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    [self performSelector:@selector(clickedWithSubmit:) withObject:nil afterDelay:0.2];
    
    return YES;
}

@end


























