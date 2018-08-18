//
//  MyRestaurantViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/16.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantViewController.h"
#import "LocalCommon.h"
#import "MyRestaurantNavTitleView.h"
#import "MyRestaurantTopView.h"
#import "MyRestaurantDataViewController.h" // 餐厅资料视图控制器
#import "MyRestaurantMenuViewController.h" // 我的餐厅菜单视图控制器
//#import "MyRestaurantBookedViewController.h" // 餐厅预订视图控制器
//#import "MyRestaurantBookedWebViewController.h" // 餐厅预订视图控制器(h5)
#import "MyRestaurantRoomSpaceViewController.h" // 我的空间视图控制器
#import "MyRestaurantManagerViewController.h" // 我的餐厅管理视图控制器
#import "MyRestaurantMouthViewController.h" // 我的餐厅档口视图控制器
#import "UserLoginStateObject.h"
#import "OpenRestaurantInputEntity.h"
#import "OrderMealContentEntity.h"
#import "ShopListDataEntity.h"
#import "UserLoginStateObject.h"
#import "ShopMouthDataEntity.h"

@interface MyRestaurantViewController () <UIScrollViewDelegate>
{
    MyRestaurantNavTitleView *_navTitleView;
    
    MyRestaurantTopView *_topView;
    
    /**
     *  餐厅信息是否切换
     */
    BOOL _shopInfoSwitch;
    
    /**
     *  餐厅菜单切换
     */
    BOOL _shopMenuSwitch;
    
    /**
     *  餐厅预订切换
     */
    BOOL _shopBookedSwitch;
    
    /**
     *  餐厅管理切换
     */
    BOOL _shopManageSwitch;
    
    /**
     *  餐厅档口切换
     */
    BOOL _shopMouthSwitch;
    
}

@property (nonatomic, strong) MyRestaurantNavTitleView *navTitleView;

@property (nonatomic, strong) UIScrollView *rootScrollView;

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

/**
 *  selected状态下按钮文字的颜色
 */
@property (nonatomic, strong) UIColor *selectedLabelColor;

/**
 *  normal状态下按钮文字的颜色
 */
@property (nonatomic, strong) UIColor *unselectedLabelColor;

- (void)initWithNavTitleView;

- (void)initWithTopView;

- (void)initWithRootScrollView;

/**
 *  点击，景点点评、商户点评、游迹点评 按钮后调用，显示对应的视图
 *
 *  @param index 视图控制器对应的index
 */
- (void)transitionToViewControllerAtIndex:(NSUInteger)index;


@end

@implementation MyRestaurantViewController

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
    
    _shopInfoSwitch = YES;
    _shopMenuSwitch = YES;
    _shopBookedSwitch = YES;
    _shopManageSwitch = YES;
    _shopMouthSwitch = YES;
    
    _childTitles = [[NSMutableArray alloc] initWithObjects:@"资料", @"菜单", @"空间", @"管理", @"档口", nil];
    _childControllers = [[NSMutableArray alloc] initWithCapacity:_childTitles.count];
    _selectedIndex = 0;
    self.selectedLabelColor = [UIColor colorWithHexString:@"#ff5500"];
    self.unselectedLabelColor = [UIColor colorWithHexString:@"#323232"];
    
    __weak typeof(self)weakSelf = self;
    // 餐厅资料视图控制器
    MyRestaurantDataViewController *dataVC = [[MyRestaurantDataViewController alloc] initWithNibName:nil bundle:nil isStylePlain:YES firstShowRefresh:NO];
    [_childControllers addObject:dataVC];
    dataVC.popResultBlock = ^(id data)
    {
        [weakSelf.navTitleView updateViewData:data];
    };
    
    // 我的餐厅菜单视图控制器
    MyRestaurantMenuViewController *menuVC = [[MyRestaurantMenuViewController alloc] initWithNibName:nil bundle:nil];
    [_childControllers addObject:menuVC];
    
    // 我的空间视图控制器
    MyRestaurantRoomSpaceViewController *roomSpaceVC = [[MyRestaurantRoomSpaceViewController alloc] initWithNibName:nil bundle:nil isStylePlain:NO firstShowRefresh:NO];
    
