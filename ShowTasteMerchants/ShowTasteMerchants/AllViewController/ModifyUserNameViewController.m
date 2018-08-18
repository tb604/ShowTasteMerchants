//
//  ModifyUserNameViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/30.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ModifyUserNameViewController.h"
#import "LocalCommon.h"
#import "ModifyUserNameView.h"
#import "UserLoginStateObject.h"


@interface ModifyUserNameViewController ()
{
    ModifyUserNameView *_userNameView;
    
    /**
     *  备注
     */
    UILabel *_noteLabel;
    
    /**
     *  提交&保存
     */
    UIButton *_btnSubmitSave;
    
    
}



- (void)initWithUserNameView;

- (void)initWithNoteLabel;

- (void)initWithBtnSubmitSave;



@end

@implementation ModifyUserNameViewController

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
    
    // completion (data ({@"familyName":@"tang", @"lastName":@"bin"}))
    
    
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = @"修改姓名";
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    
    [self initWithUserNameView];
    
    [self initWithNoteLabel];
    
    [self initWithBtnSubmitSave];
}


- (void)initWithUserNameView
{
    if (!_userNameView)
    {
        CGRect frame = CGRectMake(0, 44.0, [[UIScreen mainScreen] screenWidth], kModifyUserNameViewHeight);
        _userNameView = [[ModifyUserNameView alloc] initWithFrame:frame];
        [self.view addSubview:_userNameView];
        [_userNameView updateViewData:_nameDict];
    }
    __weak typeof(self)weakSelf = self;
    _userNameView.viewCommonBlock = ^(id data)
    {
        [weakSelf clickedButton:nil];
    };
}

- (void)initWithNoteLabel
{
    if (!_noteLabel)
    {
        CGRect frame = CGRectMake(10, _userNameView.bottom + 8, _userNameView.width - 20, 20);
        _noteLabel = [TYZCreateCommonObject createWithLabel:self.view labelFrame:frame textColor:[UIColor colorWithHexString:@"#b2b2b2"] fontSize:FONTSIZE_10 labelTag:0 alignment:NSTextAlignmentCenter];
        _noteLabel.text = @"*姓名将用于订单称呼，以及账号提现的实名信息校验";
    }
}

- (void)initWithBtnSubmitSave
{
    if (!_btnSubmitSave)
    {
        CGFloat top = 100;
        if (kiPhone4)
        {
            top = 70;
        }
        CGRect frame = CGRectMake(30, _userNameView.bottom + top, _userNameView.width - 60, 40);
        _btnSubmitSave = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"保存" titleColor:[UIColor whiteColor] titleFont:FONTSIZE_16 targetSel:@selector(clickedButton:)];
        _btnSubmitSave.frame = frame;
        _btnSubmitSave.backgroundColor = [UIColor colorWithHexString:@"#ff5601"];
        [self.view addSubview:_btnSubmitSave];
    }

}

- (void)clickedButton:(id)sender
{
    NSString *familyName = [_userNameView getFamilyName];
    NSString *lastName = [_userNameView getLastName];
    
    if (!familyName || [familyName isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入姓氏！"];
        return;
    }
    if (!lastName || [lastName isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入名字！"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"修改中"];
    
    [HCSNetHttp requestWithUserUpdateuserName:[UserLoginStateObject getUserId] familyName:familyName name:lastName completion:^(id result) {
        [self responseWithuserUpdateuserName:result];
    }];
}

- (void)responseWithuserUpdateuserName:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success)
    {
        [SVProgressHUD dismiss];
        
        NSString *familyName = [_userNameView getFamilyName];
        NSString *lastName = [_userNameView getLastName];
        
        NSDictionary *dict = @{@"familyName":familyName, @"lastName":lastName};
        if (self.popResultBlock)
        {
            self.popResultBlock(dict);
        }
        [self clickedBack:nil];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
}

@end
