//
//  MyFinanceWeekViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/7.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyFinanceWeekViewController.h"
#import "LocalCommon.h"
#import "TYZBaseTableViewCell.h"
#import "MyFinanceWeekOrderNumViewCell.h"
#import "MyFinanceWeekTotalAmountCell.h"
#import "MyFinanceWeekChartViewCell.h"
#import "MyFinanceWeekOrderChartViewCell.h"

@interface MyFinanceWeekViewController ()
{
    NSMutableArray *_monthList;
}

- (void)getWithWeekData;

@end

@implementation MyFinanceWeekViewController

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
    
    _monthList = [NSMutableArray new];
    MyFinanceMonthEntity *ent = [MyFinanceMonthEntity new];
    ent.title = @"08/01~07";
    ent.value = 2.5;
    [_monthList addObject:ent];
    
    ent = [MyFinanceMonthEntity new];
    ent.title = @"08~14";
    ent.value = 2.6;
    [_monthList addObject:ent];
    
    ent = [MyFinanceMonthEntity new];
    ent.title = @"15~21";
    ent.value = 2.8;
    [_monthList addObject:ent];
    
    ent = [MyFinanceMonthEntity new];
    ent.title = @"22~29";
    ent.value = 3.8;
    [_monthList addObject:ent];
    
    ent = [MyFinanceMonthEntity new];
    ent.title = @"30~07";
    ent.value = 3.2;
    [_monthList addObject:ent];
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    AppDelegate *app = [UtilityObject appDelegate];
    CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight] - [app navBarHeight] - STATUSBAR_HEIGHT);
    self.baseTableView.frame = frame;
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.baseTableView.showsHorizontalScrollIndicator = NO;
    self.baseTableView.showsVerticalScrollIndicator = NO;
    [self hiddenFooterView:YES];
    
//    self.view.backgroundColor = [UIColor yellowColor];
//    self.baseTableView.backgroundColor = [UIColor orangeColor];
}

- (void)doRefreshData
{
    [super doRefreshData];
    
    [self getWithWeekData];
}

- (void)getWithWeekData
{
    [self endAllRefreshing];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return EN_FW_MAX_SECTION;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == EN_FW_ORDERNUM_SECTION)
    {
        return 1;
    }
    return EN_FW_CHART_MAX_ROW;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == EN_FW_ORDERNUM_SECTION)
    {
        MyFinanceWeekOrderNumViewCell *cell = [MyFinanceWeekOrderNumViewCell cellForTableView:tableView];
        [cell updateCellData:nil];
        return cell;
    }
    else if (indexPath.section == EN_FW_ORDERCHART_SECTION)
    {
        if (indexPath.row == EN_FW_CHART_TOTALAMOUNT_ROW)
        {// 营业总额
            MyFinanceWeekTotalAmountCell *cell = [MyFinanceWeekTotalAmountCell cellForTableView:tableView];
            [cell updateCellData:nil];
            return cell;
        }
        else if (indexPath.row == EN_FW_CHART_AMOUNTWEEK_ROW)
        {// 以周为单位的统计
            // MyFinanceWeekChartViewCell
            MyFinanceWeekChartViewCell *cell = [MyFinanceWeekChartViewCell cellForTableView:tableView];
//            [cell updateCellData:_monthList];
            [cell updateCellData:_monthList];
            return cell;
        }
        else if (indexPath.row == EN_FW_CHART_ORDERDATA_ROW)
        {// 本周订单数据图
            MyFinanceWeekOrderChartViewCell *cell = [MyFinanceWeekOrderChartViewCell cellForTableView:tableView];
            [cell updateCellData:nil title:@"本周订单数据"];
            return cell;
        }
    }
    TYZBaseTableViewCell *cell = [TYZBaseTableViewCell cellForTableView:tableView];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == EN_FW_ORDERNUM_SECTION)
    {
        return kMyFinanceWeekOrderNumViewCellHeight;
    }
    else if (indexPath.section == EN_FW_ORDERCHART_SECTION)
    {
        if (indexPath.row == EN_FW_CHART_TOTALAMOUNT_ROW)
        {// 营业总额
            return kMyFinanceWeekTotalAmountCellHeight;
        }
        else if (indexPath.row == EN_FW_CHART_AMOUNTWEEK_ROW)
        {// 以周为单位的统计
            return kMyFinanceWeekChartViewCellHeight;
        }
        else if (indexPath.row == EN_FW_CHART_ORDERDATA_ROW)
        {// 本周订单数据图
            return [MyFinanceWeekOrderChartViewCell getWithCellHeight];
        }
        // MyFinanceWeekTotalAmountCell
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == EN_FW_ORDERNUM_SECTION)
    {
        return 0.001;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}


@end





















