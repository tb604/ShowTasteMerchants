/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCRestaurantHistoryOrderViewController.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/17 15:51
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCRestaurantHistoryOrderViewController.h"
#import "LocalCommon.h"
#import "CTCRestaurantHistoryOrderTopView.h"
#import "CTCRestaurantHistoryOrderCell.h"
#import "TYZChoiceDateBackgroundView.h"
#import "CTCRestaurantHistoryOrderInputEntity.h" // 传入参数
#import "CTCRestaurantOrderDateHistoryEntity.h"
#import "OrderDataEntity.h"
#import "CTCOrderDetailEntity.h"
#import "CTCEmptyOrderView.h"

@interface CTCRestaurantHistoryOrderViewController ()
{
    CTCRestaurantHistoryOrderTopView *_topView;
    
    CTCRestaurantHistoryOrderInputEntity *_inputEntity;
    
    CTCEmptyOrderView *_emptyView;
}

@property (nonatomic, strong) NSIndexPath *indexPath;

/// 选择日期视图
@property (nonatomic, strong) TYZChoiceDateBackgroundView *choiceDateView;

@property (nonatomic, copy) NSString *todayDate;


- (void)initWithTopView;


- (void)getWithOrderData;

@end

@implementation CTCRestaurantHistoryOrderViewController

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

- (void)initWithVar
{
    [super initWithVar];
    
    NSDate *date = [NSDate date];
    NSString *strDate = [date stringWithFormat:@"yyyy-MM-dd"];
    self.todayDate = strDate;
    
//    NSArray *array = @[@"1", @"2", @"3", @"4"];
//    [self.baseList addObject:array];
//    
//    array = @[@"6", @"7", @"8", @"9", @"10"];
//    [self.baseList addObject:array];
    
    
    _inputEntity = [CTCRestaurantHistoryOrderInputEntity new];
    _inputEntity.pageSize = 20;
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = @"历史订单";
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithTopView];
    
    CGRect frame = self.baseTableView.frame;
    frame.origin.y = kCTCRestaurantHistoryOrderTopViewHeight;
    frame.size.height = frame.size.height - kCTCRestaurantHistoryOrderTopViewHeight;
    self.baseTableView.frame = frame;
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    __weak typeof(self)weakSelf = self;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
//        debugLog(@"eeeee");
//        [weakSelf.view endEditing:YES];
//    }];
//    [self.baseTableView addGestureRecognizer:tap];
    
    [self doRefreshData];
    
    [self initWithEmptyView];
}

- (void)doRefreshData
{
    [super doRefreshData];
    
    [self getWithOrderData];
}

- (void)doMoreRefreshData
{
    [super doMoreRefreshData];
    
    [self getWithOrderData];
    
}

- (void)initWithTopView
{
    if (!_topView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kCTCRestaurantHistoryOrderTopViewHeight);
        _topView = [[CTCRestaurantHistoryOrderTopView alloc] initWithFrame:frame];
        [self.view addSubview:_topView];
    }
    __weak typeof(self)weakSelf = self;
    _topView.choiceDateBlock = ^()
    {// 选择日期
        [weakSelf showWithChoiceDateView:YES];
    };
    _topView.viewCommonBlock = ^(id data)
    {// 搜索
        [weakSelf searchWithTableNo:data];
    };
}

- (void)initWithEmptyView
{
    if (!_emptyView)
    {
        CGRect frame = CGRectMake(0, 0, 230, 230);
        _emptyView = [[CTCEmptyOrderView alloc] initWithFrame:frame];
        _emptyView.userInteractionEnabled = NO;
        _emptyView.center = CGPointMake(self.baseTableView.width / 2., self.baseTableView.height / 2. - 60);
        [self.view addSubview:_emptyView];
    }
    _emptyView.hidden = YES;
    if ([self.baseList count] == 0)
    {
        _emptyView.hidden = NO;
    }
}

- (void)getWithOrderData
{
    _inputEntity.shop_id = [UserLoginStateObject getCurrentShopId];
    _inputEntity.pageIndex = self.pageId;
    // 获取历史订单数据
    [HCSNetHttp requestWithShopOrderHistoryOrders:_inputEntity completion:^(id result) {
        [self responseWithShopOrderHistotryOrders:result];
    }];
}

- (void)responseWithShopOrderHistotryOrders:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success)
    {
        if (self.pageId == 1)
        {
            [self.baseList removeAllObjects];
        }
        [self.baseList addObjectsFromArray:respond.data];
        self.pageId += 1;
        [self.baseTableView reloadData];
    }
    else
    {
        
    }
    
    [self endAllRefreshing];
    
    [self initWithEmptyView];
}

