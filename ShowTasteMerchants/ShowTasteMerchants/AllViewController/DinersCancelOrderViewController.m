//
//  DinersCancelOrderViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/20.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DinersCancelOrderViewController.h"
#import "LocalCommon.h"
#import "DinersCancelOrderCell.h"
#import "DinersOrderDetailBottomView.h"
#import "CellCommonDataEntity.h"
#import "DinersCancelOrderOtherCell.h"
#import "CancelReservationEntity.h" // 取消订单的传入参数
#import "UserLoginStateObject.h"
#import "DinersCancelOrderInfoView.h"


@interface DinersCancelOrderViewController () <UIAlertViewDelegate>
{
    
    DinersCancelOrderInfoView *_headerView;
    
    DinersOrderDetailBottomView *_bottomView;
}

@property (nonatomic, assign) CGPoint point;

- (void)initWithHeaderView;

@property (nonatomic, strong) CancelReservationEntity *cancelEntity;

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)initWithBottomView;

@end

@implementation DinersCancelOrderViewController

- (void)initWithVar
{
    [super initWithVar];
        
    [self.baseList addObjectsFromArray:_reasonList];
    
    CellCommonDataEntity *firstEnt = self.baseList[0];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    self.indexPath = indexPath;
    
    _cancelEntity = [[CancelReservationEntity alloc] init];
    _cancelEntity.userId = [UserLoginStateObject getUserId];
    _cancelEntity.orderId = _orderDetailEntity.order_id;
    _cancelEntity.remark = firstEnt.subTitle;
    _cancelEntity.reason = firstEnt.tag;
    
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    if (_orderDetailEntity.status == NS_ORDER_COMPLETED_BOOKING_STATE)
    {// 预定完成
        self.title = @"申请退单";
    }
    else
    {
        self.title = @"取消订单";
    }
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    
    
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.baseTableView.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    AppDelegate *app = [UtilityObject appDelegate];
    CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight] - [app navBarHeight] - [app tabBarHeight] - STATUSBAR_HEIGHT);
    self.baseTableView.frame = frame;
    
    [self initWithHeaderView];
    
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

- (void)initWithHeaderView
{
    if (!_headerView && _orderDetailEntity.status == NS_ORDER_COMPLETED_BOOKING_STATE)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kDinersCancelOrderInfoViewHeight);
        _headerView = [[DinersCancelOrderInfoView alloc] initWithFrame:frame];
        self.baseTableView.tableHeaderView = _headerView;
    }
    [_headerView updateViewData:_orderDetailEntity];
}

- (void)initWithBottomView
{
    AppDelegate *app = [UtilityObject appDelegate];
    __weak typeof(self)blockSelf = self;
    if (!_bottomView)
    {
        _bottomView = [[DinersOrderDetailBottomView alloc] initWithFrame:CGRectMake(0, self.baseTableView.bottom, [[UIScreen mainScreen] screenWidth], [app tabBarHeight])];
        [self.view addSubview:_bottomView];
    }
    _bottomView.bottomClickedBlock = ^(NSString *title, NSInteger tag)
    {
        [blockSelf bottomViewClicked:title tag:tag];
    };
    if (_orderDetailEntity.status == NS_ORDER_COMPLETED_BOOKING_STATE)
    {
        [_bottomView updateWithBottom:_orderDetailEntity buttonWidthType:1 buttonTitle:@"确认退单"];
    }
    {
        [_bottomView updateWithBottom:_orderDetailEntity buttonWidthType:1 buttonTitle:@"确认取消"];
    }
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex != buttonIndex)
    {// 取消订单
        [self cancelWithOrder];
    }
}

- (void)bottomViewClicked:(NSString *)title tag:(NSInteger)tag
{
    if ([title isEqualToString:@"确认取消"])
    {
        
        if (_orderDetailEntity.status == NS_ORDER_COMPLETED_BOOKING_STATE)
        {// 预订就餐，食客支付了订金后，退单
            [SVProgressHUD showWithStatus:@"检查中"];
            [HCSNetHttp requestWithOrderCancelOrderTip:_orderDetailEntity.order_id completion:^(id result) {
                TYZRespondDataEntity *respond = result;
                if (respond.errcode == respond_success)
                {
                    NSInteger allow_refund = [respond.data[@"allow_refund"] integerValue];
                    if (allow_refund == 1)
                    {
                        [self cancelWithOrder];
                    }
                    else
                    {
                        [SVProgressHUD dismiss];
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:respond.msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                        [alertView show];
                    }
                }
                else
                {
                    [UtilityObject svProgressHUDError:respond viewContrller:self];
                }
            }];
        }
        else
        {
            [self cancelWithOrder];
        }
    }
}

