//
//  MyRestaurantManagerViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/17.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantManagerViewController.h"
#import "LocalCommon.h"
#import "MyRestaurantManagerHeadView.h"
#import "MyRestaurantManagerCell.h"
#import "UserLoginStateObject.h"
//#import "ShopManageDataEntity.h"
#import "ShopManageNewDataEntity.h"

@interface MyRestaurantManagerViewController ()
{
    MyRestaurantManagerHeadView *_headView;
}

- (void)initWithHeadView;

- (void)getWithManagerData;

@end

@implementation MyRestaurantManagerViewController

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
    
    [self.baseList addObjectsFromArray:_empList];
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = @"员工管理";
    
    UIImage *image = [UIImage imageNamed:@"data_btn_edit"];
    UIButton *btnEdit = [TYZCreateCommonObject createWithButton:self imgNameNor:@"data_btn_edit" imgNameSel:@"data_btn_edit" targetSel:@selector(clickedWithEdit:)];
    btnEdit.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    UIBarButtonItem *itemEdit = [[UIBarButtonItem alloc] initWithCustomView:btnEdit];
    self.navigationItem.rightBarButtonItem = itemEdit;
}

- (void)initWithSubView
{
    [super initWithSubView];
    
//    AppDelegate *app = [UtilityObject appDelegate];
//    self.baseTableView.height = [[UIScreen mainScreen] screenHeight] - [app navBarHeight] * 2 - STATUSBAR_HEIGHT - [app tabBarHeight];
//    self.baseTableView.height = [[UIScreen mainScreen] screenHeight] - [app navBarHeight] * 2 - STATUSBAR_HEIGHT;
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self hiddenFooterView:YES];
    
    [self initWithHeadView];
}

- (void)doRefreshData
{
    [super doRefreshData];
    
    [self getWithManagerData];
    
}

- (void)initWithHeadView
{
    if (!_headView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kMyRestaurantManagerHeadViewHeight);
        _headView = [[MyRestaurantManagerHeadView alloc] initWithFrame:frame];
//        self.baseTableView.tableHeaderView = _headView;
    }
}

/// 编辑
- (void)clickedWithEdit:(id)sender
{
    [MCYPushViewController showWithRestaurantManagerEditVC:self data:self.baseList completion:^(id data) {
        if (data)
        {
            [self.baseList removeAllObjects];
            [self.baseList addObjectsFromArray:data];
            [self.baseTableView reloadData];
        }
    }];
}

- (void)getWithManagerData
{
    [HCSNetHttp requestWithUserGetEmployeeList:[UserLoginStateObject getCurrentShopId] completion:^(id result) {
        [self responseWithManage:result];
    }];
}

- (void)responseWithManage:(TYZRespondDataEntity *)respond
{// ShopManageNewDataEntity
    if (respond.errcode == respond_success)
    {
//        debugLog(@"车管内功");
        [self.baseList removeAllObjects];
        [self.baseList addObjectsFromArray:respond.data];
        [self.baseTableView reloadData];
    }
    else if (respond.errcode == respond_nodata)
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
        [self.baseList removeAllObjects];
        [self.baseTableView reloadData];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
    [self endAllRefreshing];
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


@end
