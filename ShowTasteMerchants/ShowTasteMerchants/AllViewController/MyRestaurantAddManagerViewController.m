//
//  MyRestaurantAddManagerViewController.m
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/3.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantAddManagerViewController.h"
#import "LocalCommon.h"
#import "CTCUserInfoViewCell.h"
#import "CellCommonDataEntity.h"
#import "CTCUserInfoHeadViewCell.h"
#import "CTCRestaurantManagerChoicePermisView.h"
#import "ShopPositionDataEntity.h"
#import "ShopManageInputEntity.h"
#import "ShopListDataEntity.h"

@interface MyRestaurantAddManagerViewController ()

@property (nonatomic, strong) CTCRestaurantManagerChoicePermisView *choicePermisView;

@property (nonatomic, strong) ShopManageInputEntity *inputEntity;

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)initWithStep;

@end

@implementation MyRestaurantAddManagerViewController

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
    
    [self initWithStep];
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
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)initWithStep
{
    [self.baseList removeAllObjects];
    /*
     EN_EDIT_MANAGER_HEADER_ROW = 0, ///< 头像
     EN_EDIT_MANAGER_NAME_ROW,       ///< 姓名
     EN_EDIT_MANAGER_PHONE_ROW,      ///< 手机号码
     EN_EDIT_MANAGER_ROLE_ROW,       ///< 角色
     EN_EDIT_MANAGER_PASSWORD_ROW,   ///< 密码
     EN_EDIT_MANAGER_MGSHOP_ROW,     ///< 管理餐厅
     */
    CellCommonDataEntity *ent = nil;
    
    // 头像
    ent = [CellCommonDataEntity new];
    ent.title = @"头像";
    ent.thumalImgName = @"";
    [self.baseList addObject:ent];
    
    // 手机号码
    ent = [CellCommonDataEntity new];
    ent.title = @"手机号";
    if (_managerEntity)
    {
        ent.subTitle = _managerEntity.mobile;
    }
    else
    {
        ent.subTitle = @"";
        ent.placeholder = @"请输入手机号";
    }
    [self.baseList addObject:ent];
    
    // 姓名
    ent = [CellCommonDataEntity new];
    ent.title = @"姓名";
    if (_managerEntity)
    {
        ent.subTitle = _managerEntity.username;
    }
    else
    {
        ent.subTitle = @"无";
        ent.placeholder = @"输入姓名";
    }
    [self.baseList addObject:ent];
    
    // 角色
    ent = [CellCommonDataEntity new];
    ent.title = @"角色";
    ent.subTitle = @"管理员";
    [self.baseList addObject:ent];
    
    // 密码
//    ent = [CellCommonDataEntity new];
//    ent.title = @"密码";
//    ent.subTitle = @"******";
//    [self.baseList addObject:ent];
    
    // 管理餐厅
    ent = [CellCommonDataEntity new];
    ent.title = @"管理餐厅";
    ent.subTitle = @"";
    [self.baseList addObject:ent];
    
    
    
    ShopManageInputEntity *inent = [ShopManageInputEntity new];
    inent.shopList = [NSMutableArray array];
    self.inputEntity = inent;
    _inputEntity.auth = 2;
    _inputEntity.authName = @"管理员";
    if (!_isAdd)
    {// 修改
        _inputEntity.userId = _managerEntity.user_id;
        _inputEntity.userName = _managerEntity.username;
        _inputEntity.mobile = _managerEntity.mobile;
//        _inputEntity.title = _managerEntity.title_id;
//        _inputEntity.titleName = _managerEntity.title_name;
        _inputEntity.auth = _managerEntity.role_id;
        _inputEntity.authName = _managerEntity.role_name;
//        _inputEntity.password = @"******";
        [_inputEntity.shopList addObjectsFromArray:_managerEntity.shopList];
    }
    ent.subTitle = [NSString stringWithFormat:@"%d", (int)_inputEntity.shopList.count];
    [self.baseTableView reloadData];
}

