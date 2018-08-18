//
//  MyFinanceMonthViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/7.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyFinanceMonthViewController.h"
#import "LocalCommon.h"
#import "MyFinanceMonthInfoCell.h"
#import "MyFinanceMonthEarningCell.h"
#import "MyFinanceWeekOrderChartViewCell.h"

@interface MyFinanceMonthViewController ()
{
    NSMutableArray *_monthList;
}

- (void)getWithMonthData;

@end

@implementation MyFinanceMonthViewController

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
    ent.title = @"1月";
    ent.value = 2.5;
    [_monthList addObject:ent];
    
    ent = [MyFinanceMonthEntity new];
    ent.title = @"2月";
    ent.value = 2.6;
    [_monthList addObject:ent];
    
    ent = [MyFinanceMonthEntity new];
    ent.title = @"3月";
    ent.value = 2.8;
    [_monthList addObject:ent];
    
    ent = [MyFinanceMonthEntity new];
    ent.title = @"4月";
    ent.value = 3.8;
    [_monthList addObject:ent];
    
    ent = [MyFinanceMonthEntity new];
    ent.title = @"5月";
    ent.value = 3.2;
    [_monthList addObject:ent];
    
    ent = [MyFinanceMonthEntity new];
    ent.title = @"6月";
    ent.value = 3.6;
    [_monthList addObject:ent];
    
    ent = [MyFinanceMonthEntity new];
    ent.title = @"7月";
    ent.value = 4;
    [_monthList addObject:ent];
    
    ent = [MyFinanceMonthEntity new];
    ent.title = @"8月";
    ent.value = 4.6;
    [_monthList addObject:ent];
    
    ent = [MyFinanceMonthEntity new];
    ent.title = @"9月";
    ent.value = 3;
    [_monthList addObject:ent];
    
    ent = [MyFinanceMonthEntity new];
    ent.title = @"10月";
    ent.value = 2.4;
    [_monthList addObject:ent];
    
    ent = [MyFinanceMonthEntity new];
    ent.title = @"11月";
    ent.value = 3.8;
    [_monthList addObject:ent];
    
    ent = [MyFinanceMonthEntity new];
    ent.title = @"12月";
    ent.value = 3.5;
    [_monthList addObject:ent];
    
}
// [@2.5,@2.6,@2.8,@3.8,@3.2,@3.6,@4,@4.5,@2.6,@2.8,@3,@2.8,@3.2];

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
    
//    self.view.backgroundColor = [UIColor cyanColor];
//    self.baseTableView.backgroundColor = [UIColor purpleColor];
}

- (void)doRefreshData
{
    [super doRefreshData];
    
    [self getWithMonthData];
}


- (void)getWithMonthData
{
    [self endAllRefreshing];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        MyFinanceMonthInfoCell *cell = [MyFinanceMonthInfoCell cellForTableView:tableView];
        [cell updateCellData:nil];
        return cell;
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            MyFinanceMonthEarningCell *cell = [MyFinanceMonthEarningCell cellForTableView:tableView];
            [cell updateCellData:_monthList];
            return cell;
        }
        else if (indexPath.row == 1)
        {
            MyFinanceWeekOrderChartViewCell *cell = [MyFinanceWeekOrderChartViewCell cellForTableView:tableView];
            [cell updateCellData:nil title:@"本月订单数据"];
            return cell;
        }
    }
    
    TYZBaseTableViewCell *cell = [TYZBaseTableViewCell cellForTableView:tableView];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return kMyFinanceMonthInfoCellHeight;
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            return kMyFinanceMonthEarningCellHeight;
        }
        else if (indexPath.row == 1)
        {
            return [MyFinanceWeekOrderChartViewCell getWithCellHeight];
        }
    }
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.001;
    }
    else
    {
        return 30;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], 30)];
        view.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
        UILabel *label = [TYZCreateCommonObject createWithLabel:view labelFrame:CGRectMake(15, 0, [[UIScreen mainScreen] screenWidth] - 30, 30) textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
        label.text = @"年度收益波动图";
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

@end





