//    MyRestaurantBookedWebViewController *bookedVC = [[MyRestaurantBookedWebViewController alloc] initWithNibName:nil bundle:nil];
//    bookedVC.url = @"http://www.baidu.com";
    [_childControllers addObject:roomSpaceVC];
    
    // 我的餐厅管理视图控制器
    MyRestaurantManagerViewController *managerVC = [[MyRestaurantManagerViewController alloc] initWithNibName:nil bundle:nil isStylePlain:YES firstShowRefresh:NO];
    [_childControllers addObject:managerVC];
    
    // 我的餐厅档口视图控制器
    MyRestaurantMouthViewController *mouthVC = [[MyRestaurantMouthViewController alloc] initWithNibName:nil bundle:nil isStylePlain:NO firstShowRefresh:NO];
    [_childControllers addObject:mouthVC];
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithNavTitleView];
    
    [self initWithBtnBrowse];
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    
    [self initWithTopView];
    
    [self initWithRootScrollView];
    
    [_topView updateHorizonTalPosition:1];
    self.selectedIndex = 1;
}

- (void)initWithNavTitleView
{
    if (!_navTitleView)
    {
        AppDelegate *app = [UtilityObject appDelegate];
        CGRect frame = CGRectMake(60, 0, [[UIScreen mainScreen] screenWidth] - 120, [app navBarHeight]);
        _navTitleView = [[MyRestaurantNavTitleView alloc] initWithFrame:frame];
        self.navigationItem.titleView = _navTitleView;
    }
    __weak typeof(self)weakSelf = self;
    _navTitleView.viewCommonBlock = ^(id data)
    {// 进去餐厅列表
        AppDelegate *app = [UtilityObject appDelegate];
        [app hiddenWithTipView:YES isTop:NO];
//        [MCYPushViewController showWithOpenRestaurantListVC:weakSelf data:nil completion:^(id data) {
//            [weakSelf switchWithShop:data];
//            [app hiddenWithTipView:NO isTop:NO];
//        }];
    };
}

- (void)initWithBtnBrowse
{
    NSString *str = @"预览";
    CGFloat width = [str widthForFont:FONTSIZE_16];
    UIButton *btnBrowse = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBrowse setTitle:str forState:UIControlStateNormal];
    btnBrowse.titleLabel.font = FONTSIZE_16;
    btnBrowse.frame = CGRectMake(0, 0, width, 30);
    [btnBrowse setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnBrowse addTarget:self action:@selector(clickedBrowse:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itemBrowsee = [[UIBarButtonItem alloc] initWithCustomView:btnBrowse];
    self.navigationItem.rightBarButtonItem = itemBrowsee;
}

- (void)initWithTopView
{
    if (!_topView)
    {
        AppDelegate *app = [UtilityObject appDelegate];
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [app navBarHeight]);
        
        
        __weak typeof(self)blockSelf = self;
        _topView = [[MyRestaurantTopView alloc] initWithFrame:frame btnTitles:_childTitles];
        [self.view addSubview:_topView];
        _topView.clickedButtonBlock = ^(int index)
        {
            debugLog(@"index=%d", (int)index);
            blockSelf.selectedIndex = index;
        };
        _topView.clickedBtnEditBlock = ^()
        {// 编辑
            [blockSelf restautInfoEdit];
        };
    }
}

- (void)initWithRootScrollView
{
    if (!_rootScrollView)
     {
         CGRect lframe = _topView.frame;
         
         AppDelegate *app = [UtilityObject appDelegate];
//         debugLog(@"tab=%.2f", [app tabBarHeight]);
         CGRect frame = CGRectMake(0.0f, lframe.origin.y + lframe.size.height, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight] - [app navBarHeight] - lframe.size.height - STATUSBAR_HEIGHT - [app tabBarHeight]);
         _rootScrollView = [[UIScrollView alloc] initWithFrame:frame];
         _rootScrollView.pagingEnabled = YES;
//         _rootScrollView.backgroundColor = [UIColor purpleColor];
         _rootScrollView.alwaysBounceHorizontal = YES;
         _rootScrollView.showsHorizontalScrollIndicator = NO;
         _rootScrollView.showsVerticalScrollIndicator = NO;
         _rootScrollView.contentSize = CGSizeMake([[UIScreen mainScreen] screenWidth] * _childTitles.count, _rootScrollView.frame.size.height);
         _rootScrollView.delegate = self;
     
         
         for (NSInteger i=0; i<self.childControllers.count; i++)
         {
             id obj = [self.childControllers objectAtIndex:i];
             if ([obj isKindOfClass:[UIViewController class]])
             {
                 UIViewController *controller = (UIViewController *)obj;
                 [self addChildViewController:controller];
                 CGFloat scrollWidth = _rootScrollView.frame.size.width;
                 CGFloat scrollHeight = _rootScrollView.frame.size.height;
                CGRect frame = CGRectMake(i * scrollWidth, 0, scrollWidth, scrollHeight);
                 [controller.view setFrame:frame];
                 [_rootScrollView addSubview:controller.view];
            }
         }
     }
     
     [self.view addSubview:_rootScrollView];
    
}

