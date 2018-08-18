//
//  MyRestaurantMouthArchiveFoodView.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/5.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantMouthArchiveFoodView.h"
#import "LocalCommon.h"
#import "TYZBaseTableViewCell.h"
#import "MyRestaurantMouthArchiveFoodCell.h"
#import "ShopMouthDataEntity.h"

@interface MyRestaurantMouthArchiveFoodView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *archiveList;
@property (nonatomic, strong) UITableView *archiveTableView;

@property (nonatomic, strong) ShopMouthDataEntity *mouthEntity;

- (void)initWithArchiveTableView;

@end

@implementation MyRestaurantMouthArchiveFoodView

- (void)initWithVar
{
    [super initWithVar];
    
    _archiveList = [NSMutableArray new];
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    
    [self initWithArchiveTableView];
}

- (void)initWithArchiveTableView
{
    CGRect frame = self.bounds;
    _archiveTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _archiveTableView.dataSource = self;
    _archiveTableView.delegate = self;
    _archiveTableView.showsVerticalScrollIndicator = NO;
    _archiveTableView.showsHorizontalScrollIndicator = NO;
    _archiveTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_archiveTableView];
}

- (void)updateViewData:(id)entity
{
    self.mouthEntity = entity;
    [_archiveList removeAllObjects];
    [_archiveList addObjectsFromArray:_mouthEntity.foods];
    [_archiveTableView reloadData];
}

- (void)addWithFood:(id)entity
{
    [_archiveList insertObject:entity atIndex:0];
    _mouthEntity.foods = _archiveList;
    [_archiveTableView reloadData];
    
    if (self.refreshMouthBlock)
    {
        self.refreshMouthBlock(_mouthEntity);
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_archiveList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyRestaurantMouthArchiveFoodCell *cell = [MyRestaurantMouthArchiveFoodCell cellForTableView:tableView];
    [cell updateCellData:_archiveList[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ShopFoodDataEntity *foodEnt = _archiveList[indexPath.row];
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(foodEnt);
    }
    [_archiveList removeObjectAtIndex:indexPath.row];
    _mouthEntity.foods = _archiveList;
    
    [_archiveTableView reloadData];
    
    if (self.refreshMouthBlock)
    {
        self.refreshMouthBlock(_mouthEntity);
    }
}

@end















