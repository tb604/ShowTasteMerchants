/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCRestaurantMealingOrderViewController.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/17 15:52
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCRestaurantMealingOrderViewController.h"
#import "LocalCommon.h"
#import "CTCRestaurantMealingOrderTopView.h" // 顶部视图
#import "CTCRestaurantMealingOrderLeftView.h" // 左边视图
#import "CTCRestaurantMealingOrderHeaderView.h" // titleView
#import "CTCRestaurantMealingOrderBottomView.h" // bottomView
#import "CTCRestaurantMealingOrderFooterView.h" // footerView
#import "OrderFoodInfoEntity.h"
#import "CTCRestaurantMealingFoodOrderViewCell.h"
#import "CTCRestaurantMealingSubFoodOrderViewCell.h"
#import "TYZPopMenu.h" // popMenu
#import "ShopAddSubFoodView.h"
#import "ShopSeatInfoEntity.h"
#import "OrderDiningSeatEntity.h" // 订单餐位信息
#import "CTCRestaurantMealingChangeTableNoBgView.h" // 更换台号视图
#import "ShopPlaceOrderBackgroundView.h" // 下单视图
#import "CTCMealOrderDetailsEntity.h" // 餐中订单明细
#import "CTCMealOrderFoodEntity.h" // 餐中订单的菜品
#import "ShopAddSubFoodBackgroundView.h" // 服务员加菜或者减菜视图
//#import "ShopAccountStatementBackgroundView.h" // 结算清单视图
//#import "ShopModifyActuallyAmountBackgroundView.h" // 修改金额视图
#import "ShopingCartEntity.h"
#import "CTCEmptyOrderView.h"

@interface CTCRestaurantMealingOrderViewController () <UIActionSheetDelegate>
{
    
    CTCEmptyOrderView *_emptyView;
    
    // requestWithShopOrderDiningDetails
    /**
     *  对菜品的操作，加菜、退菜、已上菜
     */
    UIActionSheet *_foodActionSheet;
    
    /**
     *  操作菜，1表示加菜；2表示减菜
     */
    NSInteger _operateFood;
    
    /**
     *  100 第一次添加的菜品；101 点击有多次加菜加减菜品的主cell；102 点击有多次加减菜品的子cell
     */
    NSInteger _addSubType;
    
    /**
     *  服务员加菜或者减菜视图
     */
    ShopAddSubFoodBackgroundView *_addSubFoodView;
}

/// 下单视图
@property (nonatomic, strong) ShopPlaceOrderBackgroundView *placeOrderView;
/**
 *  选中的档口id
 */
@property (nonatomic, assign) NSInteger selectedPrinterId;

//@property (nonatomic, strong) TYZPopMenu *popMenu;
@property (nonatomic, strong) TYZPopMenuConfiguration *popMenuConfig;
@property (nonatomic, strong) NSMutableArray *popMenuList;

@property (nonatomic, strong) CTCRestaurantMealingOrderTopView *topView;

@property (nonatomic, strong) CTCRestaurantMealingOrderLeftView *leftView;

@property (nonatomic, strong) CTCRestaurantMealingOrderHeaderView *headerView;

@property (nonatomic, strong) CTCRestaurantMealingOrderBottomView *bottomView;

@property (nonatomic, strong) CTCRestaurantMealingOrderFooterView *footerView;

@property (nonatomic, strong) UIView *bottomMoreView;

@property (nonatomic, strong) NSIndexPath *indexPath;

/**
 *  选中的菜品
 */
@property (nonatomic, strong) CTCMealOrderFoodEntity *selectFoodEntity;




/// 更换台号视图
@property (nonatomic, strong) CTCRestaurantMealingChangeTableNoBgView *changeTableNoView;

/// 结算清单视图
//@property (nonatomic, strong) ShopAccountStatementBackgroundView *accountStatementView;





- (void)initWithTopView;

- (void)initWithLeftView;

- (void)initWithHeadertView;

- (void)initWithBottomView;

- (void)initWithFoodActionSheet;

- (void)initWithEmptyView;

/**
 *  重新刷新UI
 */
- (void)refreshUIData;


@end

@implementation CTCRestaurantMealingOrderViewController

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
    
    _popMenuList = [NSMutableArray new];
    
//    debugLog(@"orderSeat.count=%d", (int)_orderSeatList.count);
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = @"餐中订单";
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithTopView];
    
    [self initWithLeftView];
    
    [self initWithHeadertView];
    
    [self initWithBottomView];
    
    CGRect frame = CGRectMake(_leftView.right, _headerView.bottom, _headerView.width, _leftView.height - _headerView.height - _bottomView.height);
    self.baseTableView.frame = frame;
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self initWithEmptyView];
}


#pragma mark -
#pragma mark private init

- (void)initWithTopView
{
    if (!_topView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], 30);
        _topView = [[CTCRestaurantMealingOrderTopView alloc] initWithFrame:frame];
        [self.view addSubview:_topView];
    }
    [_topView updateViewData:_selectedOrderSeatEntity.orderDetailEntity];
}

- (void)initWithLeftView
{
    if (!_leftView)
    {
        AppDelegate *app = [UtilityObject appDelegate];
        CGRect frame = CGRectMake(0, _topView.bottom, [CTCRestaurantMealingOrderLeftView getWithViewWidth], [[UIScreen mainScreen] screenHeight] - [app navBarHeight] - STATUSBAR_HEIGHT - _topView.height);
        _leftView = [[CTCRestaurantMealingOrderLeftView alloc] initWithFrame:frame];
        [self.view addSubview:_leftView];
    }
    
    [_leftView updateViewData:_orderSeatList isReset:YES];
    __weak typeof(self)weakSelf = self;
    _leftView.selectOrderSeatBlock = ^(id data)
    {// 点击左边的台号
        [weakSelf touchWithLeftView:data isReset:NO];
    };
}