// 切换餐厅
- (void)switchWithShop:(ShopListDataEntity *)shopEnt
{
    if (!shopEnt)
    {
        return;
    }
    
    if (shopEnt.shop_id != [UserLoginStateObject getCurrentShopId])
    {// 当前餐厅跟切换的餐厅不相同。
        _shopInfoSwitch = YES;
        _shopMenuSwitch = YES;
        _shopBookedSwitch = YES;
        _shopManageSwitch = YES;
        _shopMouthSwitch = YES;
        
        UserInfoDataEntity *userInfo = [UserLoginStateObject getUserInfo];
        userInfo.shop_id = shopEnt.shop_id;
        userInfo.shop_state = shopEnt.state;
        [UserLoginStateObject saveWithUserInfo:userInfo];
        
        // 更新餐厅名称
        [_navTitleView updateViewData:shopEnt.name];
        
        [_topView updateHorizonTalPosition:1];
        [_topView updateSelectedButtonIndex:1];
        _selectedIndex = -1;
        self.selectedIndex = 1;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kCHANGE_SHOP_NOTE object:nil];
        
    }
}

/**
 *  点击，显示对应的视图
 *
 *  @param index 视图控制器对应的index
 */
- (void)transitionToViewControllerAtIndex:(NSUInteger)index
{
    [_rootScrollView setContentOffset:CGPointMake(index * _rootScrollView.frame.size.width, 0) animated:NO];
    
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
    
    [self transitionToViewControllerAtIndex:index-1];
    
    if (bRet)
    {
        [self showWithViewRefreshData:index - 1];
    }
}
#pragma mark end getter and setter
// 餐厅信息编辑
- (void)restautInfoEdit
{
    NSInteger shopId = [UserLoginStateObject getCurrentShopId];
    
    if (_selectedIndex == 1)
    {// 餐厅资料
        AppDelegate *app = [UtilityObject appDelegate];
        [app hiddenWithTipView:YES isTop:NO];
        OpenRestaurantInputEntity *inputEnt = [OpenRestaurantInputEntity new];
        inputEnt.shopId = shopId;
        inputEnt.comeType = 2;
        [MCYPushViewController showWithOpenRestaurantInfoVC:self inputData:inputEnt data:nil completion:^(id data) {
            MyRestaurantDataViewController *shopData = _childControllers[_selectedIndex - 1];
            [shopData refreshWithData:data];
            [app hiddenWithTipView:NO isTop:NO];
        }];
    }
    else
    {
        if ([UserLoginStateObject getWithCurrentState] != EN_SHOP_NOTAUDIT_STATE && [UserLoginStateObject getWithCurrentState] != EN_SHOP_WAITINGAUDIT_STATE)
        {
            [self showWithEditVC];
        }
        else
        {
            [SVProgressHUD showWithStatus:@"加载中"];
            [HCSNetHttp requestWithShopState:shopId completion:^(id result) {
                TYZRespondDataEntity *respond = result;
                if (respond.errcode == respond_success)
                {
                    NSInteger state = [respond.data integerValue];
                    if (state == EN_SHOP_NOTAUDIT_STATE)
                    {
                        [SVProgressHUD showErrorWithStatus:@"请上传资质！"];
                        
                    }
                    else if (state == EN_SHOP_WAITINGAUDIT_STATE)
                    {
                        [SVProgressHUD showErrorWithStatus:@"等待资质审核！"];
                    }
                    else
                    {
                        [SVProgressHUD dismiss];
                        [self showWithEditVC];
                    }
                    [UserLoginStateObject saveWithShopState:state];
                }
                else
                {
                    [UtilityObject svProgressHUDError:respond viewContrller:self];
                }
            }];
        }
    }
}

