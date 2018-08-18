//
//  MallSelectInfoView.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/23.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MallSelectInfoView.h"
#import "LocalCommon.h"
//#import "MallEditTableViewCell.h"
#import "MallSelectedTableViewCell.h"
#import "MallListDataEntity.h"

@interface MallSelectInfoView () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
}

@property (nonatomic, strong) NSIndexPath *selectIndexPath;

@property (nonatomic, strong) NSArray *mallList;

@property (nonatomic, strong) MallListDataEntity *mallEntity;

- (void)initWithTableView;

@end

@implementation MallSelectInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithVar
{
    [super initWithVar];
    
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithTableView];
}

- (void)initWithTableView
{
    CGRect frame = self.bounds;
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
}

- (void)updateViewData:(id)entity
{
    self.mallList = entity;
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
//    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    [_tableView reloadData];
    
}

#pragma mark start <UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mallList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MallSelectedTableViewCell *cell = [MallSelectedTableViewCell cellForTableView:tableView];
    [cell updateCellData:_mallList[indexPath.row]];
    [cell updateWithTitleColor:[UIColor colorWithHexString:@"#323232"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kMallSelectedTableViewCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.mallEntity = _mallList[indexPath.row];
    NSInteger newRow = [indexPath row];
    NSInteger oldRow = (_selectIndexPath?_selectIndexPath.row:-1);
    if (newRow != oldRow)
    {
        MallSelectedTableViewCell *newCell = (MallSelectedTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//        newCell.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
//        newCell.contentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [newCell updateWithTitleColor:[UIColor colorWithHexString:@"#fd5800"]];
        
        MallSelectedTableViewCell *oldCell = nil;
        if (_selectIndexPath)
        {
            oldCell = (MallSelectedTableViewCell *)[tableView cellForRowAtIndexPath:_selectIndexPath];
        }
        
//        oldCell.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
//        oldCell.contentView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
        [oldCell updateWithTitleColor:[UIColor colorWithHexString:@"#323232"]];
        self.selectIndexPath = indexPath;
    }
    else
    {
        //        debugLog(@"else");
        MallSelectedTableViewCell *newCell = (MallSelectedTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        [newCell updateWithTitleColor:[UIColor colorWithHexString:@"#fd5800"]];
//        newCell.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
//        newCell.contentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    }
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(_mallEntity);
    }
}


@end
