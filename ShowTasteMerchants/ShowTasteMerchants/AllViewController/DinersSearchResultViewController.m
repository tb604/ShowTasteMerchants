//
//  DinersSearchResultViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/8.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DinersSearchResultViewController.h"
#import "LocalCommon.h"
#import "TYZDropDownMenu.h"
#import "ShopListDataEntity.h"
#import "DinersSearchResultViewCell.h"

@interface DinersSearchResultViewController () <TYZDropDownMenuDataSource, TYZDropDownMenuDelegate>
/**
 *  菜系
 */
@property (nonatomic, strong) NSMutableArray *cuisineList;


- (void)getWithSearchData;

@end

@implementation DinersSearchResultViewController



- (void)initWithVar
{
    [super initWithVar];
    
//    [self.baseList addObject:@"1"];
//    [self.baseList addObject:@"1"];
//    [self.baseList addObject:@"1"];
//    [self.baseList addObject:@"1"];
//    [self.baseList addObject:@"1"];
//    [self.baseList addObject:@"1"];
//    [self.baseList addObject:@"1"];
//    [self.baseList addObject:@"1"];
//    [self.baseList addObject:@"1"];
//    [self.baseList addObject:@"1"];
//    [self.baseList addObject:@"1"];
//    [self.baseList addObject:@"1"];
//    [self.baseList addObject:@"1"];
//    [self.baseList addObject:@"1"];
//    [self.baseList addObject:@"1"];
//    [self.baseList addObject:@"1"];
    
    _cuisineList = [NSMutableArray new];
    [_cuisineList addObject:_cuisineEntity.chuantong.title];
    [_cuisineList addObject:_cuisineEntity.tese.title];
    [_cuisineList addObject:_cuisineEntity.guoji.title];
    
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = _searchInputEntity.key;
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithMenu];
    
//    [self hiddenFooterView:YES];
//    [self hiddenHeaderView:YES];
    
    AppDelegate *app = [UtilityObject appDelegate];
    CGRect frame = CGRectMake(0, 44, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight] - STATUSBAR_HEIGHT - [app navBarHeight] * 2);
    self.baseTableView.frame = frame;
    
    [self doRefreshData];
    
}

- (void)initWithMenu
{
    // 添加下拉菜单
    TYZDropDownMenu *menu = [[TYZDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:44];
    menu.indicatorColor = [UIColor colorWithHexString:@"#737272"];
    menu.textColor = [UIColor colorWithHexString:@"#999999"];
    menu.textSelectedColor = [UIColor colorWithHexString:@"#ff5500"];
    menu.separatorColor = [UIColor colorWithHexString:@"#e0e0e0"];
    menu.delegate = self;
    menu.dataSource = self;
    [self.view addSubview:menu];
}

- (void)doRefreshData
{
    [super doRefreshData];
    
    [self getWithSearchData];
    
}

- (void)doMoreRefreshData
{
    [super doMoreRefreshData];
    
    [self getWithSearchData];
}

- (void)getWithSearchData
{
    _searchInputEntity.key = @"";
    [HCSNetHttp requestWithSearch:_searchInputEntity completion:^(id result) {
        [self responseWithSearch:result];
    }];
}

- (void)responseWithSearch:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success)
    {
        [SVProgressHUD dismiss];
        if (self.pageId == 1)
        {
            [self.baseList removeAllObjects];
        }
        [self.baseList addObjectsFromArray:respond.data];
        self.pageId += 1;
        [self.baseTableView reloadData];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
        if (self.pageId == 1)
        {
            [self.baseList removeAllObjects];
            [self.baseTableView reloadData];
        }
    }
    
    [self endAllRefreshing];
}



#pragma mark TYZDropDownMenuDataSource
- (NSInteger)numberOfColumnsInMenu:(TYZDropDownMenu *)menu
{// 两列
    return 2;
}

- (NSInteger)menu:(TYZDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    if (column == 0)
    {// 第一列菜系方面
        return [self.cuisineList count];
    }
    else if (column == 1)
    {// 商圈上面
        return [self.mallList count];
    }
    return 0;

}

