//
//  UserInfoViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/27.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "UserInfoViewController.h"
#import "LocalCommon.h"
#import "TYZBaseTableViewCell.h"
#import "UINavigationBar+Awesome.h"
#import "UserInfoHeadView.h"
#import "UploadImageObject.h"
#import "UserInfoViewCell.h"
#import "CellCommonDataEntity.h"
#import "UserInfoFooterView.h"
#import "UserLoginStateObject.h"
#import "UploadImageServerObject.h"
#import "CustomNavBarView.h"
//#import "KitchenCircleViewController.h" // 圈子视图控制器

@interface UserInfoViewController ()
{
    UserInfoHeadView *_headView;
    
    UserInfoFooterView *_footerView;
    
    CGFloat _titleWidth;
    
    BOOL _isTest;
}

@property (nonatomic, strong) UserInfoHeadView *headView;

/**
 *  上传图片到服务器
 */
@property (nonatomic, strong) UploadImageServerObject *uploadImgServerObject;

@property (nonatomic, strong) UploadImageObject *uploadImgObject;

@property (nonatomic, strong) UIBarButtonItem *itemEidt;


- (void)initWithHeadView;

- (void)initWithFooterView;

- (void)initWithUploadImgObject;

@end

@implementation UserInfoViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.userInfoEntity = [UserLoginStateObject getUserInfo];
    
    // imgUrl = [NSString stringWithFormat:@"%@?imageView2/0/q/80", imgUrl];
    
    _userInfoEntity.avatar = [NSString stringWithFormat:@"%@?t=%@&imageView2/0/q/40", _userInfoEntity.avatar, [NSDate stringWithCurrentTimeStamp]];
    
    self.navigationController.navigationBarHidden = NO;
    
    
    [self scrollViewDidScroll:self.baseTableView];
    
    UIImage *image = [[UIImage alloc] init];
    [self.navigationController.navigationBar setShadowImage:image];
    
//    CC_SAFE_RELEASE_NULL(image);
    [self.baseTableView reloadData];
    
    _isTest = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    self.navigationController.navigationBarHidden = NO;
    
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    
    [super viewWillDisappear:animated];
    
    UIColor * color = [UIColor colorWithHexString:@"#393b40"];
    [self.navigationController.navigationBar wyx_reset:color];
    
    _isTest = YES;
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
    
    [self scrollViewDidScroll:self.baseTableView];
    
    [self.navigationController.navigationBar wyx_setBackgroundColor:[UIColor clearColor]];
    
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
    
    
    NSString *str = @"第三方支付";
    _titleWidth = [str widthForFont:FONTSIZE_12];
    
    [self initWithUploadImgObject];
    
    _uploadImgServerObject = [[UploadImageServerObject alloc] init];
    
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    
    
    
//    self.title = @"个人信息";
    
    if (!_itemEidt)
    {
        UIImage *image = [UIImage imageNamed:@"u_btn_compile_sel"];
        UIButton *btnEdit = [TYZCreateCommonObject createWithButton:self imgNameNor:@"u_btn_compile_nor" imgNameSel:@"u_btn_compile_sel" targetSel:@selector(clickedEdit:)];
        btnEdit.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        UIBarButtonItem *itemEidt = [[UIBarButtonItem alloc] initWithCustomView:btnEdit];
        self.itemEidt = itemEidt;
    }
    
    self.navigationItem.rightBarButtonItem = _itemEidt;
    
    
    // title
    AppDelegate *app = [UtilityObject appDelegate];
    CGRect frame = CGRectMake(46, 0, [[UIScreen mainScreen] screenWidth] - 120, [app navBarHeight]);
    CustomNavBarView *titleView = [[CustomNavBarView alloc] initWithFrame:frame];
    [titleView updateViewData:@"个人信息" titleColor:nil];
    self.navigationItem.titleView = titleView;
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeAll;
    }
    CGRect frame = self.baseTableView.frame;
    frame.size.height = [[UIScreen mainScreen] screenHeight];
    self.baseTableView.frame = frame;
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self initWithHeadView];
    
    [self initWithFooterView];
}


- (void)initWithUploadImgObject
{
    __weak typeof(self)weakSelf = self;
    _uploadImgObject = [[UploadImageObject alloc] init];
    _uploadImgObject.imgSize = CGSizeMake(140, 140);
    _uploadImgObject.imgType = 1;
    _uploadImgObject.extName = @"png";
    _uploadImgObject.dissPickerHeadImgDataBlock = ^(NSData *data, NSString *imgName)
    {// 保存图片
        [weakSelf uploadWithImageData:data imageName:imgName];
    };
}