- (void)showWithEditVC
{
    AppDelegate *app = [UtilityObject appDelegate];
    if (_selectedIndex == 2)
    {// 菜单
        [app hiddenWithTipView:YES isTop:NO];
        MyRestaurantMenuViewController *menuVC = _childControllers[_selectedIndex - 1];
        [MCYPushViewController showWithResaurantMenuEditVC:self data:menuVC.menuList completion:^(id data) {
//            debugLog(@"返回来了");
            [menuVC addEditMenu:data];
            [app hiddenWithTipView:NO isTop:NO];
        }];
    }
    else if (_selectedIndex == 3)
    {// 空间编辑
        debugLog(@"空间编辑");
        [app hiddenWithTipView:YES isTop:NO];
        MyRestaurantRoomSpaceViewController *roomSpaceVC = _childControllers[_selectedIndex - 1];
//        debugLog(@"==%@", roomSpaceVC.baseList);
        [MCYPushViewController showWithRoomSpaceVC:self data:roomSpaceVC.baseList completion:^(id data) {
            [roomSpaceVC.baseList removeAllObjects];
            [roomSpaceVC.baseList addObjectsFromArray:data];
            [roomSpaceVC.baseTableView reloadData];
            [app hiddenWithTipView:NO isTop:NO];
        }];
    }
    else if (_selectedIndex == 4)
    {// 管理编辑
        [app hiddenWithTipView:YES isTop:NO];
        MyRestaurantManagerViewController *vc = _childControllers[_selectedIndex-1];
        [MCYPushViewController showWithRestaurantManagerEditVC:self data:vc.baseList completion:^(id data) {
            [vc doRefreshData];
            [app hiddenWithTipView:NO isTop:NO];
        }];
    }
    else if (_selectedIndex == 5)
    {// 档口编辑
        MyRestaurantMouthViewController *mouthVC = _childControllers[_selectedIndex-1];
        
        debugLog(@"base=%@", mouthVC.baseList);
        
        NSMutableArray *addList = [NSMutableArray new];
        NSInteger i = 0;
        for (id ent in mouthVC.baseList)
        {
            if ([ent isKindOfClass:[ShopMouthDataEntity class]])
            {
                if (i == 0)
                {
                    ((ShopMouthDataEntity *)ent).isSelected = YES;
                }
                [addList addObject:ent];
            }
            i+= 1;
        }
        
        [MCYPushViewController showWithShopMouthEditVC:self data:addList completion:^(id data) {
            [mouthVC.baseList removeAllObjects];
            [mouthVC.baseList addObjectsFromArray:data];
            [mouthVC.baseTableView reloadData];
//            [mouthVC doRefreshData];
            [app hiddenWithTipView:NO isTop:NO];
        }];
    }
}

/**
 *  预览餐厅信息
 *
 *  @param sender send
 */
- (void)clickedBrowse:(id)sender
{
//    MyRestaurantDataViewController *vc = _childControllers[0];
    AppDelegate *app = [UtilityObject appDelegate];
    [app hiddenWithTipView:YES isTop:NO];
    [MCYPushViewController showWithRestaurantPreviewVC:self data:nil completion:^(id data) {
        [app hiddenWithTipView:NO isTop:NO];
    }];
}

- (void)showWithViewRefreshData:(NSInteger)index
{    
    if (index == 0)
    {// 资料
        MyRestaurantDataViewController *shopInfoVC = _childControllers[index];
        if ([shopInfoVC refreshData] || _shopInfoSwitch)
        {
            [shopInfoVC doRefreshData];
            _shopInfoSwitch = NO;
        }
    }
    else if (index == 1)
    {// 菜单
        MyRestaurantMenuViewController *menuVC = _childControllers[index];
        [menuVC doRefreshData];
    }
    else if (index == 2)
    {// 空间
        MyRestaurantRoomSpaceViewController *roomSpaceVC = _childControllers[index];
        [roomSpaceVC doRefreshData];
        debugLog(@"空间");
    }
    else if (index == 3)
    {// 管理
        MyRestaurantManagerViewController *managerVC = _childControllers[index];
        [managerVC doRefreshData];
    }
    else if (index == 4)
    {// 档口
        MyRestaurantMouthViewController *mouthVC = _childControllers[index];
        [mouthVC doRefreshData];
    }
}


