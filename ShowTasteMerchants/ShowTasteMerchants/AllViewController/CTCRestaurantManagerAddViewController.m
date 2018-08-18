/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCRestaurantManagerAddViewController.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/20 22:21
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCRestaurantManagerAddViewController.h"
#import "LocalCommon.h"
#import "CTCRestaurantManagerAddCell.h"
#import "CellCommonDataEntity.h"
#import "CTCRestaurantManagerAddFooterView.h"
#import "CTCRestaurantManagerChoicePermisView.h"
#import "ShopManageInputEntity.h"

@interface CTCRestaurantManagerAddViewController ()
{
    CTCRestaurantManagerAddFooterView *_footerView;
}

@property (nonatomic, strong) CTCRestaurantManagerChoicePermisView *choicePermisView;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) ShopManageInputEntity *inputEntity;

@property (nonatomic, strong) ShopPositionDataEntity *selectedEntity;

@end

@implementation CTCRestaurantManagerAddViewController

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
    
    
    [self initWithSetup];
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    if (_isAdd)
    {
        self.title = @"添加";
    }
    else
    {
        self.title = @"编辑";
    }
    
    NSString *str = @"保存";
    float width = [str widthForFont:FONTSIZE_16];
    UIButton *btnSave = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:str titleColor:[UIColor whiteColor] titleFont:FONTSIZE_16 targetSel:@selector(saveWithInfo:)];
    btnSave.frame = CGRectMake(0, 0, width, 30);
    
    UIBarButtonItem *itemSave = [[UIBarButtonItem alloc] initWithCustomView:btnSave];
    self.navigationItem.rightBarButtonItem = itemSave;
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.baseTableView.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    
}

- (void)initWithSetup
{
    [self.baseList removeAllObjects];
    CellCommonDataEntity *ent = [CellCommonDataEntity new];
    ent.title = @"姓名";
    if (_managerEntity)
    {
        ent.subTitle = objectNull(_managerEntity.username);
    }
    else
    {
        ent.subTitle = @"无";
    }
    [self.baseList addObject:ent];
    
    ent = [CellCommonDataEntity new];
    ent.title = @"职位";
    if (_managerEntity)
    {
        ent.subTitle = _managerEntity.title_name;
    }
    else
    {
        ent.subTitle = @"无";
    }
    [self.baseList addObject:ent];
    
    ent = [CellCommonDataEntity new];
    ent.title = @"手机号码";
    if (_managerEntity)
    {
        ent.subTitle = _managerEntity.mobile;
    }
    else
    {
        ent.subTitle = @"无";
    }
    [self.baseList addObject:ent];
    
    ent = [CellCommonDataEntity new];
    ent.title = @"密码";
    if (_managerEntity)
    {
        ent.subTitle = @"******";
    }
    else
    {
        ent.subTitle = @"无";
    }
    [self.baseList addObject:ent];
    
    ent = [CellCommonDataEntity new];
    ent.title = @"权限";
    if (_managerEntity)
    {
        ent.subTitle = _managerEntity.role_name;
    }
    else
    {
        ent.subTitle = @"无";
    }
    [self.baseList addObject:ent];
    
    //    ShopManageNewDataEntity
    ShopManageInputEntity *inent = [ShopManageInputEntity new];
    self.inputEntity = inent;
    if (!_isAdd)
    {// 修改
        _inputEntity.userId = _managerEntity.user_id;
        _inputEntity.userName = _managerEntity.username;
        _inputEntity.mobile = _managerEntity.mobile;
        _inputEntity.title = _managerEntity.title_id;
        _inputEntity.titleName = _managerEntity.title_name;
        _inputEntity.auth = _managerEntity.role_id;
        _inputEntity.authName = _managerEntity.role_name;
        _inputEntity.password = @"******";
    }
    
    [self.baseTableView reloadData];
}

- (void)initWithFooterView
{
    if (!_footerView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kCTCRestaurantManagerAddFooterViewHeight);
        _footerView = [[CTCRestaurantManagerAddFooterView alloc] initWithFrame:frame];
        self.baseTableView.tableFooterView = _footerView;
    }
    __weak typeof(self)weakSelf = self;
    _footerView.viewCommonBlock = ^(id data)
    {// 查看权限说明
        [MCYPushViewController showWithShopManagePerMissVC:weakSelf data:nil completion:nil];
    };
}

