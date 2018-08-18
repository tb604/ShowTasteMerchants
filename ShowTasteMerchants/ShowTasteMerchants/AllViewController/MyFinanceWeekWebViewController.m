/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: MyFinanceWeekWebViewController.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/31 13:59
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "MyFinanceWeekWebViewController.h"
#import "LocalCommon.h"

@interface MyFinanceWeekWebViewController ()
{
    BOOL _isLoadSuccess;
}
@end

@implementation MyFinanceWeekWebViewController

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

- (void)initWithSubView
{
    [super initWithSubView];
    
    //AppDelegate *app = [UtilityObject appDelegate];
    
    //CGRect frame = self.baseWebView.frame;
    //frame.size.height = frame.size.height - [app tabBarHeight] + STATUSBAR_HEIGHT;
    //self.baseWebView.frame = frame;
//    [SVProgressHUD showWithStatus:@"加载中"];
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
