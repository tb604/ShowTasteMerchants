/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCLoginViewController.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/18 17:25
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCLoginViewController.h"
#import "LocalCommon.h"
#import "CTCLoginTextView.h"
#import "FirstViewController.h" // 测试二维码扫描


typedef NS_ENUM(NSInteger, EN_LOGIN_VC_BTN_TAG)
{
    EN_LOGIN_VC_BTN_LOGIN_TAG = 100, ///< 登录按钮
    EN_LOGIN_VC_BTN_SWITCH_TAG, ///<切换按钮
    EN_LOGIN_VC_BTN_FORGOTPWD_TAG, ///<忘记密码
    EN_LOGIN_VC_BTN_COMEREG_TAG, ///<进入注册
};

@interface CTCLoginViewController () <UITextFieldDelegate>
{
    UIScrollView *_contentView;
    
    UIImageView *_topView;
    
    /// 切换至员工\切换至老板
    UIButton *_btnSwitch;
    
    /// 忘记密码
    UIButton *_btnForgotPwd;
    
    /// 登录按钮
    UIButton *_btnLogin;
    
    /// 进入注册
    UILabel *_comeRegLabel;
}

/// 餐厅编码view
@property (nonatomic, strong) CTCLoginTextView *restaurantCodeView;

/// 手机号码
@property (nonatomic, strong) CTCLoginTextView *phoneCodeView;

/// 密码
@property (nonatomic, strong) CTCLoginTextView *passwordView;

- (void)initWithContentView;

- (void)initWithTopView;

/**
 *  初始化餐厅编码view
 */
- (void)initWithRestaurantCodeView;

/**
 *  初始化手机号码
 */
- (void)initWithPhoneCodeView;

/**
 *  初始化密码
 */
- (void)initWithPasswordView;

/**
 *  初始化切换至员工\切换至老板
 */
- (void)initWithBtnSwitch;

/**
 *  初始化忘记密码
 */
- (void)initWithBtnForgotPwd;

/**
 *  初始化登录按钮
 */
- (void)initWithBtnLogin;

/**
 *  进入注册
 */
- (void)initWithComeRegLabel;


- (void)tapGesture:(UITapGestureRecognizer *)tap;

@end

@implementation CTCLoginViewController

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

- (void)initWithVar
{
    [super initWithVar];
    
    if (_userLoginType == 0)
    {
        self.userLoginType = [UserLoginStateObject readWithUserLoginType];
    }
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithContentView];
    
    [self initWithTopView];
    
    [self initWithPartView];
    
}

