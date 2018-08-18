/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCMainPageViewController.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/14 12:03
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCMainPageViewController.h"
#import "LocalCommon.h"
#import "CTCMainHeaderView.h" // header
#import "CellCommonDataEntity.h"
#import "CTCMainPageViewCell.h"
#import "CTCMainMessageNoteCell.h"

#import "TYZShowImageInfoObject.h" // 上传图片
#import "UploadFileInputObject.h" // 上传图片出入参数
#import "UploadImageServerObject.h" // 上传到七牛平台
#import "CTCShopLicenseDataEntity.h"
#import "ShopListDataEntity.h"
#import "CTCUserAuthorObject.h"
#import "UIImageView+WebCache.h"

@interface CTCMainPageViewController ()
{
    
}

// 用户
@property (nonatomic, strong) UIImageView *btnUser;

/// 进入我的餐厅列表
@property (nonatomic, strong) UIButton *btnMyShop;

/// 权限
@property (nonatomic, strong) CTCUserAuthorObject *userAuthorEnt;

@property (nonatomic, strong) CTCMainHeaderView *headerView;

/**
 *  上传图片到服务器
 */
@property (nonatomic, strong) UploadImageServerObject *uploadImgServerObject;

/**
 *  上传图片的传入参数
 */
@property (nonatomic, strong) UploadFileInputObject *uploadFileInputEntity;

@property (nonatomic, strong) TYZShowImageInfoObject *showImageObject;

//- (void)initWithUploadImgObject;

- (void)initWithShowImageObject;

/**
 *  左上角的按钮
 */
- (void)initWithLeftItem;

/**
 *  右上角的按钮
 */
- (void)initWithRightItem;



@end

@implementation CTCMainPageViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    [self stepWithCommon];
    
    [_headerView updateViewData:@([UserLoginStateObject getUserInfo].shop_employee_count)];
    
    [self initWithRightItem];
    
    /*NSInteger userLoginType = [UserLoginStateObject readWithUserLoginType];
    NSString *cardId = objectNull([UserLoginStateObject getWithCardId]);
    if (userLoginType == EN_LOGIN_USER_BOSS_TYPE)
    {// 老板，身份证为空
        debugLog(@"老板身份");
        if ([cardId isEqualToString:@""])
        {
            // 绑定身份
            [MCYPushViewController showWithBindCardIdVC:self data:nil completion:nil];
            return;
        }
        else
        {
            NSInteger shopId = [UserLoginStateObject getCurrentShopId];
            if (shopId == 0)
            {// 表示没有餐厅
                [MCYPushViewController showWithOpenRestaurantZeroVC:self data:nil completion:nil];
                return;
            }
        }*/
        
//        NSInteger shopId = [UserLoginStateObject getCurrentShopId];
//        debugLog(@"shopId=%d", (int)shopId);
        // 获取资质信息
        /*[HCSNetHttp requestWithShopCertificate:[UserLoginStateObject getCurrentShopId] completion:^(TYZRespondDataEntity *result) {
            if (result.errcode == respond_success)
            {
                CTCShopLicenseDataEntity *licenseEnt = result.data;
                // 0未处理；1有问题；2成功
//                debugLog(@"display=%d", (int)licenseEnt.display);
                if (licenseEnt.display == 1)
                {
                    [MCYPushViewController showWithShopQualificationVC:self data:licenseEnt shopId:shopId completion:nil];
                }
            }
            else if (result.errcode == 1 && [result.msg isEqualToString:@"餐厅不存在"])
            {// 餐厅不存在
                [MCYPushViewController showWithOpenRestaurantZeroVC:self data:nil completion:nil];
            }
            else if (result.errcode == 1)
            {// 餐厅资质为空
                [MCYPushViewController showWithShopQualificationVC:self data:@"nodata" shopId:shopId completion:nil];
            }
            else
            {
                [UtilityObject svProgressHUDError:result viewContrller:self];
            }
        }];*/
        
