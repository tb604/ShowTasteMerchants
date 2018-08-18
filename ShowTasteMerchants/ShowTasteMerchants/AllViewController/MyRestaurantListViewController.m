//
//  MyRestaurantListViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/7.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantListViewController.h"
#import "LocalCommon.h"
#import "MyRestaurantListViewCell.h"
#import "ShopListDataEntity.h"
#import "UserLoginStateObject.h"
#import "OpenRestaurantInputEntity.h"
#import "CTCLoginViewController.h"
#import "CTCShopQualificationViewController.h" // 资质审核视图控制器
#import "TYZPopMenu.h" // popMenu
#import "CTCMainPageViewController.h"

@interface MyRestaurantListViewController () <UIAlertViewDelegate>
{
    UIButton *_btnMore;
    
    BOOL _isAdd;
    
    /// 是否有我创建的店
    BOOL _isMyCreateShop;
    
}

@property (nonatomic, strong) ShopListDataEntity *selectShopEntity;

@property (nonatomic, strong) TYZPopMenuConfiguration *popMenuConfig;
@property (nonatomic, strong) NSMutableArray *popMenuList;

- (void)restaurantListData;


@end

@implementation MyRestaurantListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    self.navigationController.navigationBarHidden = NO;
    
    if (_isAdd)
    {
        [self doRefreshData];
    }
    _isAdd = NO;
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
    
    _isAdd = NO;
    
    if ([_shopList count] > 0)
    {
        [self.baseList addObjectsFromArray:_shopList];
    }
    
    _isMyCreateShop = NO;
    
    _popMenuList = [NSMutableArray new];
    
    _selectShopEntity = [ShopListDataEntity new];
    _selectShopEntity.shop_id = [UserLoginStateObject getCurrentShopId];
    _selectShopEntity.state = [UserLoginStateObject getUserInfo].shop_state;
    
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = @"我的餐厅";
    
    // btn_add_shop
//    if (_comeType != 2)
//    {
        // 创建餐厅
        UIImage *image = [UIImage imageNamed:@"restaurant_btn_more"];
        CGRect frame = CGRectMake(0, 0, image.size.width*1.5, image.size.height*1.5);
        _btnMore = [TYZCreateCommonObject createWithButton:self imgNameNor:@"restaurant_btn_more" imgNameSel:@"restaurant_btn_more" targetSel:@selector(clickedWithCreateShop:)];
        _btnMore.frame = frame;
        UIBarButtonItem *itemCreate = [[UIBarButtonItem alloc] initWithCustomView:_btnMore];
        self.navigationItem.rightBarButtonItem = itemCreate;
//    }
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.baseTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], 0)];
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self hiddenFooterView:YES];
    
    if ([_shopList count] <= 0)
    {
        [self doRefreshData];
    }
    
    
}

- (void)clickedBack:(id)sender
{
    NSArray *viewContrller = self.navigationController.viewControllers;
    CTCShopQualificationViewController *shopQualVC = nil;
    for (id vc in viewContrller)
    {
        if ([vc isKindOfClass:[CTCShopQualificationViewController class]])
        {
            shopQualVC = vc;
            break;
        }
    }
    
    if (shopQualVC)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您是否确认退出登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alertView show];
        return;
    }
    
    debugLog(@"statue=%d", (int)_selectShopEntity.state);

    if (_selectShopEntity.state == 4 || _selectShopEntity.state == 5 || _selectShopEntity.state == 6)
    {
        [super clickedBack:sender];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您是否确认退出登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alertView show];
        return;
    }
    
}

- (void)doRefreshData
{
    [super doRefreshData];
    
    [self restaurantListData];
}


