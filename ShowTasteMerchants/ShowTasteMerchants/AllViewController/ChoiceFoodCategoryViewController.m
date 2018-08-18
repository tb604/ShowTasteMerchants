//
//  ChoiceFoodCategoryViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/7.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ChoiceFoodCategoryViewController.h"
#import "LocalCommon.h"
#import "ChoiceFoodCategoryCell.h"
#import "ShopFoodCategoryDataEntity.h"

@interface ChoiceFoodCategoryViewController ()

@property (nonatomic, strong) NSIndexPath *selectIndexPath;

@end

@implementation ChoiceFoodCategoryViewController

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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)initWithVar
{
    [super initWithVar];
    
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = @"菜品类别选择";
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_categoryList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChoiceFoodCategoryCell *cell = [ChoiceFoodCategoryCell cellForTableView:tableView];
    
//    if (!_selectIndexPath && indexPath.row == 0)
    if (_selectIndexPath && indexPath.row == _selectIndexPath.row)
    {
//        self.selectIndexPath = indexPath;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    [cell updateCellData:_categoryList[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kChoiceFoodCategoryCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger newRow = [indexPath row];
    NSInteger oldRow = (_selectIndexPath?_selectIndexPath.row:-1);
    if (newRow != oldRow)
    {
        ChoiceFoodCategoryCell *newCell = (ChoiceFoodCategoryCell *)[tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        ChoiceFoodCategoryCell *oldCell = nil;
        if (_selectIndexPath)
        {
            oldCell = (ChoiceFoodCategoryCell *)[tableView cellForRowAtIndexPath:_selectIndexPath];
        }
        
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        self.selectIndexPath = indexPath;
    }
    else
    {
        TYZBaseTableViewCell *newCell = (TYZBaseTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    ShopFoodCategoryDataEntity *categorEnt = self.categoryList[indexPath.row];
    if (self.popResultBlock)
    {
        self.popResultBlock(categorEnt);
    }
    [self clickedBack:nil];
    
}

@end
