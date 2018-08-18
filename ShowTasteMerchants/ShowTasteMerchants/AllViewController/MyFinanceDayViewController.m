//
//  MyFinanceDayViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/7.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyFinanceDayViewController.h"
#import "LocalCommon.h"
#import "MyFinanceDayBaseInfoCell.h"
#import "MyFinanceDayOrderInfoCell.h"
#import "MyFinanceDayAbnormalOrderCell.h"
#import "MyFinanceDayOrderViewCell.h"
#import "WYXCalendarDayModel.h"
#import "TYZChoiceDateBackgroundView.h"

@interface MyFinanceDayViewController ()

/// 选择日期
@property (nonatomic, strong) TYZChoiceDateBackgroundView *choiceDateView;

@property (nonatomic, copy) NSString *todayDate;

@property (nonatomic, strong) MyFinanceTodayDataEntity *todayEntity;

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)getWithDayData;

@end

@implementation MyFinanceDayViewController

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
    
    NSDate *date = [NSDate date];
    NSString *strDate = [date stringWithFormat:@"yyyy-MM-dd"];
    self.todayDate = strDate;
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    AppDelegate *app = [UtilityObject appDelegate];
    CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight] - [app navBarHeight] - STATUSBAR_HEIGHT);
    self.baseTableView.frame = frame;
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self hiddenFooterView:YES];
    
//    self.view.backgroundColor = [UIColor blueColor];
//    self.baseTableView.backgroundColor = [UIColor redColor];
    
    [self doRefreshData];
}

- (void)doRefreshData
{
    [super doRefreshData];
    
    [self getWithDayData];
}

- (void)getWithDayData
{
    [HCSNetHttp requestWithOrderReportDaySummary:[UserLoginStateObject getCurrentShopId] date:_todayDate completion:^(id result) {
        [self responseWithOrderReportDaySummary:result];
    }];
}

- (void)responseWithOrderReportDaySummary:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success)
    {
        [self.baseList removeAllObjects];
        self.todayEntity = respond.data;
        _todayEntity.todayDate = _todayDate;
        [self.baseTableView reloadData];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
    
    [self endAllRefreshing];
}


- (void)showWithChoiceDateView:(BOOL)show
{
    __weak typeof(self)blockSelf = self;
    if (!_choiceDateView)
    {
        _choiceDateView = [[TYZChoiceDateBackgroundView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight])];
        _choiceDateView.alpha = 0;
    }
    _choiceDateView.TouchDateBlock = ^(NSString *date, NSInteger type)
    {
        if (type == -1)
        {
            return;
        }
        [blockSelf changedWithDate:date];
    };
    if (show)
    {
        [_choiceDateView updateWithDate:_todayDate];
        [self.view.window addSubview:_choiceDateView];
        [UIView animateWithDuration:0.5 animations:^{
            _choiceDateView.alpha = 1.0;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            _choiceDateView.alpha = 0;
        } completion:^(BOOL finished) {
            [_choiceDateView removeFromSuperview];
        }];
    }
}

- (void)changedWithDate:(NSString *)date
{
    if (date)
    {
        self.todayDate = date;
        _todayEntity.todayDate = _todayDate;
        [MCYPushViewController reloadWithTableView:self.baseTableView indexPath:_indexPath reloadType:2];
    }
    
    [self showWithChoiceDateView:NO];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return EN_FD_MAX_SECTION;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == EN_FD_ABNORMAL_ORDER_SECTION)
    {
        return 1 + [self.baseList count];
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    if (indexPath.section == EN_FD_BASE_INFO_SECTION)
    {// 基本信息
        MyFinanceDayBaseInfoCell *cell = [MyFinanceDayBaseInfoCell cellForTableView:tableView];
        [cell updateCellData:_todayEntity];
        cell.todayWithDateBlock = ^()
        {// 回到今天
            NSDate *date = [NSDate date];
            NSString *strDate = [date stringWithFormat:@"yyyy-MM-dd"];
//            debugLog(@"date=%@", strDate);
            self.todayDate = strDate;
            _todayEntity.todayDate = strDate;
            [MCYPushViewController reloadWithTableView:tableView indexPath:indexPath reloadType:2];
        };
        
        cell.choiceWithDateBlock = ^()
        {// 选择日期
            weakSelf.indexPath = indexPath;
            [self showWithChoiceDateView:YES];
        };
        cell.touchTurnoverBlock = ^()
        {// 点击营业额，进入“日汇总”
            [MCYPushViewController showWithAggregateVC:self data:_todayDate completion:nil];
        };
        return cell;
    }
    else if (indexPath.section == EN_FD_ORDER_SECTION)
    {// 今日订单
        MyFinanceDayOrderInfoCell *cell = [MyFinanceDayOrderInfoCell cellForTableView:tableView];
        [cell updateCellData:_todayEntity];
        return cell;
    }
    else
    {
        if (indexPath.row == 0)
        {
            MyFinanceDayAbnormalOrderCell *cell = [MyFinanceDayAbnormalOrderCell cellForTableView:tableView];
            [cell updateCellData:@(_todayEntity.exp.count)];
            return cell;
        }
        else
        {
            MyFinanceDayOrderViewCell *cell = [MyFinanceDayOrderViewCell cellForTableView:tableView];
            [cell updateCellData:self.baseList[indexPath.row - 1]];
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 60.;
    if (indexPath.section == EN_FD_BASE_INFO_SECTION)
    {
        height = kMyFinanceDayBaseInfoCellHeight;
    }
    else if (indexPath.section == EN_FD_ORDER_SECTION)
    {
        height = kMyFinanceDayOrderInfoCellHeight;
    }
    else
    {
        if (indexPath.row == 0)
        {
            height = kMyFinanceDayAbnormalOrderCellHeight;
        }
    }
    
    return height;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == EN_FD_BASE_INFO_SECTION)
    {
        return 0.001;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == EN_FD_ORDER_SECTION)
    {
        if (indexPath.row == 0)
        {// 今日订单
            //[MCYPushViewController showWithFinanceTodayOrderListVC:self data:nil completion:nil];
            [MCYPushViewController showWithTodayOrderSummaryVC:self data:_todayDate completion:nil];
        }
    }
    else if (indexPath.section == EN_FD_ABNORMAL_ORDER_SECTION)
    {
        if (indexPath.row == 0)
        {
            _todayEntity.exp.isCheck = !_todayEntity.exp.isCheck;
            NSMutableArray *foodList = [NSMutableArray new];
            if (_todayEntity.exp.isCheck)
            {
                [self.baseList insertObjects:_todayEntity.exp.records atIndex:indexPath.row+1];
                for (NSInteger i=1; i<=_todayEntity.exp.records.count; i++)
                {
                    [foodList addObject:[NSIndexPath indexPathForRow:i+indexPath.row inSection:indexPath.section]];
                }
                [tableView insertRowsAtIndexPaths:foodList withRowAnimation:UITableViewRowAnimationFade];
            }
            else
            {
                [self.baseList removeObjectsInArray:_todayEntity.exp.records];
                for (NSInteger i=1; i<=_todayEntity.exp.records.count; i++)
                {
                    [foodList addObject:[NSIndexPath indexPathForRow:i+indexPath.row inSection:indexPath.section]];
                }
                [tableView deleteRowsAtIndexPaths:foodList withRowAnimation:UITableViewRowAnimationFade];
            }
        }
    }
}

@end



















