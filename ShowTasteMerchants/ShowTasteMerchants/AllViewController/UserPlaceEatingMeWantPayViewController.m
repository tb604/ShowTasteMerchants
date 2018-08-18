//
//  UserPlaceEatingMeWantPayViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "UserPlaceEatingMeWantPayViewController.h"
#import "LocalCommon.h"
#import "UserPlaceEatingOrderBaseViewCell.h"
#import "UserPlaceEatingPayFoodViewCell.h"
#import "UserPlaceEatingMeWantPayMoneyCell.h"
#import "DinersOrderDetailBottomView.h"
#import "UserMeWantPayHeaderView.h"

@interface UserPlaceEatingMeWantPayViewController ()
{
    DinersOrderDetailBottomView *_bottomView;
}

- (void)initWithBottomView;

@end

/**
 *  就餐完，点击我要支付，后显示的清单视图控制器
 */
@implementation UserPlaceEatingMeWantPayViewController

- (void)initWithVar
{
    [super initWithVar];
    
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = @"结算清单";
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithBottomView];
}

- (void)clickedBack:(id)sender
{
    if (self.popResultBlock)
    {
        self.popResultBlock(_orderDetailEntity);
    }
    [super clickedBack:sender];
}

- (void)initWithBottomView
{
    CGFloat statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navBarHeight = self.navigationController.navigationBar.bounds.size.height;
    CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight] - statusHeight - navBarHeight - TABBAR_HEIGHT);
    self.baseTableView.frame = frame;
    __weak typeof(self)blockSelf = self;
    if (!_bottomView)
    {
        _bottomView = [[DinersOrderDetailBottomView alloc] initWithFrame:CGRectMake(0, frame.size.height, [[UIScreen mainScreen] screenWidth], TABBAR_HEIGHT)];
        [self.view addSubview:_bottomView];
    }
    _bottomView.bottomClickedBlock = ^(NSString *title, NSInteger tag)
    {
        [blockSelf bottomViewClicked:title tag:tag];
    };
    [_bottomView updateWithBottom:_orderDetailEntity.order buttonWidthType:1 buttonTitle:@"去支付"];
}

- (void)bottomViewClicked:(NSString *)title tag:(NSInteger)tag
{
    if ([title isEqualToString:@"去支付"])
    {
        // 进入支付方式
        [MCYPushViewController showWithPayWayVC:self data:_orderDetailEntity completion:^(id data) {
            // 支付完成后返回
            OrderDetailDataEntity *retOrderDetailEnt = data;
            _orderDetailEntity.order.status = retOrderDetailEnt.order.status;
//            [self reloadWithOrderDetail];
        }];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return [_orderDetailEntity.details count];
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {// 订单基本信息
        UserPlaceEatingOrderBaseViewCell *cell = [UserPlaceEatingOrderBaseViewCell cellForTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell updateCellData:_orderDetailEntity.order];
        return cell;
    }
    else if (indexPath.section == 1)
    {// 菜品列表
        UserPlaceEatingPayFoodViewCell *cell = [UserPlaceEatingPayFoodViewCell cellForTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell updateCellData:_orderDetailEntity.details[indexPath.row]];
        return cell;
    }
    else
    {
        UserPlaceEatingMeWantPayMoneyCell *cell = [UserPlaceEatingMeWantPayMoneyCell cellForTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell updateCellData:_orderDetailEntity];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return [UserPlaceEatingOrderBaseViewCell getWithCellHeight:_orderDetailEntity.order.type];
//        return kUserPlaceEatingOrderBaseViewCellHeight;
    }
    else if (indexPath.section == 1)
    {
        OrderFoodInfoEntity *foodEnt = _orderDetailEntity.details[indexPath.row];
        return [UserPlaceEatingPayFoodViewCell getWithCellHeight:foodEnt];
    }
    else
    {
        return kUserPlaceEatingMeWantPayMoneyCellHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 30;
    }
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], 30);
        UserMeWantPayHeaderView *view = [[UserMeWantPayHeaderView alloc] initWithFrame:frame];
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}



@end
