//
//  MyFinanceTodayAggregateViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/20.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyFinanceTodayAggregateViewController.h"
#import "LocalCommon.h"
#import "UserLoginStateObject.h"

@interface MyFinanceTodayAggregateViewController ()
{
    BOOL _isLoadSuccess;
}
@end

@implementation MyFinanceTodayAggregateViewController

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
    
    //http://182.254.132.142:8082/order-report/day-summary?shop_id=1&date=20160912
    
    NSString *strDate = [_date stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if (kIsProductioinEnvironment == 1)
    {// 生产环境
        self.url = [NSString stringWithFormat:@"%@order-report/day-summary?shop_id=%d&date=%@", H5ROOTURL, (int)[UserLoginStateObject getCurrentShopId], strDate];
    }
    else
    {// 测试环境
//        NSString *path = [REQUESTBASICURL substringToIndex:[REQUESTBASICURL length]-1];
        self.url = [NSString stringWithFormat:@"%@order-report/day-summary?shop_id=%d&date=%@", H5ROOTURL, (int)[UserLoginStateObject getCurrentShopId], strDate];
    }
    debugLog(@"url=%@", self.url);
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = @"日汇总";
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