- (void)clickedBack:(id)sender
{
    if (_comeType == 3)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
//    if (_type == 3)
//    {
        AppDelegate *app = [UtilityObject appDelegate];
        [app loadRootVC];
       /* return;
    }
    if ([sender isKindOfClass:[NSNumber class]] && _type == 2)
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
    }
    else
    {
        [super clickedBack:sender];
    }*/
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

- (void)initWithPartView
{
    debugMethod();
    // 初始化餐厅编码view
    [self initWithRestaurantCodeView];
    
    // 初始化手机号码
    [self initWithPhoneCodeView];
    
    // 初始化密码
    [self initWithPasswordView];
    
    // 关联餐厅编码下面的线
//    [self initWithLineOne];
    
    // 手机号码下面的线
//    [self initWithLineTwo];
    
    // 密码下面的线
//    [self initWithLineThree];
    
    
    // 初始化切换至员工\切换至老板
    [self initWithBtnSwitch];
    
    // 初始化忘记密码
    [self initWithBtnForgotPwd];
    
    // 初始化登录按钮
    [self initWithBtnLogin];
    
    // 进入注册
    [self initWithComeRegLabel];
}

/**
 *  初始化餐厅编码view
 */
- (void)initWithRestaurantCodeView
{
    if (!_restaurantCodeView)
    {
        NSInteger width = [[UIScreen mainScreen] screenWidth] / 1.25;
        NSInteger space = [[UIScreen mainScreen] screenWidth] / 10.714285;
        if (kiPhone4)
        {
            space = 10;
        }
        CGRect frame = CGRectMake(([[UIScreen mainScreen] screenWidth] - width)/2., _topView.bottom + space, width, kCTCLoginTextViewHeight);
        _restaurantCodeView = [[CTCLoginTextView alloc] initWithFrame:frame];
        [_contentView addSubview:_restaurantCodeView];
        
        UIImage *image = [UIImage imageWithContentsOfFileName:@"login_icon_shop.png"];
        
        [_restaurantCodeView updateWithIconImg:image placeholder:@"请输入关联的餐厅编码" pwdRightImg:nil isVerCode:NO];
        
        _restaurantCodeView.txtField.delegate = self;
        _restaurantCodeView.txtField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _restaurantCodeView.txtField.returnKeyType = UIReturnKeyNext;
    }
    _restaurantCodeView.hidden = YES;
    if (_userLoginType == EN_LOGIN_USER_EMPLOYE_TYPE)
    {// 员工
        _restaurantCodeView.hidden = NO;
    }
}

/**
 *  初始化手机号码
 */
- (void)initWithPhoneCodeView
{
    CGRect frame = _restaurantCodeView.frame;;
    if (!_phoneCodeView)
    {
        _phoneCodeView = [[CTCLoginTextView alloc] initWithFrame:frame];
        [_contentView addSubview:_phoneCodeView];
        UIImage *image = [UIImage imageWithContentsOfFileName:@"login_icon_phone.png"];
        [_phoneCodeView updateWithIconImg:image placeholder:@"请输入您的手机号" pwdRightImg:nil isVerCode:NO];
        
        _phoneCodeView.txtField.delegate = self;
        _phoneCodeView.txtField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _phoneCodeView.txtField.returnKeyType = UIReturnKeyNext;
    }
    
    if (_userLoginType == EN_LOGIN_USER_BOSS_TYPE)
    {// 老板
        NSInteger space = [[UIScreen mainScreen] screenWidth] / 6.57894737;
        if (kiPhone4)
        {
            space = space - 30;
        }
        frame.origin.y = _topView.bottom + space;
    }
    else if (_userLoginType == EN_LOGIN_USER_EMPLOYE_TYPE)
    {// 员工
        frame.origin.y = frame.origin.y + frame.size.height;
    }
    _phoneCodeView.frame = frame;
}

/**
 *  初始化密码
 */
- (void)initWithPasswordView
{
    CGRect frame = _phoneCodeView.frame;
    if (!_passwordView)
    {
        _passwordView = [[CTCLoginTextView alloc] initWithFrame:frame];
        [_contentView addSubview:_passwordView];
        
        UIImage *image = [UIImage imageWithContentsOfFileName:@"login_icon_password.png"];
        UIImage *psdImg = [UIImage imageWithContentsOfFileName:@"login_btn_invisible.png"];
        [_passwordView updateWithIconImg:image placeholder:@"请输入您的密码" pwdRightImg:psdImg isVerCode:NO];
        
        _passwordView.txtField.delegate = self;
        _passwordView.txtField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _passwordView.txtField.returnKeyType = UIReturnKeyDone;
        _passwordView.txtField.secureTextEntry = YES;
    }
    frame.origin.y = frame.origin.y + frame.size.height;
    _passwordView.frame = frame;
}


/**
 *  初始化切换至员工\切换至老板
 */
- (void)initWithBtnSwitch
{
    if (!_btnSwitch)
    {
        NSInteger bottomSpace = [[UIScreen mainScreen] screenWidth] / 9.375;
        if (kiPhone4)
        {
            bottomSpace = 20;
        }
        NSInteger empWidth = [[UIScreen mainScreen] screenWidth] / 1.25;
        float leftSpace = ([[UIScreen mainScreen] screenWidth] - empWidth) / 2.;
        NSInteger width = [[UIScreen mainScreen] screenWidth] / 3.75;
        CGRect frame = CGRectMake(leftSpace, _contentView.height - bottomSpace - 20, width, 20);
        
        _btnSwitch = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"切换老板" titleColor:[UIColor colorWithHexString:@"#323232"] titleFont:FONTSIZE_13 targetSel:@selector(clickedWithButton:)];
        _btnSwitch.tag = EN_LOGIN_VC_BTN_SWITCH_TAG;
        _btnSwitch.frame = frame;
        _btnSwitch.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
        _btnSwitch.layer.borderWidth = 1;
        _btnSwitch.layer.masksToBounds = YES;
        _btnSwitch.layer.cornerRadius = frame.size.height / 2.;
        [_contentView addSubview:_btnSwitch];
    }
    
    if (_userLoginType == EN_LOGIN_USER_BOSS_TYPE)
    {// 老板
        [_btnSwitch setTitle:@"切换至员工" forState:UIControlStateNormal];
    }
    else if (_userLoginType == EN_LOGIN_USER_EMPLOYE_TYPE)
    {// 员工
        [_btnSwitch setTitle:@"切换至老板" forState:UIControlStateNormal];
    }
}

/**
 *  初始化忘记密码
 */