- (void)initWithHeadertView
{
    if (!_headerView)
    {
        CGRect frame = _topView.frame;
        frame.size.height = 25;
        frame.size.width = _topView.width - _leftView.width;
        frame.origin.x = _leftView.right;
        frame.origin.y = _topView.bottom;
        _headerView = [[CTCRestaurantMealingOrderHeaderView alloc] initWithFrame:frame];
        [self.view addSubview:_headerView];
    }
}

/*- (void)initWithFooterView
{
    if (!_footerView)
    {
        CGRect frame = CGRectMake(0, 0, self.baseTableView.width, kCTCRestaurantMealingOrderFooterViewHeight);
        _footerView = [[CTCRestaurantMealingOrderFooterView alloc] initWithFrame:frame];
        self.baseTableView.tableFooterView = _footerView;
    }
    
}*/

- (void)initWithBottomView
{
    if (!_bottomView)
    {
        CGRect frame = _headerView.frame;
        frame.size.height = 50;
        _bottomView = [[CTCRestaurantMealingOrderBottomView alloc] initWithFrame:frame];
        _bottomView.bottom = _leftView.bottom;
        [self.view addSubview:_bottomView];
        
        
        frame = _bottomView.frame;
        frame.size.width = _bottomView.height;
        frame.size.height = _bottomView.height;
        frame.origin.x = [[UIScreen mainScreen] screenWidth] - frame.size.width;
        _bottomMoreView = [[UIView alloc] initWithFrame:frame];
        _bottomMoreView.userInteractionEnabled = NO;
        _bottomMoreView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_bottomMoreView];
        
    }
    [_bottomView updateViewData:_selectedOrderSeatEntity.orderDetailEntity];
    __weak typeof(self)weakSelf = self;
    _bottomView.viewCommonBlock = ^(id data)
    {
        [weakSelf touchWithBottomView:data];
    };
}

- (void)initWithEmptyView
{
    if (!_emptyView)
    {
//        debugLog(@"dddd");
        CGRect frame = CGRectMake(0, 0, 230, 230);
        _emptyView = [[CTCEmptyOrderView alloc] initWithFrame:frame];
        _emptyView.userInteractionEnabled = NO;
        _emptyView.center = CGPointMake(_leftView.width + self.baseTableView.width / 2., self.baseTableView.height / 2.);
//        _emptyView.backgroundColor = [UIColor redColor];
        [self.view addSubview:_emptyView];
    }
    _emptyView.hidden = YES;
    if ([_orderSeatList count] == 0)
    {
        _emptyView.hidden = NO;
    }
}

#pragma mark -
#pragma mark primvate methods

/**
 *  点击左边的台号
 */
- (void)touchWithLeftView:(OrderDiningSeatEntity *)seatEnt isReset:(BOOL)isReset
{
    [SVProgressHUD showWithStatus:@"加载中"];
    [HCSNetHttp requestWithShopOrderDiningDetails:seatEnt.order_id shopId:[UserLoginStateObject getCurrentShopId] completion:^(TYZRespondDataEntity  *result) {
        [self responseWithShopOrderDiningDetails:result orderSeatEnt:seatEnt isReset:isReset];
    }];
}

- (void)responseWithShopOrderDiningDetails:(TYZRespondDataEntity *)respond orderSeatEnt:(OrderDiningSeatEntity *)orderSeatEnt isReset:(BOOL)isReset
{
    if (respond.errcode == respond_success)
    {
        [SVProgressHUD dismiss];
        orderSeatEnt.orderDetailEntity = respond.data;
        self.selectedOrderSeatEntity = orderSeatEnt;
        self.selectFoodEntity = nil;
        [_topView updateViewData:_selectedOrderSeatEntity.orderDetailEntity];
        [_bottomView updateViewData:_selectedOrderSeatEntity.orderDetailEntity];
        if (isReset)
        {
            [_leftView updateViewData:_orderSeatList isReset:YES];
        }
        [self.baseTableView reloadData];
        [self initWithEmptyView];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
}

/**
 *  下单到厨房
 */
- (void)placeWithOrder
{
    debugLog(@"下单");
    [SVProgressHUD showWithStatus:@"加载中"];
    [HCSNetHttp requestWithShopPrinterGetPrintersByConfigType:_selectedOrderSeatEntity.orderDetailEntity.shop_id configType:1 seatName:objectNull(_selectedOrderSeatEntity.seat_number) completion:^(TYZRespondDataEntity *respPrinter) {
        if (respPrinter.errcode == respond_success)
        {
            self.printerList = respPrinter.data;
            // 加菜下单列表
            [HCSNetHttp requestWithShopOrderWaitPrintFoods:_selectedOrderSeatEntity.orderDetailEntity.order_id shopId:_selectedOrderSeatEntity.orderDetailEntity.shop_id completion:^(TYZRespondDataEntity *respond) {
                if (respond.errcode == respond_success)
                {
                    [SVProgressHUD dismiss];
                    NSArray *food = respond.data;
                    [self showWithPlaceOrderView:YES foods:food];
                }
                else if (respond.errcode == respond_nodata)
                {
                    [SVProgressHUD dismiss];
                    // 显示下单视图
                    [self showWithPlaceOrderView:YES foods:respond.data];
                }
                else
                {
                    [UtilityObject svProgressHUDError:respond viewContrller:self];
                }
            }];
        }
        else if (respPrinter.errcode == respond_nodata)
        {
            [SVProgressHUD showInfoWithStatus:@"没有档口信息"];
        }
        else
        {
            [UtilityObject svProgressHUDError:respPrinter viewContrller:self];
        }
    }];
}

/**
 *  更改台号
 */
- (void)showWithChangeTableNoView:(BOOL)show
{
    __weak typeof(self)blockSelf = self;
    if (!_changeTableNoView)
    {
        _changeTableNoView = [[CTCRestaurantMealingChangeTableNoBgView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight])];
        _changeTableNoView.alpha = 0;
    }
    _changeTableNoView.touchChangeCancelBlock = ^()
    {// 取消
        [blockSelf showWithChangeTableNoView:NO];
    };
    _changeTableNoView.touchChangeSubmitBlock = ^(ShopSeatInfoEntity *seatEnt, NSString *tableNo, NSInteger number)
    {// 确认
        [blockSelf changeTableNoNumber:seatEnt tableNo:tableNo number:number];
    };
    
    if (show)
    {
        [_changeTableNoView updateWithSeat:_seatLocList tableNo:_selectedOrderSeatEntity.seat_number number:_selectedOrderSeatEntity.orderDetailEntity.eater_count seatLocId:_selectedOrderSeatEntity.orderDetailEntity.seat_type];
        [self.view.window addSubview:_changeTableNoView];
        [UIView animateWithDuration:0.5 animations:^{
            _changeTableNoView.alpha = 1.0;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            _changeTableNoView.alpha = 0;
        } completion:^(BOOL finished) {
            [_changeTableNoView removeFromSuperview];
        }];
    }
}

