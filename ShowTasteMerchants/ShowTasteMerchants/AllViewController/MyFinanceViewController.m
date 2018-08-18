//
//  MyFinanceViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/7.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyFinanceViewController.h"
#import "LocalCommon.h"
#import "MyFinanceNavTitleView.h"
#import "MyFinanceDayViewController.h" // 日
//#import "MyFinanceWeekViewController.h" // 周
#import "MyFinanceWeekWebViewController.h" // 周
//#import "MyFinanceMonthViewController.h" // 月
#import "MyFinanceMonthWebViewController.h" // 月

@interface MyFinanceViewController ()
{
    MyFinanceNavTitleView *_navTitleView;
    
    NSInteger _selectedIndex;
}

@property (nonatomic, assign) NSInteger selectedIndex;

/**
 *  存放子视图的控制器数组
 */
@property (nonatomic, strong) NSMutableArray *childControllers;

/**
 *  子视图的标题数组
 */
@property (nonatomic, strong) NSMutableArray *childTitles;


- (void)initWithNavTitleView;


@end

@implementation MyFinanceViewController

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
    
    _selectedIndex = 0;
    
    _childTitles = [[NSMutableArray alloc] initWithCapacity:0];
    [_childTitles addObject:@"日"];
    [_childTitles addObject:@"周"];
    [_childTitles addObject:@"月"];
    
    _childControllers = [[NSMutableArray alloc] initWithCapacity:0];
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
//    self.title = NSLocalizedString(@"MyFinanceTitle", @"");
    
    UIImage *image = [UIImage imageNamed:@"nav_btn_back_nor"];
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [btnBack setImage:image forState:UIControlStateNormal];
    UIBarButtonItem *itemBack = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.rightBarButtonItem = itemBack;
    btnBack.hidden = YES;

    [self initWithNavTitleView];
}

- (void)initWithSubView
{
    [super initWithSubView];
    
//    AppDelegate *app = [UtilityObject appDelegate];
    CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight]);
    // 日
    MyFinanceDayViewController *dayVC = [[MyFinanceDayViewController alloc] initWithNibName:nil bundle:nil isStylePlain:NO firstShowRefresh:NO];
    [self addChildViewController:dayVC];
    [dayVC.view setFrame:frame];
    [self.view addSubview:dayVC.view];
    dayVC.view.hidden = NO;
    [_childControllers addObject:dayVC];
    
    // 周
    MyFinanceWeekWebViewController *weekVC = [[MyFinanceWeekWebViewController alloc] initWithNibName:nil bundle:nil];
    weekVC.url = [NSString stringWithFormat:@"%@/order-report/week-summary?shop_id=%d", H5ROOTURL, (int)[UserLoginStateObject getCurrentShopId]];
    [self addChildViewController:weekVC];
    [weekVC.view setFrame:frame];
    [self.view addSubview:weekVC.view];
    weekVC.view.hidden = YES;
    [_childControllers addObject:weekVC];
    
    // 月
    MyFinanceMonthWebViewController *monthVC = [[MyFinanceMonthWebViewController alloc] initWithNibName:nil bundle:nil];
    monthVC.url = [NSString stringWithFormat:@"%@/order-report/month-summary?shop_id=%d", H5ROOTURL, (int)[UserLoginStateObject getCurrentShopId]];
    [self addChildViewController:monthVC];
    [monthVC.view setFrame:frame];
    [self.view addSubview:monthVC.view];
    monthVC.view.hidden = YES;
    [_childControllers addObject:monthVC];
}

- (void)initWithNavTitleView
{
    if (!_navTitleView)
    {
        AppDelegate *app = [UtilityObject appDelegate];
        CGRect frame = CGRectMake(80, 0, [[UIScreen mainScreen] screenWidth] - 80 * 2, [app navBarHeight]);
        _navTitleView = [[MyFinanceNavTitleView alloc] initWithFrame:frame];
//        _navTitleView.backgroundColor = [UIColor purpleColor];
        self.navigationItem.titleView = _navTitleView;
    }
    [_navTitleView setSelectedIndex:_selectedIndex];
    [_navTitleView updateViewData:_childTitles];
    __weak typeof(self)weakSelf = self;
    _navTitleView.viewCommonBlock = ^(id data)
    {
        NSInteger index = [data integerValue] - EN_FINANCE_BTN_DAY_TAG;
        [weakSelf setSelectedIndex:index];
    };
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    debugMethod();
    
    _selectedIndex = selectedIndex;
    
    for (UIViewController *vc in _childControllers)
    {
        vc.view.hidden = YES;
    }
    
    UIViewController *vc = _childControllers[_selectedIndex];
    vc.view.hidden = NO;
    if ([vc isKindOfClass:[MyFinanceDayViewController class]])
    {// 日
        MyFinanceDayViewController *dayVC = (MyFinanceDayViewController *)vc;
        [dayVC doRefreshData];
    }
    else if ([vc isKindOfClass:[MyFinanceWeekWebViewController class]])
    {// 周
        MyFinanceWeekWebViewController *weekVC = (MyFinanceWeekWebViewController *)vc;
        [weekVC doRefreshData];
    }
    else if ([vc isKindOfClass:[MyFinanceMonthWebViewController class]])
    {// 月
        MyFinanceMonthWebViewController *monthVC = (MyFinanceMonthWebViewController *)vc;
        [monthVC doRefreshData];
    }
    
}


@end

/*
 CGRect frame = CGRectMake(0, _topView.bottom, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight] - _topView.height);
 
 // 预订订单
 ShopReservationOrderViewController *reservationOrderVC = [[ShopReservationOrderViewController alloc] initWithNibName:nil bundle:nil isStylePlain:NO firstShowRefresh:NO];
 [self addChildViewController:reservationOrderVC];
 [reservationOrderVC.view setFrame:frame];
 [self.view addSubview:reservationOrderVC.view];
 reservationOrderVC.view.hidden = NO;
 [_childControllers addObject:reservationOrderVC];
 */
