//    }
    
    self.title = [UserLoginStateObject getCurrentShopName];
    
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
    
    _userAuthorEnt = [CTCUserAuthorObject new];
//    [self stepWithCommon];
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    // 左上角的按钮
    [self initWithLeftItem];
    
//    self.title = @"趁机四川食府";
    
//    NSInteger userLoginType = [UserLoginStateObject readWithUserLoginType];
    
    // 右上角的按钮
    [self initWithRightItem];
}

- (void)initWithSubView
{
    [super initWithSubView];
    
//    self.baseTableView.backgroundColor = [UIColor redColor];
    
//    CGRect frame = self.baseTableView.frame;
//    frame.size.height = frame.size.height - 10;
//    self.baseTableView.frame = frame;
    self.baseTableView.showsVerticalScrollIndicator = NO;
    self.baseTableView.showsHorizontalScrollIndicator = NO;
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)initWithHeaderView
{
    if (!_headerView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [CTCMainHeaderView getWithViewHeight]);
        _headerView = [[CTCMainHeaderView alloc] initWithFrame:frame];
        self.baseTableView.tableHeaderView = _headerView;
    }
    __weak typeof(self)weakSelf = self;
    _headerView.viewCommonBlock = ^(id data)
    {// 更新图片
//        [weakSelf.showImageObject showActionSheet:weakSelf];
    };
}

- (void)stepWithCommon
{
    [self.baseList removeAllObjects];
    [_userAuthorEnt getWithUserAuthor:self.baseList];
    
    
    
    if (!_uploadFileInputEntity)
    {
        _uploadFileInputEntity = [[UploadFileInputObject alloc] init];
    }
    _uploadFileInputEntity.userId = [UserLoginStateObject getUserId];
    _uploadFileInputEntity.shopId = [UserLoginStateObject getCurrentShopId];
    _uploadImgServerObject = [[UploadImageServerObject alloc] init];
    [self initWithShowImageObject];
    
    [self.baseTableView reloadData];
}



#pragma mark -
#pragma mark private init

/**
 *  左上角的按钮
 */
- (void)initWithLeftItem
{
    UIImage *image = [UIImage imageNamed:@"home_top_icon_head"];
    if (!_btnUser)
    {
        CGRect frame = CGRectMake(0, 0, 36, 36);
        debugLog(@"frame=%@", NSStringFromCGRect(frame));
        _btnUser = [[UIImageView alloc] initWithFrame:frame];
        _btnUser.layer.cornerRadius = frame.size.width / 2.;
        _btnUser.layer.masksToBounds = YES;
        _btnUser.image = image;
        _btnUser.userInteractionEnabled = YES;
//        UIButton *btnUser = [TYZCreateCommonObject createWithButton:self imgNameNor:@"home_top_icon_head" imgNameSel:@"home_top_icon_head" targetSel:@selector(clickedWithLeft:)];
//        btnUser.frame = frame;
//        btnUser.layer.cornerRadius = image.size.height / 2.;
//        btnUser.layer.masksToBounds = YES;
        UIBarButtonItem *userItem = [[UIBarButtonItem alloc] initWithCustomView:_btnUser];
        self.navigationItem.leftBarButtonItem = userItem;
//        self.btnUser = btnUser;
        __weak typeof(self)weakSelf = self;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
            [weakSelf clickedWithLeft:nil];
        }];
        [_btnUser addGestureRecognizer:tapGesture];
    }
    NSString *avatar = objectNull([UserLoginStateObject getUserInfo].avatar);
    if (![avatar isEqualToString:@""])
    {
        avatar = [NSString stringWithFormat:@"%@?t=%@&imageView2/0/q/40", avatar, [NSDate stringWithCurrentTimeStamp]];
        [_btnUser sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:image];
    }
//    _userInfoEntity.avatar = [NSString stringWithFormat:@"%@?t=%@&imageView2/0/q/40", _userInfoEntity.avatar, [NSDate stringWithCurrentTimeStamp]];
    
}

/**
 *  右上角的按钮
 */