- (void)saveWithInfo:(id)sender
{
//    if ([objectNull(_inputEntity.userName) isEqualToString:@""])
//    {
//        [SVProgressHUD showErrorWithStatus:@"请输入姓名"];
//        return;
//    }
//    if ([objectNull(_inputEntity.titleName) isEqualToString:@""])
//    {
//        [SVProgressHUD showErrorWithStatus:@"请选择职位"];
//        return;
//    }
    if ([objectNull(_inputEntity.mobile) isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return;
    }
    
    if ([_inputEntity.shopList count] == 0)
    {
        [SVProgressHUD showInfoWithStatus:@"请加入管理餐厅"];
        return;
    }
    
    NSMutableString *mutStr = [[NSMutableString alloc] initWithCapacity:0];
    for (ShopListDataEntity *shopEnt in _inputEntity.shopList)
    {
        if ([mutStr length] == 0)
        {
            [mutStr appendFormat:@"%d", (int)shopEnt.shop_id];
        }
        else
        {
            [mutStr appendFormat:@",%d", (int)shopEnt.shop_id];
        }
    }
    
//    _inputEntity.shopId = [UserLoginStateObject getCurrentShopId];
    debugLog(@"userInfo=%@", [_inputEntity modelToJSONString]);
    if (_isAdd)
    {// 增加
        
        [SVProgressHUD showWithStatus:@"添加中"];
        [HCSNetHttp requestWithUserGetUserNameByMobile:_inputEntity.mobile completion:^(TYZRespondDataEntity *result) {
            if (result.errcode == respond_success)
            {
                _inputEntity.userName = objectNull(result.data);
                [self.baseTableView reloadData];
                
                _inputEntity.sellerId = [UserLoginStateObject getUserInfo].seller_id;
                
                [HCSNetHttp requestWithSellerCreateManager:_inputEntity.sellerId mobile:_inputEntity.mobile shopIds:mutStr completion:^(id result) {
                    [self reponseWithEditManage:result];
                }];
            }
            else
            {
                [UtilityObject svProgressHUDError:result viewContrller:self];
            }
        }];
    }
    else
    {// 修改
        debugLog(@"修改");
        // ******
        [SVProgressHUD showWithStatus:@"修改中"];
        _inputEntity.userId = _managerEntity.user_id;
        _inputEntity.sellerId = [UserLoginStateObject getUserInfo].seller_id;
        
        [HCSNetHttp requestWithSellerSetManageShop:_inputEntity.userId sellerId:_inputEntity.sellerId shopIds:mutStr completion:^(id result) {
            [self reponseWithEditManage:result];
        }];
    }
}

- (void)reponseWithEditManage:(TYZRespondDataEntity *)respond
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
            ent.seller_id = [UserLoginStateObject getUserInfo].seller_id;
            self.popResultBlock(ent);
        }
        if (_isAdd)
        {//  添加
            [SVProgressHUD showSuccessWithStatus:@"添加成功"];
            // 重新初始化
//            [self initWithStep];
            [self clickedBack:nil];
        }
        else
        {// 修改
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            _managerEntity.shopList = _inputEntity.shopList;
            if (self.popResultBlock)
            {
                self.popResultBlock(_managerEntity);
            }
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
//        [blockSelf updateWithPermis:data];
    };
    
    if (show)
    {
        NSMutableArray *addList = [NSMutableArray new];
        ShopPositionDataEntity *ent = [ShopPositionDataEntity new];
        ent.name = @"管理员";
        [addList addObject:ent];
        ent = [ShopPositionDataEntity new];
        ent.name = @"老板";
        [addList addObject:ent];
        ent = [ShopPositionDataEntity new];
        ent.name = @"创建者";
        [addList addObject:ent];
        
        // 角色
        [_choicePermisView updateWithData:addList title:@"选择角色"];
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

/// 添加或者修改
- (void)addEdit:(NSArray *)array
{
//    ShopListDataEntity
    [_inputEntity.shopList removeAllObjects];
    [_inputEntity.shopList addObjectsFromArray:array];
    
    CellCommonDataEntity *ent = self.baseList[_indexPath.row];
    ent.subTitle = [NSString stringWithFormat:@"%d", (int)_inputEntity.shopList.count];
    [self.baseTableView reloadData];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.baseList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == EN_EDIT_MANAGER_HEADER_ROW)
    {// 头像
        CTCUserInfoHeadViewCell *cell = [CTCUserInfoHeadViewCell cellForTableView:tableView];
        [cell updateCellData:self.baseList[indexPath.row]];
        [cell hiddenBottomLine:NO];
        return cell;
    }
    else
    {
        CTCUserInfoViewCell *cell = [CTCUserInfoViewCell cellForTableView:tableView];
        [cell updateCellData:self.baseList[indexPath.row]];
        if (indexPath.row == [self.baseList count] - 1)
        {
            [cell updateCellData:nil title:nil hiddenLine:YES isModify:YES];
        }
        else
        {
            [cell updateCellData:nil title:nil hiddenLine:NO isModify:YES];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == EN_EDIT_MANAGER_HEADER_ROW)
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
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.indexPath = indexPath;
    __weak typeof(self)weakSelf = self;
    CellCommonDataEntity *ent = self.baseList[indexPath.row];
    
    if (indexPath.row == EN_EDIT_MANAGER_HEADER_ROW)
    {// 头像
        
    }
    /*else if (indexPath.row == EN_EDIT_MANAGER_NAME_ROW)
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
    }*/
    else if (indexPath.row == EN_EDIT_MANAGER_PHONE_ROW)
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
    else if (indexPath.row == EN_EDIT_MANAGER_ROLE_ROW)
    {// 角色
//        [self showWithPermisView:YES];
    }
    /*else if (indexPath.row == EN_EDIT_MANAGER_PASSWORD_ROW)
    {// 密码
        NSString *str = @"";
        if ([ent.subTitle isEqualToString:@"无"])
        {
            str = @"";
        }
        NSDictionary *param = @{@"title":ent.title, @"data":str, @"placeholder":@"请输入密码", @"singleRow":@(YES), @"isNumber":@(NO)};
        [MCYPushViewController showWithModifyInfoVC:self data:param completion:^(id data) {
            ent.subTitle = ([objectNull(data) isEqualToString:@""]?@"******":objectNull(data));
//            weakSelf.inputEntity.password = data;
            [MCYPushViewController reloadWithTableView:tableView indexPath:indexPath reloadType:3];
        }];
    }*/
    else if (indexPath.row == EN_EDIT_MANAGER_MGSHOP_ROW)
    {// 管理餐厅
        [MCYPushViewController showWithSelectShopVC:self allShops:nil selShops:_inputEntity.shopList completion:^(id data) {
            if (data)
            {
                [self addEdit:data];
            }
        }];
    }
}

/*
 EN_EDIT_MANAGER_HEADER_ROW = 0, ///< 头像
 EN_EDIT_MANAGER_NAME_ROW,       ///< 姓名
 EN_EDIT_MANAGER_PHONE_ROW,      ///< 手机号码
 EN_EDIT_MANAGER_ROLE_ROW,       ///< 角色
 EN_EDIT_MANAGER_PASSWORD_ROW,   ///< 密码
 EN_EDIT_MANAGER_MGSHOP_ROW,     ///< 管理餐厅
 */

@end





