/**
 *  修改位置(大厅，包间)，桌号、人数
 *
 *  @param  seatEnt 餐位位置
 *  @param tableNo  台号
 *  @param number   人数
 */
- (void)changeTableNoNumber:(ShopSeatInfoEntity *)seatEnt tableNo:(NSString *)tableNo number:(NSInteger)number
{
    [SVProgressHUD showWithStatus:@"修改中"];
    RestaurantReservationInputEntity *inputEnt = [RestaurantReservationInputEntity new];
    inputEnt.orderId = _selectedOrderSeatEntity.order_id;
    inputEnt.tableNo = tableNo;
    inputEnt.shopLocation = seatEnt.id;
    inputEnt.shopLocationNote = seatEnt.name;
    inputEnt.shopId = _selectedOrderSeatEntity.orderDetailEntity.shop_id;
    inputEnt.number = number;
    [HCSNetHttp requestWithShopOrderChangeSeat:inputEnt completion:^(TYZRespondDataEntity *result) {
        if (result.errcode == respond_success)
        {
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            // 换台调用服务端完成后，更新UI
            [self changeWithSeatRefreshData:inputEnt];
        }
        else
        {
            [UtilityObject svProgressHUDError:result viewContrller:self];
        }
    }];
    
    
    [self showWithChangeTableNoView:NO];
    
//    debugLog(@"seat=%@; tableNo=%@; number=%d", seatEnt.name, tableNo, (int)number);
}

/**
 *  取消订单
 */
- (void)cancelWithOrder
{
    // 取消订单
    [MCYPushViewController showWithDinersCancelOrderVC:self data:_selectedOrderSeatEntity.orderDetailEntity completion:^(id data) {
        [self cancelOrder:data];
    }];
}

/**
 *  换台调用服务端完成后，更新UI
 */
- (void)changeWithSeatRefreshData:(RestaurantReservationInputEntity *)ent
{
    // 桌号
    _selectedOrderSeatEntity.seat_number = ent.tableNo;
    
    _selectedOrderSeatEntity.eater_count = ent.number;
    
    _selectedOrderSeatEntity.orderDetailEntity.seat_number = ent.tableNo;
    _selectedOrderSeatEntity.orderDetailEntity.eater_count = ent.number;
    _selectedOrderSeatEntity.orderDetailEntity.seat_type = ent.shopLocation;
    _selectedOrderSeatEntity.orderDetailEntity.seat_type_desc = ent.shopLocationNote;
    
    NSInteger index = -1;
    for (NSInteger i=0; i<[_orderSeatList count]; i++)
    {
        OrderDiningSeatEntity *orderSeatEnt = _orderSeatList[i];
        if ([orderSeatEnt.order_id isEqualToString:_selectedOrderSeatEntity.order_id])
        {
            index = i;
            break;
        }
    }
    if (index != -1)
    {
        [_orderSeatList replaceObjectAtIndex:index withObject:_selectedOrderSeatEntity];
        [self refreshUIData];
    }
}

/**
 *  取消订单返回后
 */
- (void)cancelOrder:(CTCMealOrderDetailsEntity *)cancelEnt
{
    if (cancelEnt.status == NS_ORDER_ORDER_CANCELED_STATE)
    {
        NSInteger index = -1;
        for (NSInteger i=0; i<_orderSeatList.count; i++)
        {
            OrderDiningSeatEntity *ent = _orderSeatList[i];
            if ([ent.order_id isEqualToString:cancelEnt.order_id])
            {
                index = i;
                break;
            }
        }
        if (index != -1)
        {
            [_orderSeatList removeObjectAtIndex:index];
            if ([_orderSeatList count] != 0)
            {// 删除后，还有订单，所以要重新获取数据
                self.selectedOrderSeatEntity = _orderSeatList[0];
                self.indexPath = nil;
                self.selectFoodEntity = nil;
                self.selectedPrinterId = 0;
                [self touchWithLeftView:_selectedOrderSeatEntity isReset:YES];
            }
            else
            {
                self.selectedOrderSeatEntity = nil;
                self.indexPath = nil;
                self.selectFoodEntity = nil;
                self.selectedPrinterId = 0;
                [self refreshUIData];
            }
            
        }
    }
}



