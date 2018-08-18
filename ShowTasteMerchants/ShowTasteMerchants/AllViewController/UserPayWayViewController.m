//
//  UserPayWayViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "UserPayWayViewController.h"
#import "LocalCommon.h"
#import "CellCommonDataEntity.h"
#import "UserPayWayViewCell.h"
#import "UserPayWayHeaderView.h"
#import "UserPayWayFooterView.h"
#import "UserPayWayPriceDescCell.h"
#import "WXPayManager.h" // 微信
#import "AliPayClient.h" // 支付宝
#import "DinersOrderDetailViewController.h"


@interface UserPayWayViewController ()
{
    UserPayWayHeaderView *_headerView;
    
    UserPayWayFooterView *_footerView;
    
}

/**
 *  支付宝支付
 */
@property (nonatomic, strong) AliPayClient *aliPayClient;

/**
 *  微信支付
 */
@property (nonatomic, strong) WXPayManager *wxPay;

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)initWithHeaderView;

- (void)initWithFooterView;

- (void)payWithPrice:(CGFloat)price withWay:(NSInteger)way;

/**
 *  微信支付
 *
 *  @param price   金额
 *  @param tradeNo 交易号
 */
- (void)wxPay:(CGFloat)price tradeNo:(NSString *)tradeNo;

/**
 *  支付宝支付
 *
 *  @param price   金额
 *  @param tradeNo 交易号
 */
- (void)alipay:(CGFloat)price tradeNo:(NSString *)tradeNo;

/**
 *  支付宝支付返回结果通知
 *
 *  @param note <#note description#>
 */
- (void)alipayResult:(NSNotification *)note;

/** 进入后台后调用 */
- (void)appDidEnterBackground:(NSNotification *)notification;


@end

@implementation UserPayWayViewController

- (void)dealloc
{
    [SVProgressHUD dismiss];
    // 微信支付(0)；支付宝支付(1)
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAliPayNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayResult:) name:kAliPayNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAliPayNotification object:nil];
    
    [super viewDidDisappear:animated];
}



- (void)initWithVar
{
    [super initWithVar];
    
    
    self.wxPay = [WXPayManager sharedManager];
    __weak typeof(self)weakSelf = self;
    _wxPay.wxPayStateBlock = ^(int state)
    {// 1表示失败；0表示成功
        [weakSelf payResult:state];
    };
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    
    
    // 支付宝支付
    _aliPayClient = [[AliPayClient alloc] init];
    _aliPayClient.AliPayStateBlock = ^(NSInteger resultState)
    {// 支付宝支付，返回结果
        // 6002
        [weakSelf aliPayStateClient:resultState];
    };
    
    
    CellCommonDataEntity *entity = [CellCommonDataEntity new];
    entity.title = @"支付宝支付";
    entity.subTitle = entity.title;
    entity.checkImgName = @"btn_diners_check_sel";
    entity.uncheckImgName = @"btn_diners_check_nor";
    entity.thumalImgName = @"hall-order_pay_icon_zhifubao";
    entity.isCheck = YES;
    entity.tag = 0;
    [self.baseList addObject:entity];
    
    entity = [CellCommonDataEntity new];
    entity.title = @"微信支付";
    entity.subTitle = entity.title;
    entity.checkImgName = @"btn_diners_check_sel";
    entity.uncheckImgName = @"btn_diners_check_nor";
    entity.thumalImgName = @"hall-order_pay_icon_weixin";
    entity.isCheck = NO;
    entity.tag = 1;
    [self.baseList addObject:entity];
    
    self.indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = @"支付方式";
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.baseTableView.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
//    self.baseTableView.pagingEnabled = NO;
    self.baseTableView.scrollEnabled = NO;
    
    [self initWithHeaderView];
    
    [self initWithFooterView];
}

- (void)initWithHeaderView
{
    CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kUserPayWayHeaderViewHeight);
    _headerView = [[UserPayWayHeaderView alloc] initWithFrame:frame];
//    self.baseTableView.tableHeaderView = _headerView;
}

- (void)initWithFooterView
{
    CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kUserPayWayFooterViewHeight);
    _footerView = [[UserPayWayFooterView alloc] initWithFrame:frame];
    self.baseTableView.tableFooterView = _footerView;
    __weak typeof(self)weakSelf = self;
    _footerView.viewCommonBlock = ^(id data)
    {// 支付
        [weakSelf touchWithPay];
    };
    
    [_footerView updateViewData:_orderDetailEntity];
    
}

- (void)touchWithPay
{
    [SVProgressHUD showWithStatus:@"支付中"];
    if (_indexPath.row == 0)
    {// 支付宝支付
        debugLog(@"支付宝支付");
        [self payWithPrice:0.01 withWay:EPaymentTypeAliPay];
    }
    else if (_indexPath.row == 1)
    {// 微信支付
        debugLog(@"微信支付");
        [SVProgressHUD showErrorWithStatus:@"暂不支持微信支付。"];
        [self payWithPrice:0.01 withWay:EPaymentTypeWX];
    }
}

- (void)payWithPrice:(CGFloat)price withWay:(NSInteger)way
{
    if (way == EPaymentTypeAliPay)
    {// 支付宝支付
        [self alipay:price tradeNo:_orderDetailEntity.order.order_id];
    }
    else
    {// 微信支付
        [self wxPay:price tradeNo:_orderDetailEntity.order.order_id];
    }
    
    /*if (_orderDetailEntity.order.status == NS_ORDER_WAITING_PAY_DEPOSIT_STATE)
    {// 支付订金
        _orderDetailEntity.order.status = NS_ORDER_COMPLETED_BOOKING_STATE;
    }
    else if (_orderDetailEntity.order.status == NS_ORDER_PAYAMOUNTCONFIRMED_STATE)
    {// 吃饭后支付
        _orderDetailEntity.order.status = NS_ORDER_PAY_COMPLETE_STATE;
    }
    
    if (self.popResultBlock)
    {
        self.popResultBlock(_orderDetailEntity);
    }
    [self clickedBack:nil];
     */
}

