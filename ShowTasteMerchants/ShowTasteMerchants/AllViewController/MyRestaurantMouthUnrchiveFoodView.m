//
//  MyRestaurantMouthUnrchiveFoodView.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/5.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantMouthUnrchiveFoodView.h"
#import "LocalCommon.h"
#import "TYZBaseTableViewCell.h"
#import "MyRestaurantMouthUnarchiveFoodCell.h"

@interface MyRestaurantMouthUnrchiveFoodView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *unarchiveList;
@property (nonatomic, strong) UITableView *unarchiveTableView;

- (void)initWithUnarchiveTableView;

@end

@implementation MyRestaurantMouthUnrchiveFoodView

- (void)initWithVar
{
    [super initWithVar];
    
    _unarchiveList = [NSMutableArray new];
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    
    [self initWithUnarchiveTableView];
}

- (void)initWithUnarchiveTableView
{
    CGRect frame = self.bounds;
    _unarchiveTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _unarchiveTableView.dataSource = self;
    _unarchiveTableView.delegate = self;
    _unarchiveTableView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    _unarchiveTableView.showsVerticalScrollIndicator = NO;
    _unarchiveTableView.showsHorizontalScrollIndicator = NO;
    _unarchiveTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_unarchiveTableView];
}

- (void)updateViewData:(id)entity
{
    if ([_unarchiveList count] >0)
    {
        return;
    }
    [_unarchiveList removeAllObjects];
    [_unarchiveList addObjectsFromArray:entity];
    [_unarchiveTableView reloadData];
}

- (void)addWithFood:(id)entity
{
    [_unarchiveList insertObject:entity atIndex:0];
    [_unarchiveTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_unarchiveList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyRestaurantMouthUnarchiveFoodCell *cell = [MyRestaurantMouthUnarchiveFoodCell cellForTableView:tableView];
    [cell updateCellData:_unarchiveList[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(_unarchiveList[indexPath.row]);
    }
    [_unarchiveList removeObjectAtIndex:indexPath.row];
    
    [_unarchiveTableView reloadData];
}

@end
