- (void)touchWithBottomView:(UIButton *)button
{
    __weak typeof(self)weakSelf = self;
    if (button.tag == NS_MEALINGORDER_BUTTON_MORE_TAG)
    {// 加菜、下单
        if ([_popMenuList count] == 0)
        {
            // 加菜
            UIImage *image = [UIImage imageWithContentsOfFileName:@"order_icon_jiacai.png"];
            TYZPopMenuItem *model =  [[TYZPopMenuItem alloc] initWithTitle:@"加菜" image:image block:^(TYZPopMenuItem * _Nullable item) {
                // 加菜
                [weakSelf shopWithAddFood];
            }];
            [_popMenuList addObject:model];
            
            // 下单
            image = [UIImage imageWithContentsOfFileName:@"order_btn_xiadan.png"];
            model =  [[TYZPopMenuItem alloc] initWithTitle:@"下单" image:image block:^(TYZPopMenuItem * _Nullable item) {
                // 下单，显示下单视图
                [weakSelf placeWithOrder];
            }];
            [_popMenuList addObject:model];
            
            // 换台
            image = [UIImage imageWithContentsOfFileName:@"order_icon_ht.png"];
            model =  [[TYZPopMenuItem alloc] initWithTitle:@"换台" image:image block:^(TYZPopMenuItem * _Nullable item) {
                [weakSelf showWithChangeTableNoView:YES];
            }];
            [_popMenuList addObject:model];
            
            // 取消
            image = [UIImage imageWithContentsOfFileName:@"order_icon_cancel.png"];
            model =  [[TYZPopMenuItem alloc] initWithTitle:@"退单" image:image block:^(TYZPopMenuItem * _Nullable item) {
                [weakSelf cancelWithOrder];
            }];
            [_popMenuList addObject:model];
        }
        
        if (!_popMenuConfig)
        {
            TYZPopMenuConfiguration *options = [TYZPopMenuConfiguration defaultConfiguration];
            options.style               = TYZPopMenuAnimationStyleScale;
            options.menuMaxHeight       = 200; // 菜单最大高度
            options.itemHeight          = 50;
            options.itemMaxWidth        = 140;
            options.arrowSize           = 10; //指示箭头大小
            options.arrowMargin         = 0; // 手动设置箭头和目标view的距离
            options.marginXSpacing      = 10; //MenuItem左右边距
            options.marginYSpacing      = 9; //MenuItem上下边距
            options.intervalSpacing     = 15; //MenuItemImage与MenuItemTitle的间距
            options.menuCornerRadius    = 1; //菜单圆角半径
            options.shadowOfMenu        = YES; //是否添加菜单阴影
            options.hasSeparatorLine    = YES; //是否设置分割线
            options.separatorInsetLeft  = 10; //分割线左侧Insets
            options.separatorInsetRight = 10; //分割线右侧Insets
            options.separatorHeight     = 1.0 / [UIScreen mainScreen].scale;//分割线高度
            options.shadowColor = [UIColor colorWithWhite:0.5 alpha:0.5];
            options.titleColor          = [UIColor colorWithHexString:@"#323232"];//menuItem字体颜色
            options.separatorColor      = [UIColor colorWithHexString:@"#cdcdcd"];//分割线颜色
            options.menuBackgroundColor = [UIColor whiteColor],//菜单的底色
            options.selectedColor       = [UIColor colorWithHexString:@"#e6e6e6"];// menuItem选中颜色
            self.popMenuConfig = options;
        }
        
        [TYZPopMenu showMenuWithView:_bottomMoreView menuItems:_popMenuList withOptions:_popMenuConfig];
        
    }
    else if (button.tag == NS_MEALINGORDER_BUTTON_PAY_TAG)
    {// 买单
        debugLog(@"买单");
        
//        CTCMealOrderDetailsEntity *orderDetailEnt = _selectedOrderSeatEntity.orderDetailEntity;
//        for (CTCMealOrderFoodEntity *foodEnt in orderDetailEnt.foods)
//        {
//            if ([foodEnt.details count] != 0 && foodEnt.isCheck)
//            {
//                [orderDetailEnt.foods removeObjectsInArray:foodEnt.details];
//            }
//        }
//        
//        
//        
//        OrderDiningSeatEntity *ent =  _orderSeatList[1];
//        NSArray *array = ent.orderDetailEntity.foods;
//        debugLog(@"count=%d", (int)[array count]);
//        
//        
//        
//        return;
        
        [MCYPushViewController showWithCustomerPayVC:self data:_selectedOrderSeatEntity.orderDetailEntity completion:^(CTCMealOrderDetailsEntity *data) {
            [self customerPayReturn:data];
        }];
    }
}

