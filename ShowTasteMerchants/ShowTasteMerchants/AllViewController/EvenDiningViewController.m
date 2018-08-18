//
//  EvenDiningViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/26.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "EvenDiningViewController.h"
#import "LocalCommon.h"
#import "EvenDiningOrderViewCell.h"
#import "EvenDiningOrderInfoViewCell.h"


@interface EvenDiningViewController ()

@end

@implementation EvenDiningViewController

- (void)initWithVar
{
    [super initWithVar];
    
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = _shopDetailEntity.name;
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        EvenDiningOrderViewCell *cell = [EvenDiningOrderViewCell cellForTableView:tableView];
        
        return cell;
    }
    else if (indexPath.section == 1)
    {
        EvenDiningOrderInfoViewCell *cell = [EvenDiningOrderInfoViewCell cellForTableView:tableView];
        
        return cell;
    }
    TYZBaseTableViewCell *cell = [TYZBaseTableViewCell cellForTableView:tableView];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0;
    if (indexPath.section == 0)
    {
        height = kEvenDiningOrderViewCellHeight;
    }
    else if (indexPath.section == 1)
    {
        height = kEvenDiningOrderInfoViewCellHeight;
    }
    return height;
}

@end
