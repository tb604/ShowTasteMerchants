//
//  DinersSearchResultNewViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/11.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DinersSearchResultNewViewController.h"
#import "LocalCommon.h"
#import "RestaurantClassificationCell.h"
#import "DinersSearchResultTopView.h"
#import "DinersSearchResultNewNearView.h" // 附近
#import "RestaurantClassifiyView.h" // 显示菜系的视图提供选择
#import "MallListDataEntity.h"
#import "OrderMealContentEntity.h"
#import "ShopListDataEntity.h"
#import "UserLoginStateObject.h"
#import "HCSLocationManager.h"
#import "TYZDBManager.h"

@interface DinersSearchResultNewViewController ()
{
    DinersSearchResultTopView *_topView;
    
    /**
     *  附近的搜索视图
     */
    DinersSearchResultNewNearView *_nearSearchView;
    /**
     *  YES表示显示；NO表示不显示
     */
    BOOL _isShowNearView;
    
    /**
     *  菜系视图
     */
    RestaurantClassifiyView *_restaurantClassifiyView;
    
    /**
     *  YES表示显示；NO表示不显示
     */
    BOOL _isShowClassifiyView;

}

- (void)initWithTopView;

/**
 *  显示附近的视图
 *
 *  @param show YES显示，否则NO
 */
- (void)showWithNearSearchView:(BOOL)show;

/**
 *  显示菜系视图
 *
 *  @param show YES显示，否则NO
 */
- (void)showWithRestaurantClassifiyView:(BOOL)show;

- (void)getWithSearchResultData;

@end

@implementation DinersSearchResultNewViewController

- (void)initWithVar
{
    [super initWithVar];
    
    _isShowNearView = YES;
    _isShowClassifiyView = YES;
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithTopView];
    
    self.baseTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], 0)];
    
    [self doRefreshData];
}

- (void)doRefreshData
{
    [super doRefreshData];
    
    CGRect frame = self.baseTableView.frame;
    frame.origin.y = kDinersSearchResultTopViewHeight;
    frame.size.height = frame.size.height - kDinersSearchResultTopViewHeight;
    self.baseTableView.frame = frame;
    
    [self getWithSearchResultData];
}

- (void)doMoreRefreshData
{
    [super doMoreRefreshData];
    
    [self getWithSearchResultData];
}

- (void)clickedBack:(id)sender
{
    [self showWithNearSearchView:NO];
    [self showWithRestaurantClassifiyView:NO];
    
    [super clickedBack:sender];
}

- (void)initWithTopView
{
    if (!_topView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kDinersSearchResultTopViewHeight);
        _topView = [[DinersSearchResultTopView alloc] initWithFrame:frame];
        [self.view addSubview:_topView];
    }
    __weak typeof(self)weakSelf = self;
    _topView.viewCommonBlock = ^(id data)
    {
        NSInteger tag = [data integerValue];
        [weakSelf clickedWithTopView:tag];
    };
}

- (void)clickedWithTopView:(NSInteger)tag
{
    if (tag == 100)
    {// 附近
        debugLog(@"附近");
        if (!_isShowClassifiyView)
        {
            [self showWithRestaurantClassifiyView:_isShowClassifiyView];
        }
        [self showWithNearSearchView:_isShowNearView];
    }
    else if (tag == 101)
    {// 菜系
        debugLog(@"菜系");
        if (!_isShowNearView)
        {
            [self showWithNearSearchView:_isShowNearView];
        }
        [self showWithRestaurantClassifiyView:_isShowClassifiyView];
    }
}

/**
 *  显示附近的视图
 *
 *  @param show YES显示，否则NO
 */
