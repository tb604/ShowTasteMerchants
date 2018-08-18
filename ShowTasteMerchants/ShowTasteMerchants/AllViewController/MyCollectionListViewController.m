//
//  MyCollectionListViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/18.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyCollectionListViewController.h"
#import "LocalCommon.h"
#import "OrderEmptyView.h"
#import "TYZBaseTableViewCell.h"
#import "MyRestaurantListViewCell.h"
#import "ShopListDataEntity.h"
#import "OrderMealContentEntity.h"

@interface MyCollectionListViewController ()
{
    OrderEmptyView *_emptyView;
    
    // requestWithUserFavoriteGetShopList
    
}

- (void)initWithEmptyView;

- (void)getWithCollectionList;

@end

@implementation MyCollectionListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
}


- (void)initWithVar
{
    [super initWithVar];
    
    
    
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = @"我的收藏";
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self hiddenFooterView:YES];
    [self hiddenHeaderView:YES];
    
    self.baseTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], 0)];
    
    [self initWithEmptyView];
}

- (void)doRefreshData
{
    [super doRefreshData];
    
//    [self getWithCollectionList];
}

- (void)doMoreRefreshData
{
    [super doMoreRefreshData];
    
//    [self getWithCollectionList];
    
}

- (void)initWithEmptyView
{
    if (!_emptyView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight] / 3);
        _emptyView = [[OrderEmptyView alloc] initWithFrame:frame];
        [self.view addSubview:_emptyView];
        _emptyView.center = CGPointMake([[UIScreen mainScreen] screenWidth] / 2, [[UIScreen mainScreen] screenHeight] / 2 - 100);
        [_emptyView updateViewData:@"暂无收藏"];
    }
    _emptyView.hidden = YES;
    if ([_collectionList count] == 0)
    {
        _emptyView.hidden = NO;
    }
}

- (void)getWithCollectionList
{
    
    [self endAllRefreshing];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_collectionList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyRestaurantListViewCell *cell = [MyRestaurantListViewCell cellForTableView:tableView];
    [cell updateCellData:_collectionList[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kMyRestaurantListViewCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ShopListDataEntity *entity = _collectionList[indexPath.row];
    
    OrderMealContentEntity *ent = [OrderMealContentEntity new];
    ent.shop_id = entity.shop_id;
    ent.name = entity.name;
    // debugLog(@"shopId=%d; name=%@", (int)entity.shop_id, entity.name);
    [MCYPushViewController showWithShopDetailVC:self data:ent completion:nil];
}


@end
