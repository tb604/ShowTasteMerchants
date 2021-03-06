//
//  TYZRefreshTableViewController.m
//  51tourGuide
//
//  Created by 唐斌 on 16/3/15.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZRefreshTableViewController.h"
#import "MJRefresh.h"

@interface TYZRefreshTableViewController ()
/**
 *  是否第一次，进入界面就显示下拉，默认是YES
 */
@property (nonatomic, assign) BOOL isFirstRefresh;
@end

@implementation TYZRefreshTableViewController
- (void)dealloc
{
#if !__has_feature(objc_arc)
//    [self.baseTableView removeHeader];
//    [self.baseTableView removeFooter];
    [super dealloc];
#endif
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil isStylePlain:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil isStylePlain:(BOOL)isStylePlain
{
    return [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil isStylePlain:isStylePlain firstShowRefresh:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil isStylePlain:(BOOL)isStylePlain firstShowRefresh:(BOOL)firstShowRefresh
{
    _isFirstRefresh = firstShowRefresh;
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil isStylePlain:isStylePlain];
    if (self)
    {
        
    }
    return self;
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
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (BOOL)isRefreshing
{
    return (self.baseTableView.mj_header.isRefreshing && self.baseTableView.mj_footer.isRefreshing);
}


#pragma mark start override
- (void)initWithVar
{
    [super initWithVar];
    
    _pageId = 1;
    
    _isRefreshing = NO;
    _isAllFinished = NO;
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
}
#pragma mark end override

#pragma mark start private methods
#pragma mark start init
- (void)initWithBaseTableView
{
    [super initWithBaseTableView];
    
    // 1.下拉刷新(进入刷新状态就会调用self的doRefreshData)
    // dataKey 用于存储刷新事件，可以保证不同的界面拥有不同的刷新时间
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(doRefreshData)];
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新中" forState:MJRefreshStateRefreshing];
//    header.stateLabel.font = [UIFont systemFontOfSize:15];
//    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
//    header.stateLabel.textColor = [UIColor redColor];
    self.baseTableView.mj_header = header;
//    __unsafe_unretained __typeof(self)weakSelf = self;
    
    if (_isFirstRefresh)
    {
//#warning 自动刷新(已进入程序就下拉刷新)
        [self.baseTableView.mj_header beginRefreshing];
    }
    
    // 2.上拉加载更多(进入刷新状态就会调用self的doMoreRefreshData)
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(doMoreRefreshData)];
    [footer setTitle:@"上拉加载更多数据" forState:MJRefreshStateIdle];
    [footer setTitle:@"松开加载更多数据" forState:MJRefreshStatePulling];
    [footer setTitle:@"正在加载中" forState:MJRefreshStateRefreshing];
    self.baseTableView.mj_footer = footer;
}
#pragma mark end init
#pragma mark end private methods

#pragma mark start public methods
/** 下拉刷新 */
- (void)doRefreshData
{
    _isAllFinished = NO;
    _pageId = 1;
    _isHeadRefresh = YES;
}

/** 上拉加载更多数据 */
- (void)doMoreRefreshData
{
    _isHeadRefresh = NO;
    if (self.isAllFinished)
    {// 所有数据都加载完了。就直接停止加载
        [self.baseTableView.mj_footer endRefreshing];
    }
}

/** 结束所有刷新 */
- (void)endAllRefreshing
{
    [self endHeaderRefreshing];
    
    [self endFooterRefreshing];
}

/**
 *  下拉刷新结束
 */
- (void)endHeaderRefreshing
{
    _isRefreshing = NO;
    [self.baseTableView.mj_header endRefreshing];
}

/**
 *  上拉刷新结束
 */
- (void)endFooterRefreshing
{
    _isRefreshing = NO;
    [self.baseTableView.mj_footer endRefreshing];
}

/** 隐藏footer */
- (void)hiddenFooterView:(BOOL)isHidden
{
    [self.baseTableView.mj_footer setHidden:isHidden];
}

/** 隐藏header */
- (void)hiddenHeaderView:(BOOL)isHidden
{
    [self.baseTableView.mj_header setHidden:isHidden];
}
#pragma mark end public methods

#pragma mark start delegate
#pragma mark start UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.baseList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TYZBaseTableViewCell *cell = [TYZBaseTableViewCell cellForTableView:tableView];
    return cell;
}

#pragma mark end UITableViewDataSource, UITableViewDelegate
#pragma mark end delegate
@end
