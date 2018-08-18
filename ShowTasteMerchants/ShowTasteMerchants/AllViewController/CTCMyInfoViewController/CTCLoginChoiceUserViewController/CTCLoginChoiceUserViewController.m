/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCLoginChoiceUserViewController.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/18 16:10
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCLoginChoiceUserViewController.h"
#import "LocalCommon.h"

@interface CTCLoginChoiceUserViewController ()
{
    UIImageView *_bgView;
    
    UIImageView *_logoImgView;
    
    /// 老板登录按钮
    UIButton *_btnBoss;
    
    /// 员工登录按钮
    UIButton *_btnEmploye;
}

- (void)initWithBgView;

- (void)initWithLogoImgView;

/**
 *  初始化老板登录按钮
 */
- (void)initWithBtnBoss;

/**
 *  初始化员工登录按钮
 */
- (void)initWithBtnEmploye;

@end

@implementation CTCLoginChoiceUserViewController

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

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithBgView];
    
    [self initWithLogoImgView];
    
    // 初始化老板登录按钮
    [self initWithBtnBoss];
    
    // 初始化员工登录按钮
    [self initWithBtnEmploye];
}

- (void)initWithBgView
{
    if (!_bgView)
    {
        UIImage *image = [UIImage imageWithContentsOfFileName:@"login_bg_choose.png"];
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight]);
        _bgView = [[UIImageView alloc] initWithFrame:frame];
        _bgView.userInteractionEnabled = YES;
        _bgView.image = image;
        [self.view addSubview:_bgView];
    }
}

- (void)initWithLogoImgView
{
    
    if (!_logoImgView)
    {
        NSInteger topSpace = [[UIScreen mainScreen] screenHeight] / 7.4111;
        debugLog(@"topSpace=%d", (int)topSpace);
        UIImage *image = [UIImage imageWithContentsOfFileName:@"login_icon_logo.png"];
        CGRect frame = CGRectMake(([[UIScreen mainScreen] screenWidth] - image.size.width)/2., topSpace, image.size.width, image.size.height);
        _logoImgView = [[UIImageView alloc] initWithFrame:frame];
        _logoImgView.image = image;
        [_bgView addSubview:_logoImgView];
    }
}


/**
 *  初始化老板登录按钮
 */
- (void)initWithBtnBoss
{
    if (!_btnBoss)
    {
        NSInteger topSpace = [[UIScreen mainScreen] screenHeight] / 1.551162;// 1.49217
        NSInteger width = [[UIScreen mainScreen] screenWidth] / 1.25;
        CGRect frame = CGRectMake(([[UIScreen mainScreen] screenWidth] - width)/2., topSpace, width, 50.);
        _btnBoss = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnBoss setTitle:@"老板登录" forState:UIControlStateNormal];
        _btnBoss.tag = EN_LOGIN_USER_BOSS_TYPE;
        _btnBoss.titleLabel.font = FONTSIZE(18);
        _btnBoss.frame = frame;
        _btnBoss.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.3];
        _btnBoss.layer.masksToBounds = YES;
        _btnBoss.layer.cornerRadius = frame.size.height / 2.;
        [_btnBoss addTarget:self action:@selector(clickedWithButton:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_btnBoss];
    }
}

/**
 *  初始化员工登录按钮
 */
- (void)initWithBtnEmploye
{
    if (!_btnEmploye)
    {
        CGRect frame = _btnBoss.frame;
        frame.origin.y = _btnBoss.bottom + 20;
        _btnEmploye = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnEmploye setTitle:@"员工登录" forState:UIControlStateNormal];
        _btnEmploye.tag = EN_LOGIN_USER_EMPLOYE_TYPE;
        _btnEmploye.titleLabel.font = FONTSIZE(18);
        _btnEmploye.frame = frame;
        _btnEmploye.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.3];
        _btnEmploye.layer.masksToBounds = YES;
        _btnEmploye.layer.cornerRadius = frame.size.height / 2.;
        [_btnEmploye addTarget:self action:@selector(clickedWithButton:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_btnEmploye];
    }
}

// 选择 老板还是员工登录
- (void)clickedWithButton:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    debugLog(@"tag=%d", (int)btn.tag);
    [UserLoginStateObject saveWithUserLoginType:btn.tag];
    [MCYPushViewController showWithUserLoginVC:self data:@(btn.tag) completion:nil];
}

@end