/**
 *  搜索
 *
 *  @param search 搜索内容
 */
- (void)searchWithTableNo:(NSString *)search
{
    _inputEntity.seat_number = search;
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
        _inputEntity.date = date;
//        _todayEntity.todayDate = _todayDate;
//        [MCYPushViewController reloadWithTableView:self.baseTableView indexPath:_indexPath reloadType:2];
    }
    
    [self showWithChoiceDateView:NO];
}


// 查看订单信息
- (void)lookWithOrderInfo:(id)data indexPath:(NSIndexPath *)indexPath
{
    self.indexPath = indexPath;
    
    OrderDataEntity *orderEnt = data;
    orderEnt.shop_id = [UserLoginStateObject getCurrentShopId];
    if (orderEnt.status == NS_ORDER_PAY_COMPLETE_STATE || orderEnt.status == NS_ORDER_ORDER_COMPLETE_STATE)
    {// 支付完成(支付成功)、订单完成
        [MCYPushViewController showWithFinishOrderDetailVC:self data:orderEnt modeType:1 completion:^(id data) {
//            AppDelegate *app = [UtilityObject appDelegate];
//            [app hiddenWithTipView:NO isTop:NO];
            CTCOrderDetailEntity *orderDetailEnt = data;
            
            CTCRestaurantOrderDateHistoryEntity *ent = self.baseList[indexPath.section];
            OrderDataEntity *orderEnt = [ent.orders objectOrNilAtIndex:indexPath.row];
            if (orderDetailEnt.status != orderEnt.status)
            {
                [self doRefreshData];
            }
            else if (orderEnt.status == NS_ORDER_ORDER_COMPLETE_STATE && orderEnt.comment_status != orderDetailEnt.comment_status)
            {
                [self doRefreshData];
            }
        }];
        return;
    }
    
    debugLog(@"else");
    [MCYPushViewController showWithShopOrderDetailVC:self data:data completion:^(id data) {
        /*AppDelegate *app = [UtilityObject appDelegate];
        [app hiddenWithTipView:NO isTop:NO];
        OrderDetailDataEntity *orderDetailEnt = data;
        OrderDataEntity *orderEnt = [self.baseList objectOrNilAtIndex:indexPath.section];
        if (orderDetailEnt.order.status != orderEnt.status)
        {
            [self doRefreshData];
        }
        else if (orderEnt.status == NS_ORDER_ORDER_COMPLETE_STATE && orderEnt.comment_status != orderDetailEnt.order.comment_status)
        {
            [self doRefreshData];
        }
        //        orderEnt.status = orderDetailEnt.order.status;
        //        orderEnt.status_remark = orderDetailEnt.order.status_remark;
        //        [MCYPushViewController reloadWithTableView:self.baseTableView indexPath:indexPath reloadType:2];
         */
    }];
}


#pragma mark -
#pragma mark UITableViewDelegate, UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.baseList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CTCRestaurantOrderDateHistoryEntity *ent = self.baseList[section];
    NSInteger count = [ent.orders count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CTCRestaurantHistoryOrderCell *cell = [CTCRestaurantHistoryOrderCell cellForTableView:tableView];
    CTCRestaurantOrderDateHistoryEntity *ent = self.baseList[indexPath.section];
    OrderDataEntity *orderEnt = ent.orders[indexPath.row];
    [cell updateCellData:orderEnt];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCTCRestaurantHistoryOrderCellHeight;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], 20)];
    view.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    float space = 10;
    if (kiPhone4 || kiPhone5)
    {
        space = 8;
    }
    
    CTCRestaurantOrderDateHistoryEntity *ent = self.baseList[section];
    
    UILabel *label = [TYZCreateCommonObject createWithLabel:view labelFrame:CGRectMake(space, 0, [[UIScreen mainScreen] screenWidth] - 20, 20) textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    label.text = ent.date;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CTCRestaurantOrderDateHistoryEntity *ent = self.baseList[indexPath.section];
    OrderDataEntity *orderEnt = ent.orders[indexPath.row];
    
    debugLog(@"orderId=%@; shopId=%d", orderEnt.order_id, (int)orderEnt.shop_id);
    
    [self lookWithOrderInfo:orderEnt indexPath:indexPath];
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
//    debugMethod();
//    self.point = scrollView.contentOffset;
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
//    debugMethod();
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
//    debugMethod();
    //    if (_fpsLabel.alpha == 0)
    //    {
    //        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
    //            _fpsLabel.alpha = 1;
    //        } completion:^(BOOL finished) {
    //        }];
    //    }
}



@end
