- (BOOL)displayByCollectionViewInColumn:(NSInteger)column
{
//    debugLog(@"colon=%d", (int)column);
//    if (column == 2)
//    {
//        return YES;
//    }
    return NO;
}

- (NSString *)menu:(TYZDropDownMenu *)menu titleForRowAtIndexPath:(TYZDropDownMenuIndexPath *)indexPath
{
    if (indexPath.column == 0)
    {// 第一列菜系方面
        return self.cuisineList[indexPath.row];
    }
    else if (indexPath.column == 1)
    {// 商圈
        MallDataEntity *mallEnt = _mallList[indexPath.row];
        return mallEnt.name;
    }
    return nil;
}

- (NSInteger)menu:(TYZDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column
{
    if (column == 0)
    {// 菜系
        if (row == 0)
        {// 传统菜系
            return [_cuisineEntity.chuantong.content count];
        }
        else if (row == 1)
        {// 特色菜系
            return [_cuisineEntity.tese.content count];
        }
        else if (row == 2)
        {// 国际菜系
            return [_cuisineEntity.guoji.content count];
        }
    }
    else if (column == 1)
    {// 商圈
        MallDataEntity *mallEnt = _mallList[row];
        return [mallEnt.malls count];
    }
    return 0;
}

- (NSString *)menu:(TYZDropDownMenu *)menu titleForItemsInRowAtIndexPath:(TYZDropDownMenuIndexPath *)indexPath
{
    if (indexPath.column == 0)
    {// 菜系
        if (indexPath.row == 0)
        {// 传统菜系
            // CuisineContentDataEntity
            CuisineContentDataEntity *ent = _cuisineEntity.chuantong.content[indexPath.item];
            return ent.name;
        }
        else if (indexPath.row == 1)
        {// 特色菜系
            CuisineContentDataEntity *ent = _cuisineEntity.tese.content[indexPath.item];
            return ent.name;
        }
        else if (indexPath.row == 2)
        {// 国际菜系
            CuisineContentDataEntity *ent = _cuisineEntity.guoji.content[indexPath.item];
            return ent.name;
        }
    }
    else if (indexPath.column == 1)
    {// 商圈MallListDataEntity
        MallDataEntity *mallEnt = _mallList[indexPath.row];
        MallListDataEntity *mallListEnt = mallEnt.malls[indexPath.item];
        return mallListEnt.name;
    }
    return nil;
}

- (void)menu:(TYZDropDownMenu *)menu didSelectRowAtIndexPath:(TYZDropDownMenuIndexPath *)indexPath
{
    // 0:出行时间最早，9:人均价格最低,1:1日游，2:2日游，3:3日游
//        [self doRefreshData];
    if (indexPath.item >= 0)
    {
        NSLog(@"点击了 %d - %d - %d 项目",(int)indexPath.column, (int)indexPath.row, (int)indexPath.item);
        if (indexPath.column == 0)
        {// 菜系
            if (indexPath.row == 0)
            {// 传统
//                CuisineContentDataEntity *cuisineEnt = _cuisineEntity.chuantong.content[indexPath.item];
                
            }
            else if (indexPath.row == 1)
            {// 特色
//                CuisineContentDataEntity *cuisineEnt = _cuisineEntity.tese.content[indexPath.item];
                
            }
            else if (indexPath.row == 2)
            {// 国际
//                CuisineContentDataEntity *cuisineEnt = _cuisineEntity.guoji.content[indexPath.item];
                
            }
        }
        else if (indexPath.column == 1)
        {// 商圈
            MallDataEntity *mallEnt = _mallList[indexPath.row];
            MallListDataEntity *mallListEnt = mallEnt.malls[indexPath.item];
            _searchInputEntity.mall_id = mallListEnt.id;
        }
    }
    else
    {
        NSLog(@"点击了 %d - %d 项目", (int)indexPath.column, (int)indexPath.row);
    }
}






- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.baseList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DinersSearchResultViewCell *cell = [DinersSearchResultViewCell cellForTableView:tableView];
    
    [cell updateCellData:self.baseList[indexPath.section]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kDinersSearchResultViewCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.001;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

@end