// NS_ORDER_PAY_COMPLETE_STATE
- (void)customerPayReturn:(CTCMealOrderDetailsEntity *)detailEnt
{
    if (detailEnt.status == NS_ORDER_PAY_COMPLETE_STATE)
    {
        NSInteger index = -1;
        for (NSInteger i=0; i<_orderSeatList.count; i++)
        {
            OrderDiningSeatEntity *ent = _orderSeatList[i];
            if ([ent.order_id isEqualToString:detailEnt.order_id])
            {
                index = i;
                break;
            }
        }
        if (index != -1)
        {
            [_orderSeatList removeObjectAtIndex:index];
            if ([_orderSeatList count] != 0)
            {// 删除后，还有订单，所以要重新获取数据
                self.selectedOrderSeatEntity = _orderSeatList[0];
                self.indexPath = nil;
                self.selectFoodEntity = nil;
                self.selectedPrinterId = 0;
                [self touchWithLeftView:_selectedOrderSeatEntity isReset:YES];
            }
            else
            {
                self.selectedOrderSeatEntity = nil;
                self.indexPath = nil;
                self.selectFoodEntity = nil;
                self.selectedPrinterId = 0;
                [self refreshUIData];
            }
            
        }
        
        // [self getWithOrderDetail];
    }
    else
    {
        _selectedOrderSeatEntity.orderDetailEntity.sf_amount = detailEnt.sf_amount;
        _selectedOrderSeatEntity.orderDetailEntity.waiter_amt_note = detailEnt.waiter_amt_note;
    }
    [_bottomView updateViewData:_selectedOrderSeatEntity.orderDetailEntity];
}

- (void)initWithFoodActionSheet
{
    _foodActionSheet = nil;
    if (_addSubType == EN_ADD_SUB_FIRST_TYPE)
    {// 第一次添加的菜品
        if (_selectFoodEntity.status == NS_ORDER_FOOD_TABLE_STATE)
        {// 此菜已上桌
            _foodActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"取消上菜" otherButtonTitles:@"加菜", @"退菜", nil];
        }
        else
        {
            _foodActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"已上菜" otherButtonTitles:@"加菜", @"退菜", nil];
        }
    }
    else if (_addSubType == EN_ADD_SUB_SECOND_TYPE)
    {// 点击有多次加菜加减菜品的主cell
        if (_selectFoodEntity.status == NS_ORDER_FOOD_TABLE_STATE)
        {
            _foodActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"加菜", nil];
        }
        else
        {
            _foodActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"已上菜" otherButtonTitles:@"加菜", nil];
        }
    }
    else if (_addSubType == EN_ADD_SUB_THIRD_TYPE)
    {// 点击有多次加减菜品的子cell
//        debugLog(@"EN_ADD_SUB_THIRD_TYPE");
//        debugLog(@"status=%d", (int)_selectFoodEntity.status);
        if (_selectFoodEntity.status == NS_ORDER_FOOD_TABLE_STATE)
        {
            _foodActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: @"退菜", nil];
        }
        else if (_selectFoodEntity.status == NS_ORDER_FOOD_RETIRED_STATE)
        {// 已退菜
            return;
        }
        else
        {
            _foodActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"已上菜" otherButtonTitles: @"退菜", nil];
        }
    }
    [_foodActionSheet showInView:self.view];
}

/**
 *  重新刷新UI
 */
- (void)refreshUIData
{
    [_topView updateViewData:_selectedOrderSeatEntity.orderDetailEntity];
    
    [_leftView updateViewData:_orderSeatList isReset:NO];
    
    [self.baseTableView reloadData];
    [self initWithEmptyView];
}

/**
 *  得到订单详情
 */
- (void)getWithOrderDetail
{
    [HCSNetHttp requestWithShopOrderDiningDetails:_selectedOrderSeatEntity.order_id shopId:[UserLoginStateObject getCurrentShopId] completion:^(TYZRespondDataEntity  *result) {
        
        if (result.errcode == respond_success)
        {
            _selectedOrderSeatEntity.orderDetailEntity = result.data;
            for (OrderDiningSeatEntity *orderSeatEnt in _orderSeatList)
            {
                if ([orderSeatEnt.order_id isEqualToString:_selectedOrderSeatEntity.order_id])
                {
                    orderSeatEnt.orderDetailEntity = result.data;
                    break;
                }
            }
            [self.baseTableView reloadData];
            [self initWithEmptyView];
        }
    }];
}

/**
 *  下单视图
 *
 *  @param show YES显示，否则NO
 */
- (void)showWithPlaceOrderView:(BOOL)show foods:(NSArray *)foods
{
    __weak typeof(self)weakSelf = self;
    if (!_placeOrderView)
    {
        _placeOrderView =[[ShopPlaceOrderBackgroundView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight])];
        _placeOrderView.alpha = 0;
    }
    
    _placeOrderView.viewCommonBlock = ^(id data)
    {// 取消、下单、好的、补单
        [weakSelf clickedWithPlaceOrderView:data];
    };
    _placeOrderView.choiceWithPrintIdBlock = ^(NSInteger mouthId)
    {
        weakSelf.selectedPrinterId = mouthId;
    };
    
    
    if (show)
    {
        [_placeOrderView updateWithData:foods printerList:_printerList];
        [self.view.window addSubview:_placeOrderView];
        [UIView animateWithDuration:0.5 animations:^{
            _placeOrderView.alpha = 1.0;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            _placeOrderView.alpha = 0;
        } completion:^(BOOL finished) {
            [_placeOrderView removeFromSuperview];
        }];
    }
}

