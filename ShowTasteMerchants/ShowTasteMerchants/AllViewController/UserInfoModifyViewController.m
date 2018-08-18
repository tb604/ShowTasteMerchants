//
//  UserInfoModifyViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/28.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "UserInfoModifyViewController.h"
#import "LocalCommon.h"
#import "UserInfoViewCell.h"
#import "UserInfoDataEntity.h"
#import "UserLoginStateObject.h"
#import "ModifyUserSexObject.h" // 性别
#import "BirthdayBgView.h" // 出生日期
#import "UserUpdateInputEntity.h"

@interface UserInfoModifyViewController ()
{
    CGFloat _titleWidth;
    
    /**
     *  显示性别修改
     */
    ModifyUserSexObject *_modifySexObject;
}

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)initWithModifySexObject;

//@property (nonatomic, strong) UserInfoDataEntity *userInfoEntity;

@property (nonatomic, strong) BirthdayBgView *birthdayView;

@end

@implementation UserInfoModifyViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.userInfoEntity = [UserLoginStateObject getUserInfo];
    
    _userInfoEntity.family_name = (_userInfoEntity.family_name==nil?@"":_userInfoEntity.family_name);
    _userInfoEntity.name = (_userInfoEntity.name==nil?@"":_userInfoEntity.name);
    _userInfoEntity.nikename = (_userInfoEntity.nikename==nil?@"":_userInfoEntity.nikename);
    _userInfoEntity.birthday = (_userInfoEntity.birthday==nil?@"":_userInfoEntity.birthday);
    if ([_userInfoEntity.birthday isEqualToString:@"0000-00-00"])
    {
        _userInfoEntity.birthday = @"";
    }
    _userInfoEntity.identity_card = (_userInfoEntity.identity_card==nil?@"":_userInfoEntity.identity_card);
    _userInfoEntity.pay_account = (_userInfoEntity.pay_account==nil?@"":_userInfoEntity.pay_account);
    _userInfoEntity.email = (_userInfoEntity.email==nil?@"":_userInfoEntity.email);
    
    debugLog(@"serInfo=%@", [_userInfoEntity modelToJSONString]);
    
    [self.baseTableView reloadData];
    
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
    
    [self initWithModifySexObject];
    
    NSString *str = @"第三方支付";
    _titleWidth = [str widthForFont:FONTSIZE_12];
    
    
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = @"编辑设置";
}

- (void)initWithSubView
{
    [super initWithSubView];
    
}

- (void)initWithModifySexObject
{
    __weak typeof(self)weakSelf = self;
    _modifySexObject = [[ModifyUserSexObject alloc] init];
    _modifySexObject.hiddObjectBlock = ^(id data)
    {
        [weakSelf modifySexObject:data];
    };
}

