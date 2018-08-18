//
//  DeliveryOrdersViewController.m
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/16.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DeliveryOrdersViewController.h"
#import "LocalCommon.h"
#import "HungryNetHttp.h"
#import "HungryOrderDetailEntity.h"
#import "DeliveryOrdersTopView.h"
#import "DeliveryOrdersListViewController.h" // 订单视图控制器

@interface DeliveryOrdersViewController ()
{
    DeliveryOrdersTopView *_topView;
}

@property (nonatomic, strong) NSArray *menuList;

@property (nonatomic, strong) NSMutableArray *childControllers;

- (void)initWithTopView;

- (void)initWithOrderListVC;

@end

@implementation DeliveryOrdersViewController

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

#pragma mark -


- (void)initWithVar
{
    [super initWithVar];
    
    /*[HungryNetHttp requestWithHungryOrderDetail:101547084688647790 tpId:0 completion:^(TYZRespondDataEntity *result) {
        if (result.errcode == 200)
        {
            debugLog(@"获取数据成功");
            debugLog(@"data=%@", NSStringFromClass([result.data class]));
//            HungryOrderDetailEntity
        }
        else
        {
            debugLog(@"获取数据失败");
        }
    }];*/
    
    _childControllers = [[NSMutableArray alloc] initWithCapacity:0];
    
//    [HungryNetHttp requestWithTest:123 completion:nil];
    
    
    /*NSString *cityPath = [NSFileManager getfilebulderPath:@"emeOrderDetail.json"];
    NSString *jsonStr = [NSString stringWithContentsOfFile:cityPath encoding:NSUTF8StringEncoding error:nil];

    NSDictionary *dict = [NSDictionary modelDictionaryWithJson:jsonStr];
    
    TYZRespondDataEntity *respond = [TYZRespondDataEntity modelWithJSON:dict];
//    debugLog(@"data=%@", respond.data);
    id data = dict[@"data"];
    if ([data isEqual:[NSNull null]])
    {
        respond.data = nil;
    }
    else
    {
        respond.data = data;
    }
    HungryOrderDetailEntity *orderDetilEnt = [HungryOrderDetailEntity modelWithJSON:data];
    
    NSMutableArray *groups = [NSMutableArray new];
    for (id list in orderDetilEnt.detail.group)
    {
        NSMutableArray *addList = [NSMutableArray new];
        for (id dict in list)
        {
            HungryOrderFoodEntity *foodEnt = [HungryOrderFoodEntity modelWithJSON:dict];
//            debugLog(@"foodName=%@", foodEnt.name);
            [addList addObject:foodEnt];
        }
        if ([addList count] > 0)
        {
            [groups addObject:addList];
        }
    }
    if ([groups count] > 0)
    {
        orderDetilEnt.detail.group = groups;
    }
    
    for (NSArray *list in orderDetilEnt.detail.group)
    {
        for (HungryOrderFoodEntity *ent in list)
        {
            debugLog(@"foodName=%@", ent.name);
        }
    }*/
    
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = @"外卖订单";
    
    
    UIImage *image = [UIImage imageWithContentsOfFileName:@"take-out_btn_set.png"];
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    UIButton *btnSettings = [TYZCreateCommonObject createWithButton:self imgNameNor:@"take-out_btn_set" imgNameSel:@"take-out_btn_set" targetSel:@selector(clickedWithSettings:)];
    btnSettings.frame = frame;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btnSettings];
    self.navigationItem.rightBarButtonItem = rightItem;
}


- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithTopView];
    
    [self initWithOrderListVC];
}

#pragma mark private init methods
- (void)initWithTopView
{
    if (!_topView)
    {
        NSArray *array = @[@"待接单", @"已接单", @"配送未接单", @"取货中", @"配送结果", @"异常订单"];
        self.menuList = array;
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], 40.0);
        _topView = [[DeliveryOrdersTopView alloc] initWithFrame:frame titleList:array];
        [self.view addSubview:_topView];
    }
    __weak typeof(self)weakSelf = self;
    _topView.selectButtonBlock = ^(NSInteger orderType)
    {
        [weakSelf selectWithOrderVC:orderType];
    };
}

- (void)initWithOrderListVC
{
//    DeliveryOrdersListViewController
    CGRect frame = CGRectMake(0, _topView.bottom, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight] - _topView.height);
    for (NSInteger i=0; i<_menuList.count; i++)
    {
        DeliveryOrdersListViewController *orderListVC = [[DeliveryOrdersListViewController alloc] initWithNibName:nil bundle:nil isStylePlain:NO firstShowRefresh:NO];
        orderListVC.orderType = i;
        [self addChildViewController:orderListVC];
        [orderListVC.view setFrame:frame];
        [self.view addSubview:orderListVC.view];
        if (i == 0)
        {
            orderListVC.view.hidden = NO;
        }
        else
        {
            orderListVC.view.hidden = YES;;
        }
        [_childControllers addObject:orderListVC];
    }
    
}

#pragma mark -
#pragma mark private methods

/**
 *  设置
 */
- (void)clickedWithSettings:(id)sender
{
    
//    --------------------------------
//    NSString *str = @"---";
//    int len = tyzStrLength([str UTF8String]);
//    debugLog(@"len=%d", len);
    
    
    // http://api.open.cater.meituan.com/waimai/order/queryById?appAuthToken=sdfsfsfsfd&charset=UTF-8&couponCode=2231312&sign=7b370e46698328fa8f27fd4ae923f79199e79c8c&timestamp=1480321613&version=1
    // http://api.open.cater.meituan.com/waimai/order/queryById?appAuthToken=sdfsfsfsfd&charset=UTF-8&couponCode=2231312&sign=7b370e46698328fa8f27fd4ae923f79199e79c8c&timestamp=1480321613&version=1&orderId=1234
//    [HungryNetHttp requestWithMeiTuanOrderDetail:1234 completion:nil];
//    return;
    
    [MCYPushViewController showWithDeliverySettingsVC:self data:nil completion:nil];
}

- (void)selectWithOrderVC:(NSInteger)orderType
{
    DeliveryOrdersListViewController *orderListVC = _childControllers[orderType];
    
    for (DeliveryOrdersListViewController *vc in _childControllers)
    {
        vc.view.hidden = YES;
    }
    orderListVC.view.hidden = NO;
    
}

@end