// 取消、下单、好的
- (void)clickedWithPlaceOrderView:(id)data
{
    if ([data isEqualToString:@"取消"] || [data isEqualToString:@"好的"])
    {
        [self showWithPlaceOrderView:NO foods:nil];
    }
    else if ([data isEqualToString:@"下单"])
    {
        [SVProgressHUD showWithStatus:@"下单中"];
        [HCSNetHttp requestWithShopOrderFoodToKitchen:_selectedOrderSeatEntity.orderDetailEntity.order_id shopId:_selectedOrderSeatEntity.orderDetailEntity.shop_id printId:_selectedPrinterId completion:^(TYZRespondDataEntity *respond) {
            if (respond.errcode == respond_success)
            {
                [SVProgressHUD showSuccessWithStatus:@"下单成功"];
                [self showWithPlaceOrderView:NO foods:nil];
            }
            else
            {
                [UtilityObject svProgressHUDError:respond viewContrller:self];
            }
        }];
    }
    else if ([data isEqualToString:@"补单"])
    {// ShopMouthDataEntity
        [MCYPushViewController showWithRepairVC:self data:_selectedOrderSeatEntity.orderDetailEntity completion:^(id data) {
            if ([data isEqualToString:@"success"])
            {
                _placeOrderView.hidden = YES;
            }
            else
            {
                _placeOrderView.hidden = NO;
            }
        }];
    }
}

/**
 *  进入加菜视图控制器
 */
- (void)shopWithAddFood
{
    CTCMealOrderDetailsEntity *orderDetailEntity = _selectedOrderSeatEntity.orderDetailEntity;
    RestaurantReservationInputEntity *inputEnt = [RestaurantReservationInputEntity new];
    inputEnt.orderId = orderDetailEntity.order_id;
    inputEnt.orderState = orderDetailEntity.status;
//    inputEnt.userId = orderDetailEntity.user_id;
    inputEnt.shopId = [UserLoginStateObject getCurrentShopId];
    inputEnt.shopName = [UserLoginStateObject getCurrentShopName];
    inputEnt.shopAddress = orderDetailEntity.shop_address;
    inputEnt.shopMobile = orderDetailEntity.shop_tel;
    inputEnt.type = orderDetailEntity.type;
    inputEnt.addType = 2; // 表示修改菜单
    inputEnt.userType = 1; // 1表示商家
    inputEnt.fixedShopingCartList = [NSMutableArray array];
    
    // 加菜完成后，调用 getWithOrderDetail 进行更新
    [MCYPushViewController showWithRecipeVC:self data:inputEnt completion:nil];
}

/*
 NSMutableArray *tempArr = [NSMutableArray array];
 NSArray *titleArr = @[@"扫一扫", @"加好友", @"创建讨论组", @"发送到电脑", @"面对面快传", @"收钱"];
 for (int i = 1; i < titleArr.count; i++) {
 XHPopMenuItem *model = [[XHPopMenuItem alloc] initWithTitle:titleArr[i - 1] image:[UIImage imageNamed:[NSString stringWithFormat:@"menu_%d",i]] block:^(XHPopMenuItem *item) {
 NSLog(@"block:%@",item);
 }];
 
 [tempArr addObject:model];
 }
 
 XHPopMenuConfiguration *options = [XHPopMenuConfiguration defaultConfiguration];
 options.style            = XHPopMenuAnimationStyleWeiXin;
 options.marginXSpacing   = 15;//MenuItem左右边距
 options.marginYSpacing   = 8;//MenuItem上下边距
 options.intervalSpacing  = 10;// MenuItemImage与MenuItemTitle的间距
 options.itemHeight       = 40;
 options.itemMaxWidth     = 140;
 options.arrowSize        = 9;//指示箭头大小
 options.arrowMargin      = 10;// 手动设置箭头和目标view的距离
 options.menuCornerRadius = 3;//菜单圆角半径
 options.titleColor       = [UIColor whiteColor];//menuItem字体颜色
 
 [XHPopMenu showMenuWithView:sender menuItems:tempArr withOptions:options];
 */

/**
 *  上菜/取消上菜
 */
- (void)dishUpDown:(NSString *)title
{
//    debugLog(@"title=%@", title);
//    debugLog(@"fooddetId=%d", (int)_selectFoodEntity.detail_id);
    
    [SVProgressHUD showWithStatus:@"提交中"];
    CTCRestaurantDishUpDownFoodEntity *inputEnt = [CTCRestaurantDishUpDownFoodEntity new];
    inputEnt.id = _selectFoodEntity.detail_id;
    inputEnt.order_id = _selectedOrderSeatEntity.orderDetailEntity.order_id;
    inputEnt.shop_id = _selectedOrderSeatEntity.orderDetailEntity.shop_id;
    
    if (_selectFoodEntity.status == NS_ORDER_FOOD_TABLE_STATE)
    {// 状态是“已上菜”,点击就变成了“取消上菜”
        inputEnt.dish_type = 2;
    }
    else
    {// 上菜
        inputEnt.dish_type = 1;
    }
    
    [HCSNetHttp requestWithShopOrderDishUpDown:inputEnt completion:^(TYZRespondDataEntity *result) {
        if (result.errcode == respond_success)
        {
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
            
            OrderDiningSeatEntity *seatEnt = nil;
            for (OrderDiningSeatEntity *ent in self.orderSeatList)
            {
                if ([inputEnt.order_id isEqualToString:ent.order_id])
                {
                    seatEnt = ent;
                    break;
                }
            }
            for (CTCMealOrderFoodEntity *foodEnt in seatEnt.orderDetailEntity.foods)
            {
                if (foodEnt.detail_id == _selectFoodEntity.detail_id)
                {
                    [self updateWithDishStatus:foodEnt dishType:inputEnt.dish_type];
                    break;
                }
                else
                {
                    for (CTCMealOrderFoodEntity *foodEntity in foodEnt.details)
                    {
                        if (foodEntity.detail_id == _selectFoodEntity.detail_id)
                        {
                            [self updateWithDishStatus:foodEntity dishType:inputEnt.dish_type];
                            break;
                        }
                    }
                }
            }
            
            if (seatEnt)
            {
//                debugLog(@"更新");
                self.selectedOrderSeatEntity = seatEnt;
            }
            
            
            [MCYPushViewController reloadWithTableView:self.baseTableView indexPath:_indexPath reloadType:3];
        }
        else
        {
            [UtilityObject svProgressHUDError:result viewContrller:self];
        }
    }];
}

