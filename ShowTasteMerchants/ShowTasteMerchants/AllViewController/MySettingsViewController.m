//
//  MySettingsViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/27.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MySettingsViewController.h"
#import "LocalCommon.h"
#import "CellCommonDataEntity.h"
#import "MySettingsViewCell.h"

@interface MySettingsViewController ()

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)initWithSetingsInfo;

@end

@implementation MySettingsViewController

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
    
    self.title = @"设置";
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithSetingsInfo];
}

- (void)initWithSetingsInfo
{
    NSMutableArray *addList = [NSMutableArray new];
    CellCommonDataEntity *ent = [CellCommonDataEntity new];
    ent.title = @"账号管理";
    [addList addObject:ent];
    
    ent = [CellCommonDataEntity new];
    ent.title = @"手机号绑定";
    ent.subTitle = @"18261929604";
    [addList addObject:ent];
    
    ent = [CellCommonDataEntity new];
    ent.title = @"账号安全";
    ent.subTitle = @"未开启";
    [addList addObject:ent];
    
    ent = [CellCommonDataEntity new];
    ent.title = @"辅助功能";
    ent.subTitle = @"";
    [addList addObject:ent];
    [self.baseList addObject:addList];
    
    addList = [NSMutableArray new];
    ent = [CellCommonDataEntity new];
    ent.title = @"帮助与反馈";
    ent.subTitle = @"";
    [addList addObject:ent];
    
    ent = [CellCommonDataEntity new];
    ent.title = @"关于";
    ent.subTitle = @"";
    [addList addObject:ent];
    [self.baseList addObject:addList];
    
    [self.baseTableView reloadData];
}

- (void)selectWithTitle:(NSString *)title
{
    // showWithMyAboutVC
    if ([title isEqualToString:@"账号管理"])
    {
        
    }
    else if ([title isEqualToString:@"手机号绑定"])
    {
        
    }
    else if ([title isEqualToString:@"账号安全"])
    {
        
    }
    else if ([title isEqualToString:@"辅助功能"])
    {
        
    }
    else if ([title isEqualToString:@"帮助与反馈"])
    {
        
    }
    else if ([title isEqualToString:@"关于"])
    {
        [MCYPushViewController showWithMyAboutVC:self data:nil completion:nil];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.baseList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.baseList[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MySettingsViewCell *cell = [MySettingsViewCell cellForTableView:tableView];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell updateCellData:self.baseList[indexPath.section][indexPath.row] cellType:2];
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
    
    CellCommonDataEntity *ent = self.baseList[indexPath.section][indexPath.row];
    
    [self selectWithTitle:ent.title];
    
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

















