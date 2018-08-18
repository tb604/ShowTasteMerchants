//
//  DeliverySettingsViewController.m
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/17.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DeliverySettingsViewController.h"
#import "LocalCommon.h"
#import "CellCommonDataEntity.h"
#import "DeliverySettingsSwicthCell.h"
#import "DeliverySettingsBaseCell.h"

@interface DeliverySettingsViewController ()

@end

@implementation DeliverySettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)initWithVar
{
    [super initWithVar];
    
    
    NSMutableArray *addList = [NSMutableArray new];
    CellCommonDataEntity *ent = [CellCommonDataEntity new];
    ent.title = @"自动接单";
    ent.thumalImgName = @"take-out_icon_automatic-order.png";
    ent.isCheck = NO;
    [addList addObject:ent];
    
    ent = [CellCommonDataEntity new];
    ent.title = @"是否营业";
    ent.thumalImgName = @"take-out_icon_open.png";
    ent.isCheck = YES;
    [addList addObject:ent];
    [self.baseList addObject:addList];
    
    addList = [NSMutableArray new];
    ent = [CellCommonDataEntity new];
    ent.title = @"配送费";
    ent.thumalImgName = @"take-out_icon_pay.png";
    [addList addObject:ent];
    
    ent = [CellCommonDataEntity new];
    ent.title = @"营业时间";
    ent.thumalImgName = @"take-out_icon_hours.png";
    [addList addObject:ent];
    
    ent = [CellCommonDataEntity new];
    ent.title = @"配送范围";
    ent.thumalImgName = @"take-out_icon_range.png";
    [addList addObject:ent];
    [self.baseList addObject:addList];
    
    // 打印机
    NSString *ip = objectNull([UtilityObject readWithPrinterIP]);
    addList = [NSMutableArray new];
    ent = [CellCommonDataEntity new];
    ent.title = @"打印机IP";
    ent.subTitle = ip;
    ent.placeholder = @"请输入打印机IP地址";
    ent.thumalImgName = @"take-out_icon_hours.png";
    [addList addObject:ent];
    
    NSString *model = objectNull([UtilityObject readWithPrinterModel]);
    ent = [CellCommonDataEntity new];
    ent.title = @"打印机型号";
    ent.subTitle = model;
    ent.placeholder = @"请输入打印机型号";
    ent.thumalImgName = @"take-out_icon_range.png";
    [addList addObject:ent];
    [self.baseList addObject:addList];
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
    
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

/**
 *  自动接单、是否营业
 */
- (void)autoOrderBussines:(CellCommonDataEntity *)entity
{
    debugLog(@"title=%@", entity.title);
    if ([entity.title isEqualToString:@"自动接单"])
    {
        
    }
    else if ([entity.title isEqualToString:@"是否营业"])
    {
        
    }
}

/**
 *  更新打印机设置
 */
- (void)updateWithPrinterInfo:(id)data indexPath:(NSIndexPath *)indexPath
{
    CellCommonDataEntity *ent = self.baseList[indexPath.section][indexPath.row];
    if (indexPath.row == 0)
    {// 设置打印机IP
        if (![objectNull(data) isValidIP])
        {
            [SVProgressHUD showErrorWithStatus:@"您输入的不是IP地址！"];
            return;
        }
        ent.subTitle = objectNull(data);
        [UtilityObject saveWithPrinterIP:data];
        [MCYPushViewController reloadWithTableView:self.baseTableView indexPath:indexPath reloadType:3];
    }
    else if (indexPath.row == 1)
    {// 设置打印机型号
        if ([objectNull(data) isEqualToString:@""])
        {
            [SVProgressHUD showErrorWithStatus:@"请输入打印机型号！"];
            return;
        }
        ent.subTitle = objectNull(data);
        [UtilityObject saveWithPrinterModel:data];
        [MCYPushViewController reloadWithTableView:self.baseTableView indexPath:indexPath reloadType:3];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.baseList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = self.baseList[section];
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    NSArray *array = self.baseList[indexPath.section];
    NSInteger count = array.count;
    if (indexPath.section == 0)
    {// 自动接单、是否营业
        DeliverySettingsSwicthCell *cell = [DeliverySettingsSwicthCell cellForTableView:tableView];
        [cell updateCellData:array[indexPath.row]];
        [cell hiddenBottomLine:NO];
        if (indexPath.row == count - 1)
        {
            [cell hiddenBottomLine:YES];
        }
        cell.baseTableViewCellBlock = ^(CellCommonDataEntity *data)
        {
            [weakSelf autoOrderBussines:data];
        };
        return cell;
    }
    else
    {
        DeliverySettingsBaseCell *cell = [DeliverySettingsBaseCell cellForTableView:tableView];
        [cell updateCellData:array[indexPath.row]];
        [cell hiddenBottomLine:NO];
        if (indexPath.row == count - 1)
        {
            [cell hiddenBottomLine:YES];
        }
         return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kDeliverySettingsSwicthCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {// 配送费
            NSDictionary *param = @{@"title":@"配送费", @"data":@"", @"placeholder":@"请输入配送费", @"isNumber":@(NO)};
            [MCYPushViewController showWithRestaurantSingleEditVC:self data:param completion:^(id data) {
//                [self updateWithBaseData:data];
            }];
        }
        else if (indexPath.row == 1)
        {// 营业时间
            [MCYPushViewController showWithDeliveryBusHoursVC:self data:nil completion:nil];
        }
        else if (indexPath.row == 2)
        {// 配送范围
            
        }
    }
    else if (indexPath.section == 2)
    {// 打印机相关
        CellCommonDataEntity *ent = self.baseList[indexPath.section][indexPath.row];
        if (indexPath.row == 0)
        {// 打印机IP
            NSDictionary *param = @{@"title":ent.title, @"data":objectNull(ent.subTitle), @"placeholder":ent.placeholder, @"isNumber":@(NO)};
            [MCYPushViewController showWithRestaurantSingleEditVC:self data:param completion:^(id data) {
                [self updateWithPrinterInfo:data indexPath:indexPath];
            }];
        }
        else if (indexPath.row == 1)
        {//打印机型号
            NSDictionary *param = @{@"title":ent.title, @"data":objectNull(ent.subTitle), @"placeholder":ent.placeholder, @"isNumber":@(NO)};
            [MCYPushViewController showWithRestaurantSingleEditVC:self data:param completion:^(id data) {
                [self updateWithPrinterInfo:data indexPath:indexPath];
            }];
        }
    }
    // showWithDeliveryBusHoursVC
}

@end


















