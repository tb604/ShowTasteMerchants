//
//  MyRestaurantManagerEditViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/28.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantManagerEditViewController.h"
#import "LocalCommon.h"
#import "MyRestaurantManagerCell.h"
#import "MyRestaurantManagerHeadView.h"
#import "OpenRestaurantBottomView.h"
#import "MyRestaurantManagerEditViewBg.h"
#import "ShopPositionDataEntity.h" // 职位信息
#import "ShopManageDataEntity.h"
#import "UserLoginStateObject.h"
#import "ShopManageNewDataEntity.h"


@interface MyRestaurantManagerEditViewController ()
{
    MyRestaurantManagerHeadView *_headView;
    
    OpenRestaurantBottomView *_bottomView;
    
    MyRestaurantManagerEditViewBg *_managerEditView;
}

@property (nonatomic, strong) NSIndexPath *indexPath;

/**
 *  是否添加
 */
@property (nonatomic, assign) BOOL isAdd;

- (void)initWithHeadView;

- (void)initWithBottomView;

@end

@implementation MyRestaurantManagerEditViewController


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
    
    [self.baseList removeAllObjects];
    [self.baseList addObjectsFromArray:_list];
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = @"员工管理";
    
    UIImage *image = [UIImage imageWithContentsOfFileName:@"yggl_btn_addr.png"];
    UIButton *btnAdd = [TYZCreateCommonObject createWithButton:self imgNameNor:@"yggl_btn_addr.png" imgNameSel:@"yggl_btn_addr.png" targetSel:@selector(addWithEoy:)];
    btnAdd.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    UIBarButtonItem *itemAdd = [[UIBarButtonItem alloc] initWithCustomView:btnAdd];
    self.navigationItem.rightBarButtonItem = itemAdd;
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    AppDelegate *app = [UtilityObject appDelegate];
    CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight] - [app navBarHeight] - STATUSBAR_HEIGHT);
    self.baseTableView.frame = frame;
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self hiddenHeaderView:YES];
    
    [self hiddenFooterView:YES];
    
    [self initWithHeadView];
    
//    [self initWithBottomView];
}

- (void)clickedBack:(id)sender
{
    UserInfoDataEntity *userInfo = [UserLoginStateObject getUserInfo];
    userInfo.shop_employee_count = [self.baseList count];
    [UserLoginStateObject saveWithUserInfo:userInfo];
    
    if (self.popResultBlock)
    {
        self.popResultBlock(self.baseList);
    }
    [super clickedBack:sender];
}

- (void)initWithHeadView
{
    if (!_headView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kMyRestaurantManagerHeadViewHeight);
        _headView = [[MyRestaurantManagerHeadView alloc] initWithFrame:frame];
    }
}

- (void)initWithBottomView
{
    if (!_bottomView)
    {
        AppDelegate *app = [UtilityObject appDelegate];
        CGRect frame = CGRectMake(0, self.baseTableView.bottom, [[UIScreen mainScreen] screenWidth], [app tabBarHeight]);
        _bottomView = [[OpenRestaurantBottomView alloc] initWithFrame:frame];
        _bottomView.backgroundColor = [UIColor colorWithHexString:@"#ff5601"];
        [_bottomView topLineWithHidden:YES];
        [self.view addSubview:_bottomView];
    }
    [_bottomView updateViewData:@"添加"];
    __weak typeof(self)weakSelf = self;
    _bottomView.viewCommonBlock = ^(id data)
    {
        [weakSelf clickedBottom];
    };
}

- (void)getWithEmployeeList
{
    [HCSNetHttp requestWithUserGetEmployeeList:[UserLoginStateObject getCurrentShopId] completion:^(TYZRespondDataEntity *result) {
        if (result.errcode == respond_success)
        {
            [self.baseList removeAllObjects];
            [self.baseList addObjectsFromArray:result.data];
            [self.baseTableView reloadData];
        }
    }];
}

/// 添加员工
- (void)addWithEoy:(id)sender
{
    _isAdd = YES;
    [self edithAdd:nil];
    
}

