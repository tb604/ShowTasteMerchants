//
//  ManagerModeOrderViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/7.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ManagerModeOrderViewController.h"
#import "LocalCommon.h"
#import "ManagerModeOrderTopView.h"
#import "ShopReservationOrderViewController.h" // 预订的订单列表视图控制器
#import "ShopMealingOrderViewController.h" // 正在就餐中的订单列表视图控制器
#import "ShopFinishOrderViewController.h" // 完成的订单列表视图控制器
#import "OrderButtonEntity.h"
#import "WaitingNoticeOrderView.h" // 等待处理的订单视图
#import "HCSLocationManager.h"

@interface ManagerModeOrderViewController ()
{
    ManagerModeOrderTopView *_topView;
}

/**
 *  待处理的订单视图
 */
@property (nonatomic, strong) WaitingNoticeOrderView *waitingNoticeOrderView;

/**
 *  存放子视图的控制器数组
 */
@property (nonatomic, strong) NSMutableArray *childControllers;

/**
 *  子视图的标题数组
 */
@property (nonatomic, strong) NSMutableArray *childTitles;

/**
 *  选中的index
 */
@property (nonatomic, assign) NSInteger selectedIndex;

- (void)initWithTopView;

- (void)initWithWaitingNoticeOrderView;

@end

@implementation ManagerModeOrderViewController

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
    
    _selectedIndex = -1;
    
    _childTitles = [[NSMutableArray alloc] initWithCapacity:0];
    
    _childControllers = [[NSMutableArray alloc] initWithCapacity:0];
    
    OrderButtonEntity *titleEnt = [OrderButtonEntity new];
    titleEnt.title = @"餐前订单";
    titleEnt.imageNameNor = @"order_book_btn_nor";
    titleEnt.imageNameSel = @"order_book_btn_sel";
    titleEnt.titleColorNor = [UIColor colorWithHexString:@"#999999"];
    titleEnt.titleColorSel = [UIColor colorWithHexString:@"#ff5500"];
    titleEnt.isCheck = YES;
    [_childTitles addObject:titleEnt];
    
    titleEnt = [OrderButtonEntity new];
    titleEnt.title = @"餐中订单";
    titleEnt.imageNameNor = @"order_eating_btn_nor";
    titleEnt.imageNameSel = @"order_eating_btn_sel";
    titleEnt.titleColorNor = [UIColor colorWithHexString:@"#999999"];
    titleEnt.titleColorSel = [UIColor colorWithHexString:@"#ff5500"];
    [_childTitles addObject:titleEnt];

    titleEnt = [OrderButtonEntity new];
    titleEnt.title = @"完成订单";
    titleEnt.imageNameNor = @"order_finish_btn_nor";
    titleEnt.imageNameSel = @"order_finish_btn_sel";
    titleEnt.titleColorNor = [UIColor colorWithHexString:@"#999999"];
    titleEnt.titleColorSel = [UIColor colorWithHexString:@"#ff5500"];
    [_childTitles addObject:titleEnt];
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    self.title = @"订单";
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [HCSLocationManager shareInstance];
    
    [self initWithTopView];
    
    self.view.backgroundColor = [UIColor redColor];
    
//    AppDelegate *app = [UtilityObject appDelegate];
    CGRect frame = CGRectMake(0, _topView.bottom, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight] - _topView.height);
    
    // 预订订单
    ShopReservationOrderViewController *reservationOrderVC = [[ShopReservationOrderViewController alloc] initWithNibName:nil bundle:nil isStylePlain:NO firstShowRefresh:NO];
    [self addChildViewController:reservationOrderVC];
    [reservationOrderVC.view setFrame:frame];
    [self.view addSubview:reservationOrderVC.view];
    reservationOrderVC.view.hidden = NO;
    [_childControllers addObject:reservationOrderVC];
    
    // 就餐中的订单
    ShopMealingOrderViewController *mealingOrderVC = [[ShopMealingOrderViewController alloc] initWithNibName:nil bundle:nil isStylePlain:NO firstShowRefresh:NO];
    [self addChildViewController:mealingOrderVC];
    [mealingOrderVC.view setFrame:frame];
    [self.view addSubview:mealingOrderVC.view];
    mealingOrderVC.view.hidden = YES;
    [_childControllers addObject:mealingOrderVC];
    
    
    // 完成的订单
    ShopFinishOrderViewController *finishOrderVC = [[ShopFinishOrderViewController alloc] initWithNibName:nil bundle:nil isStylePlain:NO firstShowRefresh:NO];
    [self addChildViewController:finishOrderVC];
    [finishOrderVC.view setFrame:frame];
    [self.view addSubview:finishOrderVC.view];
    reservationOrderVC.view.hidden = YES;
    [_childControllers addObject:finishOrderVC];
    
    
    self.selectedIndex = 0;
    
//    [self initWithWaitingNoticeOrderView];
}

- (void)initWithTopView
{
    __weak typeof(self)weakSelf = self;
    CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kManagerModeOrderTopViewHeight);
    _topView = [[ManagerModeOrderTopView alloc] initWithFrame:frame];
    [self.view addSubview:_topView];
    _topView.clickedButtonBlock = ^(int index)
    {
        [weakSelf setSelectedIndex:index];
    };
    [_topView updateViewData:_childTitles];
}

- (void)initWithWaitingNoticeOrderView
{
    /*if (!_waitingNoticeOrderView)
    {
        AppDelegate *app = [UtilityObject appDelegate];
        CGRect frame = CGRectMake(0, [[UIScreen mainScreen] screenHeight] - [app tabBarHeight] - [app navBarHeight] - 20 - 40, [[UIScreen mainScreen] screenWidth], 40);
        _waitingNoticeOrderView = [[WaitingNoticeOrderView alloc] initWithFrame:frame];
        [self.view addSubview:_waitingNoticeOrderView];
    }
    __weak typeof(self)weakSelf = self;
    _waitingNoticeOrderView.viewCommonBlock = ^(id data)
    {
        [MCYPushViewController showWithWaitingNoticeOrderVC:weakSelf data:nil completion:nil];
    };*/
}

- (void)transitionToViewControllerAtIndex:(NSUInteger)index
{
    for (NSInteger i=0; i<[_childControllers count]; i++)
    {
        UIViewController *vc = _childControllers[i];
        if (i == _selectedIndex)
        {
            vc.view.hidden = NO;
        }
        else
        {
            vc.view.hidden = YES;
        }
    }
    [_topView selectedIndex:index];
}

#pragma mark start getter and setter
- (void)setSelectedIndex:(NSInteger)index
{
    BOOL bRet = NO;
    if (index != _selectedIndex)
    {
        _selectedIndex = index;
        bRet = YES;
    }
    
    [self transitionToViewControllerAtIndex:index];
    
    if (bRet)
    {
        /*
         #import "ShopReservationOrderViewController.h" // 预订的订单列表视图控制器
         #import "ShopMealingOrderViewController.h" // 正在就餐中的订单列表视图控制器
         #import "ShopFinishOrderViewController.h"
         */
        TYZRefreshTableViewController *vc = _childControllers[index];
//        if ([vc getBaseListCount] == 0)
//        {
            [vc doRefreshData];
//        }
    }
}



@end
