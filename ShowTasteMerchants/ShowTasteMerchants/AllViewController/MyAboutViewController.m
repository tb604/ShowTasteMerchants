//
//  MyAboutViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/29.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyAboutViewController.h"
#import "LocalCommon.h"
#import "CellCommonDataEntity.h"
#import "MySettingsViewCell.h"
#import "MyAboutHeaderView.h"
#import "MyAboutFooterView.h"

@interface MyAboutViewController ()
{
    MyAboutHeaderView *_headerView;
    
    MyAboutFooterView *_footerView;
}
@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)initWithHeaderView;

- (void)initWithFooterView;

@end

@implementation MyAboutViewController

- (void)initWithVar
{
    [super initWithVar];
    
    
    CellCommonDataEntity *ent = [CellCommonDataEntity new];
    ent.title = @"去评分";
    [self.baseList addObject:ent];
    
    ent = [CellCommonDataEntity new];
    ent.title = @"版本说明";
    [self.baseList addObject:ent];
    
    ent = [CellCommonDataEntity new];
    ent.title = @"功能介绍";
    [self.baseList addObject:ent];
    
    ent = [CellCommonDataEntity new];
    ent.title = @"投诉";
    [self.baseList addObject:ent];
    
    
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = @"关于";
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.baseTableView.scrollEnabled = NO;
    
    [self initWithHeaderView];
    
    [self initWithFooterView];
    
}

- (void)initWithHeaderView
{
    if (!_headerView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kMyAboutHeaderViewHeight);
        _headerView = [[MyAboutHeaderView alloc] initWithFrame:frame];
        self.baseTableView.tableHeaderView = _headerView;
    }
    [_headerView updateViewData:nil];
}

- (void)initWithFooterView
{
    if (!_footerView)
    {
        AppDelegate *app = [UtilityObject appDelegate];
        CGFloat height = [[UIScreen mainScreen] screenHeight] - [app navBarHeight] - STATUSBAR_HEIGHT;
        CGFloat fheight = height - [self.baseList count] * kMySettingsViewCellHeight - _headerView.height;
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], fheight);
        _footerView = [[MyAboutFooterView alloc] initWithFrame:frame];
        self.baseTableView.tableFooterView = _footerView;
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
    MySettingsViewCell *cell = [MySettingsViewCell cellForTableView:tableView];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell updateCellData:self.baseList[indexPath.row] cellType:2];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kMySettingsViewCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.indexPath = indexPath;
    
//    CellCommonDataEntity *ent = self.baseList[indexPath.row];
    
//    [self selectWithTitle:ent.title];
    
}


@end

