- (void)edithAdd:(id)userInfo
{
    [MCYPushViewController showWithShopManageEmployeVC:self data:userInfo isAdd:_isAdd positionAuth:_postionAuthEntity completion:^(id data) {
        if (data)
        {
            ShopManageNewDataEntity *ent = data;
            if (_isAdd)
            {// 添加
//                [self.baseList addObject:ent];
//                [self.baseTableView reloadData];
                [self getWithEmployeeList];
            }
            else
            {// 修改
                NSInteger index = -1;
                for (NSInteger i=0; i<[self.baseList count]; i++)
                {
                    ShopManageNewDataEntity *entity = self.baseList[i];
                    if (ent.user_id == entity.user_id)
                    {
                        index = i;
                        break;
                    }
                }
                if (index != -1)
                {
                    [self.baseList replaceObjectAtIndex:index withObject:ent];
                }
                [self.baseTableView reloadData];
            }
        }
    }];
}

- (void)clickedBottom
{
    _isAdd = YES;
//    [self showWithManagerEditView:YES];
}

/*- (void)showWithManagerEditView:(BOOL)show
{
    __weak typeof(self)blockSelf = self;
    if (!_managerEditView)
    {
        _managerEditView = [[MyRestaurantManagerEditViewBg alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight])];
        _managerEditView.alpha = 0;
        _managerEditView.postionAuthEntity = _postionAuthEntity;
    }
    _managerEditView.editViewBlock = ^(id ent)
    {// ent为空表示放弃
        if (ent)
        {
            [SVProgressHUD showWithStatus:@"提交中"];
            ShopManageInputEntity *inputEnt = ent;
            debugLog(@"input=%@", [inputEnt modelToJSONString]);
            
            if (blockSelf.isAdd)
            {// 添加
                [HCSNetHttp requestWithManageAdd:inputEnt completion:^(id result) {
                    [blockSelf responseWithManageAdd:result];
                }];
            }
            else
            {// 修改
                [HCSNetHttp requestWithManageSet:inputEnt completion:^(id result) {
                    [blockSelf responseWithManageAdd:result];
                }];
            }
        }
        else
        {
            [blockSelf showWithManagerEditView:NO];
        }
    };
    if (show)
    {
        if (_isAdd)
        {
            [_managerEditView updateWithData:nil title:@"添加"];
        }
        else
        {
            [_managerEditView updateWithData:self.baseList[_indexPath.row] title:@"修改"];
        }
        
        [self.view.window addSubview:_managerEditView];
        [UIView animateWithDuration:0.5 animations:^{
            _managerEditView.alpha = 1.0;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            _managerEditView.alpha = 0;
        } completion:^(BOOL finished) {
            [_managerEditView removeFromSuperview];
        }];
    }
}*/

- (void)responseWithManageAdd:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success)
    {
        [SVProgressHUD dismiss];
//        [self showWithManagerEditView:NO];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
}

- (void)deleteWithManager
{
//    debugLog(@"4444");
    [SVProgressHUD showWithStatus:@"删除中"];
    ShopManageNewDataEntity *entity = self.baseList[_indexPath.row];
//    ShopManageInputEntity *delEnt = [ShopManageInputEntity new];
//    delEnt.id = entity.id;
//    delEnt.shopId = entity.shop_id;
//    delEnt.userId = entity.user_id;
//    delEnt.opUserId = [UserLoginStateObject getUserId];
//    entity.shop_id
    [HCSNetHttp requestWithUserDeleteEmployee:entity.user_id shopId:[UserLoginStateObject getCurrentShopId] sellerId:[UserLoginStateObject getUserInfo].seller_id type:2 completion:^(id result) {
        [self responseWithManageDelete:result];
    }];
}

- (void)responseWithManageDelete:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success)
    {
        [SVProgressHUD dismiss];
        [self.baseTableView beginUpdates];
        [self.baseList removeObjectAtIndex:_indexPath.row];
        [self.baseTableView deleteRowsAtIndexPaths:@[_indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.baseTableView endUpdates];
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
    MyRestaurantManagerCell *cell = [MyRestaurantManagerCell cellForTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateCellData:self.baseList[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kMyRestaurantManagerCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _headView;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        self.indexPath = indexPath;
        [self deleteWithManager];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.indexPath = indexPath;
    _isAdd = NO;
    [self edithAdd:self.baseList[indexPath.row]];
}
@end
























