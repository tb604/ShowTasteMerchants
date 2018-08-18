//
//  TYZCustomTabBarController.m
//  TYZCustomTabBarController_1
//
//  Created by 唐斌 on 16/3/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZCustomTabBarController.h"
//#import "LocalCommon.h"
#import "TYZTabBar.h"
#import "ViewController.h"
#import "TYZCustomNavController.h"
#import "TYZKit.h"
//#import "KitchenCircleViewController.h" // 圈子视图控制器
//#import "UserOrderViewController.h" // 订单视图控制器
#import "MyInfoViewController.h" // 我的视图控制器
#import "ManagerModeOrderViewController.h" // 经营模式的订单视图控制器
#import "UserLoginStateObject.h"


@interface TYZCustomTabBarController ()
{
    BOOL _isShowMiddleBulgeBtn;
}

/**
 *  普通模式的订单
 */
@property (nonatomic, strong) TYZCustomNavController *orderMealNav;
//@property (nonatomic, strong) UINavigationController *orderMealNav;

/**
 *  普通模式圈子
 */
@property (nonatomic, strong) TYZCustomNavController *kitCircleNav;
//@property (nonatomic, strong) KitchenCircleViewController *kitCircleVC;

/**
 *  普通模式订单
 */
@property (nonatomic, strong) TYZCustomNavController *orderNav;

/**
 *  我的
 */
@property (nonatomic, strong) TYZCustomNavController *myInfoNav;

@end

@implementation TYZCustomTabBarController

- (void)dealloc
{
//    NSLog(@"%s", __func__);
    
}


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
    [self setupTabBar];
    
    [[UITabBar appearance] setBackgroundImage:[self imageWithColor:[UIColor whiteColor]]];
    
    // 去除TabBar自带的顶部阴影
//    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    // 标题的颜色
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    // 标题的font
//    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:19], NSFontAttributeName, nil]];
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

- (void)updateWithNavType:(NSInteger)type
{
    debugLog(@"type=%d", (int)type);
    if (type == 1)
    {
        debugLog(@"这是");
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];
        //    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHexString:@"#00bbfc"]];
        // 去除自带的顶部阴影
        [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
        // 设置导航栏控制器颜色
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#ffffff"]] forBarMetrics:UIBarMetricsDefault];
        //    debugLog(@"translucent=%d", [UINavigationBar appearance].translucent);
        if ([[UINavigationBar appearance] respondsToSelector:@selector(setTranslucent:)])
        {
            [[UINavigationBar appearance] setTranslucent:NO];
        }
    }
    else
    {
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];
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
    }
}

#pragma mark - private methods
/**
 *  利用KVC把系统的tabBar类型改为自定义的类型
 */
- (void)setupTabBar
{
    [self setValue:[[TYZTabBar alloc] initWithShowMiddleBtn:_isShowMiddleBulgeBtn] forKey:@"tabBar"];
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
    // 订餐
    if (!_orderMealNav)
    {
        ViewController *orderMealVC = [[ViewController alloc] initWithNibName:nil bundle:nil];
//        OrderMealViewController *orderMealVC = [[OrderMealViewController alloc] initWithNibName:nil bundle:nil isStylePlain:YES firstShowRefresh:NO];
        _orderMealNav = [[TYZCustomNavController alloc] initWithRootViewController:orderMealVC];
    }
    [self addChildViewController:_orderMealNav withTitle:NSLocalizedString(@"OrderMealTitle", nil) imageName:@"tab_btn_ordering_nor" selectedImageName:@"tab_btn_ordering_sel"];
    self.appNavBarHeight = _orderMealNav.navigationBar.bounds.size.height;
    
    
    // 圈子
    if (!_kitCircleNav)
    {
        ViewController *kitCircleVC = [[ViewController alloc] initWithNibName:nil bundle:nil];
//        KitchenCircleViewController *kitCircleVC = [[KitchenCircleViewController alloc] initWithNibName:nil bundle:nil];
        _kitCircleNav = [[TYZCustomNavController alloc] initWithRootViewController:kitCircleVC];
//        self.kitCircleVC = kitCircleVC;
    }
    [self addChildViewController:_kitCircleNav withTitle:NSLocalizedString(@"KitchenCircleTitle", nil) imageName:@"tab_btn_circle_nor" selectedImageName:@"tab_btn_circle_sel"];
    
    // 订单
    if (!_orderNav)
    {
        ViewController *orderVC = [[ViewController alloc] initWithNibName:nil bundle:nil];
//        UserOrderViewController *orderVC = [[UserOrderViewController alloc] initWithNibName:nil bundle:nil];
        _orderNav = [[TYZCustomNavController alloc] initWithRootViewController:orderVC];
    }
    [self addChildViewController:_orderNav withTitle:NSLocalizedString(@"UserOrderTitle", nil) imageName:@"tab_btn_order_nor" selectedImageName:@"tab_btn_order_sel"];
    
    // 我的
    if (!_myInfoNav)
    {
//        ViewController *myInfoVC = [[ViewController alloc] initWithNibName:nil bundle:nil];
        ViewController *myInfoVC = [[ViewController alloc] initWithNibName:nil bundle:nil];
        myInfoVC.title = NSLocalizedString(@"MyInfoTitle", nil);
        _myInfoNav = [[TYZCustomNavController alloc] initWithRootViewController:myInfoVC];
    }
    [self addChildViewController:_myInfoNav withTitle:NSLocalizedString(@"MyInfoTitle", nil) imageName:@"tab_btn_i_nor" selectedImageName:@"tab_btn_i_sel"];
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

@end




























