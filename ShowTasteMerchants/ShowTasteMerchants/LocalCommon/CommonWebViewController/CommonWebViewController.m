//
//  CommonWebViewController.m
//  51tourGuide
//
//  Created by 唐斌 on 16/4/29.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "CommonWebViewController.h"

@interface CommonWebViewController ()

@end

@implementation CommonWebViewController

- (void)dealloc
{
    
}

- (void)initWithVar
{
    [super initWithVar];
    
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self performSelector:@selector(doRefreshData) withObject:nil afterDelay:2];
}

- (void)doRefreshData
{
    [self loadRequest];
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
