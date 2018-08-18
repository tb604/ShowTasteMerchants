//
//  TYZRefreshWebViewController.h
//  51tourGuide
//
//  Created by 唐斌 on 16/3/15.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface TYZRefreshWebViewController : TYZBaseViewController <UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *baseWebView;

@property (nonatomic, copy) NSString *url;

/** 下拉刷新 */
- (void)doRefreshData;
/** 结束所有刷新 */
- (void)endAllRefreshing;

/**
 *  下拉刷新结束
 */
- (void)endHeaderRefreshing;

/** 隐藏header */
- (void)hiddenHeaderView:(BOOL)isHidden;

- (void)loadRequest;




@end
