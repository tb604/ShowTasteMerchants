//
//  TestRefreshViewController.m
//  51tourGuide
//
//  Created by 唐斌 on 16/3/15.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TestRefreshViewController.h"
#import "TYZKit.h"

@implementation TestRefreshViewController

- (void)dealloc
{
    debugMethod();
}

- (void)doRefreshData
{
    [super doRefreshData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reloadData];
    });
    
}

- (void)doMoreRefreshData
{
    [super doMoreRefreshData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reloadData];
    });

}

- (void)reloadData
{
    [self.baseList addObject:@"1"];
    [self.baseList addObject:@"1"];
    [self.baseList addObject:@"1"];
    [self.baseList addObject:@"1"];
    [self.baseList addObject:@"1"];
    [self.baseList addObject:@"1"];
    [self.baseList addObject:@"1"];
    [self.baseList addObject:@"1"];
    [self endAllRefreshing];
    [self.baseTableView reloadData];
}

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
    cell.textLabel.text = self.baseList[indexPath.row];
    return cell;
}

@end