- (void)initWithHeadView
{
    if (!_headView)
    {
        CGFloat width = [[UIScreen mainScreen] screenWidth];
        CGFloat height = width / 1.5;
        CGRect frame = CGRectMake(0, 0, width, height);
        _headView = [[UserInfoHeadView alloc] initWithFrame:frame];
        self.baseTableView.tableHeaderView = _headView;
//        [_headView updateViewData:nil];
    }
    [_headView updateViewData:_userInfoEntity];
    __weak typeof(self)weakSelf = self;
    _headView.viewCommonBlock = ^(id data)
    {// 显示传图片的方式
        [weakSelf.uploadImgObject showActionSheet:weakSelf];
    };
}

- (void)initWithFooterView
{
    if (!_footerView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kUserInfoFooterViewHeight);
        _footerView = [[UserInfoFooterView alloc] initWithFrame:frame];
        self.baseTableView.tableFooterView = _footerView;
        [_footerView updateViewData:nil];
    }
    __weak typeof(self)weakSelf = self;
    _footerView.viewCommonBlock = ^(id data)
    {// 退出当前账号
        [weakSelf userOutLogin];
    };
}

- (void)uploadWithImageData:(NSData *)data imageName:(NSString *)imageName
{
    UploadFileInputObject *inputEnt = [[UploadFileInputObject alloc] init];
    inputEnt.sourceId = [UserLoginStateObject getUserId];
    inputEnt.userId = [UserLoginStateObject getUserId];
    inputEnt.imageType = EN_UPLOAD_IMAGE_HEADER;
    inputEnt.data = data;
    inputEnt.extName = _uploadImgObject.extName;
    __weak typeof(self)weakSelf = self;
    [_uploadImgServerObject getUploadFileToken:inputEnt complete:^(int status, NSString *host, NSString *filePath, NSInteger imageId) {
        debugLog(@"status=%d; filePath=%@", status, filePath);
        if (status == 1)
        {
            NSString *headUrl = nil;
            headUrl = [NSString stringWithFormat:@"%@?t=%@&imageView2/0/q/40", filePath, [NSDate stringWithCurrentTimeStamp]];
            // http://182.254.132.142/user/20/1466048424.png
            debugLog(@"headurl=%@", headUrl);
            [weakSelf performSelector:@selector(reloadAvater:) withObject:headUrl afterDelay:1];
        }
    }];
}

- (void)reloadAvater:(NSString *)headUrl
{
    self.userInfoEntity.avatar = headUrl;
    [UserLoginStateObject saveWithUserInfo:self.userInfoEntity];
    [self.headView updateViewData:self.userInfoEntity];
}

// 退出登录
- (void)userOutLogin
{
    [UserLoginStateObject saveLoginState:EUserUnlogin];
    [self performSelector:@selector(clickedBack:) withObject:nil afterDelay:1];
    
    // 登陆后，给圈子发送通知，更改
//    [[NSNotificationCenter defaultCenter] postNotificationName:kKitchenCircleNote object:nil];
}

