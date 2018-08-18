//
//  MyFinanceTodayOrderListViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/9.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyFinanceTodayOrderListViewController.h"
#import "LocalCommon.h"
#import "MyFinanceDayOrderViewCell.h"

@interface MyFinanceTodayOrderListViewController ()

- (void)getWithOrderListData;

@end

@implementation MyFinanceTodayOrderListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *array = @[@"1", @"2", @"3", @"4"];
    [self.baseList addObject:array];
    
    array = @[@"1", @"2", @"3", @"4"];
    [self.baseList addObject:array];
    
    array = @[@"1", @"2", @"3", @"4"];
    [self.baseList addObject:array];
    
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
    
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = @"今日订单汇总";
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
}

- (void)doRefreshData
{
    [super doRefreshData];
    
    [self getWithOrderListData];
    
}

- (void)doMoreRefreshData
{
    [super doMoreRefreshData];
    
    [self getWithOrderListData];
}

- (void)getWithOrderListData
{
    
    [self endAllRefreshing];
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
    MyFinanceDayOrderViewCell *cell = [MyFinanceDayOrderViewCell cellForTableView:tableView];
    [cell updateCellData:nil];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kMyFinanceDayOrderViewCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], 30)];
    view.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    UILabel *label = [TYZCreateCommonObject createWithLabel:view labelFrame:CGRectMake(15, 0, [[UIScreen mainScreen] screenWidth] - 30, 30) textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
    label.text = @"午餐段";
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}


@end