- (void)initWithBtnForgotPwd
{
    if (!_btnForgotPwd)
    {
        CGRect frame = _btnSwitch.frame;
        _btnForgotPwd = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"忘记密码？" titleColor:[UIColor colorWithHexString:@"#323232"] titleFont:FONTSIZE_13 targetSel:@selector(clickedWithButton:)];
        _btnForgotPwd.frame = frame;
        _btnForgotPwd.tag = EN_LOGIN_VC_BTN_FORGOTPWD_TAG;
        _btnForgotPwd.right = _contentView.width - frame.origin.x;
        _btnForgotPwd.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
        _btnForgotPwd.layer.borderWidth = 1;
        _btnForgotPwd.layer.masksToBounds = YES;
        _btnForgotPwd.layer.cornerRadius = frame.size.height / 2.;
        [_contentView addSubview:_btnForgotPwd];
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
        
        _btnLogin = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"登录" titleColor:[UIColor whiteColor] titleFont:FONTSIZE_16 targetSel:@selector(clickedWithButton:)];
        _btnLogin.tag = EN_LOGIN_VC_BTN_LOGIN_TAG;
        _btnLogin.frame = frame;
        _btnLogin.backgroundColor = [UIColor colorWithHexString:@"#ff5500"];
        _btnLogin.layer.masksToBounds = YES;
        _btnLogin.layer.cornerRadius = height / 2.;
        [_contentView addSubview:_btnLogin];
    }
}

/**
 *  进入注册
 */
- (void)initWithComeRegLabel
{
    if (!_comeRegLabel)
    {
        NSString *str = @"要开店，去注册";
        float width = [str widthForFont:FONTBOLDSIZE(13)];
        float space = 15;
        if (kiPhone4)
        {
            space = 8;
        }
        CGRect frame = CGRectMake(0, _btnLogin.bottom + space, width, 30);
        _comeRegLabel = [TYZCreateCommonObject createWithLabel:_contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentCenter];
        _comeRegLabel.centerX = [[UIScreen mainScreen] screenWidth] / 2.;
        NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] init];
        UIColor *color = [UIColor colorWithHexString:@"#646464"];
        NSAttributedString *bTitle = [[NSAttributedString alloc] initWithString:@"要开店，去" attributes:@{NSFontAttributeName: FONTSIZE(13), NSForegroundColorAttributeName: color}];
        [mas appendAttributedString:bTitle];
        
        [UIColor colorWithHexString:@"#323232"];
        bTitle = [[NSAttributedString alloc] initWithString:@"注册" attributes:@{NSFontAttributeName: FONTBOLDSIZE(13), NSForegroundColorAttributeName: color}];
        [mas appendAttributedString:bTitle];
        _comeRegLabel.attributedText = mas;
        _comeRegLabel.userInteractionEnabled = YES;
        __weak typeof(self)weakSelf = self;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
            debugLog(@"去注册");
            [MCYPushViewController showWithUserRegisterVC:weakSelf data:nil completion:nil];
        }];
        [_comeRegLabel addGestureRecognizer:tap];
    }
    
    _comeRegLabel.hidden = YES;
    if (_userLoginType == EN_LOGIN_USER_BOSS_TYPE)
    {
        _comeRegLabel.hidden = NO;
    }
    
}

- (void)clickedWithButton:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == EN_LOGIN_VC_BTN_LOGIN_TAG)
    {// 登录按钮
        
        [self userWithLogin];
    }
    else if (btn.tag == EN_LOGIN_VC_BTN_SWITCH_TAG)
    {// 切换按钮
        if (_userLoginType == EN_LOGIN_USER_BOSS_TYPE)
        {// 如果当前是老板模式，就切换到员工
            _userLoginType = EN_LOGIN_USER_EMPLOYE_TYPE;
            [UserLoginStateObject saveWithUserLoginType:_userLoginType];
        }
        else if (_userLoginType == EN_LOGIN_USER_EMPLOYE_TYPE)
        {// 如果是员工模式，就切换到老板模式
            _userLoginType = EN_LOGIN_USER_BOSS_TYPE;
            [UserLoginStateObject saveWithUserLoginType:_userLoginType];
        }
        
        [self initWithPartView];
    }
    else if (btn.tag == EN_LOGIN_VC_BTN_FORGOTPWD_TAG)
    {// 忘记密码
        [MCYPushViewController showWithUserForgotPswVC:self data:nil completion:nil];
    }
}

- (void)tapGesture:(UITapGestureRecognizer *)tap
{
    _contentView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view endEditing:YES];
}