- (void)initWithRightItem
{
    if (!_btnMyShop)
    {
        UIImage *image = [UIImage imageNamed:@"home_top_btn_cut"];
        CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
        UIButton *btnChange = [TYZCreateCommonObject createWithButton:self imgNameNor:@"home_top_btn_cut" imgNameSel:@"home_top_btn_cut" targetSel:@selector(clickedWithRight:)];
        btnChange.frame = frame;
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btnChange];
        self.navigationItem.rightBarButtonItem = rightItem;
        self.btnMyShop = btnChange;
    }
    
    _btnMyShop.hidden = YES;
    NSInteger userLoginType = [UserLoginStateObject readWithUserLoginType];
    if (userLoginType == EN_LOGIN_USER_BOSS_TYPE)
    {// 老板
        _btnMyShop.hidden = NO;
    }
    
}

- (void)initWithShowImageObject
{
    __weak typeof(self)weakSelf = self;
    if (!_showImageObject)
    {
        _showImageObject = [[TYZShowImageInfoObject alloc] init];
    }
    _showImageObject.imgSize = CGSizeMake([[UIScreen mainScreen] screenWidth], [CTCMainHeaderView getWithViewHeight]);
    _showImageObject.imgType = EN_IMAGE_LANDSCAPE_ACTION;
    _showImageObject.extName = @"jpg";
    _showImageObject.dissPickerHeadImgDataBlock = ^(NSData *data, NSString *imgName)
    {
        UIImage *image = [UIImage imageWithData:data];
//        debugLogSize(image.size);
        //        [weakSelf uploadImageToServer:data imageName:imgName];
    };
}

- (void)uploadImageToServer:(NSData *)data imageName:(NSString *)imageName
{
    //    debugLog(@"imageName=%@", imageName);
    [SVProgressHUD showWithStatus:@"上传中"];
    _uploadFileInputEntity.data = data;
    _uploadFileInputEntity.extName = _showImageObject.extName;
    
    debugLog(@"inputEnt=%@", [_uploadFileInputEntity modelToJSONString]);
    
//    __weak typeof(self)weakSelf = self;
    [_uploadImgServerObject getUploadFileToken:_uploadFileInputEntity complete:^(int status, NSString *host, NSString *filePath, NSInteger imageId) {
        debugLog(@"status=%d; filePath=%@", status, filePath);
        if (status == 1)
        {
//            [weakSelf uploadImageResponse:status urlPath:filePath];
        }
    }];
}

// 点击左上角的按钮
- (void)clickedWithLeft:(id)sender
{
//    debugMethod();
    [MCYPushViewController showWithUserInfoVC:self data:nil completion:^(id data) {
        [self initWithLeftItem];
    }];
}

// 点击右上角的按钮(餐厅列表)
- (void)clickedWithRight:(id)sender
{
    // 餐厅列表
    [MCYPushViewController showWithOpenRestaurantListVC:self data:nil completion:^(id data) {
        ShopListDataEntity *shopEnt = data;
        self.title = shopEnt.name;
    }];
}

