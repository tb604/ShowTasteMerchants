//
//  TestRefreshWebViewController.m
//  51tourGuide
//
//  Created by 唐斌 on 16/3/15.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TestRefreshWebViewController.h"
#import "TYZKit.h"

@implementation TestRefreshWebViewController

- (void)dealloc
{
    
}

- (void)initWithNavBar
{
    self.title = @"网页下拉刷新";
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self.baseWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.163.com"]]];
}

- (void)doRefreshData
{
    [self.baseWebView reload];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //debugMethod();
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
