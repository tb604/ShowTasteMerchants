//
//  RestaurantClassificationViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/24.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "RestaurantClassificationViewController.h"
#import "LocalCommon.h"
#import "OrderMealDataEntity.h"
#import "ClassifiyConditionFiltrateView.h"
#import "RestaurantClassificationCell.h"
#import "RestaurantClassifiyView.h"
#import "HCSLocationManager.h"
#import "CityDataEntity.h"
#import "ShopListDataEntity.h"

@interface RestaurantClassificationViewController ()
{
    /**
     *  筛选条件按钮视图
     */
    ClassifiyConditionFiltrateView *_conditionFiltrateView;
    
    RestaurantClassifiyView *_restaurantClassifiyView;
    
    /**
     *  YES表示显示；NO表示不显示
     */
    BOOL _isShowClassifiyView;
}

@property (nonatomic, strong) ShopTypeFilterInputEntity *filterInputEntity;

/**
 *  菜系数组
 */
//@property (nonatomic, strong) NSArray *cuisineList;

@property (nonatomic, strong) OrderMealContentEntity *contentEntity;


/**
 *  获取餐厅基本属性
 */
- (void)getRestaurantBaseAttribute;


- (void)initWithConditionFiltrateView;

- (void)initWithRestaurantClassifiyView;

- (void)showWithRestaurantClassifiyView:(BOOL)show;

// requestWithSearch
- (void)getClassifyData;

@end

@implementation RestaurantClassificationViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    self.navigationController.navigationBarHidden = NO;
}

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
    
    self.contentEntity = _orderMealEntity.content;
    
//    NSArray *list = [UtilityObject readCacheDataLocalKey:kCacheCuisineData saveFilename:kCacheCuisineFileName];
//    self.cuisineList = list;
    
    
    _isShowClassifiyView = YES;
    
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = _orderMealEntity.borad_name;
}

- (void)initWithSubView
{
    [super initWithSubView];
    
//    [self getRestaurantBaseAttribute];
    
    [self initWithConditionFiltrateView];
    
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.baseTableView.contentInset = UIEdgeInsetsMake(_conditionFiltrateView.height, 0, 0, 0);
    // 指定滚动条在scrollerView中的位置
    self.baseTableView.scrollIndicatorInsets = self.baseTableView.contentInset;
    
    [self initWithRestaurantClassifiyView];
    
//    [self hiddenFooterView:YES];
    
    [self doRefreshData];
}

- (void)doRefreshData
{
    [super doRefreshData];
    
    [self getClassifyData];
    
}

- (void)doMoreRefreshData
{
    [super doMoreRefreshData];
    
    [self getClassifyData];
}

- (void)initWithConditionFiltrateView
{
    if (!_conditionFiltrateView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kClassifiyConditionFiltrateViewHeight);
        _conditionFiltrateView = [[ClassifiyConditionFiltrateView alloc] initWithFrame:frame];
        [self.view addSubview:_conditionFiltrateView];
    }
    __weak typeof(self)weakSelf = self;
    _conditionFiltrateView.viewCommonBlock = ^(id data)
    {// 点击 “筛选条件”
        [weakSelf conditionFiltrate];
    };
}

- (void)initWithRestaurantClassifiyView
{
    if (!_restaurantClassifiyView)
    {
        CGRect frame = CGRectMake(0, _conditionFiltrateView.bottom, [[UIScreen mainScreen] screenWidth], 0);
        _restaurantClassifiyView = [[RestaurantClassifiyView alloc] initWithFrame:frame];
    }
    [_restaurantClassifiyView updateViewData:_cuisineEntity];
    __weak typeof(self)weakSelf = self;
    _restaurantClassifiyView.viewCommonBlock = ^(id data)
    {
        [weakSelf submitCondition:data];
    };
}

- (void)submitCondition:(ShopTypeFilterInputEntity *)entity
{
    self.filterInputEntity = entity;
    debugLog(@"ent=%@", [entity modelToJSONString]);
    self.pageId = 1;
    [self getClassifyData];
    
    [self conditionFiltrate];
}

