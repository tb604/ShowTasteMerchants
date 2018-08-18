//
//  TestSwipeTableViewController.m
//  51tourGuide
//
//  Created by 唐斌 on 16/3/17.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TestSwipeTableViewController.h"
#import "TYZSwipeTableViewCell.h"
#import "TYZKit.h"

@implementation TestSwipeTableViewController

- (void)dealloc
{
    debugMethod();
}

- (void)initWithVar
{
    [super initWithVar];
    for (int i=0; i<20; i++)
    {
        [self.baseList addObject:@(i)];
    }
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    self.title = @"向右滑动cell，显示按钮";
}

- (void)initWithSubView
{
    [super initWithSubView];
    self.view.backgroundColor = [UIColor whiteColor];
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
    NSString *cellID = NSStringFromClass([TYZSwipeTableViewCell class]);
    TYZSwipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 55)];
        btn1.backgroundColor = [UIColor redColor];
        [btn1 setTitle:@"delete" forState:UIControlStateNormal];
        UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 55)];
        btn2.backgroundColor = [UIColor greenColor];
        [btn2 setTitle:@"add" forState:UIControlStateNormal];
        NSArray *btnArr = [[NSMutableArray alloc]initWithObjects:btn1,btn2, nil];
        cell = [[TYZSwipeTableViewCell alloc] initWithTableView:tableView reseIdentifier:cellID tableViewCellStyle:UITableViewCellStyleDefault btnList:btnArr indexPath:indexPath];
    }
    [cell updateCellData:@(indexPath.row)];
    /*cell.cellOptionBtnWillShowBlock = ^()
    {
        debugLog(@"将要显示");
    };
    cell.cellOptionBtnDidShowBlock = ^()
    {
        debugLog(@"完全显示");
    };
    cell.cellOptionBtnWillHiddenBlock = ^()
    {
        debugLog(@"将要隐藏");
    };
    cell.cellOptionBtnDidHiddenBlock = ^()
    {
        debugLog(@"完全隐藏");
    };*/
    cell.swipCellDidSelectedBtnTagBlock = ^(NSInteger tag, NSIndexPath *indexPath)
    {
        debugLog(@"点击按钮tag=%d; row=%d", (int)tag, (int)indexPath.row);
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    debugMethod();
    NSIndexPath *selected = [tableView indexPathForSelectedRow];
    if(selected)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

@end






















