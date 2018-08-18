//
//  MyWalletDetailConditionView.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/19.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyWalletDetailConditionView.h"
#import "LocalCommon.h"
#import "CellCommonDataEntity.h"
#import "MyWalletDetailConditionViewCell.h"

@interface MyWalletDetailConditionView () <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *_conditionList;
    
    UITableView *_conditionTableView;
}

- (void)initWithConditionTableView;

@end

@implementation MyWalletDetailConditionView

- (void)initWithVar
{
    [super initWithVar];
    
    _conditionList = [NSMutableArray new];
    
    CellCommonDataEntity *ent = [CellCommonDataEntity new];
    ent.title = @"全部";
    ent.tag = 0;
    ent.isCheck = YES;
    ent.thumalImgName = @"wallet_icon_all";
    ent.checkImgName = @"wallet_icon_selected";
    ent.uncheckImgName = nil;
    [_conditionList addObject:ent];
    
    ent = [CellCommonDataEntity new];
    ent.title = @"支出";
    ent.tag = 2;
    ent.isCheck = NO;
    ent.thumalImgName = @"wallet_icon_payout";
    ent.checkImgName = @"wallet_icon_selected";
    ent.uncheckImgName = nil;
    [_conditionList addObject:ent];
    
    ent = [CellCommonDataEntity new];
    ent.title = @"收入";
    ent.tag = 1;
    ent.isCheck = NO;
    ent.thumalImgName = @"wallet_icon_income";
    ent.checkImgName = @"wallet_icon_selected";
    ent.uncheckImgName = nil;
    [_conditionList addObject:ent];
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithConditionTableView];
    
}

- (void)initWithConditionTableView
{
    if (!_conditionTableView)
    {
        CGRect frame = self.bounds;
        _conditionTableView = [[UITableView alloc] initWithFrame:frame];
        _conditionTableView.dataSource = self;
        _conditionTableView.delegate = self;
        _conditionTableView.scrollEnabled = NO;
        [self addSubview:_conditionTableView];
    }
}

#pragma mark UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_conditionList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyWalletDetailConditionViewCell *cell = [MyWalletDetailConditionViewCell cellForTableView:tableView];
    [cell updateCellData:_conditionList[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CellCommonDataEntity *selEntity = _conditionList[indexPath.row];
    for (CellCommonDataEntity *ent in _conditionList)
    {
        ent.isCheck = NO;
    }
    selEntity.isCheck = YES;
    [_conditionTableView reloadData];
    
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(selEntity);
    }
    
}

@end
