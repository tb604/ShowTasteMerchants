/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCCustomersPayViewController.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/27 18:09
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCCustomersPayViewController.h"
#import "LocalCommon.h"
#import "CTCCustomersPayHeaderView.h"
#import "CTCCustomersFoodTitleView.h"
#import "ShopOrderDetailBottomView.h"
#import "CTCCustomersPayFoodViewCell.h"
#import "CTCCustomersPaySubFoodViewCell.h"
#import "CTCCustomersPayFooterView.h"
#import "ShopModifyActuallyAmountBackgroundView.h" // 修改金额视图
#import "CTCCustomersPayWayView.h" // 实付方式选择视图
#import "CellCommonDataEntity.h"
#import "CTCCustomersPayScanQrcodeView.h" // 显示二维码视图
#import "CTCCustomersPaySubmitView.h" // 支付确认视图

// requestWithShopOrderPayChannel

@interface CTCCustomersPayViewController ()
{
    CTCCustomersPayHeaderView *_seatNumberView;
    
    CTCCustomersFoodTitleView *_foodTitleView;
    
    /// 选择支付方式视图
    CTCCustomersPayWayView *_payWayView;
    
    /// 显示二维码视图给用户扫描
    CTCCustomersPayScanQrcodeView *_payScanQrcodeView;
    
    /// 支付确认视图
    CTCCustomersPaySubmitView *_paySubmitView;
    
    ShopOrderDetailBottomView *_bottomView;
}

@property (nonatomic, strong) PayChannelDataEntity *payWayEnt;

@property (nonatomic, strong) CTCCustomersPayFooterView *footerView;

/// 修改结算金额视图
@property (nonatomic, strong) ShopModifyActuallyAmountBackgroundView *modifyAmountView;


@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)initWithSeatNumberView;

- (void)initWithFoodTitleView;

- (void)initWithBottomView;

@end

@implementation CTCCustomersPayViewController

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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender 
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -
#pragma mark override
- (void)initWithVar
{
    [super initWithVar];
    
//    debugLog(@"paycount=%d", (int)_payWayList.count);
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = @"食客买单";
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithSeatNumberView];
    
    [self initWithFoodTitleView];
    
    AppDelegate *app = [UtilityObject appDelegate];
    CGRect frame = CGRectMake(0, _foodTitleView.bottom, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight] - _foodTitleView.bottom - [app tabBarHeight] - STATUSBAR_HEIGHT - [app navBarHeight]);
    self.baseTableView.frame = frame;
    self.baseTableView.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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

- (void)initWithSeatNumberView
{
    if (!_seatNumberView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], 60);
        _seatNumberView = [[CTCCustomersPayHeaderView alloc] initWithFrame:frame];
        [self.view addSubview:_seatNumberView];
    }
    [_seatNumberView updateViewData:_orderDetailEntity];
}

- (void)initWithFoodTitleView
{
    if (!_foodTitleView)
    {
        CGRect frame = CGRectMake(0, _seatNumberView.bottom, [[UIScreen mainScreen] screenWidth], kCTCCustomersFoodTitleViewHeight);
        _foodTitleView = [[CTCCustomersFoodTitleView alloc] initWithFrame:frame];
        [self.view addSubview:_foodTitleView];
    }
}

- (void)initWithFooterView
{
    if (!_footerView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kCTCCustomersPayFooterViewHeight);
        _footerView = [[CTCCustomersPayFooterView alloc] initWithFrame:frame];
        self.baseTableView.tableFooterView = _footerView;
    }
    [_footerView updateViewData:_orderDetailEntity];
    __weak typeof(self)weakSelf = self;
    _footerView.touchEditAmountBlock = ^()
    {// 修改价格
        [weakSelf showWithModifyAmountView:YES];
    };
}

- (void)initWithBottomView
{
    if (!_bottomView)
    {
        AppDelegate *app = [UtilityObject appDelegate];
        CGRect frame = CGRectMake(0, self.baseTableView.bottom, [[UIScreen mainScreen] screenWidth], [app tabBarHeight]);
        _bottomView = [[ShopOrderDetailBottomView alloc] initWithFrame:frame];
        [self.view addSubview:_bottomView];
    }
    [_bottomView updateViewData:nil type:6 leftTitle:@"打印票据" rightTitle:@"支付方式"];
    __weak typeof(self)weakSelf = self;
    _bottomView.bottomClickedBlock = ^(NSString *title, NSInteger tag)
    {
        [weakSelf touchWithBottom:title];
    };
}


