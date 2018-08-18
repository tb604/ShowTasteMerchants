//
//  TestDropDownMenuViewController.m
//  51tourGuide
//
//  Created by 唐斌 on 16/3/16.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TestDropDownMenuViewController.h"
#import "TYZDropDownMenu.h"
#import "TYZKit.h"


@interface TestDropDownMenuViewController () <TYZDropDownMenuDataSource, TYZDropDownMenuDelegate>
@property (nonatomic, strong) NSArray *classifys;
@property (nonatomic, strong) NSArray *cates;
@property (nonatomic, strong) NSArray *movices;
@property (nonatomic, strong) NSArray *hostels;
@property (nonatomic, strong) NSArray *areas;

@property (nonatomic, strong) NSArray *sorts;
@end

@implementation TestDropDownMenuViewController


- (void)initWithNavBar
{
    self.title = @"TestDropDownMenu";
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 数据
    self.classifys = @[@"美食",@"今日新单",@"电影",@"酒店"];
    self.cates = @[@"自助餐",@"快餐",@"火锅",@"日韩料理",@"西餐",@"烧烤小吃"];
    self.movices = @[@"内地剧",@"港台剧",@"英美剧"];
    self.hostels = @[@"经济酒店",@"商务酒店",@"连锁酒店",@"度假酒店",@"公寓酒店"];
    self.areas = @[@"全城",@"芙蓉区",@"雨花区",@"天心区",@"开福区",@"岳麓区"];
    self.sorts = @[@"默认排序",@"离我最近",@"好评优先",@"人气优先",@"最新发布"];
    
    // 添加下拉菜单
    TYZDropDownMenu *menu = [[TYZDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:44];
    menu.indicatorColor = [UIColor redColor];
    menu.textColor = [UIColor purpleColor];//[UIColor colorWithHexString:@"#8d8d8d"];
    menu.textSelectedColor = [UIColor orangeColor];//[UIColor colorWithHexString:@"#00bcfc"];
    menu.separatorColor = [UIColor blueColor];//[UIColor colorWithHexString:@"#b3b3b3"];
    menu.delegate = self;
    menu.dataSource = self;
    [self.view addSubview:menu];
}

#pragma mark TYZDropDownMenuDataSource
- (NSInteger)numberOfColumnsInMenu:(TYZDropDownMenu *)menu
{
    return 4;
}

- (NSInteger)menu:(TYZDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    if (column == 0)
    {
        return [self.classifys count];
    }
    else if (column == 1)
    {
        return [self.areas count];
    }
    else if (column == 2)
    {
        return [self.sorts count];
    }
    else if (column == 3)
    {
        return [self.movices count];
    }
    return 0;
}

- (BOOL)displayByCollectionViewInColumn:(NSInteger)column
{
    if (column == 2)
    {
        return YES;
    }
    return NO;
}

- (NSString *)menu:(TYZDropDownMenu *)menu titleForRowAtIndexPath:(TYZDropDownMenuIndexPath *)indexPath
{
    if (indexPath.column == 0)
    {
        return self.classifys[indexPath.row];
    }
    else if (indexPath.column == 1)
    {
        return self.areas[indexPath.row];
    }
    else if (indexPath.column == 2)
    {
        return self.sorts[indexPath.row];
    }
    else
    {
        return self.movices[indexPath.row];
    }
}

- (NSInteger)menu:(TYZDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column
{
    if (column == 0)
    {
        if (row == 0)
        {
            return self.cates.count;
        }
        else if (row == 2)
        {
            return [self.movices count];
        }
        else if (row == 3)
        {
            return [self.hostels count];
        }
    }
    return 0;
}

- (NSString *)menu:(TYZDropDownMenu *)menu titleForItemsInRowAtIndexPath:(TYZDropDownMenuIndexPath *)indexPath
{
    if (indexPath.column == 0)
    {
        if (indexPath.row == 0)
        {
            return self.cates[indexPath.item];
        }
        else if (indexPath.row == 2)
        {
            return self.movices[indexPath.item];
        }
        else if (indexPath.row == 3)
        {
            return self.hostels[indexPath.item];
        }
    }
    return nil;
}

- (void)menu:(TYZDropDownMenu *)menu didSelectRowAtIndexPath:(TYZDropDownMenuIndexPath *)indexPath
{
    if (indexPath.item >= 0)
    {
        NSLog(@"点击了 %ld - %ld - %ld 项目", (long)indexPath.column, (long)indexPath.row, (long)indexPath.item);
    }
    else
    {
        NSLog(@"点击了 %ld - %ld 项目", (long)indexPath.column, (long)indexPath.row);
    }
}

@end



