- (void)modifySexObject:(id)data
{
    NSInteger sex = -1;
    if ([data isEqualToString:@"男"])
    {
        sex = 1;
    }
    else if ([data isEqualToString:@"女"])
    {
        sex = 0;
    }
    if (sex == -1)
    {
        return;
    }
    
    
    
    [SVProgressHUD showWithStatus:@"修改性别"];
    
    [HCSNetHttp requestWithUserUpdateUserSex:[UserLoginStateObject getUserId] sex:sex completion:^(id result) {
        [self responseWithModifyUserSex:result sex:sex];
    }];
}
- (void)responseWithModifyUserSex:(TYZRespondDataEntity *)respond sex:(NSInteger)sex
{
    if (respond.errcode == respond_success)
    {
        [SVProgressHUD showSuccessWithStatus:@"修改性别成功"];
        _userInfoEntity.sex = sex;
        [MCYPushViewController reloadWithTableView:self.baseTableView indexPath:_indexPath reloadType:3];
        [UserLoginStateObject saveWithUserInfo:_userInfoEntity];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
}

/**
 *  显示修改出生年月日的视图
 *
 *  @param show <#show description#>
 */
- (void)showWithBirthdayView:(BOOL)show
{
    __weak typeof(self)blockSelf = self;
    if (!_birthdayView)
    {
        _birthdayView = [[BirthdayBgView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight])];
        _birthdayView.alpha = 0;
    }
    _birthdayView.TouchDateTimeBlock = ^(NSString *date, BOOL isSubmit)
    {
        [blockSelf modifyBirthday:date isSubmit:isSubmit];
    };
    if (show)
    {
        [_birthdayView updateWithBirthday:_userInfoEntity.birthday isLogTime:NO];
        [self.view.window addSubview:_birthdayView];
        [UIView animateWithDuration:0.5 animations:^{
            _birthdayView.alpha = 1.0;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            _birthdayView.alpha = 0;
        } completion:^(BOOL finished) {
            [_birthdayView removeFromSuperview];
        }];
    }
}
- (void)modifyBirthday:(NSString *)date isSubmit:(BOOL)isSubmit
{
    if (date)
    {
//        _userInfoEntity.birthday = date;
//        [MCYPushViewController reloadWithTableView:self.baseTableView indexPath:_indexPath reloadType:3];
    }
    if (isSubmit)
    {
        [self showWithBirthdayView:NO];
        
        [SVProgressHUD showWithStatus:@"修改出生日期"];
        [HCSNetHttp requestWithUserUpdateUserBirthday:[UserLoginStateObject getUserId] birthday:date completion:^(id result) {
            [self responseWithUserBirthday:result birthday:date];
        }];
    }
}
- (void)responseWithUserBirthday:(TYZRespondDataEntity *)respond birthday:(NSString *)birthday
{
    if (respond.errcode == respond_success)
    {
        [SVProgressHUD showSuccessWithStatus:@"修改出生日期成功"];
        _userInfoEntity.birthday = birthday;
        [MCYPushViewController reloadWithTableView:self.baseTableView indexPath:_indexPath reloadType:3];
        [UserLoginStateObject saveWithUserInfo:_userInfoEntity];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
}





- (void)reloadUserInfo:(NSIndexPath *)indexPath reData:(id)reData
{
    if (indexPath.section == EN_UIM_USERINFO_BASE_SECTION)
    {// 个人基本信息
        if (indexPath.row == EN_UIM_BASEINFO_NAME_ROW)
        {// 姓名
            NSDictionary *dict = reData;
            _userInfoEntity.family_name = dict[@"familyName"];
            _userInfoEntity.name = dict[@"lastName"];
            [MCYPushViewController reloadWithTableView:self.baseTableView indexPath:indexPath reloadType:3];
        }
        else if (indexPath.row == EN_UIM_BASEINFO_PHONE_ROW)
        {// 手机号码
//            [HCSNetHttp requestwithuserupdate]
        }
        else if (indexPath.row == EN_UIM_BASEINFO_MAIL_ROW)
        {// 邮箱
            
        }
        else if (indexPath.row == EN_UIM_BASEINFO_PASSWORD_ROW)
        {// 密码
            _userInfoEntity.password = reData;
            [MCYPushViewController reloadWithTableView:self.baseTableView indexPath:indexPath reloadType:3];
        }
    }
    else if (indexPath.section == EN_UIM_USERINFO_PRIVATE_SECTION)
    {// 个人私密信息
        if (indexPath.row == EN_UIM_PRIVATEINFO_IDCARD_ROW)
        {// 身份证号
            [SVProgressHUD showWithStatus:@"修改身份证"];
            [HCSNetHttp requestWithUserUpdateIdentityCard:[UserLoginStateObject getUserId] identityCard:reData completion:^(id result) {
                [self responseWithModifyIdentityCard:result reData:reData];
            }];
        }
        else if (indexPath.row == EN_UIM_PRIVATEINFO_THIRDPAY_ROW)
        {// 第三方支付
            
        }
    }

    [UserLoginStateObject saveWithUserInfo:_userInfoEntity];
}

/**
 *  修改身份证，返回结果
 *
 *  @param respond <#respond description#>
 *  @param reData  修改的身份证号
 */
- (void)responseWithModifyIdentityCard:(TYZRespondDataEntity *)respond reData:(id)reData
{
    if (respond.errcode == respond_success)
    {
        [SVProgressHUD showSuccessWithStatus:@"身份证修改成功"];
        _userInfoEntity.identity_card = reData;
        [UserLoginStateObject saveWithUserInfo:_userInfoEntity];
        [MCYPushViewController reloadWithTableView:self.baseTableView indexPath:_indexPath reloadType:3];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return EN_UIM_USERINFO_MAX_SECTION;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    switch (section)
    {
        case EN_UIM_USERINFO_BASE_SECTION:
            count = EN_UIM_BASEINFO_MAX_ROW;
            break;
        case EN_UIM_USERINFO_PRIVATE_SECTION:
            count = EN_UIM_PRIVATEINFO_MAX_ROW;
        default:
            break;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserInfoViewCell *cell = [UserInfoViewCell cellForTableView:tableView];
    [cell updateHiddenLine:YES];
    if (indexPath.section == EN_UIM_USERINFO_BASE_SECTION)
    {// 个人基本信息
        if (indexPath.row == EN_UIM_BASEINFO_NAME_ROW)
        {// 姓名
            UIColor *color = [UIColor colorWithHexString:@"#646464"];
            NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"姓名" attributes:@{NSFontAttributeName: FONTSIZE_12, NSForegroundColorAttributeName: color}];
            color = [UIColor colorWithHexString:@"#323232"];
            NSAttributedString *value = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", _userInfoEntity.family_name, _userInfoEntity.name] attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
            [cell updateCellData:title titleWidth:_titleWidth attri:value alignment:NSTextAlignmentRight detailHeight:20];
        }
        else if (indexPath.row == EN_UIM_BASEINFO_SEX_ROW)
        {// 性别
            NSString *strSex = @"男";
            if (_userInfoEntity.sex == 0)
            {
                strSex = @"女";
            }
            UIColor *color = [UIColor colorWithHexString:@"#646464"];
            NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"性别" attributes:@{NSFontAttributeName: FONTSIZE_12, NSForegroundColorAttributeName: color}];
            color = [UIColor colorWithHexString:@"#323232"];
            NSAttributedString *value = [[NSAttributedString alloc] initWithString:strSex attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
            [cell updateCellData:title titleWidth:_titleWidth attri:value alignment:NSTextAlignmentRight detailHeight:20];
        }
        else if (indexPath.row == EN_UIM_BASEINFO_BIRTHDAY_ROW)
        {// 出生日期
            UIColor *color = [UIColor colorWithHexString:@"#646464"];
            NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"出生月日" attributes:@{NSFontAttributeName: FONTSIZE_12, NSForegroundColorAttributeName: color}];
            color = [UIColor colorWithHexString:@"#323232"];
            NSAttributedString *value = [[NSAttributedString alloc] initWithString:_userInfoEntity.birthday attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
            [cell updateCellData:title titleWidth:_titleWidth attri:value alignment:NSTextAlignmentRight detailHeight:20];
        }
        else if (indexPath.row == EN_UIM_BASEINFO_PHONE_ROW)
        {// 手机号码
            UIColor *color = [UIColor colorWithHexString:@"#646464"];
            NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"手机号码" attributes:@{NSFontAttributeName: FONTSIZE_12, NSForegroundColorAttributeName: color}];
            color = [UIColor colorWithHexString:@"#323232"];
            NSAttributedString *value = [[NSAttributedString alloc] initWithString:_userInfoEntity.mobile attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
            [cell updateCellData:title titleWidth:_titleWidth attri:value alignment:NSTextAlignmentRight detailHeight:20];
        }
        else if (indexPath.row == EN_UIM_BASEINFO_MAIL_ROW)
        {// 邮箱
            UIColor *color = [UIColor colorWithHexString:@"#646464"];
            NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"邮箱" attributes:@{NSFontAttributeName: FONTSIZE_12, NSForegroundColorAttributeName: color}];
            color = [UIColor colorWithHexString:@"#323232"];
            NSAttributedString *value = [[NSAttributedString alloc] initWithString:_userInfoEntity.email attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
            [cell updateCellData:title titleWidth:_titleWidth attri:value alignment:NSTextAlignmentRight detailHeight:20];
        }
        else if (indexPath.row == EN_UIM_BASEINFO_PASSWORD_ROW)
        {// 密码
            UIColor *color = [UIColor colorWithHexString:@"#646464"];
            NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"密码" attributes:@{NSFontAttributeName: FONTSIZE_12, NSForegroundColorAttributeName: color}];
            color = [UIColor colorWithHexString:@"#323232"];
            NSAttributedString *value = [[NSAttributedString alloc] initWithString:_userInfoEntity.password attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
            [cell updateCellData:title titleWidth:_titleWidth attri:value alignment:NSTextAlignmentRight detailHeight:20];
        }
    }
    else if (indexPath.section == EN_UIM_USERINFO_PRIVATE_SECTION)
    {// 个人私密信息
        if (indexPath.row == EN_UIM_PRIVATEINFO_IDCARD_ROW)
        {// 身份证号
            UIColor *color = [UIColor colorWithHexString:@"#646464"];
            NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"身份证号" attributes:@{NSFontAttributeName: FONTSIZE_12, NSForegroundColorAttributeName: color}];
            color = [UIColor colorWithHexString:@"#323232"];
            NSAttributedString *value = [[NSAttributedString alloc] initWithString:_userInfoEntity.identity_card attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
            [cell updateCellData:title titleWidth:_titleWidth attri:value alignment:NSTextAlignmentRight detailHeight:20];
        }
        else if (indexPath.row == EN_UIM_PRIVATEINFO_THIRDPAY_ROW)
        {// 第三方支付
            UIColor *color = [UIColor colorWithHexString:@"#646464"];
            NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"第三方支付" attributes:@{NSFontAttributeName: FONTSIZE_12, NSForegroundColorAttributeName: color}];
            color = [UIColor colorWithHexString:@"#323232"];
            NSAttributedString *value = [[NSAttributedString alloc] initWithString:_userInfoEntity.pay_account attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
            [cell updateCellData:title titleWidth:_titleWidth attri:value alignment:NSTextAlignmentRight detailHeight:20];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kUserInfoViewCellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *str = nil;
    if (section == EN_UIM_USERINFO_BASE_SECTION)
    {
        str = @"个人基本信息";
    }
    else if (section == EN_UIM_USERINFO_PRIVATE_SECTION)
    {
        str = @"私密信息";
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], 35.0)];
    view.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    UILabel *label = [TYZCreateCommonObject createWithLabel:view labelFrame:CGRectMake(20, 10, view.width - 40, 20) textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentCenter];
    label.text = str;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.indexPath = indexPath;
    
    if (indexPath.section == EN_UIM_USERINFO_BASE_SECTION)
    {// 个人基本信息
        if (indexPath.row == EN_UIM_BASEINFO_NAME_ROW)
        {// 姓名
            NSDictionary *dict = @{@"familyName":_userInfoEntity.family_name, @"lastName":_userInfoEntity.name};
            [MCYPushViewController showWithModifyUserNameVC:self data:dict completion:^(id data) {
                [self reloadUserInfo:indexPath reData:data];
            }];
        }
        else if (indexPath.row == EN_UIM_BASEINFO_SEX_ROW)
        {// 性别
            [_modifySexObject showActionSheet:self];
        }
        else if (indexPath.row == EN_UIM_BASEINFO_BIRTHDAY_ROW)
        {// 出生日期
            [self showWithBirthdayView:YES];
        }
        else if (indexPath.row == EN_UIM_BASEINFO_PHONE_ROW)
        {// 手机号码
            UserUpdateInputEntity *userEntity = [UserUpdateInputEntity new];
            userEntity.mobile = _userInfoEntity.mobile;
            userEntity.smschannel = EN_SMS_CHANNEL_TYPE_CURPHONE;
            [MCYPushViewController showWithModifyMobileVC:self data:userEntity completion:^(id data) {
                
            }];
        }
        else if (indexPath.row == EN_UIM_BASEINFO_MAIL_ROW)
        {// 邮箱
            
        }
        else if (indexPath.row == EN_UIM_BASEINFO_PASSWORD_ROW)
        {// 密码
            [MCYPushViewController showWithModifyPswVC:self data:_userInfoEntity completion:^(id data) {
//                [self reloadUserInfo:indexPath reData:data];
            }];
        }
    }
    else if (indexPath.section == EN_UIM_USERINFO_PRIVATE_SECTION)
    {// 个人私密信息
        if (indexPath.row == EN_UIM_PRIVATEINFO_IDCARD_ROW)
        {// 身份证号
            NSDictionary *param = @{@"title":@"身份证号", @"data":_userInfoEntity.identity_card, @"placeholder":@"请输入身份证号", @"singleRow":@(YES), @"isNumber":@(YES)};
            [MCYPushViewController showWithModifyInfoVC:self data:param completion:^(id data) {
                [self reloadUserInfo:indexPath reData:data];
            }];
        }
        else if (indexPath.row == EN_UIM_PRIVATEINFO_THIRDPAY_ROW)
        {// 第三方支付
            
        }
    }
}

@end
