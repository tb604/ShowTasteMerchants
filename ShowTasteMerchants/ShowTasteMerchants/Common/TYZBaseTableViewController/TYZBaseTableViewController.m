//
//  TYZBaseTableViewController.m
//  51tourGuide
//
//  Created by 唐斌 on 16/3/14.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewController.h"

@interface TYZBaseTableViewController ()
/**
 *  tableview类型 UITableViewStylePlain
 */
@property (nonatomic, assign) BOOL isStyle;
@end

@implementation TYZBaseTableViewController

- (void)dealloc
{
    _baseTableView.delegate = nil;
    _baseTableView.dataSource = nil;
#if !__has_feature(objc_arc)
    [_baseTableView release], _baseTableView = nil;
    [_baseList release], _baseList = nil;
    [super dealloc];
#endif
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil isStylePlain:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil isStylePlain:(BOOL)isStylePlain
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _isStyle = isStylePlain;
    }
    return self;
}

#pragma mark start override
- (void)initWithVar
{
    [super initWithVar];
    
    _baseList = [[NSMutableArray alloc] initWithCapacity:0];
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithBaseTableView];
    
    [self initWithHeaderView];
    
    [self initWithFooterView];
}
#pragma mark end override

#pragma mark start public methods
#pragma mark start init define
- (void)initWithBaseTableView
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
    if (_isStyle)
    {
        _baseTableView = [[TYZBaseTableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    }
    else
    {
        _baseTableView = [[TYZBaseTableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    }
//    _baseTableView.
    
    _baseTableView.delegate = self;
    _baseTableView.dataSource = self;
    [self.view addSubview:_baseTableView];
//    _baseTableView.backgroundColor = [UIColor orangeColor];
}

- (void)initWithHeaderView
{
    
}

- (void)initWithFooterView
{
    
}

#pragma mark end init define

- (NSInteger)getBaseListCount
{
    return [self.baseList count];
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
    return _baseList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TYZBaseTableViewCell *cell = [TYZBaseTableViewCell cellForTableView:tableView];
    return cell;
}
#pragma mark end UITableViewDataSource, UITableViewDelegate
#pragma mark end delegate


@end




























