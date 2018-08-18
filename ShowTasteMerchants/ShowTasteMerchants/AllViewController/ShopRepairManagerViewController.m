//
//  ShopRepairManagerViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopRepairManagerViewController.h"
#import "LocalCommon.h"
#import "TYZBaseTableViewCell.h"
#import "ShopRepairManagerSectionHeaderView.h"
#import "ShopRepairPrinterViewCell.h"
#import "ShopRepairPrinterFoodCell.h"
#import "ShopRepairManagerHeaderView.h"
#import "ShopRepairCashierPrintCell.h" // 收银打印cell
#import "UserLoginStateObject.h"

@interface ShopRepairManagerViewController ()
{
    ShopRepairManagerHeaderView *_headerView;
}

- (void)initWithHeaderView;

@end

@implementation ShopRepairManagerViewController

- (void)initWithVar
{
    [super initWithVar];
    
    [self.baseList removeAllObjects];
    
    [self.baseList addObjectsFromArray:_batchFoods];
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = @"补单管理";
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self initWithHeaderView];
}

- (void)clickedBack:(id)sender
{
    if (self.popResultBlock)
    {
        self.popResultBlock(@"back");
    }
    [super clickedBack:sender];
}

- (void)initWithHeaderView
{
    if (!_headerView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kShopRepairManagerHeaderViewHeight);
        _headerView = [[ShopRepairManagerHeaderView alloc] initWithFrame:frame];
        self.baseTableView.tableHeaderView = _headerView;
    }
    [_headerView updateViewData:_orderDetailEnt];
}

- (void)batchPrinter:(ShopPrinterEntity *)batchEnt printerEnt:(ShopBatchDataEntity *)printerEnt
{
    [SVProgressHUD showWithStatus:@"补打中"];
    ShopPatchFoodInputEntity *inputEnt = [ShopPatchFoodInputEntity new];
    inputEnt.orderId = _orderDetailEnt.order_id;
    inputEnt.shopId = _orderDetailEnt.shop_id;
    inputEnt.batchNo = printerEnt.timestamp; // 时间戳是批次号
    inputEnt.printerId = batchEnt.printer_id;
    [HCSNetHttp requestWithShopOrderPatchFoodToKitchen:inputEnt completion:^(TYZRespondDataEntity *respond) {
        if (respond.errcode == respond_success)
        {
            [SVProgressHUD showSuccessWithStatus:@"补打成功"];
        }
        else
        {
            [UtilityObject svProgressHUDError:respond viewContrller:self];
        }
    }];
}

// 收银打印
- (void)cashierWithPrinter
{
    [SVProgressHUD showWithStatus:@"打印中"];
    
    [HCSNetHttp requestWithShopOrderCashPrinter:_orderDetailEnt.order_id shopId:_orderDetailEnt.shop_id completion:^(TYZRespondDataEntity *respond) {
        if (respond.errcode == respond_success)
        {
            [SVProgressHUD showSuccessWithStatus:@"打印成功"];
        }
        else
        {
            [UtilityObject svProgressHUDError:respond viewContrller:self];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = 1 + [self.baseList count];
//    debugLog(@"num.count=%d", (int)count);
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    PrintBatchDataEntity *ent = self.baseList[section];
//    NSInteger count = [ent.printers count];
    if (section == 0)
    {
        return 1;
    }
    ShopPrinterEntity *ent = self.baseList[section-1];
    NSInteger count = [ent.batch_foods count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    PrintBatchDataEntity *ent = self.baseList[indexPath.section];
    __weak typeof(self)weakSelf = self;
    if (indexPath.section == 0)
    {
        ShopRepairCashierPrintCell *cell = [ShopRepairCashierPrintCell cellForTableView:tableView];
        cell.baseTableViewCellBlock = ^(id data)
        {// 收银打印
            [weakSelf cashierWithPrinter];
        };
        return cell;
    }
    
    ShopPrinterEntity *ent = self.baseList[indexPath.section-1];
    id Entt = ent.batch_foods[indexPath.row];
    if ([Entt isKindOfClass:[ShopBatchDataEntity class]])
    {
//        debugLog(@"ddfd");
//        ShopPrinterDataEntity *printEnt = nil;
        ShopRepairPrinterViewCell *cell = [ShopRepairPrinterViewCell cellForTableView:tableView];
        [cell updateCellData:Entt];
        __weak typeof(self)weakSelf = self;
        cell.baseTableViewCellBlock = ^(id data)
        {// 补打
            [weakSelf batchPrinter:ent printerEnt:Entt];
        };
        return cell;
    }
    else if ([Entt isKindOfClass:[OrderFoodInfoEntity class]])
    {
        OrderFoodInfoEntity *foodEnt = Entt;
        ShopRepairPrinterFoodCell *cell = [ShopRepairPrinterFoodCell cellForTableView:tableView];
        [cell updateCellData:foodEnt];
        return cell;

    }
    TYZBaseTableViewCell *cell = [TYZBaseTableViewCell cellForTableView:tableView];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 50;
    if (indexPath.section == 0)
    {
        return kShopRepairCashierPrintCellHeight;
    }
    ShopPrinterEntity *ent = self.baseList[indexPath.section-1];
    id Entt = ent.batch_foods[indexPath.row];
    if ([Entt isKindOfClass:[OrderFoodInfoEntity class]])
    {
        height = 40;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 10;
    }
    return kShopRepairManagerSectionHeaderViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    PrintBatchDataEntity *ent = _batchFoods[section];
    if (section == 0)
    {
        return nil;
    }
    ShopPrinterEntity *ent = _batchFoods[section-1];
    ShopRepairManagerSectionHeaderView *view = [[ShopRepairManagerSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kShopRepairManagerSectionHeaderViewHeight)];
//    NSString *strDate = [NSDate stringWithDateInOut:ent.batch_no_date inFormat:@"yyyy-MM-dd HH:mm:ss" outFormat:@"yyyy-MM-dd HH:mm"];
    [view updateViewData:ent.printer_name];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0)
    {
        return;
    }
    
    ShopPrinterEntity *ent = self.baseList[indexPath.section-1];
    id ient = ent.batch_foods[indexPath.row];
    if ([ient isKindOfClass:[OrderFoodInfoEntity class]])
    {
        return;
    }
    ShopBatchDataEntity *printEnt = ient;
    printEnt.isCheck = !printEnt.isCheck;
    printEnt.indexPath = indexPath;
    
    ShopRepairPrinterViewCell *cell = (ShopRepairPrinterViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell updateCellData:printEnt];
    
    
    NSMutableArray *foodList = [NSMutableArray new];
    if (printEnt.isCheck)
    {
        [ent.batch_foods insertObjects:printEnt.foods atIndex:indexPath.row+1];
        for (NSInteger i=1; i<=printEnt.foods.count; i++)
        {
            [foodList addObject:[NSIndexPath indexPathForRow:i+indexPath.row inSection:indexPath.section]];
        }
        [tableView insertRowsAtIndexPaths:foodList withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        [ent.batch_foods removeObjectsInArray:printEnt.foods];
        for (NSInteger i=1; i<=printEnt.foods.count; i++)
        {
            [foodList addObject:[NSIndexPath indexPathForRow:i+indexPath.row inSection:indexPath.section]];
        }
        [tableView deleteRowsAtIndexPaths:foodList withRowAnimation:UITableViewRowAnimationFade];
    }
    
    
//    [self.baseTableView reloadData];
//    [MCYPushViewController reloadWithTableView:tableView indexPath:indexPath reloadType:2];
}

@end





















