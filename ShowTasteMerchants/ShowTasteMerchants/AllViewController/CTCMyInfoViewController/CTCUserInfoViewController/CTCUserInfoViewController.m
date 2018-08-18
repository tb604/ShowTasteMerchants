/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCUserInfoViewController.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/21 14:10
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCUserInfoViewController.h"
#import "LocalCommon.h"
#import "CTCUserInfoViewCell.h"
#import "CellCommonDataEntity.h"
#import "CTCUserInfoHeadViewCell.h"
#import "UploadImageServerObject.h"
#import "UploadImageObject.h"
#import "CTCUserInfoFooterView.h"

@interface CTCUserInfoViewController ()
{
    /// 1表示老板登录；2表示员工登录
    NSInteger _loginType;
    
    CTCUserInfoFooterView *_footerView;
    
}

/**
 *  上传图片到服务器
 */
@property (nonatomic, strong) UploadImageServerObject *uploadImgServerObject;

@property (nonatomic, strong) UploadImageObject *uploadImgObject;

@property (nonatomic, strong) UserInfoDataEntity *userInfoEntity;


- (void)initWithUploadImgObject;

@end

@implementation CTCUserInfoViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.userInfoEntity = [UserLoginStateObject getUserInfo];
    
    _userInfoEntity.avatar = [NSString stringWithFormat:@"%@?t=%@&imageView2/0/q/40", _userInfoEntity.avatar, [NSDate stringWithCurrentTimeStamp]];
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


- (void)initWithVar
{
    [super initWithVar];
    
    _loginType = [UserLoginStateObject readWithUserLoginType];
    
    // 员工(头像、姓名、职位、权限、手机号码、密码)
    
    // 老板(头像、姓名、身份证号、手机号码、密码)
    
    [self initWithUploadImgObject];
    
    _uploadImgServerObject = [[UploadImageServerObject alloc] init];
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = @"个人信息";
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)clickedBack:(id)sender
{
    if (self.popResultBlock)
    {
        self.popResultBlock(nil);
    }
    [super clickedBack:sender];
}

- (void)initWithFooterView
{
    if (!_footerView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kCTCUserInfoFooterViewHeight);
        _footerView = [[CTCUserInfoFooterView alloc] initWithFrame:frame];
        self.baseTableView.tableFooterView = _footerView;
    }
    __weak typeof(self)weakSelf = self;
    _footerView.viewCommonBlock = ^(id data)
    {
        [weakSelf userOutLogin];
    };
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
    
    //  更新头像
    [self.baseTableView reloadData];
}

// 退出登录
- (void)userOutLogin
{
    [UserLoginStateObject saveLoginState:EUserUnlogin];
    [self.navigationController popViewControllerAnimated:NO];
    
    AppDelegate *app = [UtilityObject appDelegate];
    [app loadRootVC];
    
//    [self performSelector:@selector(clickedBack:) withObject:nil afterDelay:1];
    
    // 登陆后，给圈子发送通知，更改
    //    [[NSNotificationCenter defaultCenter] postNotificationName:kKitchenCircleNote object:nil];
}