#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex == buttonIndex)
    {
//        [super clickedBack:nil];
    }
    else
    {
        [UserLoginStateObject saveLoginState:EUserUnlogin];
        
        NSArray *viewContrller = self.navigationController.viewControllers;
        CTCLoginViewController *loginVC = nil;
        for (id vc in viewContrller)
        {
            if ([vc isKindOfClass:[CTCLoginViewController class]])
            {
                loginVC = vc;
                break;
            }
        }
        if (loginVC)
        {
            [self.navigationController popToViewController:loginVC animated:YES];
        }
        else
        {
            // 1表示老板；2表示员工
            NSInteger type = [UserLoginStateObject readWithUserLoginType];
            debugLog(@"type=%d", (int)type);
//            UIViewController *loginVC = nil;
            CTCLoginViewController *uloginVC = [[CTCLoginViewController alloc] initWithNibName:nil bundle:nil];
            uloginVC.comeType = 3;
            uloginVC.userLoginType = type;
//            loginVC = uloginVC;
            [self.navigationController pushViewController:uloginVC animated:YES];
        }
    }
}

- (void)restaurantListData
{
    debugLog(@"userId=%d", (int)[UserLoginStateObject getUserId]);
    [HCSNetHttp requestWithShopGetShopListbyUserId:[UserLoginStateObject getUserId] sellerId:[UserLoginStateObject getUserInfo].seller_id completion:^(id result) {
        [self responseWithShopList:result];
    }];
}

- (void)responseWithShopList:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success)
    {
        [self.baseList removeAllObjects];
        [self.baseList addObjectsFromArray:respond.data];
        [SVProgressHUD dismiss];
        [self.baseTableView reloadData];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
    [self endAllRefreshing];
}

/**
 *  创建餐厅
 *
 *  @param sender sender description
 */
- (void)clickedWithCreateShop:(id)sender
{
    __weak typeof(self)weakSelf = self;
    if ([_popMenuList count] == 0)
    {
        // 创建新餐厅
        UIImage *image = [UIImage imageWithContentsOfFileName:@"restaurant_icon_found.png"];
        TYZPopMenuItem *model =  [[TYZPopMenuItem alloc] initWithTitle:@"创建新餐厅" image:image block:^(TYZPopMenuItem * _Nullable item) {
            // 创建新餐厅
            [weakSelf createWithShop];
        }];
        [_popMenuList addObject:model];
        
        // 管理员设置
        image = [UIImage imageWithContentsOfFileName:@"restaurant_icon_set.png"];
        model =  [[TYZPopMenuItem alloc] initWithTitle:@"管理员设置" image:image block:^(TYZPopMenuItem * _Nullable item) {
            // 管理员设置
            [weakSelf managerWithSettings];
        }];
        [_popMenuList addObject:model];
    }
    
    if (!_popMenuConfig)
    {
//        configuration.marginXSpacing;
//        configuration.marginYSpacing;
        
        TYZPopMenuConfiguration *options = [TYZPopMenuConfiguration defaultConfiguration];
        options.style               = TYZPopMenuAnimationStyleScale;
        options.menuMaxHeight       = 100; // 菜单最大高度
        options.itemHeight          = 50;
        options.itemMaxWidth        = 150;
        options.arrowSize           = 10; //指示箭头大小
        options.arrowMargin         = 0; // 手动设置箭头和目标view的距离
        options.marginXSpacing      = 15; //MenuItem左右边距
        options.marginYSpacing      = 15; //MenuItem上下边距
        options.intervalSpacing     = 15; //MenuItemImage与MenuItemTitle的间距
        options.menuCornerRadius    = 1; //菜单圆角半径
        options.shadowOfMenu        = YES; //是否添加菜单阴影
        options.hasSeparatorLine    = YES; //是否设置分割线
        options.separatorInsetLeft  = 10; //分割线左侧Insets
        options.separatorInsetRight = 10; //分割线右侧Insets
        options.separatorHeight     = 1.0 / [UIScreen mainScreen].scale;//分割线高度
        options.shadowColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        options.titleColor          = [UIColor colorWithHexString:@"#323232"];//menuItem字体颜色
        options.separatorColor      = [UIColor colorWithHexString:@"#cdcdcd"];//分割线颜色
        options.menuBackgroundColor = [UIColor whiteColor],//菜单的底色
        options.selectedColor       = [UIColor colorWithHexString:@"#e6e6e6"];// menuItem选中颜色
        self.popMenuConfig = options;
    }
    
    [TYZPopMenu showMenuWithView:_btnMore menuItems:_popMenuList withOptions:_popMenuConfig];
}