/**
 *  更上菜/取消上菜的状态
 *
 *  @param foodEnt 订单菜品
 *  @param dishType 1上菜；2取消上菜
 */
- (void)updateWithDishStatus:(CTCMealOrderFoodEntity *)foodEnt dishType:(NSInteger)dishType
{
    if (dishType == 1)
    {// 上菜
        foodEnt.status = NS_ORDER_FOOD_TABLE_STATE;
//        debugLog(@"上菜");
    }
    else
    {// 取消上菜
//        debugLog(@"取消上菜");
        foodEnt.status = NS_ORDER_FOOD_HAVE_STATE;
    }
}

/**
 *  服务员加菜或者减菜视图
 *
 *  @param show YES显示，否则NO
 */
- (void)showWithAddSubFoodView:(BOOL)show
{
    __weak typeof(self)weakSelf = self;
    if (!_addSubFoodView)
    {
        _addSubFoodView =[[ShopAddSubFoodBackgroundView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight])];
        _addSubFoodView.alpha = 0;
    }
    _addSubFoodView.touchAddSubFoodBlock = ^(id data)
    {
        if (!data)
        {// 取消
            [weakSelf showWithAddSubFoodView:NO];
        }
        else
        {
            ShopingCartEntity *cartEntity = data;
            cartEntity.number = cartEntity.number - cartEntity.fixedNumber;
//            debugLog(@"cartEnt=%@", [cartEntity modelToJSONString]);
            if (cartEntity.number == 0)
            {// 表示没有加菜，也没有减菜
//                debugLog(@"表示没有加菜，也没有减菜");
                [weakSelf showWithAddSubFoodView:NO];
                return;
            }
//            debugLog(@"number=%d", (int)cartEntity.number);
            UpdateOrderFoodInputEntity *inputEntity = [UpdateOrderFoodInputEntity new];
            inputEntity.orderId = weakSelf.selectedOrderSeatEntity.orderDetailEntity.order_id;
            inputEntity.shopId = weakSelf.selectedOrderSeatEntity.orderDetailEntity.shop_id;
            NSArray *list = @[cartEntity];
            inputEntity.content = [list modelToJSONString];
            if (cartEntity.number > 0)
            {// 表示加菜
                inputEntity.order_food_type = 2;
            }
            else if (cartEntity.number < 0)
            {// 表示退菜
                inputEntity.order_food_type = 3;
                inputEntity.detailId = cartEntity.foodAutoId;
                inputEntity.foodNumber = -cartEntity.number;
            }
            
            
//            debugLog(@"input=%@", [inputEntity modelToJSONString]);
            
            // 提交
            [SVProgressHUD showWithStatus:@"提交中"];
            if (inputEntity.order_food_type == 2)
            {// 加菜
//                debugLog(@"加菜");
                [HCSNetHttp requestWithShopOrderAddFoods:inputEntity completion:^(id result) {
                    [weakSelf responseWithOrderDetailSupplyReturn:result cartEnt:cartEntity];
                }];
            }
            else if (inputEntity.order_food_type == 3)
            {// 退菜
//                debugLog(@"退菜");
                [HCSNetHttp requestWithShopOrderReturnFoods:inputEntity completion:^(id result) {
                    [weakSelf responseWithOrderDetailShopReturnFoods:result];
                }];
            }
        }
    };
    
    if (show)
    {
        ShopingCartEntity *cartEnt = [ShopingCartEntity new];
        cartEnt.foodAutoId = _selectFoodEntity.detail_id;
        cartEnt.id = _selectFoodEntity.food_id;
        cartEnt.name = _selectFoodEntity.food_name;
        cartEnt.category_id = _selectFoodEntity.food_category_id;
//        cartEnt.categoryName = _selectFoodEntity.category_name;
        cartEnt.price = _selectFoodEntity.food_price;
        cartEnt.activityPrice = _selectFoodEntity.food_activity_price;
        cartEnt.mode = _selectFoodEntity.mode;
        cartEnt.taste = _selectFoodEntity.taste;
        cartEnt.unit = _selectFoodEntity.unit;
        cartEnt.number = _selectFoodEntity.food_number;
        cartEnt.fixedNumber = _selectFoodEntity.food_number; // 表示在整个加菜减菜过程中不变，主要是用来比较的
        
        [_addSubFoodView updateWithData:cartEnt addSubType:_addSubType operateFood:_operateFood];
        
        [self.view.window addSubview:_addSubFoodView];
        [UIView animateWithDuration:0.5 animations:^{
            _addSubFoodView.alpha = 1.0;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            _addSubFoodView.alpha = 0;
        } completion:^(BOOL finished) {
            [_addSubFoodView removeFromSuperview];
        }];
    }
}

// 减菜返回结果
- (void)responseWithOrderDetailShopReturnFoods:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success)
    {
        [self getWithOrderDetail];
        [SVProgressHUD showSuccessWithStatus:@"退菜成功"];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
    [self showWithAddSubFoodView:NO];
}