- (void)touchWithBottom:(NSString *)title
{
    if ([title isEqualToString:@"打印票据"])
    {
        [SVProgressHUD showWithStatus:@"打印提交中"];
        [HCSNetHttp requestWithShopOrderCashPrinter:_orderDetailEntity.order_id shopId:_orderDetailEntity.shop_id completion:^(TYZRespondDataEntity *result) {
            if (result.errcode == respond_success)
            {
                [SVProgressHUD showSuccessWithStatus:@"提交成功"];
            }
            else
            {
                [UtilityObject svProgressHUDError:result viewContrller:self];
            }
        }];
    }
    else if ([title isEqualToString:@"支付方式"])
    {
        [self showWithPayWayView:YES];
    }
}

/**
 *  修改金额视图
 *
 *  @param show YES表示显示，否则NO
 */
- (void)showWithModifyAmountView:(BOOL)show
{
    __weak typeof(self)weakSelf = self;
    if (!_modifyAmountView)
    {
        _modifyAmountView =[[ShopModifyActuallyAmountBackgroundView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight])];
        _modifyAmountView.alpha = 0;
    }
    _modifyAmountView.modifyAmountBlock = ^(id data)
    {
        if (!data)
        {
            [weakSelf showWithModifyAmountView:NO];
        }
        else
        {// 修改金额
            OrderAmountModifyEntity *inputEnt = data;
            
            
            [HCSNetHttp requestWithShopOrderChangeTotal:inputEnt completion:^(TYZRespondDataEntity *respond) {
                if (respond.errcode == respond_success)
                {
                    [SVProgressHUD showSuccessWithStatus:@"修改实付金额成功"];
                    
                    weakSelf.orderDetailEntity.sf_amount = inputEnt.newAmount;
                    weakSelf.orderDetailEntity.waiter_amt_note = inputEnt.note;
                    [weakSelf.footerView updateViewData:weakSelf.orderDetailEntity];
                    [weakSelf.baseTableView reloadData];
                    [weakSelf showWithModifyAmountView:NO];
                }
                else
                {
                    [UtilityObject svProgressHUDError:respond viewContrller:weakSelf];
                }
            }];
        }
    };
    
    if (show)
    {
        [_modifyAmountView updateWithData:_orderDetailEntity];
        [self.view.window addSubview:_modifyAmountView];
        [UIView animateWithDuration:0.5 animations:^{
            _modifyAmountView.alpha = 1.0;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            _modifyAmountView.alpha = 0;
        } completion:^(BOOL finished) {
            [_modifyAmountView removeFromSuperview];
        }];
    }
}

/**
 *  显示支付方式视图
 */
- (void)showWithPayWayView:(BOOL)show
{
    __weak typeof(self)weakSelf = self;
    if (!_payWayView)
    {
        _payWayView =[[CTCCustomersPayWayView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight])];
        _payWayView.alpha = 0;
    }
    _payWayView.selectPayWayBlock = ^(CellCommonDataEntity *payWayEnt)
    {
        [weakSelf showWithPayWayView:NO];
        
        for (PayChannelDataEntity *ent in weakSelf.payWayList)
        {
            if (ent.value == payWayEnt.tag)
            {
                weakSelf.payWayEnt = ent;
            }
        }
        
//        if (payWayEnt.tag == 3)
//        {
            [weakSelf showWithPaySubmitView:YES];
//        }
//        else
//        {
//            // 显示扫描的二维码图片
//            [weakSelf showWithPayScanQrcodeView:YES];
//        }
        
    };
    _payWayView.touchCancelBlock = ^()
    {
        [weakSelf showWithPayWayView:NO];
    };
    
    if (show)
    {
//        [_payWayView updateWithData:_orderDetailEntity];
        [self.view.window addSubview:_payWayView];
        [UIView animateWithDuration:0.5 animations:^{
            _payWayView.alpha = 1.0;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            _payWayView.alpha = 0;
        } completion:^(BOOL finished) {
            [_payWayView removeFromSuperview];
        }];
    }
}

/**
 *  显示给用户扫面的二维码视图
 */
- (void)showWithPayScanQrcodeView:(BOOL)show
{
    if (!_payScanQrcodeView)
    {
        _payScanQrcodeView =[[CTCCustomersPayScanQrcodeView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight])];
        _payScanQrcodeView.alpha = 0;
    }
    __weak typeof(self)weakSelf = self;
    _payScanQrcodeView.touchCancelSubmitBlock = ^(NSInteger tag)
    {
        debugLog(@"tag=%d", (int)tag);
        [weakSelf payScanQrcodeSubmit:tag];
    };
    
    if (show)
    {
        [_payScanQrcodeView updateWithData:_payWayEnt];
        [self.view.window addSubview:_payScanQrcodeView];
        [UIView animateWithDuration:0.5 animations:^{
            _payScanQrcodeView.alpha = 1.0;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            _payScanQrcodeView.alpha = 0;
        } completion:^(BOOL finished) {
            [_payScanQrcodeView removeFromSuperview];
        }];
    }
}