/// 保存
- (void)saveWithInfo:(id)sender
{
    
    if ([objectNull(_inputEntity.userName) isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入姓名"];
        return;
    }
    if ([objectNull(_inputEntity.titleName) isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"请选择职位"];
        return;
    }
    if ([objectNull(_inputEntity.mobile) isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return;
    }
    
    
    _inputEntity.shopId = [UserLoginStateObject getCurrentShopId];
    _inputEntity.sellerId = [UserLoginStateObject getUserInfo].seller_id;
    debugLog(@"userInfo=%@", [_inputEntity modelToJSONString]);
    
    if (_isAdd)
    {// 增加
        debugLog(@"添加");
        if ([objectNull(_inputEntity.password) isEqualToString:@""])
        {
            [SVProgressHUD showErrorWithStatus:@"请输入密码"];
            return;
        }
        
        if ([objectNull(_inputEntity.authName) isEqualToString:@""])
        {
            [SVProgressHUD showErrorWithStatus:@"请选择权限"];
            return;
        }
        [SVProgressHUD showWithStatus:@"添加中"];
        [HCSNetHttp requestWithUserCreateEmployee:_inputEntity completion:^(id result) {
            [self reponseWithEditEmployee:result];
        }];
    }
    else
    {// 修改
        debugLog(@"修改");
        // ******
        if ([objectNull(_inputEntity.password) isEqualToString:@""])
        {
            [SVProgressHUD showErrorWithStatus:@"请输入密码"];
            return;
        }
        [SVProgressHUD showWithStatus:@"修改中"];
        _inputEntity.userId = _managerEntity.user_id;
        [HCSNetHttp requestWithUserSetEmployee:_inputEntity completion:^(id result) {
            [self reponseWithEditEmployee:result];
        }];
    }
}

- (void)reponseWithEditEmployee:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success)
    {
        if (self.popResultBlock)
        {
            ShopManageNewDataEntity *ent = [ShopManageNewDataEntity new];
            ent.user_id = _inputEntity.userId;
            ent.username = _inputEntity.userName;
            ent.title_id = _inputEntity.title;
            ent.title_name = _inputEntity.titleName;
            ent.role_id = _inputEntity.auth;
            ent.role_name = _inputEntity.authName;
            ent.mobile = _inputEntity.mobile;
            self.popResultBlock(ent);
        }
        if (_isAdd)
        {//  添加
            [SVProgressHUD showSuccessWithStatus:@"添加成功"];
            [self clickedBack:nil];
            // 重新初始化
//            [self initWithSetup];
        }
        else
        {// 修改
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            [self clickedBack:nil];
        }
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
}

- (void)showWithPermisView:(BOOL)show
{
    __weak typeof(self)blockSelf = self;
    if (!_choicePermisView)
    {
        _choicePermisView = [[CTCRestaurantManagerChoicePermisView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight])];
        _choicePermisView.alpha = 0;
    }
    _choicePermisView.touchWithHiddenBlock = ^()
    {
        [blockSelf showWithPermisView:NO];
    };
    _choicePermisView.touchWithSubmitBlock = ^(id data)
    {
        [blockSelf updateWithPermis:data];
    };
    
    if (show)
    {
        if (_indexPath.row == EN_EMPLOYE_MANAGE_PROFESS_ROW)
        {// 职位
            [_choicePermisView updateWithData:_postionAuthEntity.titles title:@"选择职称"];
        }
        else if (_indexPath.row == EN_EMPLOYE_MANAGE_PERMISS_ROW)
        {// 权限
            [_choicePermisView updateWithData:_postionAuthEntity.roles title:@"选择权限"];
        }
        [self.view.window addSubview:_choicePermisView];
        [UIView animateWithDuration:0.5 animations:^{
            _choicePermisView.alpha = 1.0;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            _choicePermisView.alpha = 0;
        } completion:^(BOOL finished) {
            [_choicePermisView removeFromSuperview];
        }];
    }
}

- (void)updateWithPermis:(ShopPositionDataEntity *)ent
{
    self.selectedEntity = ent;
    CellCommonDataEntity *updateEnt = self.baseList[self.indexPath.row];
    updateEnt.subTitle = ent.name;
    [MCYPushViewController reloadWithTableView:self.baseTableView indexPath:self.indexPath reloadType:3];
    [self showWithPermisView:NO];
    
    if (_indexPath.row == EN_EMPLOYE_MANAGE_PROFESS_ROW)
    {// 职称
        self.inputEntity.title = ent.id;
        self.inputEntity.titleName = ent.name;
    }
    else if (_indexPath.row == EN_EMPLOYE_MANAGE_PERMISS_ROW)
    {// 权限
        self.inputEntity.auth = ent.id;
        self.inputEntity.authName = ent.name;
    }
}