- (void)showWithNearSearchView:(BOOL)show
{
    if (!_nearSearchView)
    {
        CGRect frame = CGRectMake(0, _topView.bottom, [[UIScreen mainScreen] screenWidth], 0);
        _nearSearchView = [[DinersSearchResultNewNearView alloc] initWithFrame:frame bottomHeight:_topView.height];
//        _nearSearchView.backgroundColor = [UIColor purpleColor];
    }
    [_nearSearchView updateViewData:_mallList];
    __weak typeof(self)weakSelf = self;
    _nearSearchView.viewCommonBlock = ^(id data)
    {
        [weakSelf choiceWithMall:data];
    };
    
    if (show)
    {
        _nearSearchView.frame = CGRectMake(0, _topView.bottom, [[UIScreen mainScreen] screenWidth], 0);
//        [_nearSearchView updateWithHiddenFrame];
        CGFloat height = [[UIScreen mainScreen] screenHeight] - STATUSBAR_HEIGHT - NAVBAR_HEIGHT - _topView.height;
        [self.view addSubview:_nearSearchView];
        [UIView animateWithDuration:0.2 animations:^{
            _nearSearchView.frame = CGRectMake(0, _topView.bottom, [[UIScreen mainScreen] screenWidth], height);
        } completion:^(BOOL finished) {
        }];
        _isShowNearView = NO;
    }
    else
    {
        [UIView animateWithDuration:0.2 animations:^{
            _nearSearchView.frame = CGRectMake(0, _topView.bottom, [[UIScreen mainScreen] screenWidth], 0);
//            [_restaurantClassifiyView updateHidden:YES];
//            [_restaurantClassifiyView updateWithHiddenFrame];
        } completion:^(BOOL finished) {
            [_nearSearchView removeFromSuperview];
        }];
        _isShowNearView = YES;
    }
}

/**
 *  显示菜系视图
 *
 *  @param show YES显示，否则NO
 */
- (void)showWithRestaurantClassifiyView:(BOOL)show
{
    if (!_restaurantClassifiyView)
    {
        CGRect frame = CGRectMake(0, _topView.bottom, [[UIScreen mainScreen] screenWidth], 0);
        _restaurantClassifiyView = [[RestaurantClassifiyView alloc] initWithFrame:frame bottomHeight:_topView.height];
//        _restaurantClassifiyView.backgroundColor = [UIColor purpleColor];
    }
    [_restaurantClassifiyView updateViewData:_cuisineEntity];
    __weak typeof(self)weakSelf = self;
    _restaurantClassifiyView.viewCommonBlock = ^(id data)
    {
        [weakSelf submitCondition:data];
    };

    if (show)
    {
        _restaurantClassifiyView.frame = CGRectMake(0, _topView.bottom, [[UIScreen mainScreen] screenWidth], 0);
        [_restaurantClassifiyView updateWithHiddenFrame];
        CGFloat height = [[UIScreen mainScreen] screenHeight] - STATUSBAR_HEIGHT - NAVBAR_HEIGHT - _topView.height;
        [self.view addSubview:_restaurantClassifiyView];
        [UIView animateWithDuration:0.2 animations:^{
            _restaurantClassifiyView.frame = CGRectMake(0, _topView.bottom, [[UIScreen mainScreen] screenWidth], height);
            [_restaurantClassifiyView updateWithShowFrame];
        } completion:^(BOOL finished) {
            [_restaurantClassifiyView updateHidden:NO];
        }];
        _isShowClassifiyView = NO;
    }
    else
    {
        [UIView animateWithDuration:0.2 animations:^{
            _restaurantClassifiyView.frame = CGRectMake(0, _topView.bottom, [[UIScreen mainScreen] screenWidth], 0);
            [_restaurantClassifiyView updateHidden:YES];
            [_restaurantClassifiyView updateWithHiddenFrame];
        } completion:^(BOOL finished) {
            [_restaurantClassifiyView removeFromSuperview];
        }];
        _isShowClassifiyView = YES;
    }
}

/**
 *  选择商圈
 *
 *  @param entity <#entity description#>
 */
- (void)choiceWithMall:(MallListDataEntity *)entity
{
    self.pageId = 1;
    if ([entity.name isEqualToString:@"附近（智能范围）"])
    {
        CLLocation *location = [[HCSLocationManager shareInstance] userLocation];
        
        _searchInputEntity.lat = location.coordinate.latitude;
        _searchInputEntity.lng = location.coordinate.longitude;
    }
    else if (entity.id == 0 && entity.distance > 0)
    {
        _searchInputEntity.distance = entity.distance;
    }
    _searchInputEntity.mall_id = entity.id;
    _searchInputEntity.classify_ids = @"";
    [self getWithSearchResultData];
    [self showWithNearSearchView:_isShowNearView];
}

- (void)submitCondition:(ShopTypeFilterInputEntity *)entity
{
//    self.filterInputEntity = entity;
//    debugLog(@"ent=%@", [entity modelToJSONString]);
    self.pageId = 1;
    _searchInputEntity.mall_id = 0;
    _searchInputEntity.classify_ids = [NSString stringWithFormat:@"%d,%d,%d", (int)entity.traditionCuisineId, (int)entity.featureCuisinedId, (int)entity.interCusinedId];
    [self getWithSearchResultData];
    
    [self showWithRestaurantClassifiyView:_isShowClassifiyView];
}