#pragma mark -
#pragma mark UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return EN_UINFO_MAX_SECTION;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == EN_UINFO_HEADIMAGE_SECTION)
    {
        return 1;
    }
    else if (section == EN_UINFO_BAICINFO_SECTION)
    {
        if (_loginType == 1)
        {// 老板
            return EN_UINFO_BAICINFO_MAX_ROW - 1;
        }
        else
        {// 员工
            return EN_UINFO_BAICINFO_MAX_ROW;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == EN_UINFO_HEADIMAGE_SECTION)
    {
        CTCUserInfoHeadViewCell *cell = [CTCUserInfoHeadViewCell cellForTableView:tableView];
        [cell updateCellData:_userInfoEntity.avatar title:@"头像"];
        [cell hiddenBottomLine:YES];
        return cell;
    }
    else
    {
        // 员工(头像、姓名、职位、权限、手机号码、密码)
        
        // 老板(头像、姓名、身份证号、手机号码、密码)
        CTCUserInfoViewCell *cell = [CTCUserInfoViewCell cellForTableView:tableView];
        if (indexPath.row == EN_UINFO_BAICINFO_NAME_ROW)
        {// 姓名
            [cell updateCellData:objectNull(_userInfoEntity.username) title:@"姓名" hiddenLine:NO isModify:NO];
            [cell hiddenWithThanImgView:YES];
        }
        if (_loginType == 1)
        {// 老板
            if (indexPath.row == EN_UINFO_BAICINFO_AUTHOR_ROW - 1)
            {// 身份证号
                [cell updateCellData:objectNull(_userInfoEntity.identity_card) title:@"身份证号" hiddenLine:NO isModify:NO];
                [cell hiddenWithThanImgView:YES];
            }
            else if (indexPath.row == EN_UINFO_BAICINFO_PHONE_ROW - 1)
            {// 手机号码
                [cell updateCellData:objectNull(_userInfoEntity.mobile) title:@"手机号码" hiddenLine:NO isModify:YES];
                [cell hiddenWithThanImgView:NO];
            }
            else if (indexPath.row == EN_UINFO_BAICINFO_PWD_ROW - 1)
            {// 密码
                [cell updateCellData:@"*****" title:@"密码" hiddenLine:YES isModify:YES];
                [cell hiddenWithThanImgView:NO];
            }
        }
        else
        {// 员工
            if (indexPath.row == EN_UINFO_BAICINFO_POST_ROW)
            {// 职位
                [cell updateCellData:objectNull(_userInfoEntity.title_name) title:@"职位" hiddenLine:NO isModify:NO];
                [cell hiddenWithThanImgView:YES];
            }
            else if (indexPath.row == EN_UINFO_BAICINFO_AUTHOR_ROW)
            {// 权限
                [cell updateCellData:objectNull(_userInfoEntity.role_name) title:@"权限" hiddenLine:NO isModify:NO];
                [cell hiddenWithThanImgView:YES];
            }
            else if (indexPath.row == EN_UINFO_BAICINFO_PHONE_ROW)
            {// 手机号码
                [cell updateCellData:objectNull(_userInfoEntity.mobile) title:@"手机号码" hiddenLine:NO isModify:YES];
                [cell hiddenWithThanImgView:NO];
            }
            else if (indexPath.row == EN_UINFO_BAICINFO_PWD_ROW)
            {// 密码
                [cell updateCellData:@"*****" title:@"密码" hiddenLine:YES isModify:YES];
                [cell hiddenWithThanImgView:NO];
            }
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == EN_UINFO_HEADIMAGE_SECTION)
    {
        return kCTCUserInfoHeadViewCellHeight;
    }
    else
    {
        return kCTCUserInfoViewCellHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == EN_UINFO_HEADIMAGE_SECTION)
    {
        return 0.001;
    }
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == EN_UINFO_HEADIMAGE_SECTION)
    {// 头像
        [_uploadImgObject showActionSheet:self];
    }
    else
    {
        if (_loginType == 1)
        {// 老板
            if (indexPath.row == EN_UINFO_BAICINFO_PHONE_ROW - 1)
            {// 手机号码
                UserUpdateInputEntity *userEntity = [UserUpdateInputEntity new];
                userEntity.mobile = _userInfoEntity.mobile;
                userEntity.smschannel = EN_SMS_CHANNEL_TYPE_CURPHONE;
                [MCYPushViewController showWithModifyMobileVC:self data:userEntity completion:^(id data) {
                    
                }];
            }
            else if (indexPath.row == EN_UINFO_BAICINFO_PWD_ROW - 1)
            {// 密码
                [MCYPushViewController showWithModifyPswVC:self data:_userInfoEntity completion:^(id data) {
                    //                [self reloadUserInfo:indexPath reData:data];
                }];
            }
        }
        else
        {// 员工
            if (indexPath.row == EN_UINFO_BAICINFO_PHONE_ROW)
            {// 手机号码
                UserUpdateInputEntity *userEntity = [UserUpdateInputEntity new];
                userEntity.mobile = _userInfoEntity.mobile;
                userEntity.smschannel = EN_SMS_CHANNEL_TYPE_CURPHONE;
                [MCYPushViewController showWithModifyMobileVC:self data:userEntity completion:^(id data) {
                    
                }];
            }
            else if (indexPath.row == EN_UINFO_BAICINFO_PWD_ROW)
            {// 密码
                [MCYPushViewController showWithModifyPswVC:self data:_userInfoEntity completion:^(id data) {
//                    [self reloadUserInfo:indexPath reData:data];
                }];
            }
        }
    }
}

@end
