- (void)payScanQrcodeSubmit:(NSInteger)tag
{
//    debugMethod();
    [self showWithPayScanQrcodeView:NO];
    if (tag == 101)
    {// 确认
        [self showWithPaySubmitView:YES];
    }
}

/**
 *  显示支付确认视图
 */
- (void)showWithPaySubmitView:(BOOL)show
{
    if (!_paySubmitView)
    {
        _paySubmitView =[[CTCCustomersPaySubmitView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight])];
        _paySubmitView.alpha = 0;
    }
    __weak typeof(self)weakSelf = self;
    _paySubmitView.touchCancelSubmitBlock = ^(NSInteger tag)
    {
        if (tag == 100)
        {// 取消
            [weakSelf showWithPaySubmitView:NO];
        }
        else
        {// 确认
            // //0：支付宝 1：微信 2：现金 3：大众点评 4：美团 5：刷卡
            [SVProgressHUD showWithStatus:@"确认中"];
            [HCSNetHttp requestWithShopOrderCompleteOrder:weakSelf.orderDetailEntity.order_id payChannel:weakSelf.payWayEnt.value payWay:0 completion:^(TYZRespondDataEntity *result) {
                if (result.errcode == respond_success)
                {
                    [SVProgressHUD showSuccessWithStatus:@"确认成功"];
                    [weakSelf showWithPaySubmitView:NO];
                    weakSelf.orderDetailEntity.status = NS_ORDER_PAY_COMPLETE_STATE;
                    [self clickedBack:nil];
                }
                else
                {
                    [UtilityObject svProgressHUDError:result viewContrller:weakSelf];
                }
            }];
        }
    };
    
    if (show)
    {
        [self.view.window addSubview:_paySubmitView];
        [UIView animateWithDuration:0.5 animations:^{
            _paySubmitView.alpha = 1.0;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            _paySubmitView.alpha = 0;
        } completion:^(BOOL finished) {
            [_paySubmitView removeFromSuperview];
        }];
    }
}

#pragma mark -
#pragma mark UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_orderDetailEntity.foods count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // OrderFoodInfoEntity
//    __weak typeof(self)weakSelf = self;
    CTCMealOrderFoodEntity *foodEnt = _orderDetailEntity.foods[indexPath.row];
    debugLog(@"foodName=%@", foodEnt.food_name);
    debugLog(@"sub.count=%d", (int)foodEnt.details.count);
    if (foodEnt.isSub)
    {// 子视图(有加菜或者退菜)
        CTCCustomersPaySubFoodViewCell *cell = [CTCCustomersPaySubFoodViewCell cellForTableView:tableView];
        [cell updateCellData:foodEnt];
        return cell;
    }
    else
    {
        CTCCustomersPayFoodViewCell *cell = [CTCCustomersPayFoodViewCell cellForTableView:tableView];
        [cell updateCellData:foodEnt];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    // OrderFoodInfoEntity
    CTCMealOrderFoodEntity *foodEnt = _orderDetailEntity.foods[indexPath.row];
    if (foodEnt.isSub)
    {
        height = kCTCCustomersPaySubFoodViewCellHeight;
    }
    else
    {
        height = [CTCCustomersPayFoodViewCell getWithCellHeight:foodEnt];
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.indexPath = indexPath;
    //    debugLog(@"row===%d", (int)_indexPath.row);
    CTCMealOrderFoodEntity *foodInfoEntity = nil;
    foodInfoEntity = _orderDetailEntity.foods[indexPath.row];
    
    if ([foodInfoEntity.details count] > 1)
    {
        //        debugLog(@"--if");
        foodInfoEntity.isCheck = !foodInfoEntity.isCheck;
        
        CTCCustomersPayFoodViewCell *cell = (CTCCustomersPayFoodViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell updateCellData:foodInfoEntity];
        
        NSMutableArray *foodList = [NSMutableArray new];
        if (foodInfoEntity.isCheck)
        {
            [_orderDetailEntity.foods insertObjects:foodInfoEntity.details atIndex:indexPath.row+1];
            for (NSInteger i=1; i<=foodInfoEntity.details.count; i++)
            {
                [foodList addObject:[NSIndexPath indexPathForRow:i+indexPath.row inSection:indexPath.section]];
            }
            [tableView insertRowsAtIndexPaths:foodList withRowAnimation:UITableViewRowAnimationFade];
        }
        else
        {
            [_orderDetailEntity.foods removeObjectsInArray:foodInfoEntity.details];
            for (NSInteger i=1; i<=foodInfoEntity.details.count; i++)
            {
                [foodList addObject:[NSIndexPath indexPathForRow:i+indexPath.row inSection:indexPath.section]];
            }
            [tableView deleteRowsAtIndexPaths:foodList withRowAnimation:UITableViewRowAnimationFade];
        }
        
    }
}


@end


























