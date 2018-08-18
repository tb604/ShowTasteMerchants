//
//  ManagerModeTabBarController.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/7.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ManagerModeTabBarController.h"
#import "LocalCommon.h"
#import "TYZTabBar.h"
#import "ViewController.h"
#import "TYZCustomNavController.h"
#import "TYZKit.h"
#import "MyInfoViewController.h" // 我的视图控制器
#import "ManagerModeOrderViewController.h" // 经营模式的订单视图控制器
//#import "MyRestaurantListViewController.h" // 经营模式的，我开的餐厅列表视图控制器
#import "MyRestaurantViewController.h" // 经营模式，我的餐厅
#import "MyFinanceViewController.h" // 经营模式的，我的财务视图控制器
#import "UserLoginStateObject.h"

@interface ManagerModeTabBarController ()
{
    BOOL _isShowMiddleBulgeBtn;
}

/**
 *  订单
 */
@property (nonatomic, strong) TYZCustomNavController *managerOrderNav;

/**
 *  我的餐厅
 */
@property (nonatomic, strong) TYZCustomNavController *restaurantListNav;


/**
 *  财务
 */
@property (nonatomic, strong) TYZCustomNavController *myFinanceNav;

@end

@implementation ManagerModeTabBarController

- (instancetype)initWithShowMiddleBtn:(BOOL)showMiddleBtn
{
    _isShowMiddleBulgeBtn = showMiddleBtn;
    if (self = [super init])
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置TabBarItemtestAttributes的颜色
    [self setupTabBarItemTextAttributes];
    
    // 设置子控制器
    [self setupChildViewController];
    
    // 处理tabBar，使用自定义tabBar添加发布按钮
//    [self setupTabBar];
    
    [[UITabBar appearance] setBackgroundImage:[self imageWithColor:[UIColor whiteColor]]];
    // 去除TabBar自带的顶部阴影
    //    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    // 标题的颜色
    //    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    // 标题的font
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:19]}];
    //    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHexString:@"#00bbfc"]];
    // 去除自带的顶部阴影
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    // 设置导航栏控制器颜色
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#ff5601"]] forBarMetrics:UIBarMetricsDefault];
    //    debugLog(@"translucent=%d", [UINavigationBar appearance].translucent);
    if ([[UINavigationBar appearance] respondsToSelector:@selector(setTranslucent:)])
    {
        [[UINavigationBar appearance] setTranslucent:NO];
    }
    self.appTabBarHeight = self.tabBar.height;
    
}

#pragma mark - private methods
/**
 *  利用KVC把系统的tabBar类型改为自定义的类型
 */
- (void)setupTabBar
{
//    [self setValue:[[TYZTabBar alloc] initWithShowMiddleBtn:_isShowMiddleBulgeBtn] forKey:@"tabBar"];
}

/**
 *  tabBarItem的选中和不选中文字属性
 */
- (void)setupTabBarItemTextAttributes
{
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] =[UIColor colorWithHexString:@"#808080"];
    
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#ff5601"];
    
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateHighlighted];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}

- (void)setupChildViewController
{
    // 订单
    ManagerModeOrderViewController *orderMealVC = [[ManagerModeOrderViewController alloc] initWithNibName:nil bundle:nil];
    TYZCustomNavController *managerOrderNav = [[TYZCustomNavController alloc] initWithRootViewController:orderMealVC];
    [self addChildViewController:managerOrderNav withTitle:NSLocalizedString(@"ManagerOrderTitle", nil) imageName:@"tab_btn_ordering_nor" selectedImageName:@"tab_btn_ordering_sel"];
    self.managerOrderNav = managerOrderNav;
    self.appNavBarHeight = managerOrderNav.navigationBar.bounds.size.height;
    
    // 我开的餐厅
    MyRestaurantViewController *restaurantVC = [[MyRestaurantViewController alloc] initWithNibName:nil bundle:nil];
//    ViewController *vc = [[ViewController alloc] init];
//    vc.view.backgroundColor = [UIColor purpleColor];
    TYZCustomNavController *restaurantListNav = [[TYZCustomNavController alloc] initWithRootViewController:restaurantVC];
    [self addChildViewController:restaurantListNav withTitle:NSLocalizedString(@"RestaurantListTitle", nil) imageName:@"tab_btn_restaurant_nor" selectedImageName:@"tab_btn_restaurant_sel"];
    self.restaurantListNav = restaurantListNav;
    
    // 财务tab_btn_finance_nor
    MyFinanceViewController *myFinanceVC = [[MyFinanceViewController alloc] initWithNibName:nil bundle:nil];
    TYZCustomNavController *myFinanceNav = [[TYZCustomNavController alloc] initWithRootViewController:myFinanceVC];
    [self addChildViewController:myFinanceNav withTitle:NSLocalizedString(@"MyFinanceTitle", nil) imageName:@"tab_btn_finance_nor" selectedImageName:@"tab_btn_finance_sel"];
    self.myFinanceNav = myFinanceNav;
    
    // 我的
    ViewController *myInfoVC = [[ViewController alloc] initWithNibName:nil bundle:nil];
        myInfoVC.title = NSLocalizedString(@"MyInfoTitle", nil);
    TYZCustomNavController *myInfoNav = [[TYZCustomNavController alloc] initWithRootViewController:myInfoVC];
    [self addChildViewController:myInfoNav withTitle:NSLocalizedString(@"MyInfoTitle", nil) imageName:@"tab_btn_i_nor" selectedImageName:@"tab_btn_i_sel"];
}

/**
 *  添加一个子控制器
 *
 *  @param viewController    控制器
 *  @param title             标题
 *  @param imageName         图片
 *  @param selectedImageName 选中图片
 */
- (void)addChildViewController:(UIViewController *)viewController withTitle:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    viewController.tabBarItem.title = title;
    viewController.tabBarItem.image = [UIImage imageNamed:imageName];
    UIImage *image = [UIImage imageNamed:selectedImageName];
    //    debugLog(@"image=%@", image);
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.selectedImage = image;
    [self addChildViewController:viewController];
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    NSParameterAssert(color != nil);
    
    CGRect rect = CGRectMake(0, 0, 1, 1);
    // Create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);   // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
    
}

/**
 *  用户切换模式
 *
 *  @param note
 */
//- (void)userChangeMode:(NSNotification *)note
//{
//    _userMode = [[note object] integerValue];
//    debugLog(@"userMode=%d", (int)_userMode);
//    [self setupChildViewController];
//}


/**
 *  是否隐藏下面的视图
 *
 *  @return
 */
- (BOOL)hiddenWithWaitView
{
    BOOL bRet = NO;
    
    NSInteger orderCount = [self.managerOrderNav.viewControllers count];
    NSInteger restCount = [self.restaurantListNav.viewControllers count];
    
    NSInteger financeCount = [self.myFinanceNav.viewControllers count];
    debugLog(@"orderCount=%d; restCount=%d; financeCount=%d;", (int)orderCount, (int)restCount, (int)financeCount);
    if (orderCount > 1 || restCount > 1 || financeCount > 1)
    {
        bRet = YES;
    }
    
    return bRet;
}

@end