// 登录
- (void)userWithLogin
{
    NSString *code = @"";
    if (_userLoginType == EN_LOGIN_USER_EMPLOYE_TYPE)
    {// 员工
        // 关联餐厅的编码
        code = objectNull(_restaurantCodeView.txtField.text);
        debugLog(@"code=%@", code);
        if ([code isEqualToString:@""])
        {
            [SVProgressHUD showErrorWithStatus:@"请输入关联餐厅的编码"];
            return;
        }
    }
    
    NSString *phone = objectNull(_phoneCodeView.txtField.text);
    
    NSString *password = objectNull(_passwordView.txtField.text);
    
    if ([phone isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号码"];
        return;
    }
    
    if ([password isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    [SVProgressHUD showWithStatus:@"登录中"];
    if (_userLoginType == EN_LOGIN_USER_EMPLOYE_TYPE)
    {// 员工登录
        [HCSNetHttp requestWithUserEmployeeLogin:[code integerValue] mobile:phone password:password completion:^(TYZRespondDataEntity *respond) {
            [self responseWithUserLogin:respond password:password];
        }];
    }
    else if (_userLoginType == EN_LOGIN_USER_BOSS_TYPE)
    {// 老板登录
        [HCSNetHttp requestWithSellerLogin:phone password:password completion:^(id result) {
            [self responseWithUserLogin:result password:password];
        }];
        /*[HCSNetHttp requestWithUserLogin:phone password:password completion:^(TYZRespondDataEntity *respond) {
            [self responseWithUserLogin:respond password:password];
        }];*/
    }
}

/**
 *  登录后，返回的结果
 *
 *  @param respond  respond
 *  @param password 密码
 */
- (void)responseWithUserLogin:(TYZRespondDataEntity *)respond password:(NSString *)password
{
    if (respond.errcode == respond_success)
    {
        [SVProgressHUD showSuccessWithStatus:@"登录成功"];
        UserInfoDataEntity *userInfo = respond.data;
        // userInfo.state = [UserLoginStateObject getUserInfo].state;
        [UserLoginStateObject saveWithUserInfo:userInfo];
        [UserLoginStateObject saveLoginState:EUserLogined];
        
        [self bossLoginFinish:userInfo];
        
//        [self performSelector:@selector(clickedBack:) withObject:@(1) afterDelay:2];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
}

/**
 *  老板登录完成以后
 */
- (void)bossLoginFinish:(UserInfoDataEntity *)userInfo
{
    // 扫描二维码测试
//    FirstViewController *qrscanVC = [[FirstViewController alloc] init];
//    [self.navigationController pushViewController:qrscanVC animated:YES];
//
    debugLog(@"state=%d", (int)userInfo.shop_state);
    if (userInfo.shop_state == 4 || userInfo.shop_state == 5 || userInfo.shop_state == 6)
    {// 审核通过；餐厅已发布；餐厅下架
        [self performSelector:@selector(clickedBack:) withObject:@(1) afterDelay:2];
        return;
    }
    
    if ([objectNull(userInfo.identity_card) isEqualToString:@""])
    {
        // 绑定身份
        [MCYPushViewController showWithBindCardIdVC:self data:nil completion:nil];
        return;
    }
    else
    {
        // 进入餐厅列表
        [MCYPushViewController showWithOpenRestaurantListVC:self data:nil completion:^(id data) {
//            ShopListDataEntity *shopEnt = data;
//            self.title = shopEnt.name;
        }];
        
//        NSInteger shopId = [UserLoginStateObject getCurrentShopId];
//        if (shopId == 0)
//        {// 表示没有餐厅
//            [MCYPushViewController showWithOpenRestaurantZeroVC:self data:nil completion:nil];
//            return;
//        }
    }
}


#pragma mark -
#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([_restaurantCodeView.txtField isEqual:textField])
    {
//        debugLog(@"餐厅编码");
        if (kiPhone4)
        {
            _contentView.contentInset = UIEdgeInsetsMake(-120, 0, 0, 0);
        }
    }
    else if ([_phoneCodeView.txtField isEqual:textField])
    {
        debugLog(@"手机号");
        if (kiPhone5)
        {
            _contentView.contentInset = UIEdgeInsetsMake(-90, 0, 0, 0);
        }
        else if (kiPhone4)
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
        else if (kiPhone6)
        {
            _contentView.contentInset = UIEdgeInsetsMake(-60, 0, 0, 0);
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([_restaurantCodeView.txtField isEqual:textField])
    {
        debugLog(@"re餐厅编码");
        [_phoneCodeView.txtField becomeFirstResponder];
    }
    else if ([_phoneCodeView.txtField isEqual:textField])
    {
        debugLog(@"re手机号");
        [_passwordView.txtField becomeFirstResponder];
    }
    else if ([_passwordView.txtField isEqual:textField])
    {
        debugLog(@"re密码");
        [self tapGesture:nil];
        _contentView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return YES;
}

@end