// 加菜返回结果
- (void)responseWithOrderDetailSupplyReturn:(TYZRespondDataEntity *)respond cartEnt:(ShopingCartEntity *)cartEnt
{
    if (respond.errcode == respond_success)
    {
        [self getWithOrderDetail];
        [SVProgressHUD showInfoWithStatus:@"加菜完成，请去下单"];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
    [self showWithAddSubFoodView:NO];
}

#pragma mark -
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //    debugLog(@"buttonIndex=%d", (int)buttonIndex);
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if (buttonIndex == actionSheet.destructiveButtonIndex)
    {// 上菜/取消上菜
        [self dishUpDown:title];
    }
    else if ([title isEqualToString:@"加菜"])
    {// 加菜
        _operateFood = EN_OPERATE_FOOD_ADD_TYPE;
        [self showWithAddSubFoodView:YES];
    }
    else if ([title isEqualToString:@"退菜"])
    {// 退菜
        _operateFood = EN_OPERATE_FOOD_SUB_TYPE;
        [self showWithAddSubFoodView:YES];
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
    return [_selectedOrderSeatEntity.orderDetailEntity.foods count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // OrderFoodInfoEntity
    __weak typeof(self)weakSelf = self;
    CTCMealOrderFoodEntity *foodEnt = _selectedOrderSeatEntity.orderDetailEntity.foods[indexPath.row];
    debugLog(@"foodName=%@", foodEnt.food_name);
    debugLog(@"sub.count=%d", (int)foodEnt.details.count);
    if (foodEnt.isSub)
    {// 子视图(有加菜或者退菜)
        CTCRestaurantMealingSubFoodOrderViewCell *cell = [CTCRestaurantMealingSubFoodOrderViewCell cellForTableView:tableView];
        [cell updateCellData:foodEnt];
        return cell;
    }
    else
    {
        CTCRestaurantMealingFoodOrderViewCell *cell = [CTCRestaurantMealingFoodOrderViewCell cellForTableView:tableView];
        [cell updateCellData:foodEnt];
        cell.baseTableViewCellBlock = ^(id data)
        {
            // OrderFoodInfoEntity
            CTCMealOrderFoodEntity *orderFoodEnt = data;
            weakSelf.indexPath = indexPath;
            if (orderFoodEnt.status == NS_ORDER_FOOD_RETIRED_STATE)
            {// 退的菜
                BOOL bRet = NO;
                for (CTCMealOrderFoodEntity *ent in orderFoodEnt.details)
                {
                    if (ent.status != NS_ORDER_FOOD_RETIRED_STATE)
                    {
                        bRet = YES;
                    }
                }
                if (!bRet)
                {
                    return;
                }
            }
            
            if (weakSelf.selectedOrderSeatEntity.orderDetailEntity.status != NS_ORDER_DINING_STATE)
            {
                return;
            }
            weakSelf.selectFoodEntity = orderFoodEnt;
            if ([orderFoodEnt.details count] > 1)
            {
                _addSubType = EN_ADD_SUB_SECOND_TYPE; //点击有多次加菜加减菜品的主cell
            }
            else
            {
                _addSubType = EN_ADD_SUB_FIRST_TYPE;
            }
            // 0 正常 1 已上桌 2 已退菜
            [weakSelf initWithFoodActionSheet];
        };
        return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    // OrderFoodInfoEntity
    CTCMealOrderFoodEntity *foodEnt = _selectedOrderSeatEntity.orderDetailEntity.foods[indexPath.row];
    if (foodEnt.isSub)
    {
        height = kCTCRestaurantMealingSubFoodOrderViewCellHeight;
    }
    else
    {
        height = [CTCRestaurantMealingFoodOrderViewCell getWithCellHeight:foodEnt];
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.indexPath = indexPath;
    debugLog(@"row===%d", (int)_indexPath.row);
    CTCMealOrderFoodEntity *foodInfoEntity = nil;
    foodInfoEntity = _selectedOrderSeatEntity.orderDetailEntity.foods[indexPath.row];
        
    if ([foodInfoEntity.details count] > 1)
    {
//        debugLog(@"--if");
        foodInfoEntity.isCheck = !foodInfoEntity.isCheck;
        
        CTCRestaurantMealingFoodOrderViewCell *cell = (CTCRestaurantMealingFoodOrderViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell updateCellData:foodInfoEntity];
        
        NSMutableArray *foodList = [NSMutableArray new];
        if (foodInfoEntity.isCheck)
        {
            [_selectedOrderSeatEntity.orderDetailEntity.foods insertObjects:foodInfoEntity.details atIndex:indexPath.row+1];
            for (NSInteger i=1; i<=foodInfoEntity.details.count; i++)
            {
                [foodList addObject:[NSIndexPath indexPathForRow:i+indexPath.row inSection:indexPath.section]];
            }
            [tableView insertRowsAtIndexPaths:foodList withRowAnimation:UITableViewRowAnimationFade];
        }
        else
        {
            [_selectedOrderSeatEntity.orderDetailEntity.foods removeObjectsInArray:foodInfoEntity.details];
            for (NSInteger i=1; i<=foodInfoEntity.details.count; i++)
            {
                [foodList addObject:[NSIndexPath indexPathForRow:i+indexPath.row inSection:indexPath.section]];
            }
            [tableView deleteRowsAtIndexPaths:foodList withRowAnimation:UITableViewRowAnimationFade];
        }
        
    }
    
    
    if (foodInfoEntity && foodInfoEntity.isSub)
    {
        self.selectFoodEntity = foodInfoEntity;
        
        _addSubType = EN_ADD_SUB_THIRD_TYPE; // 点击有多次加减菜品的子cell
        [self initWithFoodActionSheet];
    }
    else
    {
        self.selectFoodEntity = nil;
    }
}

@end


// OrderFoodInfoEntity *foodEnt = _orderDetailEntity.detailFoods[indexPath.row];




















