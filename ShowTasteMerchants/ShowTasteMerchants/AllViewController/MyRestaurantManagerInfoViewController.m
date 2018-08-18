//
//  MyRestaurantManagerInfoViewController.m
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/4.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantManagerInfoViewController.h"
#import "MyRestaurantManagerListCell.h"
#import "LocalCommon.h"
#import "MyRestaurantEditShopCell.h"
#import "ShopListDataEntity.h"

@interface MyRestaurantManagerInfoViewController ()

@end

@implementation MyRestaurantManagerInfoViewController

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
    
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = @"管理";
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1 + _manageEntity.shopList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        MyRestaurantManagerListCell *cell = [MyRestaurantManagerListCell cellForTableView:tableView];
        [cell updateCellData:_manageEntity];
        return cell;
    }
    else
    {
        ShopListDataEntity *shopEnt = _manageEntity.shopList[indexPath.row - 1];
        shopEnt.selCheck = NO;
        MyRestaurantEditShopCell *cell = [MyRestaurantEditShopCell cellForTableView:tableView];
        [cell updateCellData:shopEnt];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return kMyRestaurantManagerListCellHeight;
    }
    else
    {
        return kMyRestaurantEditShopCellHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        [MCYPushViewController showWithEditManagerVC:self data:_manageEntity completion:^(id data) {
            if (data)
            {
                ShopManageNewDataEntity *ent = data;
                self.manageEntity = ent;
                [self.baseTableView reloadData];
            }
        }];
    }
    
}

@end