- (void)showWithRestaurantClassifiyView:(BOOL)show
{
    if (show)
    {
        _restaurantClassifiyView.frame = CGRectMake(0, _conditionFiltrateView.bottom, [[UIScreen mainScreen] screenWidth], 0);
        [_restaurantClassifiyView updateWithHiddenFrame];
        CGFloat height = [[UIScreen mainScreen] screenHeight] - _conditionFiltrateView.bottom;
        [self.view addSubview:_restaurantClassifiyView];
        [UIView animateWithDuration:0.2 animations:^{
            _restaurantClassifiyView.frame = CGRectMake(0, _conditionFiltrateView.bottom, [[UIScreen mainScreen] screenWidth], height);
            [_restaurantClassifiyView updateWithShowFrame];
        } completion:^(BOOL finished) {
            [_restaurantClassifiyView updateHidden:NO];
        }];
        _isShowClassifiyView = NO;
    }
    else
    {
        [UIView animateWithDuration:0.2 animations:^{
            _restaurantClassifiyView.frame = CGRectMake(0, _conditionFiltrateView.bottom, [[UIScreen mainScreen] screenWidth], 0);
            [_restaurantClassifiyView updateHidden:YES];
            [_restaurantClassifiyView updateWithHiddenFrame];
        } completion:^(BOOL finished) {
            [_restaurantClassifiyView removeFromSuperview];
        }];
        _isShowClassifiyView = YES;
    }
}

/**
 *  筛选条件
 */
- (void)conditionFiltrate
{
    [self showWithRestaurantClassifiyView:_isShowClassifiyView];
}

/**
 *  获取餐厅基本属性
 */
- (void)getRestaurantBaseAttribute
{
//    [HCSNetHttp requestWithMenu:^(id result) {
//        [self getRestaurantBaseAttribute:result];
//    }];
//    [HCSNetHttp requestWithMenu:_contentEntity.shop_id completion:^(id result) {
//        [self getRestaurantBaseAttribute:result];
//    }];
}
/*- (void)getRestaurantBaseAttribute:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success)
    {
        if ([_cuisineList count] == 0)
        {
            [_restaurantClassifiyView updateViewData:respond.data];
        }
        self.cuisineList = respond.data;
        [UtilityObject saveCacheDataLocalKey:kCacheCuisineData saveFilename:kCacheCuisineFileName saveid:_cuisineList];
    }
}*/

- (void)getClassifyData
{
//    debugMethod();
    
    CLLocation *location = [[HCSLocationManager shareInstance] userLocation];
     double lon = location.coordinate.longitude;
     double lat = location.coordinate.latitude;
    NSString *cityName = [[HCSLocationManager shareInstance] readCityName];
    [HCSNetHttp requestWithCitySearch:cityName completion:^(id result) {
        TYZRespondDataEntity *respond = result;
//        debugLog(@"class=%@", NSStringFromClass([respond.data class]));
        if (respond.errcode == respond_success)
        {
            CityDataEntity *cityEnt = respond.data;
            ShopSearchInputEntity *inputEntity = [ShopSearchInputEntity new];
            inputEntity.page_index = self.pageId;
            inputEntity.lat = lat;
            inputEntity.lng = lon;
            if (_filterInputEntity)
            {
                inputEntity.classify_ids = [NSString stringWithFormat:@"%d,%d,%d", (int)_filterInputEntity.traditionCuisineId, (int)_filterInputEntity.featureCuisinedId, (int)_filterInputEntity.interCusinedId];
            }
            else
            {
                inputEntity.classify_ids = [NSString stringWithFormat:@"%d", (int)_contentEntity.class_id];
            }
            inputEntity.city_id = cityEnt.city_id;
            [HCSNetHttp requestWithSearch:inputEntity completion:^(id result) {
                [self respondWithSearch:result];
            }];
        }
        else
        {
            [UtilityObject svProgressHUDError:respond viewContrller:self];
            [self endAllRefreshing];
        }
    }];
}

- (void)respondWithSearch:(TYZRespondDataEntity *)respond
{
    debugLog(@"dfd");
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
    RestaurantClassificationCell *cell = [RestaurantClassificationCell cellForTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateCellData:self.baseList[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [RestaurantClassificationCell getClassificationCellHeight];
}

@end
