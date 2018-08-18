//
//  ShopCommentListViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/11.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopCommentListViewController.h"
#import "LocalCommon.h"
#import "ShopCommentViewCell.h"
#import "ShopCommentDataEntity.h"
#import "CommentInfoDataEntity.h"

@interface ShopCommentListViewController ()

- (void)getWithCommentData;

@end

@implementation ShopCommentListViewController

- (void)initWithVar
{
    [super initWithVar];
    
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = @"用户评价";
}

- (void)initWithSubView
{
    [super initWithSubView];
    
//    debugLog(@"shopid=%d", (int)_shopId);
    
    self.baseTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], 0)];
    
    [self doRefreshData];
}

- (void)doRefreshData
{
    [super doRefreshData];
    
    [self getWithCommentData];
}

- (void)doMoreRefreshData
{
    [super doMoreRefreshData];
    
    [self getWithCommentData];
}

- (void)getWithCommentData
{
    [HCSNetHttp requestWithComment:_shopId pageIndex:self.pageId completion:^(id result) {
        [self responseWithComment:result];
    }];
}

- (void)responseWithComment:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success)
    {
        if (self.pageId == 1)
        {
            [self.baseList removeAllObjects];
        }
        [self.baseList addObjectsFromArray:respond.data];
        self.pageId += 1;
        [self.baseTableView reloadData];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
        if (self.pageId == 1)
        {
            [self.baseList removeAllObjects];
            [self.baseTableView reloadData];
        }
    }
    [self endAllRefreshing];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.baseList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopCommentViewCell *cell = [ShopCommentViewCell cellForTableView:tableView];
    [cell updateCellData:self.baseList[indexPath.row]];
    [cell hiddenWithLine:YES];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentInfoDataEntity *commentEnt = self.baseList[indexPath.row];
    CGFloat height = kShopCommentViewCellHeight - 20 + commentEnt.contentHeight;
    if ([commentEnt.images count] > 0)
    {
        height = height + commentEnt.imgWidth + 5;
    }
    return height;
}

@end


















