//
//  ShopPrinterChoiceViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/11.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopPrinterChoiceViewController.h"
#import "LocalCommon.h"
#import "ShopPrinterChoiceViewCell.h"
#import "ShopMouthDataEntity.h"

@interface ShopPrinterChoiceViewController ()

@property (nonatomic, strong) NSIndexPath *selectIndexPath;

@end

@implementation ShopPrinterChoiceViewController

- (void)initWithVar
{
    [super initWithVar];
    
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = @"菜品档口选择";
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_shopPrintList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopPrinterChoiceViewCell *cell = [ShopPrinterChoiceViewCell cellForTableView:tableView];
    
    //    if (!_selectIndexPath && indexPath.row == 0)
    if (_selectIndexPath && indexPath.row == _selectIndexPath.row)
    {
        //        self.selectIndexPath = indexPath;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    [cell updateCellData:_shopPrintList[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kShopPrinterChoiceViewCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger newRow = [indexPath row];
    NSInteger oldRow = (_selectIndexPath?_selectIndexPath.row:-1);
    if (newRow != oldRow)
    {
        ShopPrinterChoiceViewCell *newCell = (ShopPrinterChoiceViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        ShopPrinterChoiceViewCell *oldCell = nil;
        if (_selectIndexPath)
        {
            oldCell = (ShopPrinterChoiceViewCell *)[tableView cellForRowAtIndexPath:_selectIndexPath];
        }
        
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        self.selectIndexPath = indexPath;
    }
    else
    {
        TYZBaseTableViewCell *newCell = (TYZBaseTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    ShopMouthDataEntity *printerEnt = self.shopPrintList[indexPath.row];
    if (self.popResultBlock)
    {
        self.popResultBlock(printerEnt);
    }
    [self clickedBack:nil];
    
}


@end
