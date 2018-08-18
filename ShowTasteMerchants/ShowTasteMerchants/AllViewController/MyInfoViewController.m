//
//  MyInfoViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/12.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyInfoViewController.h"
#import "LocalCommon.h"
#import "TYZBaseTableViewCell.h"
//#import "OrderMealViewController.h"
#import "MyInfoBottomView.h"
#import "CellCommonDataEntity.h"
#import "MyInfoViewCell.h"
#import "MyInfoHeadView.h"
#import "UserLoginStateObject.h"
#import "OpenRestaurantInputEntity.h"

@interface MyInfoViewController ()
{
    MyInfoHeadView *_headView;
    
    MyInfoBottomView *_bottomView;
    
    /**
     *  登录状态；0表示没有登录；1表示登录了
     */
    NSInteger _loginState;
}

@property (nonatomic, assign) NSInteger loginState;

@property (nonatomic, strong) UserInfoDataEntity *userInfoEntity;

- (void)initWithBottomView;

- (void)tapGesture:(UITapGestureRecognizer *)tap;

/**
 *  获取开餐厅类型数据
 */
//- (void)getRestaurantTypeData;

@end

@implementation MyInfoViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    debugMethod();
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self initWithUserInfo];
    
    [self.baseTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
//    self.navigationController.navigationBarHidden = NO;
    
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
//    self.navigationController.navigationBarHidden = NO;
    
    [super viewDidDisappear:animated];
}

- (void)initWithVar
{
    [super initWithVar];
    
    // 我的收藏(i_icon_collect)
    // 推荐餐厅(i_icon_recommend)
    // 邀请好友(i_icon_invite)
    // 推广收益(i_icon_earnings)
    // 设置(i_icon_set)
    // 帮助(i_icon_help)
    

}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
//    self.title = NSLocalizedString(@"MyInfoTitle", @"");
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    
    AppDelegate *app = [UtilityObject appDelegate];
    
    CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] / 3, 0, [[UIScreen mainScreen] screenWidth] / 3 * 2, [[UIScreen mainScreen] screenHeight] - app.rootViewController.appTabBarHeight);
    self.baseTableView.frame = frame;
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    _rightView = [[MyInfoRightView alloc] initWithFrame:frame];
//    [self.view addSubview:_rightView];
    
    
    frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth] / 3, [[UIScreen mainScreen] screenHeight] - app.rootViewController.appTabBarHeight);
    UIView *view = [[UIView alloc] initWithFrame:frame];
    [self.view addSubview:view];
    
    [self initWithHeadView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [view addGestureRecognizer:tap];
    
    [self initWithBottomView];
    
}

- (void)initWithUserInfo
{
    self.userInfoEntity = [UserLoginStateObject getUserInfo];
//    debugLog(@"ent=%@", [_userInfoEntity modelToJSONString]);
    _loginState = [UserLoginStateObject userLoginState];
    
    [_headView updateViewData:_userInfoEntity];
    [self initWithBottomView];
    
    
    CellCommonDataEntity *entit = nil;
    [self.baseList removeAllObjects];
    if (_loginState == EUserLogined)
    {
        NSInteger userMode = _userInfoEntity.userMode;
        if (userMode == 0)
        {// 普通模式
            entit = [[CellCommonDataEntity alloc] init];
            entit.title = @"我的收藏";
            entit.thumalImgName = @"i_icon_collect";
            [self.baseList addObject:entit];
            
            entit = [[CellCommonDataEntity alloc] init];
            entit.title = @"我的钱包";
            entit.thumalImgName = @"i_icon_recommend";
            [self.baseList addObject:entit];
            
            entit = [[CellCommonDataEntity alloc] init];
            entit.title = @"推荐餐厅";
            entit.thumalImgName = @"i_icon_invite";
            [self.baseList addObject:entit];
            
            if ([objectNull(_userInfoEntity.invite_code) isEqualToString:@""])
            {
                entit = [[CellCommonDataEntity alloc] init];
                entit.title = @"加入推广";
                entit.thumalImgName = @"i_icon_join";
                [self.baseList addObject:entit];
            }
            else
            {
                entit = [[CellCommonDataEntity alloc] init];
                entit.title = @"邀请好友";
                entit.thumalImgName = @"i_icon_invite";
                [self.baseList addObject:entit];
                
                entit = [[CellCommonDataEntity alloc] init];
                entit.title = @"推广收益";
                entit.thumalImgName = @"i_icon_earnings";
                [self.baseList addObject:entit];
            }
            
        }
        else
        {// 经营模式
            entit = [[CellCommonDataEntity alloc] init];
            entit.title = @"我的餐厅";
            entit.thumalImgName = @"i_icon_collect";
            [self.baseList addObject:entit];
            
            entit = [[CellCommonDataEntity alloc] init];
            entit.title = @"群组";
            entit.thumalImgName = @"i_icon_recommend";
            [self.baseList addObject:entit];
            
            /*entit = [[CellCommonDataEntity alloc] init];
            entit.title = @"邀请好友";
            entit.thumalImgName = @"i_icon_invite";
            [self.baseList addObject:entit];
            
            entit = [[CellCommonDataEntity alloc] init];
            entit.title = @"推广收益";
            entit.thumalImgName = @"i_icon_earnings";
            [self.baseList addObject:entit];
             */
            if ([objectNull(_userInfoEntity.invite_code) isEqualToString:@""])
            {
                entit = [[CellCommonDataEntity alloc] init];
                entit.title = @"加入推广";
                entit.thumalImgName = @"i_icon_join";
                [self.baseList addObject:entit];
            }
            else
            {
                entit = [[CellCommonDataEntity alloc] init];
                entit.title = @"邀请好友";
                entit.thumalImgName = @"i_icon_invite";
                [self.baseList addObject:entit];
                
                entit = [[CellCommonDataEntity alloc] init];
                entit.title = @"推广收益";
                entit.thumalImgName = @"i_icon_earnings";
                [self.baseList addObject:entit];
            }
        }
    }
    entit = [[CellCommonDataEntity alloc] init];
    entit.title = @"设置";
    entit.thumalImgName = @"i_icon_set";
    [self.baseList addObject:entit];
//    entit = [[CellCommonDataEntity alloc] init];
//    entit.title = @"帮助";
//    entit.thumalImgName = @"i_icon_help";
//    [self.baseList addObject:entit];
}

