//
//  MyRestaurantRoomSpaceEditViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/2.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantRoomSpaceEditViewController.h"
#import "LocalCommon.h"
#import "OrderEmptyView.h"
#import "ShopSeatInfoEntity.h"
#import "MyRestaurantRoomSpaceEditViewCell.h"

@interface MyRestaurantRoomSpaceEditViewController ()
{
    OrderEmptyView *_emptyView;
}

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)initWithEmptyView;

@end

@implementation MyRestaurantRoomSpaceEditViewController


- (void)initWithVar
{
    [super initWithVar];
    
//    ShopSeatInfoEntity *ent = [ShopSeatInfoEntity new];
//    ent.name = @"大厅";
//    ent.remark = @"一楼的大厅";
//    [_roomSpaceList addObject:ent];
//    
//    ent = [ShopSeatInfoEntity new];
//    ent.name = @"包间";
//    ent.remark = @"一楼的包间";
//    [_roomSpaceList addObject:ent];
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = @"餐位设置";
    
    [self initWithBtnAdd];
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self hiddenFooterView:YES];
    
    [self hiddenHeaderView:YES];
    
    [self initWithEmptyView];
}

- (void)clickedBack:(id)sender
{
    if (self.popResultBlock)
    {
        self.popResultBlock(_roomSpaceList);
    }
    [super clickedBack:sender];
}

- (void)initWithBtnAdd
{
    NSString *str = @"添加";
    CGFloat width = [str widthForFont:FONTSIZE_16];
    UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnAdd setTitle:str forState:UIControlStateNormal];
    btnAdd.titleLabel.font = FONTSIZE_16;
    btnAdd.frame = CGRectMake(0, 0, width, 30);
    [btnAdd setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnAdd addTarget:self action:@selector(clickedWithAddSpace:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itemAdd = [[UIBarButtonItem alloc] initWithCustomView:btnAdd];
    self.navigationItem.rightBarButtonItem = itemAdd;
}

- (void)initWithEmptyView
{
    if (!_emptyView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight] / 3);
        _emptyView = [[OrderEmptyView alloc] initWithFrame:frame];
        [self.view addSubview:_emptyView];
        _emptyView.center = CGPointMake([[UIScreen mainScreen] screenWidth] / 2, [[UIScreen mainScreen] screenHeight] / 2 - 100);
        [_emptyView updateViewData:@"暂无空间信息"];
    }
    _emptyView.hidden = YES;
    debugLog(@"count=%d", (int)[_roomSpaceList count]);
    if ([_roomSpaceList count] == 0)
    {
        _emptyView.hidden = NO;
    }
    
}

/**
 *  添加空间
 *
 *  @param sender <#sender description#>
 */
- (void)clickedWithAddSpace:(id)sender
{
    ShopSeatInfoEntity *seatEntity = [ShopSeatInfoEntity new];
    seatEntity.name = @"";
    seatEntity.remark = @"";
    seatEntity.isAdd = YES;
    [MCYPushViewController showWithRSEditVC:self data:seatEntity completion:^(id data) {
        [_roomSpaceList addObject:data];
        [self.baseTableView reloadData];
        [self initWithEmptyView];
    }];
}

- (void)seatWithDeleteInfo
{
    [SVProgressHUD showWithStatus:@"删除中"];
    ShopSeatInfoEntity *entity = _roomSpaceList[_indexPath.section];

    [HCSNetHttp requestWithShopSeatSettingDelete:entity.id completion:^(id result) {
        [self responseWithShopSeatSettingDelete:result];
    }];
}

- (void)responseWithShopSeatSettingDelete:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success)
    {
        [SVProgressHUD dismiss];
        [self.baseTableView beginUpdates];
        [self.roomSpaceList removeObjectAtIndex:_indexPath.section];
//        [self.baseTableView deleteRowsAtIndexPaths:@[_indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:_indexPath.section];
        [self.baseTableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.baseTableView endUpdates];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_roomSpaceList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyRestaurantRoomSpaceEditViewCell *cell = [MyRestaurantRoomSpaceEditViewCell cellForTableView:tableView];
    [cell updateCellData:_roomSpaceList[indexPath.section]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kMyRestaurantRoomSpaceEditViewCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        self.indexPath = indexPath;
        [self seatWithDeleteInfo];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ShopSeatInfoEntity *seatEntity = _roomSpaceList[indexPath.section];
    seatEntity.isAdd = NO; // 编辑
    [MCYPushViewController showWithRSEditVC:self data:seatEntity completion:^(id data) {
        
        [_roomSpaceList replaceObjectAtIndex:indexPath.section withObject:data];
        [MCYPushViewController reloadWithTableView:tableView indexPath:indexPath reloadType:2];
    }];
}

@end

/*
 [self.baseTableView beginUpdates];
 [self.baseList removeObjectAtIndex:_indexPath.row];
 [self.baseTableView deleteRowsAtIndexPaths:@[_indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
 [self.baseTableView endUpdates];
 */





















