//
//  MyRestaurantRoomSpaceViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/2.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantRoomSpaceViewController.h"
#import "LocalCommon.h"
#import "EmptyRoomSpaceView.h"
#import "UserLoginStateObject.h"
#import "MyRestaurantRoomSpaceViewCell.h"
#import "ShopSeatInfoEntity.h"

@interface MyRestaurantRoomSpaceViewController ()
{
    EmptyRoomSpaceView *_emptyView;
}

- (void)initWithEmptyView;

- (void)getWithRoomSpaceData;

@end

@implementation MyRestaurantRoomSpaceViewController

- (void)initWithVar
{
    [super initWithVar];
    
//    NSString *path = [[NSBundle mainBundle] pathForScaledResource:@"space_bg.png" ofType:nil];
//    debugLog(@"path=%@", path);
    
    [self.baseList addObjectsFromArray:_seatList];
    
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = @"餐位设置";
    
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
    
    [self hiddenFooterView:YES];
    
    [self initWithEmptyView];
}

- (void)doRefreshData
{
    [super doRefreshData];
    
    [self getWithRoomSpaceData];
    
}

- (void)doMoreRefreshData
{
    [super doMoreRefreshData];

//    [self getWithRoomSpaceData];
    
}

- (void)initWithEmptyView
{
    if (!_emptyView)
    {
        CGRect frame = self.baseTableView.frame;
        _emptyView = [[EmptyRoomSpaceView alloc] initWithFrame:frame];
        _emptyView.hidden = YES;
        [self.view addSubview:_emptyView];
    }
    _emptyView.hidden = YES;
    if ([self.baseList count] == 0)
    {
        _emptyView.hidden = NO;
    }
}

/// 编辑
- (void)clickedWithEdit:(id)sender
{
    [MCYPushViewController showWithRoomSpaceVC:self data:self.baseList completion:^(id data) {
        [self.baseList removeAllObjects];
        [self.baseList addObjectsFromArray:data];
        [self.baseTableView reloadData];
    }];
}

- (void)getWithRoomSpaceData
{
    [HCSNetHttp requestWithShopSeatSetting:[UserLoginStateObject getCurrentShopId] completion:^(id result) {
        [self responseWithShopSeatSetting:result];
    }];
    
}

- (void)responseWithShopSeatSetting:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success)
    {
        debugLog(@"ddfdfdfdf");
        [self.baseList removeAllObjects];
        [self.baseList addObjectsFromArray:respond.data];
        [self.baseTableView reloadData];
    }
    else if (respond.errcode == respond_nodata)
    {
        [self.baseList removeAllObjects];
        [self.baseTableView reloadData];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
    
    [self initWithEmptyView];
    
    [self endAllRefreshing];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.baseList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyRestaurantRoomSpaceViewCell *cell = [MyRestaurantRoomSpaceViewCell cellForTableView:tableView];
    [cell updateCellData:self.baseList[indexPath.section]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kMyRestaurantRoomSpaceViewCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}


@end