- (void)cancelWithOrder
{
    CellCommonDataEntity *entity = self.baseList[_indexPath.row];
    _cancelEntity = [[CancelReservationEntity alloc] init];
//    _cancelEntity.userId = [UserLoginStateObject getUserId];
    _cancelEntity.shopId = [UserLoginStateObject getCurrentShopId];
    _cancelEntity.orderId = _orderDetailEntity.order_id;
    _cancelEntity.remark = entity.subTitle;
    _cancelEntity.reason = entity.tag;
    [SVProgressHUD showWithStatus:@"取消中"];
    
    [HCSNetHttp requestWithShopOrderCancelOrder:_cancelEntity completion:^(id result) {
        [self responseWithOrderCancelBookOrder:result];
    }];
}

- (void)responseWithOrderCancelBookOrder:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success)
    {
        [SVProgressHUD showSuccessWithStatus:@"取消成功"];
//        _orderDetailEntity.status = 300; // 订单已取消
        /*
         NS_ORDER_SHOP_SAB_STATE = 300, ///< 退单申请中
         NS_ORDER_ORDER_CANCELED_STATE = 301, ///< 订单已取消
         */
//        if (_orderDetailEntity.status == NS_ORDER_COMPLETED_BOOKING_STATE)
//        {// 用户支付了订金的
//            _orderDetailEntity.status = NS_ORDER_SHOP_SAB_STATE;
//        }
//        else
//        {
            _orderDetailEntity.status = NS_ORDER_ORDER_CANCELED_STATE;
//        }
        [self performSelector:@selector(clickedBack:) withObject:nil afterDelay:0.5];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
}

- (void)textViewEdit:(NSInteger)type
{
    if (type == 1)
    {// 编辑开始
        if (kiPhone4)
        {
            if (_orderDetailEntity.status == NS_ORDER_COMPLETED_BOOKING_STATE)
            {
                self.baseTableView.contentOffset = CGPointMake(0, self.baseList.count * 46 + 140 - 20);
            }
            else
            {
                self.baseTableView.contentOffset = CGPointMake(0, self.baseList.count * 46 - 46);
            }
        }
        else
        {
            if (_orderDetailEntity.status == NS_ORDER_COMPLETED_BOOKING_STATE)
            {
                self.baseTableView.contentOffset = CGPointMake(0, self.baseList.count * 46 + 140 - 20);
            }
            else
            {
                self.baseTableView.contentOffset = CGPointMake(0, self.baseList.count * 46 - 46);
            }
        }
    }
    else if (type == 2)
    {// 编辑结束
        self.baseTableView.contentOffset = _point;
    }
}

- (void)otherWithReason:(NSIndexPath *)indexPath data:(id)data
{
    self.indexPath = indexPath;
    CellCommonDataEntity *entity = self.baseList[_indexPath.row];
    entity.subTitle = data;
}



- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //    debugMethod();
    //    if (_fpsLabel.alpha == 0)
    //    {
    //        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
    //            _fpsLabel.alpha = 1;
    //        } completion:NULL];
    //    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
        debugMethod();
    self.point = scrollView.contentOffset;
    if (!decelerate)
    {
        //        debugLog(@"dfdfd");
        //        if (_fpsLabel.alpha != 0)
        //        {
        //            [UIView animateWithDuration:1 delay:2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        //                _fpsLabel.alpha = 0;
        //            } completion:NULL];
        //        }
        [self.view endEditing:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    //    if (_fpsLabel.alpha != 0)
    //    {
    //        [UIView animateWithDuration:1 delay:2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
    //            _fpsLabel.alpha = 0;
    //        } completion:NULL];
    //    }
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
//        debugMethod();
    //    if (_fpsLabel.alpha == 0)
    //    {
    //        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
    //            _fpsLabel.alpha = 1;
    //        } completion:^(BOOL finished) {
    //        }];
    //    }
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.baseList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    if (indexPath.row == [self.baseList count] - 1)
    {
        DinersCancelOrderOtherCell *cell = [DinersCancelOrderOtherCell cellForTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell updateCellData:self.baseList[indexPath.row]];
        cell.textViewEditBlock = ^(NSInteger type)
        {
            [weakSelf textViewEdit:type];
        };
        cell.baseTableViewCellBlock = ^(id data)
        {
            [weakSelf otherWithReason:indexPath data:data];
        };
        return cell;
    }
    DinersCancelOrderCell *cell = [DinersCancelOrderCell cellForTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateCellData:self.baseList[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.baseList count] - 1)
    {
        return kDinersCancelOrderOtherCellHeight;
    }
    return kDinersCancelOrderCellHeight;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *str = @"";
//    if (section == 0)
//    {
        str = @"取消订单的原因";
//    }
//    else
//    {
//        str = @"其它原因";
//    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], 30)];
    view.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    UILabel *label = [TYZCreateCommonObject createWithLabel:view labelFrame:CGRectMake(15, 5, [[UIScreen mainScreen] screenWidth] - 30, 20) textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    label.text = str;
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CellCommonDataEntity *oldEntity = self.baseList[_indexPath.row];
    oldEntity.isCheck = NO;
    
    CellCommonDataEntity *entity = self.baseList[indexPath.row];
    entity.isCheck = YES;
    self.indexPath = indexPath;
    [tableView reloadData];
    
}


@end


