- (void)getWithSearchResultData
{
    [HCSNetHttp requestWithSearch:_searchInputEntity completion:^(id result) {
        [self respondWithSearch:result];
    }];
}

- (void)respondWithSearch:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success)
    {
        if (self.pageId == 1)
        {
            [self.baseList removeAllObjects];
            [self.baseList addObjectsFromArray:respond.data];
            [self.baseTableView reloadData];
            self.pageId += 1;
        }
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

- (void)addWithFavorite:(NSInteger)shopId
{
    NSInteger index = -1;
    for (NSInteger i=0; i<[_favorites count]; i++)
    {
        NSInteger shopIdd = [_favorites[i] integerValue];
        if (shopId == shopIdd)
        {
            index = i;
            break;
        }
    }
    if (index == -1)
    {
        [_favorites addObject:@(shopId)];
    }
    
    [[TYZDBManager shareInstance] insertWithCollection:[UserLoginStateObject getUserId] shopId:shopId];
    
}

- (void)subWithFavorite:(NSInteger)shopId
{
    NSInteger index = -1;
    for (NSInteger i=0; i<[_favorites count]; i++)
    {
        NSInteger shopIdd = [_favorites[i] integerValue];
        if (shopId == shopIdd)
        {
            index = i;
            break;
        }
    }
    if (index != -1)
    {
        [_favorites removeObjectAtIndex:index];
    }
    
    [[TYZDBManager shareInstance] deleteWithCollection:[UserLoginStateObject getUserId] shopId:shopId];
    
}

- (NSInteger)findWithFavorite:(NSInteger)shopId
{
    NSInteger select = 0;
    for (id shopIdd in _favorites)
    {
        if ([shopIdd integerValue] == shopId)
        {
            select = 1;
            break;
        }
    }
    return select;
}

- (void)touchWithFavorite:(NSInteger)selected indexPath:(NSIndexPath *)indexPath
{
    ShopListDataEntity *shopEnt = self.baseList[indexPath.row];
    debugLog(@"sel=%d", (int)selected);
    if (selected == 0)
    {// 添加收藏
        [SVProgressHUD showWithStatus:@"收藏中"];
        [HCSNetHttp requestWithUserFavoriteAdd:[UserLoginStateObject getUserId] shopId:shopEnt.shop_id completion:^(id result) {
            TYZRespondDataEntity *respond = result;
            if (respond.errcode == respond_success)
            {
                [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
                shopEnt.favorite = 1;
                [self addWithFavorite:shopEnt.shop_id];
                [MCYPushViewController reloadWithTableView:self.baseTableView indexPath:indexPath reloadType:3];
            }
            else
            {
                [UtilityObject svProgressHUDError:respond viewContrller:self];
            }
        }];
    }
    else
    {// 取消收藏
        [SVProgressHUD showWithStatus:@"取消中"];
        [HCSNetHttp requestWithUserFavoriteCancel:[UserLoginStateObject getUserId] shopId:shopEnt.shop_id completion:^(id result) {
            TYZRespondDataEntity *respond = result;
            if (respond.errcode == respond_success)
            {
                [SVProgressHUD showSuccessWithStatus:@"取消成功"];
                shopEnt.favorite = 0;
                [self subWithFavorite:shopEnt.shop_id];
                [MCYPushViewController reloadWithTableView:self.baseTableView indexPath:indexPath reloadType:3];
            }
            else
            {
                [UtilityObject svProgressHUDError:respond viewContrller:self];
            }
        }];
    }
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
    __weak typeof(self)weakSelf = self;
    RestaurantClassificationCell *cell = [RestaurantClassificationCell cellForTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ShopListDataEntity *shopEnt = self.baseList[indexPath.row];
    shopEnt.favorite = [self findWithFavorite:shopEnt.shop_id];
    [cell updateCellData:shopEnt];
    cell.baseTableViewCellBlock = ^(id data)
    {
        [weakSelf touchWithFavorite:[data integerValue] indexPath:indexPath];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [RestaurantClassificationCell getClassificationCellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ShopListDataEntity *shopEnt = self.baseList[indexPath.row];
    OrderMealContentEntity *entity = [OrderMealContentEntity new];
    entity.name = shopEnt.name;
    entity.shop_id = shopEnt.shop_id;
    [MCYPushViewController showWithShopDetailVC:self data:entity completion:^(id data) {
        
    }];
}

@end
