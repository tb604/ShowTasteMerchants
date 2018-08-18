//
//  MyRestaurantBookedViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/17.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantBookedViewController.h"
#import "LocalCommon.h"
#import "MyRestaurantBookedViewCell.h"
#import "MyRestaurantBookedHeaderView.h"

@interface MyRestaurantBookedViewController ()
{
    MyRestaurantBookedHeaderView *_headerView;
}

- (void)initWithHeaderView;

- (void)getWithBookedData;

@end

@implementation MyRestaurantBookedViewController

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
    
    [self.baseList addObject:@"1"];
    [self.baseList addObject:@"1"];
    [self.baseList addObject:@"1"];
    [self.baseList addObject:@"1"];
    [self.baseList addObject:@"1"];
    [self.baseList addObject:@"1"];
    [self.baseList addObject:@"1"];
    [self.baseList addObject:@"1"];
    [self.baseList addObject:@"1"];
    [self.baseList addObject:@"1"];
    [self.baseList addObject:@"1"];
    [self.baseList addObject:@"1"];
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithHeaderView];
    
    [self hiddenFooterView:YES];
    
    AppDelegate *app = [UtilityObject appDelegate];
    self.baseTableView.height = [[UIScreen mainScreen] screenHeight] - [app navBarHeight] * 2 - STATUSBAR_HEIGHT - [app tabBarHeight] - kMyRestaurantBookedHeaderViewHeight;
    self.baseTableView.top = _headerView.bottom;
    
}

- (void)doRefreshData
{
    [super doRefreshData];
    
    [self getWithBookedData];
}

- (void)initWithHeaderView
{
    if (!_headerView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kMyRestaurantBookedHeaderViewHeight);
        _headerView = [[MyRestaurantBookedHeaderView alloc] initWithFrame:frame];
        [self.view addSubview:_headerView];
    }
}

- (void)getWithBookedData
{
    
    [self endAllRefreshing];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.baseList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyRestaurantBookedViewCell *cell = [MyRestaurantBookedViewCell cellForTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateCellData:nil];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MyRestaurantBookedViewCell getWithCellHeight:10];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.001;
    }
    else
    {
        return 10.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

@end
