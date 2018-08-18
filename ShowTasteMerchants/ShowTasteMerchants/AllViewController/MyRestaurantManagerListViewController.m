//
//  MyRestaurantManagerListViewController.m
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/3.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantManagerListViewController.h"
#import "LocalCommon.h"
#import "MyRestaurantManagerTopView.h"
#import "MyRestaurantManagerListCell.h"
#import "ShopManageDataEntity.h"
#import "ShopManageNewDataEntity.h"

@interface MyRestaurantManagerListViewController ()
{
    MyRestaurantManagerTopView *_topView;
}

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)initWithTopView;


- (void)getWithManagerListData;

@end

@implementation MyRestaurantManagerListViewController

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
    [self.baseList addObjectsFromArray:_managerList];
    
}

- (void)initWithNavBar
{
    [self initWithBackButton];
    
    self.title = @"管理员";
    
    // 添加
    UIImage *image = [UIImage imageNamed:@"btn_add_shop"];
    CGRect frame = CGRectMake(0, 0, image.size.width*1.5, image.size.height*1.5);
    UIButton *btnAdd = [TYZCreateCommonObject createWithButton:self imgNameNor:@"btn_add_shop" imgNameSel:@"btn_add_shop" targetSel:@selector(clickedWithAddManager:)];
    btnAdd.frame = frame;
    UIBarButtonItem *itemCreate = [[UIBarButtonItem alloc] initWithCustomView:btnAdd];
    self.navigationItem.rightBarButtonItem = itemCreate;
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self hiddenFooterView:YES];
    
    [self initWithTopView];
    
    CGRect frame = self.baseTableView.frame;
    frame.origin.y = _topView.bottom;
    frame.size.height = frame.size.height - _topView.height;
    self.baseTableView.frame = frame;
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)doRefreshData
{
    [super doRefreshData];
    
    [self getWithManagerListData];
    
}

#pragma mark -
#pragma mark private methods

- (void)initWithTopView
{
    if (!_topView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], 30);
        _topView = [[MyRestaurantManagerTopView alloc] initWithFrame:frame];
        [self.view addSubview:_topView];
    }
}


/// 添加管理员
- (void)clickedWithAddManager:(id)sender
{
    [MCYPushViewController showWithEditManagerVC:self data:nil completion:^(id data) {
        if (data)
        {
            [self doRefreshData];
//            ShopManageNewDataEntity *ent = data;
//            [self.baseList addObject:ent];
//            [self.baseTableView reloadData];
        }
    }];
}

- (void)getWithManagerListData
{
    [HCSNetHttp requestWithSellerGetManageList:[UserLoginStateObject getUserInfo].seller_id completion:^(TYZRespondDataEntity *result) {
        if (result.errcode == respond_success)
        {
            [self.baseList removeAllObjects];
            [self.baseList addObjectsFromArray:result.data];
            [self.baseTableView reloadData];
        }
        else
        {
            if (result.errcode == respond_nodata)
            {
                [self.baseList removeAllObjects];
                [self.baseTableView reloadData];
            }
            [UtilityObject svProgressHUDError:result viewContrller:self];
        }
    }];
    
    
    [self endAllRefreshing];
}

// requestWithSellerGetManageList
- (void)deleteWithManager
{
    [SVProgressHUD showWithStatus:@"删除中"];
    ShopManageNewDataEntity *entity = self.baseList[_indexPath.row];
    [HCSNetHttp requestWithUserDeleteEmployee:entity.user_id shopId:0 sellerId:entity.seller_id type:1 completion:^(id result) {
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
    MyRestaurantManagerListCell *cell = [MyRestaurantManagerListCell cellForTableView:tableView];
    [cell updateCellData:self.baseList[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        self.indexPath = indexPath;
        [self deleteWithManager];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopManageNewDataEntity *ent = self.baseList[indexPath.row];
    if ([ent.role_name isEqualToString:@"创建者"])
    {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ShopManageNewDataEntity *manEnt = self.baseList[indexPath.row];
    if ([manEnt.role_name isEqualToString:@"创建者"])
    {
        return;
    }
    
    // 我的信息和我的名下的餐厅
    [MCYPushViewController showWithManagerInfoVC:self data:manEnt completion:^(id data) {
        if (data)
        {
            ShopManageNewDataEntity *ent = data;
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
    }];
}

@end


















