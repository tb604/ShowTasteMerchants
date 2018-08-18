//
//  WaitingNoticeOrderViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/15.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "WaitingNoticeOrderViewController.h"
#import "LocalCommon.h"
#import "WaitingNoticeOrderViewCell.h"
#import "OrderDetailDataEntity.h"
#import "OrderDataEntity.h"
#import "UserLoginStateObject.h"
#import "OrderEmptyView.h"

@interface WaitingNoticeOrderViewController ()
{
    OrderEmptyView *_emptyView;
}
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, assign) BOOL requestWithSuccess;

- (void)initWithEmptyView;

- (void)getWithWaitingOrderData;

@end

@implementation WaitingNoticeOrderViewController

- (void)initWithVar
{
    [super initWithVar];
    
//    [self.baseList addObject:@"1"];
//    [self.baseList addObject:@"1"];
//    [self.baseList addObject:@"1"];
//    [self.baseList addObject:@"1"];
//    [self.baseList addObject:@"1"];
//    [self.baseList addObject:@"1"];
//    [self.baseList addObject:@"1"];
//    [self.baseList addObject:@"1"];
//    [self.baseList addObject:@"1"];
//    [self.baseList addObject:@"1"];
//    [self.baseList addObject:@"1"];
//    [self.baseList addObject:@"1"];
//    [self.baseList addObject:@"1"];
//    [self.baseList addObject:@"1"];
//    [self.baseList addObject:@"1"];
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = @"待处理订单";
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self hiddenFooterView:YES];
    
    [self initWithEmptyView];
    
    [self doRefreshData];
    
}

- (void)doRefreshData
{
    [super doRefreshData];
    
    [self getWithWaitingOrderData];
    
}

- (void)doMoreRefreshData
{
    [super doMoreRefreshData];
    
    [self getWithWaitingOrderData];
    
}

- (void)initWithEmptyView
{
    if (!_emptyView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight] / 3);
        _emptyView = [[OrderEmptyView alloc] initWithFrame:frame];
        [self.view addSubview:_emptyView];
        _emptyView.center = CGPointMake([[UIScreen mainScreen] screenWidth] / 2, [[UIScreen mainScreen] screenHeight] / 2 - 100);
        _emptyView.hidden = YES;
        [_emptyView updateViewData:@"暂无待处理订单"];
    }
}


- (void)clickedBack:(id)sender
{
    if (self.popResultBlock)
    {
        if (_requestWithSuccess)
        {
            self.popResultBlock(self.baseList);
        }
        else
        {
            self.popResultBlock(nil);
        }
    }
    [super clickedBack:sender];
}

- (void)getWithWaitingOrderData
{
    [HCSNetHttp requestWithOrderWaitProcessOrders:[UserLoginStateObject getCurrentShopId] completion:^(id result) {
        [self responseWithOrderWaitProcessOrders:result];
    }];
}

- (void)responseWithOrderWaitProcessOrders:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success)
    {
        [self.baseList removeAllObjects];
        [self.baseList addObjectsFromArray:respond.data];
        [self.baseTableView reloadData];
        self.requestWithSuccess = YES;
    }
    else if (respond.errcode == respond_nodata)
    {
        [self.baseList removeAllObjects];
        [self.baseTableView reloadData];
        self.requestWithSuccess = YES;
    }
    else
    {
        self.requestWithSuccess = NO;
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
    [self endAllRefreshing];
    
    _emptyView.hidden = YES;
    if ([self.baseList count] == 0)
    {
        _emptyView.hidden = NO;
    }
}

// 查看订单信息
- (void)lookWithOrderInfo:(id)data indexPath:(NSIndexPath *)indexPath
{
    self.indexPath = indexPath;
    [MCYPushViewController showWithShopOrderDetailVC:self data:data completion:^(id data) {
        OrderDetailDataEntity *orderDetailEnt = data;
        OrderDataEntity *orderEnt = self.baseList[indexPath.section];
//        debugLog(@"state1=%d; state2=%d", (int)orderDetailEnt.order.status, (int)orderEnt.status);
        if (orderDetailEnt.order.status != orderEnt.status)
        {
            [self doRefreshData];
        }
        
    }];
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
    __weak typeof(self)weakSelf = self;
    WaitingNoticeOrderViewCell *cell = [WaitingNoticeOrderViewCell cellForTableView:tableView];
    [cell updateCellData:self.baseList[indexPath.section]];
    cell.baseTableViewCellBlock = ^(id data)
    {
        [weakSelf lookWithOrderInfo:data indexPath:indexPath];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kWaitingNoticeOrderViewCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == [self.baseList count] - 1)
    {
        return 10;
    }
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OrderDataEntity *orderEnt = self.baseList[indexPath.section];
    [self lookWithOrderInfo:orderEnt indexPath:indexPath];
}



@end





















