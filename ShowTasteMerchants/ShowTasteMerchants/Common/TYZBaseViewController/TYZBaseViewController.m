//
//  TYZBaseViewController.m
//  51tourGuide
//
//  Created by 唐斌 on 16/3/14.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseViewController.h"
#import "TYZRespondDataEntity.h"

@interface TYZBaseViewController ()

@property (nonatomic, strong) UIButton *btnBack;

@end

@implementation TYZBaseViewController

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
#if !__has_feature(objc_arc)
    [_popResultBlock release], _popResultBlock = nil;
    [super dealloc];
#endif
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
//    NSLog(@"%s", __func__);
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
//    NSLog(@"%s", __func__);
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)])
    {
        // 简单点说就是automaticallyAdjustsScrollViewInsets根据按所在界面的status bar，navigationbar，与tabbar的高度，自动调整scrollview的 inset,设置为no，不让viewController调整，我们自己修改布局即可~
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    self.view.backgroundColor = [UIColor colorWithRed:242.0f/255 green:244.0f/255 blue:245.0f/255 alpha:1];
//    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initWithVar];
    
    [self initWithNavBar];
    
    [self initWithSubView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 *  初始化变量
 */
- (void)initWithVar
{
//    NSLog(@"%s", __func__);
}

/**
 *  初始化navbar视图
 */
- (void)initWithNavBar
{
//    NSLog(@"%s", __func__);
}

/**
 *  初始化子视图
 */
- (void)initWithSubView
{
//    NSLog(@"%s", __func__);
}

/**
 *  初始化返回按钮
 */
- (void)initWithBackButton
{
    if (!_btnBack)
    {
        UIImage *image = [UIImage imageNamed:@"nav_btn_back_nor"];
        UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
        btnBack.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        [btnBack setImage:image forState:UIControlStateNormal];
//        [btnBack setImage:[UIImage imageNamed:@"nav_btn_back_sel"] forState:UIControlStateSelected];
//        [btnBack setImage:[UIImage imageNamed:@"nav_btn_back_sel"] forState:UIControlStateHighlighted];
        [btnBack addTarget:self action:@selector(clickedBack:) forControlEvents:UIControlEventTouchUpInside];
        self.btnBack = btnBack;
    }
    UIBarButtonItem *itemBack = [[UIBarButtonItem alloc] initWithCustomView:_btnBack];
    self.navigationItem.leftBarButtonItem = itemBack;
    //    NSLog(@"frame=%@", NSStringFromCGRect(itemBack.customView.frame));
//#if !__has_feature(objc_arc)
//    [itemBack release], itemBack = nil;
//#endif
}

- (void)updateWithBackImage:(NSString *)imageName
{
    [_btnBack setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void)dataParse:(TYZRespondDataEntity *)respond
{
    
}

/**
 *  从服务端请求数据
 */
- (void)fromServerRequestData
{
    
}

/**
 *  返回按钮函数
 *
 *  @param sender 传进来的参数
 */
- (void)clickedBack:(id)sender
{
    if (self.presentingViewController)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