#pragma mark start UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // extern float fmod(float x, float y); 功能：计算x/y的余数
    float mode = fmod(scrollView.contentOffset.x, scrollView.frame.size.width);
    if (0 == mode)
    {
//        debugLog(@"tagere");
        _selectedIndex = (scrollView.contentOffset.x / scrollView.frame.size.width) + 1;
        
        [self showWithViewRefreshData:_selectedIndex - 1];
//        OneselfTripOrderAgencyListViewController *vc = _childControllers[_selectedIndex - 1];
//        if ([vc orderCount] == 0)
//        {// 订单数量为0重新加载，可能是网络导致没有数据
//            [vc doRefreshData];
//        }
        [_topView updateSelectedButtonIndex:_selectedIndex];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate)
    {
        _selectedIndex = (scrollView.contentOffset.x / scrollView.frame.size.width) + 1;
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float offsetX = scrollView.contentOffset.x;
    CGRect frame = _topView.horizontalBlueLine.frame;
//    frame.origin.x = [[UIScreen mainScreen] screenWidth] * (offsetX /([[UIScreen mainScreen] screenWidth] * self.childTitles.count));
    CGFloat width = ([[UIScreen mainScreen] screenWidth] - 15 - 40 - 10) / _childTitles.count;
    frame.origin.x = (width * [_childTitles count]) * (offsetX /([[UIScreen mainScreen] screenWidth] * self.childTitles.count));
    _topView.horizontalBlueLine.frame = frame;
    
    // 左 or 右
    //    NSLog(@"_selectedIndex=%d", _selectedIndex);
    UIButton *relativeButton = nil;
    UIButton *currentButton = (UIButton *)[_topView viewWithTag:_selectedIndex+100];
    float btnOffset = (float)(scrollView.contentOffset.x - (_selectedIndex - 1) * scrollView.frame.size.width);
    if (btnOffset > 0 && _selectedIndex <= [self.childTitles count])
    { // 右边
        relativeButton = (UIButton *)[_topView viewWithTag:(_selectedIndex + 1)+100];
    }
    else if (btnOffset < 0 && _selectedIndex > 1)
    { // 左边
        relativeButton = (UIButton *)[_topView viewWithTag:(_selectedIndex - 1)+100];
    }
    btnOffset = fabsf(btnOffset); // 求绝对值
    if (relativeButton && _selectedIndex != 0)
    {
        CGFloat scrollViewWidth = scrollView.frame.size.width;
        CGFloat red = ((self.unselectedLabelColor.red - self.selectedLabelColor.red) * btnOffset / scrollViewWidth + self.selectedLabelColor.red);
        CGFloat green = ((self.unselectedLabelColor.green - self.selectedLabelColor.green) * btnOffset/scrollViewWidth + self.selectedLabelColor.green);
        CGFloat blue = ((self.unselectedLabelColor.blue - self.selectedLabelColor.blue) * btnOffset / scrollViewWidth + self.selectedLabelColor.blue);
        UIColor *currentColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
        
        red = ((self.selectedLabelColor.red - self.unselectedLabelColor.red) * btnOffset / scrollViewWidth + self.unselectedLabelColor.red);
        green = ((self.selectedLabelColor.green - self.unselectedLabelColor.green) * btnOffset / scrollViewWidth + self.unselectedLabelColor.green);
        blue = ((self.selectedLabelColor.blue - self.unselectedLabelColor.blue) * btnOffset / scrollViewWidth + self.unselectedLabelColor.blue);
        UIColor *relativeColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
        
        [currentButton setTitleColor:currentColor forState:UIControlStateNormal];
        [relativeButton setTitleColor:relativeColor forState:UIControlStateNormal];
    }
}
#pragma mark end UIScrollViewDelegate



@end