#pragma mark -
#pragma mark UITableViewDelegate, UITableViewDataSource

/*
 EN_EMPLOYE_MANAGE_NAME_ROW = 0,   ///< 姓名
 EN_EMPLOYE_MANAGE_PROFESS_ROW,  ///< 职称
 EN_EMPLOYE_MANAGE_PHONE_ROW, ///< 手机号码
 EN_EMPLOYE_MANAGE_PASSWORD_ROW,    ///< 密码
 EN_EMPLOYE_MANAGE_PERMISS_ROW, ///< 权限
 EN_EMPLOYE_MANAGE_MAX_ROW
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return EN_EMPLOYE_MANAGE_MAX_ROW;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CTCRestaurantManagerAddCell *cell = [CTCRestaurantManagerAddCell cellForTableView:tableView tableViewCellStyle:UITableViewCellStyleDefault];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell updateCellData:self.baseList[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCTCRestaurantManagerAddCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.indexPath = indexPath;
    __block CellCommonDataEntity *ent = self.baseList[indexPath.row];
    __weak typeof(self)weakSelf = self;
    if (indexPath.row == EN_EMPLOYE_MANAGE_NAME_ROW)
    {// 姓名
        NSString *str = ent.subTitle;
        if ([ent.subTitle isEqualToString:@"无"])
        {
            str = @"";
        }
        NSDictionary *param = @{@"title":ent.title, @"data":str, @"placeholder":@"请输入姓名", @"singleRow":@(YES), @"isNumber":@(NO)};
        [MCYPushViewController showWithModifyInfoVC:self data:param completion:^(id data) {
            weakSelf.inputEntity.userName = data;
            ent.subTitle = data;
            [MCYPushViewController reloadWithTableView:tableView indexPath:indexPath reloadType:3];
        }];
    }
    else if (indexPath.row == EN_EMPLOYE_MANAGE_PROFESS_ROW)
    {// 职称
        [self showWithPermisView:YES];
    }
    else if (indexPath.row == EN_EMPLOYE_MANAGE_PHONE_ROW)
    {// 手机号码
        NSString *str = ent.subTitle;
        if ([ent.subTitle isEqualToString:@"无"])
        {
            str = @"";
        }
        NSDictionary *param = @{@"title":ent.title, @"data":str, @"placeholder":@"请输入手机号", @"singleRow":@(YES), @"isNumber":@(YES)};
        [MCYPushViewController showWithModifyInfoVC:self data:param completion:^(id data) {
            ent.subTitle = data;
            weakSelf.inputEntity.mobile = data;
            [MCYPushViewController reloadWithTableView:tableView indexPath:indexPath reloadType:3];
        }];
    }
    else if (indexPath.row == EN_EMPLOYE_MANAGE_PASSWORD_ROW)
    {// 密码
        NSString *str = @"";
        if ([ent.subTitle isEqualToString:@"无"])
        {
            str = @"";
        }
        NSDictionary *param = @{@"title":ent.title, @"data":str, @"placeholder":@"请输入密码", @"singleRow":@(YES), @"isNumber":@(NO)};
        [MCYPushViewController showWithModifyInfoVC:self data:param completion:^(id data) {
            ent.subTitle = data;
            weakSelf.inputEntity.password = data;
            [MCYPushViewController reloadWithTableView:tableView indexPath:indexPath reloadType:3];
        }];
    }
    else if (indexPath.row == EN_EMPLOYE_MANAGE_PERMISS_ROW)
    {// 权限
        [self showWithPermisView:YES];
    }
}

/*
 EN_EMPLOYE_MANAGE_NAME_ROW = 0,   ///< 姓名
 EN_EMPLOYE_MANAGE_PROFESS_ROW,  ///< 职称
 EN_EMPLOYE_MANAGE_PHONE_ROW, ///< 手机号码
 EN_EMPLOYE_MANAGE_PASSWORD_ROW,    ///< 密码
 EN_EMPLOYE_MANAGE_PERMISS_ROW, ///< 权限
 EN_EMPLOYE_MANAGE_MAX_ROW
 */

@end


















