//
//  MyRestaurantMouthViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/2.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantMouthViewController.h"
#import "LocalCommon.h"
//#import "EmptyRoomSpaceView.h"
#import "OrderEmptyView.h"
#import "UserLoginStateObject.h"
#import "ShopMouthDataEntity.h"
#import "MyRestaurantMouthFoodCell.h"
#import "MyRestaurantMouthCell.h"
#import "ShopMouthDataEntity.h"

@interface MyRestaurantMouthViewController ()
{
    OrderEmptyView *_emptyView;
}

- (void)initWithEmptyView;

- (void)getWithMouthListData;

@end

@implementation MyRestaurantMouthViewController


- (void)initWithVar
{
    [super initWithVar];
    
    [self.baseList addObjectsFromArray:_empList];
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = @"出单档口";
    
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
    
    [self initWithEmptyView];
    
    
}

- (void)doRefreshData
{
    [super doRefreshData];
    
    [self getWithMouthListData];
}

- (void)initWithEmptyView
{
    if (!_emptyView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight] / 3);
        _emptyView = [[OrderEmptyView alloc] initWithFrame:frame];
        [self.view addSubview:_emptyView];
        _emptyView.center = CGPointMake([[UIScreen mainScreen] screenWidth] / 2, [[UIScreen mainScreen] screenHeight] / 2 - 100);
        [_emptyView updateViewData:@"暂无档口信息"];
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
    
    if ([self.baseList count] == 0)
    {
        [SVProgressHUD showInfoWithStatus:@"暂无档口信息"];
        return;
    }
    
    NSMutableArray *addList = [NSMutableArray new];
    NSInteger i = 0;
    for (id ent in self.baseList)
    {
        if ([ent isKindOfClass:[ShopMouthDataEntity class]])
        {
            if (i == 0)
            {
                ((ShopMouthDataEntity *)ent).isSelected = YES;
            }
            [addList addObject:ent];
        }
        i+= 1;
    }
    
    [MCYPushViewController showWithShopMouthEditVC:self data:addList completion:^(id data) {
//        [mouthVC.baseList removeAllObjects];
//        [mouthVC.baseList addObjectsFromArray:data];
//        [mouthVC.baseTableView reloadData];
    }];
}

- (void)getWithMouthListData
{
    [HCSNetHttp requestWithShopPrinterShow:[UserLoginStateObject getCurrentShopId] completion:^(id result) {
        [self responseWithShopPrinterShow:result];
    }];
}

- (void)responseWithShopPrinterShow:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success)
    {
        [self.baseList removeAllObjects];
        [self.baseList addObjectsFromArray:respond.data];
        [self.baseTableView reloadData];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
    [self endAllRefreshing];
    
    [self initWithEmptyView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;//[self.baseList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.baseList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id mouthEnt = self.baseList[indexPath.row];
    if ([mouthEnt isKindOfClass:[ShopMouthDataEntity class]])
    {
        MyRestaurantMouthCell *cell = [MyRestaurantMouthCell cellForTableView:tableView];
        [cell updateCellData:mouthEnt];
        return cell;
    }
    // MyRestaurantMouthCell
    
    MyRestaurantMouthFoodCell *cell = [MyRestaurantMouthFoodCell cellForTableView:tableView];
    [cell updateCellData:mouthEnt];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id mouthEnt = self.baseList[indexPath.row];
    if ([mouthEnt isKindOfClass:[ShopMouthDataEntity class]])
    {
        return kMyRestaurantMouthCellHeigh;
    }
    else
    {
        return kMyRestaurantMouthFoodCellHeight;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // ShopMouthDataEntity
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id ient = self.baseList[indexPath.row];
    if ([ient isKindOfClass:[ShopMouthDataEntity class]])
    {
        
        
        ShopMouthDataEntity *mouthEnt = ient;
        mouthEnt.isCheck = !mouthEnt.isCheck;
        
        MyRestaurantMouthCell *cell = (MyRestaurantMouthCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell updateCellData:mouthEnt];
        
        NSMutableArray *foodList = [NSMutableArray new];
        if (mouthEnt.isCheck)
        {
            [self.baseList insertObjects:mouthEnt.foods atIndex:indexPath.row+1];
            for (NSInteger i=1; i<=mouthEnt.foods.count; i++)
            {
                [foodList addObject:[NSIndexPath indexPathForRow:i+indexPath.row inSection:indexPath.section]];
            }
            [tableView insertRowsAtIndexPaths:foodList withRowAnimation:UITableViewRowAnimationFade];
        }
        else
        {
            [self.baseList removeObjectsInArray:mouthEnt.foods];
            for (NSInteger i=1; i<=mouthEnt.foods.count; i++)
            {
                [foodList addObject:[NSIndexPath indexPathForRow:i+indexPath.row inSection:indexPath.section]];
            }
            [tableView deleteRowsAtIndexPaths:foodList withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}


@end