- (void)initWithHeadView
{
    if (!_headView)
    {
        CGRect frame = CGRectMake(0, 0, self.baseTableView.width, self.baseTableView.width+20);
        _headView = [[MyInfoHeadView alloc] initWithFrame:frame];
        _headView.backgroundColor = [UIColor colorWithHexString:@"#db3400"];
        self.baseTableView.tableHeaderView = _headView;
    }
    
    __weak typeof(self)weakSelf = self;
    _headView.viewCommonBlock = ^(id data)
    {// 显示用户信息视图
        if (weakSelf.loginState == EUserUnlogin)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请您先登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            [MCYPushViewController showWithUserInfoVC:weakSelf data:weakSelf.userInfoEntity completion:nil];
        }
    };
}

- (void)initWithBottomView
{
    __weak typeof(self)weakSelf = self;
    if (!_bottomView)
    {
        AppDelegate *app = [UtilityObject appDelegate];
        CGRect frame = CGRectMake(self.baseTableView.left, [[UIScreen mainScreen] screenHeight] -  app.rootViewController.appTabBarHeight, self.baseTableView.width,  app.rootViewController.appTabBarHeight);
        _bottomView = [[MyInfoBottomView alloc] initWithFrame:frame];
        [self.view addSubview:_bottomView];
    }
    
    [_bottomView updateViewData:_userInfoEntity];
    _bottomView.bottomClickedBlock = ^(NSString *title, NSInteger tag)
    {
        [weakSelf bottomClicked:title tag:tag];
    };
}

- (void)bottomClicked:(NSString *)title tag:(NSInteger)tag
{
    if ([title isEqualToString:@"登录"])
    {// 登录
        debugLog(@"登录");
        [MCYPushViewController showWithUserLoginVC:self data:@(2) completion:^(id data) {
//            [self userLoginState:data];
            [self performSelector:@selector(userLoginState:) withObject:data afterDelay:1];
        }];
    }
    else if ([title isEqualToString:@"我要开店"])
    {// 我要开店
//        [self getRestaurantTypeData];
        
        OpenRestaurantInputEntity *inputEnt = [OpenRestaurantInputEntity new];
        inputEnt.comeType = 1;
        [MCYPushViewController showWithOpenRestaurantFirstVC:self data:nil inputEnt:inputEnt completion:^(id data) {
            
        }];
        
    }
    else if ([title isEqualToString:@"进入经营模式"])
    {// 进入经营模式
        debugLog(@"title=%@", title);
        _userInfoEntity.userMode = 1;
        [UserLoginStateObject saveWithUserInfo:_userInfoEntity];
        AppDelegate *app = [UtilityObject appDelegate];
//        [app loadRootVCMode:_userInfoEntity.userMode];
        [app showWithUserInfoVC:NO];
    }
    else if ([title isEqualToString:@"进入订购模式"])
    {// 进入普通模式
        _userInfoEntity.userMode = 0;
        [UserLoginStateObject saveWithUserInfo:_userInfoEntity];
        AppDelegate *app = [UtilityObject appDelegate];
//        [app loadRootVCMode:_userInfoEntity.userMode];
        [app showWithUserInfoVC:NO];
    }
    else if ([title isEqualToString:@"切换到订购模式"])
    {
        
    }
}

