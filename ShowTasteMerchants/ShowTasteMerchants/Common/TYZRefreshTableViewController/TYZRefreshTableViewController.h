//
//  TYZRefreshTableViewController.h
//  51tourGuide
//
//  Created by 唐斌 on 16/3/15.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewController.h"

@interface TYZRefreshTableViewController : TYZBaseTableViewController
/** 页码,默认是1 */
@property (nonatomic, assign) int pageId;

/** 是否正在加载数据 默认为NO */
@property (nonatomic, assign) BOOL isRefreshing;

/** 是否所有数据读取完毕 默认为NO */
@property (nonatomic, assign) BOOL isAllFinished;
/**
 *  是“下啦”还是“上啦”，YES表示“下啦”
 */
@property (nonatomic, assign) BOOL isHeadRefresh;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil isStylePlain:(BOOL)isStylePlain firstShowRefresh:(BOOL)firstShowRefresh;

/** 下拉刷新 */
- (void)doRefreshData;

/** 上拉加载更多数据 */
- (void)doMoreRefreshData;

/** 结束所有刷新 */
- (void)endAllRefreshing;

/**
 *  下拉刷新结束
 */
- (void)endHeaderRefreshing;

/**
 *  上拉刷新结束
 */
- (void)endFooterRefreshing;

/** 隐藏footer */
- (void)hiddenFooterView:(BOOL)isHidden;

/** 隐藏header */
- (void)hiddenHeaderView:(BOOL)isHidden;
@end