// 编辑
- (void)clickedEdit:(id)sender
{
    __weak typeof(self)weakSelf = self;
    [MCYPushViewController showWithUserInfoModifyVC:self data:weakSelf.userInfoEntity completion:nil];
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIColor * color = [UIColor colorWithHexString:@"#393b40"];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT)
    {
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
        [self.navigationController.navigationBar wyx_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        
        if (!_isTest)
        {
            [self initWithNavBar];
        }
        else
        {
            [self performSelector:@selector(initWithNavBar) withObject:nil afterDelay:0.0];
        }
    }
    else
    {
        [self.navigationController.navigationBar wyx_setBackgroundColor:[color colorWithAlphaComponent:0]];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return EN_USER_INFO_MAX_ROW;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserInfoViewCell *cell = [UserInfoViewCell cellForTableView:tableView];
    if (indexPath.row == EN_USER_INFO_NAME_ROW)
    {// 姓名
        
        UIColor *color = [UIColor colorWithHexString:@"#646464"];
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"姓名" attributes:@{NSFontAttributeName: FONTSIZE_12, NSForegroundColorAttributeName: color}];
        color = [UIColor colorWithHexString:@"#323232"];
        NSString * strValue = [NSString stringWithFormat:@"%@%@", _userInfoEntity.family_name, _userInfoEntity.name];
        NSAttributedString *value = [[NSAttributedString alloc] initWithString:strValue attributes:@{NSFontAttributeName: FONTSIZE(24), NSForegroundColorAttributeName: color}];
        [cell updateCellData:title titleWidth:_titleWidth attri:value alignment:NSTextAlignmentCenter detailHeight:20];
    }
    else if (indexPath.row == EN_USER_INFO_SEX_ROW)
    {// 性别
        UIColor *color = [UIColor colorWithHexString:@"#646464"];
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"性别" attributes:@{NSFontAttributeName: FONTSIZE_12, NSForegroundColorAttributeName: color}];
        color = [UIColor colorWithHexString:@"#323232"];
        NSString *strValue = @"男";
        if (_userInfoEntity.sex == 0)
        {
            strValue = @"女";
        }
        NSAttributedString *value = [[NSAttributedString alloc] initWithString:strValue attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
        [cell updateCellData:title titleWidth:_titleWidth attri:value alignment:NSTextAlignmentCenter detailHeight:20];
    }
    else if (indexPath.row == EN_USER_INFO_BIRTHDAY_ROW)
    {// 出生日期
        UIColor *color = [UIColor colorWithHexString:@"#646464"];
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"出生月日" attributes:@{NSFontAttributeName: FONTSIZE_12, NSForegroundColorAttributeName: color}];
        color = [UIColor colorWithHexString:@"#323232"];
        NSAttributedString *value = [[NSAttributedString alloc] initWithString:_userInfoEntity.birthday attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
        [cell updateCellData:title titleWidth:_titleWidth attri:value alignment:NSTextAlignmentCenter detailHeight:20];
    }
    else if (indexPath.row == EN_USER_INFO_PHONE_ROW)
    {// 手机号码
        UIColor *color = [UIColor colorWithHexString:@"#646464"];
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"手机号码" attributes:@{NSFontAttributeName: FONTSIZE_12, NSForegroundColorAttributeName: color}];
        color = [UIColor colorWithHexString:@"#323232"];
        NSAttributedString *value = [[NSAttributedString alloc] initWithString:_userInfoEntity.mobile attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
        [cell updateCellData:title titleWidth:_titleWidth attri:value alignment:NSTextAlignmentCenter detailHeight:20];
    }
    else if (indexPath.row == EN_USER_INFO_IDCARD_ROW)
    {// 身份证号
        UIColor *color = [UIColor colorWithHexString:@"#646464"];
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"身份证号" attributes:@{NSFontAttributeName: FONTSIZE_12, NSForegroundColorAttributeName: color}];
        color = [UIColor colorWithHexString:@"#323232"];
        NSAttributedString *value = [[NSAttributedString alloc] initWithString:_userInfoEntity.identity_card attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
        [cell updateCellData:title titleWidth:_titleWidth attri:value alignment:NSTextAlignmentCenter detailHeight:20];
    }
    else if (indexPath.row == EN_USER_INFO_THIRDPAY_ROW)
    {// 第三方支付
        UIColor *color = [UIColor colorWithHexString:@"#646464"];
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"第三方支付" attributes:@{NSFontAttributeName: FONTSIZE_12, NSForegroundColorAttributeName: color}];
        color = [UIColor colorWithHexString:@"#323232"];
        NSAttributedString *value = [[NSAttributedString alloc] initWithString:_userInfoEntity.pay_account attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
        [cell updateCellData:title titleWidth:_titleWidth attri:value alignment:NSTextAlignmentCenter detailHeight:20];
    }
    return cell;
    /*
     EN_USER_INFO_NAME_ROW = 0, ///< 姓名
     EN_USER_INFO_SEX_ROW,   ///< 性别
     EN_USER_INFO_BIRTHDAY_ROW, ///< 出生日期
     EN_USER_INFO_PHONE_ROW, ///< 手机号码
     EN_USER_INFO_IDCARD_ROW,  ///< 身份证号
     EN_USER_INFO_THIRDPAY_ROW, ///< 第三方支付
     */
}

/*
 NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] init];
 NSString *str = [NSString stringWithFormat:@"%d人    ", (int)_travelEntity.peopleNumber];
 color = [UIColor colorWithHexString:@"#333333"];
 NSAttributedString *butedStr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: FONTSIZE_14, NSForegroundColorAttributeName: color}];
 [mas appendAttributedString:butedStr];
 
 str = @"客源地  ";
 color = [UIColor colorWithHexString:@"#999999"];
 butedStr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: FONTSIZE_14, NSForegroundColorAttributeName: color}];
 [mas appendAttributedString:butedStr];
 */




@end