// 登录返回结果
- (void)userLoginState:(id)data
{
    NSInteger state = [data integerValue];
    if (state == EUserLogined)
    {// 登录成功
        self.userInfoEntity = [UserLoginStateObject getUserInfo];
        [_bottomView updateViewData:_userInfoEntity];
    }
}

- (void)tapGesture:(UITapGestureRecognizer *)tap
{
    debugMethod();
    [self clickedBack:nil];
    
    AppDelegate *app = [UtilityObject appDelegate];
    [app showWithUserInfoVC:NO];
    
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    debugLog(@"row=%d", (int)indexPath.row);
    // 0普通模式；1经营模式
//    NSInteger userMode = _userInfoEntity.userMode;
    CellCommonDataEntity *ent = self.baseList[indexPath.row];
    if ([ent.title isEqualToString:@"我的收藏"])
    {
        [MCYPushViewController showWithMyCollectionListVC:self data:nil completion:nil];
    }
    else if ([ent.title isEqualToString:@"我的钱包"])
    {
        [MCYPushViewController showWithMyWalletVC:self data:nil completion:nil];
    }
    else if ([ent.title isEqualToString:@"推荐餐厅"])
    {
        
    }
    else if ([ent.title isEqualToString:@"加入推广"])
    {
        [MCYPushViewController showWithJoinPromotionVC:self data:@(1) completion:^(id data) {
            [self initWithUserInfo];
            [self.baseTableView reloadData];
        }];
    }
    else if ([ent.title isEqualToString:@"设置"])
    {
        [MCYPushViewController showWithMySettingsVC:self data:nil completion:nil];
    }
    else if ([ent.title isEqualToString:@"帮助"])
    {
        
    }
    else if ([ent.title isEqualToString:@"我的餐厅"])
    {
//        [MCYPushViewController showWithOpenRestaurantListVC:self data:nil completion:^(id data) {
//            }];
    }
    else if ([ent.title isEqualToString:@"群组"])
    {
        
    }
    else if ([ent.title isEqualToString:@"邀请好友"])
    {
        [MCYPushViewController showWithJoinPromotionVC:self data:@(2) completion:nil];
    }
    else if ([ent.title isEqualToString:@"推广收益"])
    {
        [MCYPushViewController showWithEarningVC:self data:nil completion:nil];
    }
    
    // showWithMyCollectionListVC
    
    /*if (indexPath.row == EN_MYINFO_COLLECT_ROW && _loginState == EUserLogined)
    {// 我的收藏
        
    }
    else if (indexPath.row == EN_MYINFO_RECOMMEND_ROW && _loginState == EUserLogined)
    {// 推荐餐厅
        
    }
    else if (indexPath.row == EN_MYINFO_INVITE_ROW && _loginState == EUserLogined)
    {// 邀请好友
        
    }
    else if (indexPath.row == EN_MYINFO_EARNINGS_ROW && _loginState == EUserLogined)
    {// 推广收益
        
    }
    else if ((indexPath.row == EN_MYINFO_SETTINGS_ROW && _loginState == EUserLogined) || (indexPath.row == EN_MYINFO_SETTINGS_ROW - 4 && _loginState == EUserUnlogin))
    {// 设置
        
    }
    else if ((indexPath.row == EN_MYINFO_HELP_ROW && _loginState == EUserLogined) || (indexPath.row == EN_MYINFO_HELP_ROW - 4 && _loginState == EUserUnlogin))
    {// 帮助
        
    }
    if (_loginState == EUserUnlogin)
    {
        
    }*/
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [self.baseList count];
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyInfoViewCell *cell = [MyInfoViewCell cellForTableView:tableView];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell updateCellData:self.baseList[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = kMyInfoViewCellHeight;
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self didSelectRowAtIndexPath:indexPath];
    
}

/*- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == EN_ONESELF_USERBASIC_SECTION)
    {
        return 0.01;
    }
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}*/


@end