- (void)touchWithType:(CellCommonDataEntity *)entity
{
    if ([entity.title isEqualToString:@"点菜下单"])
    {
        [MCYPushViewController showWithTakeOrderVC:self data:nil completion:nil];
    }
    else if ([entity.title isEqualToString:@"餐中订单"])
    {
        [MCYPushViewController showWithMealingOrderVC:self data:nil completion:nil];
    }
    else if ([entity.title isEqualToString:@"预定订单"])
    {
//        [TYZAlertAction showAlertWithTitle:@"提示" msg:@"敬请期待" chooseBlock:nil buttonsStatement:@"确定", nil];
        [MCYPushViewController showWithReservationOrderVC:self data:nil type:2 completion:nil];
    }
    else if ([entity.title isEqualToString:@"历史订单"])
    {
        [MCYPushViewController showWithFinishOrderVC:self data:nil completion:nil];
    }
    else if ([entity.title isEqualToString:@"外卖订单"])
    {
        [MCYPushViewController showWithDeliveryOrdersVC:self data:nil completion:nil];
    }
    else if ([entity.title isEqualToString:@"餐厅资料"])
    {
        [MCYPushViewController showWithRestaurantInfoVC:self data:nil completion:nil];
    }
    else if ([entity.title isEqualToString:@"菜单菜品"])
    {
        NSInteger shopId = [UserLoginStateObject getCurrentShopId];
        [MCYPushViewController showWithResaurantMenuEditVC:self data:@(shopId) completion:nil];
//        [MCYPushViewController showWithShopMenuVC:self data:@(shopId) completion:nil];
    }
    else if ([entity.title isEqualToString:@"餐位设置"])
    {
//        [MCYPushViewController showWithRestaurantRoomSpaceVC:self data:nil completion:nil];
        [MCYPushViewController showWithRoomSpaceVC:self data:nil completion:nil];
    }
    else if ([entity.title isEqualToString:@"员工管理"])
    {
//        [MCYPushViewController showWithRestaurantManagerVC:self data:nil completion:nil];
        [MCYPushViewController showWithRestaurantManagerEditVC:self data:nil completion:nil];
    }
    else if ([entity.title isEqualToString:@"出单档口"])
    {
        [MCYPushViewController showWithRestaurantMouthVC:self data:nil completion:nil];
    }
    else if ([entity.title isEqualToString:@"收益"])
    {
        
    }
    else if ([entity.title isEqualToString:@"报表"])
    {
        [MCYPushViewController showWithFinanceVC:self data:nil completion:nil];
    }
}

#pragma mark -
#pragma mark UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.baseList count] + 1;
//    return [self.baseList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    
    count = 1;
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    if (indexPath.section == 0)
    {
        CTCMainMessageNoteCell *cell = [CTCMainMessageNoteCell cellForTableView:tableView];
        
        return cell;
    }
    else
    {
        CTCMainPageViewCell *cell = [CTCMainPageViewCell cellForTableView:tableView];
        [cell updateCellData:self.baseList[indexPath.section-1]];
        cell.baseTableViewCellBlock = ^(id data)
        {
            [weakSelf touchWithType:data];
        };
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if (indexPath.section == 0)
    {
        height = kCTCMainMessageNoteCellHeight;
    }
    else
    {
        NSArray *array = self.baseList[indexPath.section-1];
        
        NSInteger col = ceilf(array.count / 3.);
        height = col * [[UIScreen mainScreen] screenWidth] / 3.;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.001;
    }
    return 30.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return nil;
    }
    CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], 30);
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    UILabel *label = [TYZCreateCommonObject createWithLabel:view labelFrame:CGRectMake(10, 0, 100, 30) textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
    NSString *str = nil;
    
    
    NSInteger count = self.baseList.count;
    if (count == 3)
    {
        if (section == 0)
        {
            str = @"订单";
        }
        else if (section == 1)
        {
            str = @"财务";
        }
        else if (section == 2)
        {
            str = @"设置";
        }
    }
    else if (count == 2)
    {
        if (section == 0)
        {
            if (_userAuthorEnt.isOrderOps)
            {
                str = @"订单";
            }
            else if (_userAuthorEnt.isFiance)
            {
                str = @"财务";
            }
            else if (_userAuthorEnt.isSetting)
            {
                str = @"设置";
            }
        }
        else if (section == 1)
        {
            if (_userAuthorEnt.isFiance)
            {
                str = @"财务";
            }
            else if (_userAuthorEnt.isSetting)
            {
                str = @"设置";
            }
        }
    }
    else if (count == 1)
    {
        if (_userAuthorEnt.isOrderOps)
        {
            str = @"订单";
        }
        else if (_userAuthorEnt.isFiance)
        {
            str = @"财务";
        }
        else if (_userAuthorEnt.isSetting)
        {
            str = @"设置";
        }
    }
    
    
    label.text = str;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0)
    {// 消息
        [MCYPushViewController showWithReservationOrderVC:self data:nil type:1 completion:^(id data) {
            
        }];
    }
}

@end








