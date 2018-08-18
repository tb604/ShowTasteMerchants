//
//  MyWalletDetailViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/19.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyWalletDetailViewController.h"
#import "LocalCommon.h"
#import "MyWalletDetailSectionHeaderView.h"
#import "MyWalletDetailViewCell.h"
#import "MyWalletNavTitleView.h"
#import "MyWalletDetailConditionBackgroundView.h"
#import "CellCommonDataEntity.h"
#import "UserLoginStateObject.h"
#import "MyWalletConsumeEntity.h"


@interface MyWalletDetailViewController ()
{
    MyWalletNavTitleView *_titleView;
    
    MyWalletDetailConditionBackgroundView *_conditionView;
    
    /**
     *  分类。0全部；1收入；2支出
     */
    NSInteger _category;
    
}
/**
 *  分类。0全部；1收入；2支出
 */
@property (nonatomic, assign) NSInteger category;

@property (nonatomic, strong) MyWalletNavTitleView *titleView;

@property (nonatomic, assign) BOOL isShow;

- (void)initWithTitleView;

- (void)showWithConditionView:(BOOL)show;

- (void)getWithWalletDetailData;

@end

@implementation MyWalletDetailViewController
- (void)initWithVar
{
    [super initWithVar];
    
    _isShow = YES;
    
    _category = 0;
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
//    self.title = @"明细";
    [self initWithTitleView];
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.baseTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], 0)];
    
    [self doRefreshData];
}

- (void)clickedBack:(id)sender
{
    [self showWithConditionView:NO];
    [super clickedBack:sender];
}

- (void)initWithTitleView
{
    if (!_titleView)
    {
        AppDelegate *app = [UtilityObject appDelegate];
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth] - 120, [app navBarHeight]);
        _titleView = [[MyWalletNavTitleView alloc] initWithFrame:frame];
//        _titleView.backgroundColor = [UIColor lightGrayColor];
        self.navigationItem.titleView = _titleView;
    }
    __weak typeof(self)weakSelf = self;
    _titleView.viewCommonBlock = ^(id data)
    {
        [weakSelf showWithConditionView:weakSelf.isShow];
    };
}

- (void)doRefreshData
{
    [super doRefreshData];
    
    [self getWithWalletDetailData];
    
}

- (void)doMoreRefreshData
{
    [super doMoreRefreshData];
    
    [self getWithWalletDetailData];
}

- (void)showWithConditionView:(BOOL)show
{
    AppDelegate *app = [UtilityObject appDelegate];
    if (!_conditionView)
    {
        CGRect frame = CGRectMake(0, [app navBarHeight] + STATUSBAR_HEIGHT, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight] - [app navBarHeight] - STATUSBAR_HEIGHT);
        _conditionView = [[MyWalletDetailConditionBackgroundView alloc] initWithFrame:frame];
        _conditionView.alpha = 0;
    }
    __weak typeof(self)weakSelf = self;
    _conditionView.choiceConditionBlock = ^(id data)
    {
        CellCommonDataEntity *commonEnt = data;
        debugLog(@"title=%@", commonEnt.title);
        [weakSelf.titleView updateViewData:commonEnt.title];
        [weakSelf showWithConditionView:weakSelf.isShow];
        weakSelf.category = commonEnt.tag;
        [weakSelf doRefreshData];
    };
    
    
    if (show)
    {
        [self.view.window addSubview:_conditionView];
        [UIView animateWithDuration:0.5 animations:^{
            _conditionView.alpha = 1.0;
        }];
        _isShow = NO;
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            _conditionView.alpha = 0;
        } completion:^(BOOL finished) {
            [_conditionView removeFromSuperview];
        }];
        _isShow = YES;
    }
    
    /*if (show)
    {
//        _conditionView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], 0);
//        [_restaurantClassifiyView updateWithHiddenFrame];
//        CGFloat height = [[UIScreen mainScreen] screenHeight] - [app navBarHeight] - STATUSBAR_HEIGHT;
        [self.view addSubview:_conditionView];
        [UIView animateWithDuration:0.2 animations:^{
//            _conditionView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], height);
//            [_conditionView updateWithShowFrame];
        } completion:^(BOOL finished) {
//            [_restaurantClassifiyView updateHidden:NO];
        }];
        _isShow = NO;
    }
    else
    {
        [UIView animateWithDuration:0.2 animations:^{
//            _conditionView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], 0);
//            [_conditionView updateHidden:YES];
//            [_conditionView updateWithHiddenFrame];
        } completion:^(BOOL finished) {
            [_conditionView removeFromSuperview];
        }];
        _isShow = YES;
    }*/
}

- (void)getWithWalletDetailData
{
    [HCSNetHttp requestWithUserConsume:[UserLoginStateObject getUserId] category:_category pageIndex:self.pageId completion:^(id result) {
        [self responseWithUserConsume:result];
    }];
    
}

- (void)responseWithUserConsume:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success)
    {
        if (self.pageId == 1)
        {
            [self.baseList removeAllObjects];
            [self.baseList addObjectsFromArray:respond.data];
        }
        else
        {
            for (MyWalletConsumeEntity *ent in respond.data)
            {
                BOOL bRet = NO;
                for (MyWalletConsumeEntity *entity in self.baseList)
                {
                    if ([ent.showDate isEqualToString:entity.showDate])
                    {
                        [entity.subConsumeList addObjectsFromArray:ent.subConsumeList];
                        bRet = YES;
                        break;
                    }
                }
                if (!bRet)
                {
                    [self.baseList addObject:ent];
                }
            }
        }
        [self.baseTableView reloadData];
        self.pageId += 1;
    }
    else if (respond.errcode == respond_nodata)
    {
        if (self.pageId == 1)
        {
            [self.baseList removeAllObjects];
            [self.baseTableView reloadData];
        }
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
    
    [self endAllRefreshing];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.baseList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MyWalletConsumeEntity *ent = self.baseList[section];
    NSInteger count = [ent.subConsumeList count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyWalletDetailViewCell *cell = [MyWalletDetailViewCell cellForTableView:tableView];
    MyWalletConsumeEntity *ent = self.baseList[indexPath.section];
    [cell updateCellData:ent.subConsumeList[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kMyWalletDetailViewCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kMyWalletDetailSectionHeaderViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MyWalletConsumeEntity *ent = self.baseList[section];
    CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kMyWalletDetailSectionHeaderViewHeight);
    MyWalletDetailSectionHeaderView *headerView = [[MyWalletDetailSectionHeaderView alloc] initWithFrame:frame];
    NSDate *date = [NSDate date];
    NSString *strdate = [date stringWithFormat:@"yyyy-MM"];
    if ([ent.showDate isEqualToString:strdate])
    {
        [headerView updateViewData:@"当月"];
    }
    else
    {
        [headerView updateViewData:ent.showDate];
    }
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MyWalletConsumeEntity *ent = self.baseList[indexPath.section];
    
    [MCYPushViewController showWithMyWalletDetailStreamVC:self data:ent.subConsumeList[indexPath.row] completion:nil];
}

@end


