/**
 *  微信支付
 *
 *  @param price   金额
 *  @param tradeNo 交易号
 */
- (void)wxPay:(CGFloat)price tradeNo:(NSString *)tradeNo
{
    /*if (![WXApi isWXAppInstalled])
    {// 检查微信是否已被用户安装
        debugLog(@"用户手机上没有安装微信app");
        [SVProgressHUD dismiss];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未安装微信客户端，是否立即安装？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }
    
    if ([WXApi isWXAppSupportApi])
    {// 判断当前微信的版本是否支持OpenApi
        //        debugLog(@"微信支持openApi");
    }
    
    NSString *notifiyUrl = [NSString stringWithFormat:@"%@tour/pay/tenpayCallback", REQUESTBASICURL];
    debugLog(@"url=%@", notifiyUrl);
    [_wxPay payProductWithPrice:price tradeNo:tradeNo title:@"51导游微信支付" notifiyUrl:notifiyUrl];
     */
}

/**
 *  支付宝支付
 *
 *  @param price   金额
 *  @param tradeNo 交易号
 */
- (void)alipay:(CGFloat)price tradeNo:(NSString *)tradeNo
{
//    NSString *notifiyUrl = @"";//[NSString stringWithFormat:@"%@tour/guideTrip/api.do?method=alipayClientCallback", REQUESTBASICURL];
//    [_aliPayClient payProductWithPrice:price tradeNo:tradeNo title:@"支付" notifiyUrl:notifiyUrl];
    [_aliPayClient payProductWithPriceUrl:price orderNo:tradeNo name:_orderDetailEntity.order.shop_name body:@"秀味App支付"];
}

// 支付宝支付完成后调用
- (void)aliPayStateClient:(NSInteger)resultState
{
    NSInteger state = (resultState == 9000 ? 0 : 1);
    [self payResult:state];
}



- (void)refreshData
{
    CellCommonDataEntity *selectEnt = nil;
    for (CellCommonDataEntity *ent in self.baseList)
    {
        ent.isCheck = NO;
        if (ent.tag == _indexPath.row)
        {
            selectEnt = ent;
        }
    }
    selectEnt.isCheck = YES;
    [self.baseTableView reloadData];
}

/**
 *  支付返回的状态
 *
 *  @param resultState 0表示成功；1表示失败
 */
- (void)payResult:(NSInteger)resultState
{
    debugMethod();
    if (resultState == 0)
    {
        [SVProgressHUD showSuccessWithStatus:@"交易成功"];
        
        
        DinersOrderDetailViewController *dinersOrderDetailVC = nil;
        NSArray *array = self.navigationController.viewControllers;
        for (id vc in array)
        {
            if ([vc isKindOfClass:[DinersOrderDetailViewController class]])
            {
                dinersOrderDetailVC = vc;
                break;
            }
        }
        if (dinersOrderDetailVC)
        {
            if (_orderDetailEntity.order.status == NS_ORDER_WAITING_PAY_DEPOSIT_STATE)
            {// 已接单，要求支付订金
                dinersOrderDetailVC.orderDetailEntity.order.status = NS_ORDER_COMPLETED_BOOKING_STATE;
                dinersOrderDetailVC.orderDetailEntity.order.status_remark = @"预订完成";
            }
            else if (_orderDetailEntity.order.status == NS_ORDER_IN_CHECKOUT_STATE)
            {// 服务员确认了，食客可以支付了
                dinersOrderDetailVC.orderDetailEntity.order.status = NS_ORDER_PAY_COMPLETE_STATE;
                dinersOrderDetailVC.orderDetailEntity.order.status_remark = @"支付完成";
            }
            [dinersOrderDetailVC doRefreshData];
//            [dinersOrderDetailVC.baseTableView reloadData];
            [self.navigationController popToViewController:dinersOrderDetailVC animated:YES];
        }
        
//        if (self.popResultBlock)
//        {
//            self.popResultBlock(@(resultState));
//        }
//        [self performSelector:@selector(clickedBack:) withObject:nil afterDelay:2];
    }
    else
    {
        [SVProgressHUD showSuccessWithStatus:@"交易失败"];
    }
}

/**
 *  支付宝支付返回结果通知
 *
 *  @param note <#note description#>
 */
- (void)alipayResult:(NSNotification *)note
{
    debugMethod();
    // 9000表示支付成功；其他表示失败
    NSDictionary *resultDict = [note object];
    NSInteger resultState = [[resultDict objectForKey:@"resultStatus"] integerValue];
    
    NSInteger state = (resultState == 9000 ? 0 : 1);
    [self payResult:state];
}

/** 进入后台后调用 */
- (void)appDidEnterBackground:(NSNotification *)notification
{
    [SVProgressHUD dismiss];
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
    return [self.baseList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        UserPayWayPriceDescCell *cell = [UserPayWayPriceDescCell cellForTableView:tableView];
        [cell updateCellData:_orderDetailEntity];
        return cell;
    }
    else
    {
        UserPayWayViewCell *cell = [UserPayWayViewCell cellForTableView:tableView];
        [cell updateCellData:self.baseList[indexPath.row]];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return kUserPayWayPriceDescCellHeight;
    }
    return kUserPayWayViewCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.001;
    }
    else
    {
        return kUserPayWayHeaderViewHeight;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        return _headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 10;
    }
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section != 0)
    {
        self.indexPath = indexPath;
        
        [self refreshData];
    }
}


@end
