//
//  PromotionEarningViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/20.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "PromotionEarningViewController.h"
#import "LocalCommon.h"
#import "UserLoginStateObject.h"

/// 推广收益视图控制器
@interface PromotionEarningViewController ()
{
    BOOL _isLoadSuccess;
}
@end

@implementation PromotionEarningViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    self.navigationController.navigationBarHidden = NO;
    
    
}

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
    
    _isLoadSuccess = NO;
    
    if (kIsProductioinEnvironment == 1)
    {// 生产环境
        self.url = [NSString stringWithFormat:@"%@income/index?user_id=%d", H5ROOTURL, (int)[UserLoginStateObject getUserId]];
    }
    else
    {// 测试环境
//        NSString *path = [REQUESTBASICURL substringToIndex:[REQUESTBASICURL length]-1];
        // http://182.254.132.142:8082/income/index?user_id=10001
        self.url = [NSString stringWithFormat:@"%@income/index?user_id=%d", H5ROOTURL, (int)[UserLoginStateObject getUserId]];
    }
    
    debugLog(@"url=%@", self.url);
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    self.title = @"推广收益";
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    //AppDelegate *app = [UtilityObject appDelegate];
    
    //CGRect frame = self.baseWebView.frame;
    //frame.size.height = frame.size.height - [app tabBarHeight] + STATUSBAR_HEIGHT;
    //self.baseWebView.frame = frame;
    [SVProgressHUD showWithStatus:@"加载中"];
    [self doRefreshData];
    
}

- (void)doRefreshData
{
    [super doRefreshData];
    
    [self loadRequest];
}

- (void)loadRequest
{
    if (_isLoadSuccess)
    {
        [self.baseWebView reload];
    }
    else
    {
        [super loadRequest];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [super webViewDidFinishLoad:webView];
    
    _isLoadSuccess = YES;
    
    [SVProgressHUD dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [super webView:webView didFailLoadWithError:error];
    [SVProgressHUD showErrorWithStatus:@"加载失败"];
}


@end
