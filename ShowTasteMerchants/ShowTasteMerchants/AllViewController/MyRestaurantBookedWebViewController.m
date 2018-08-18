//
//  MyRestaurantBookedWebViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/2.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantBookedWebViewController.h"
#import "LocalCommon.h"

@interface MyRestaurantBookedWebViewController ()

@end

@implementation MyRestaurantBookedWebViewController

- (void)initWithVar
{
    [super initWithVar];
    
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    AppDelegate *app = [UtilityObject appDelegate];
    
    CGRect frame = self.baseWebView.frame;
    frame.size.height = frame.size.height - [app navBarHeight] - [app tabBarHeight];
    self.baseWebView.frame = frame;
    debugLogFrame(frame);
    
}

- (void)doRefreshData
{
    [super doRefreshData];
    
    [self loadRequest];
    
//    [self endAllRefreshing];
}


@end
