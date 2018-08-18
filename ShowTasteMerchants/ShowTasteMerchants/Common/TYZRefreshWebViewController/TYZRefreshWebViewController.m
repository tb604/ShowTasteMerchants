//
//  TYZRefreshWebViewController.m
//  51tourGuide
//
//  Created by 唐斌 on 16/3/15.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZRefreshWebViewController.h"
#import "MJRefresh.h"

@interface TYZRefreshWebViewController ()

- (void)initWithBaseWebView;

@end

@implementation TYZRefreshWebViewController

- (void)dealloc
{
#if !__has_feature(objc_arc)
    [_baseWebView release], _baseWebView = nil;
    [super dealloc];
#endif
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithBaseWebView];
}

- (void)initWithBaseWebView
{
    static CGFloat statusHeight;
    static CGRect bounds;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bounds = [[UIScreen mainScreen] bounds];
        statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    });
    CGFloat navBarHeight = self.navigationController.navigationBar.bounds.size.height;
    //    NSLog(@"statusHeight=%.2f; navBarHeight=%.2f", statusHeight, navBarHeight);
    CGRect frame = CGRectMake(0.0f, 0.0f, bounds.size.width, bounds.size.height - statusHeight - navBarHeight);
    _baseWebView = [[UIWebView alloc] initWithFrame:frame];
    _baseWebView.backgroundColor = [UIColor lightGrayColor];
    _baseWebView.delegate = self;
    [self.view addSubview:_baseWebView];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(doRefreshData)];
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新中" forState:MJRefreshStateRefreshing];
    self.baseWebView.scrollView.mj_header = header;
}

/** 下拉刷新 */
- (void)doRefreshData
{
    
}

- (void)loadRequest
{
    NSLog(@"url=%@", _url);
    [_baseWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
}

/** 结束所有刷新 */
- (void)endAllRefreshing
{
    [self endHeaderRefreshing];
}

/**
 *  下拉刷新结束
 */
- (void)endHeaderRefreshing
{
    [_baseWebView.scrollView.mj_header endRefreshing];
}

/** 隐藏header */
- (void)hiddenHeaderView:(BOOL)isHidden
{
    [_baseWebView.scrollView.mj_header setHidden:isHidden];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self endAllRefreshing];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self endAllRefreshing];
}

@end