/**
 *  创建餐厅
 */
- (void)createWithShop
{
    _isAdd = YES;
    OpenRestaurantInputEntity *inputEnt = [OpenRestaurantInputEntity new];
    inputEnt.comeType = 3;
    [MCYPushViewController showWithOpenRestaurantNameVC:self data:inputEnt completion:nil];
}

/**
 *  管理员设置
 */
- (void)managerWithSettings
{
    if (!_isMyCreateShop)
    {
        [SVProgressHUD showInfoWithStatus:@"请先创建餐厅！"];
        return;
    }
    
    [MCYPushViewController showWithRestaurantBossVC:self data:nil completion:nil];
}

/// 却换餐厅，提交到服务器
- (void)responseWithUserSetShop:(TYZRespondDataEntity *)respond shopInfo:(ShopListDataEntity *)shopInfo
{
    if (respond.errcode == respond_success)
    {
        [SVProgressHUD dismiss];
        self.selectShopEntity = shopInfo;
        debugLog(@"shopId=%d; state=%d", (int)shopInfo.shop_id, (int)shopInfo.state);
        debugLog(@"count=%d", (int)shopInfo.shop_employee_count);
        UserInfoDataEntity *userInfo = [UserLoginStateObject getUserInfo];
//        userInfo.shop_id = shopInfo.shop_id;
        userInfo.shop_employee_count = shopInfo.shop_employee_count;
        userInfo.shop_state = shopInfo.state;
        userInfo.shop_name = shopInfo.name;
//        [UserLoginStateObject saveWithUserInfo:userInfo];
        
        // state 餐厅的状态 1完成开店前三部 未发布；2上传资质，待审核；3审核失败；4审核通过；5餐厅已发布；6餐厅下架
        if (shopInfo.state == 1 || shopInfo.state == 2 || shopInfo.state == 3)
        {
            userInfo.shop_id = 0;
            [UserLoginStateObject saveWithUserInfo:userInfo];
            debugLog(@"if进来了");
            if (shopInfo.type == 2)
            {
                [SVProgressHUD showInfoWithStatus:@"此餐厅暂未发布"];
            }
            else
            {
                [MCYPushViewController showWithShopQualificationVC:self data:nil shopId:shopInfo.shop_id completion:nil];
            }
        }
        else
        {
            debugLog(@"else");
            userInfo.shop_id = shopInfo.shop_id;
            [UserLoginStateObject saveWithUserInfo:userInfo];
            CTCMainPageViewController *mainVC = nil;
            NSArray *viewControlls = self.navigationController.viewControllers;
            for (id vc in viewControlls)
            {
                if ([vc isKindOfClass:[CTCMainPageViewController class]])
                {
                    mainVC = vc;
                    break;
                }
            }
            if (mainVC)
            {
                debugLog(@"if main");
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else
            {
                debugLog(@"loadRootVC");
                AppDelegate *app = [UtilityObject appDelegate];
                [app loadRootVC];
            }
        }
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.baseList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyRestaurantListViewCell *cell = [MyRestaurantListViewCell cellForTableView:tableView];
    ShopListDataEntity *ent = self.baseList[indexPath.row];
    if (ent.type == 1)
    {// 1表示自己开的餐厅；2表示有管理权限的餐厅
        _isMyCreateShop = YES;
    }
    [cell updateCellData:ent];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kMyRestaurantListViewCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ShopListDataEntity *shopEnt = self.baseList[indexPath.row];
    [SVProgressHUD showWithStatus:@"切换中"];
    [HCSNetHttp requestWithUserSetShop:[UserLoginStateObject getUserId] shopId:shopEnt.shop_id completion:^(id result) {
        [self responseWithUserSetShop:result shopInfo:shopEnt];
    }];
}





@end
