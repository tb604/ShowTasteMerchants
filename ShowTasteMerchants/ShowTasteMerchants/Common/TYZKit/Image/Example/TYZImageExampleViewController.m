//
//  TYZImageExampleViewController.m
//  51tourGuide
//
//  Created by 唐斌 on 16/4/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZImageExampleViewController.h"

@interface TYZImageExampleViewController ()

@property (nonatomic, strong) NSMutableArray *titles;

@property (nonatomic, strong) NSMutableArray *classNames;

@end

@implementation TYZImageExampleViewController

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
 
    self.titles = @[].mutableCopy;
    self.classNames = @[].mutableCopy;
    
    [self addCell:@"Animated Image" class:@"TYZImageDisplayExample"];
//    [self addCell:@"Progressive Image" class:@"TYZImageProgressiveExample"];
//    [self addCell:@"Web Image" class:@"TYZWebImageExample"];
    
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    self.title = @"Image";
}

- (void)initWithSubView
{
    [super initWithSubView];
    
}

- (void)addCell:(NSString *)title class:(NSString *)className
{
    [self.titles addObject:title];
    [self.classNames addObject:className];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TYZBaseTableViewCell *cell = [TYZBaseTableViewCell cellForTableView:tableView];
    cell.textLabel.text = _titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *className = self.classNames[indexPath.row];
    Class class = NSClassFromString(className);
    if (class)
    {
        UIViewController *ctrl = class.new;
        ctrl.title = _titles[indexPath.row];
        ctrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    [self.baseTableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end






















