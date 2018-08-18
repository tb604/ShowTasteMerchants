//
//  OpenRestaurantCityViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/17.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "OpenRestaurantCityViewController.h"
#import "LocalCommon.h"
#import "OpenRestaurantBottomView.h"
#import "CityDataEntity.h"
#import "CityTableViewCell.h"
#import "LocationCityTableViewCell.h"
#import "HCSLocationManager.h"

@interface OpenRestaurantCityViewController () <UISearchBarDelegate, UISearchDisplayDelegate>
{
    OpenRestaurantBottomView *_bottomView;
    
    /**
     *  存储字母的
     */
//    NSMutableDictionary *_sectionDict;
    
//    NSMutableArray  *_chooseCityArray;
}

@property (nonatomic, strong) HCSLocationManager *locationManager;

@property (nonatomic, strong) NSIndexPath *lastIndexPath;

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) UISearchDisplayController *searchDisplay;

@property (nonatomic, strong) NSMutableArray *searchArray;

@property (nonatomic, strong) UserLocationEntity *locationEntity;

@property (nonatomic, strong) CityDataEntity *cityDataEntity;


- (void)initWithSearchBar;

- (void)initWithSearchDisplay;

- (void)initWithBottomView;

- (void)getCityData;

@end

@implementation OpenRestaurantCityViewController

- (void)dealloc
{
    _locationManager.switchCityNameBlock = nil;
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
    
    
    _searchArray = [NSMutableArray new];
    
    self.locationManager = [HCSLocationManager shareInstance];
    __weak typeof(self)weakSelf = self;
    self.locationEntity = [_locationManager readUserLocationInfo];
    if ([objectNull(_locationEntity.currentCity) isEqualToString:@""])
    {// 没有获取到当前城市
        CLLocationCoordinate2D coor;
        coor.longitude = 0.0;
        coor.latitude = 0.0;
        [_locationManager locationGetCodeSearch:coor isiniSwitch:NO];
    }
    _locationManager.currentCityInfoBlock = ^(CityDataEntity *cityEnt, NSInteger error)
    {
        [weakSelf updateLocationInfo:cityEnt];
    };
    _cityDataEntity = [[CityDataEntity alloc] init];
    _cityDataEntity.city_name = _locationEntity.currentCity;
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = @"开餐厅";
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self hiddenFooterView:YES];
    
    AppDelegate * app = [UtilityObject appDelegate];
    CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight] - [app navBarHeight] - STATUSBAR_HEIGHT);
    self.baseTableView.frame = frame;
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    [self initWithBottomView];
    
    [self initWithSearchBar];
    
    [self initWithSearchDisplay];
    
    [SVProgressHUD showWithStatus:@"加载中"];
    [self doRefreshData];
}

- (void)doRefreshData
{
    [super doRefreshData];
    
    [self getCityData];
}

- (void)initWithSearchBar
{
    AppDelegate *app = [UtilityObject appDelegate];
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f,0.0f, [[UIScreen mainScreen] screenWidth], [app navBarHeight])];
    _searchBar.delegate =self;
    _searchBar.placeholder = @"搜索城市";
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _searchBar.keyboardType = UIKeyboardTypeDefault;
    self.baseTableView.tableHeaderView = _searchBar;
}

- (void)updateLocationInfo:(CityDataEntity *)cityEnt
{
    _cityDataEntity.city_name = cityEnt.city_name;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [MCYPushViewController reloadWithTableView:self.baseTableView indexPath:indexPath reloadType:2];
    self.locationEntity = [_locationManager readUserLocationInfo];
}

- (void)initWithSearchDisplay
{
    _searchDisplay = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _searchDisplay.searchResultsDataSource = self;
    _searchDisplay.searchResultsDelegate = self;
}

- (void)initWithBottomView
{
    if (!_bottomView)
    {
        AppDelegate * app = [UtilityObject appDelegate];
        CGRect frame = CGRectMake(0, self.baseTableView.bottom, self.baseTableView.width, [app tabBarHeight]);
        _bottomView = [[OpenRestaurantBottomView alloc] initWithFrame:frame];
        [_bottomView topLineWithHidden:YES];
        _bottomView.backgroundColor = [UIColor colorWithHexString:@"#ff5600"];
        [self.view addSubview:_bottomView];
    }
    __weak typeof(self)weakSelf = self;
    _bottomView.viewCommonBlock = ^(id data)
    {
        [weakSelf clickedNext];
    };
}

- (void)clickedNext
{
    if (!_inputEntity.address || [_inputEntity.address isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"餐厅地址为空!"];
        return;
    }
    // 开餐厅第三部，餐厅名称
    [MCYPushViewController showWithOpenRestaurantNameVC:self data:_inputEntity completion:nil];
}

- (void)getCityData
{
    [HCSNetHttp requestWithCityHot:^(id result) {
        [self getCityData:result];
    }];
}

- (void)getCityData:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success)
    {
        [SVProgressHUD dismiss];
        [self.baseList removeAllObjects];
        [self.baseList addObjectsFromArray:respond.data];
        [self.baseTableView reloadData];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
}

- (void)searchWithString:(NSString *)searchString
{
    // GuiderCityEntity
    [_searchArray removeAllObjects];
    for (CityDataEntity *entity in self.baseList)
    {
        if ([self searchResult:entity.city_name searchText:searchString])
        {// 先按输入的内容搜索
            [_searchArray addObject:entity];
        }
    }
    
//    for (NSArray *array in [_sectionDict allValues])
//    {
//        for (GuiderCityEntity *entity in array)
//        {
//            if ([self searchResult:entity.name searchText:searchString])
//            {// 先按输入的内容搜索
//                [_searchArray addObject:entity];
//            }
//        }
//    }
}

/**
 *  是否有包含
 *
 *  @param contacName 内容
 *  @param searchT    searchT是否包含在contacName中
 *
 *  @return 包含返回YES，否则返回NO
 */
- (BOOL)searchResult:(NSString *)contacName searchText:(NSString *)searchT
{
    NSComparisonResult result = [contacName compare:searchT options:NSCaseInsensitiveSearch range:NSMakeRange(0, searchT.length)];
    if (result == NSOrderedSame)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


// 刷新
- (void)refreshLocation
{
    CLLocationCoordinate2D coor;
    coor.longitude = 0.0;
    coor.latitude = 0.0;
    [_locationManager locationGetCodeSearch:coor isiniSwitch:NO];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [_searchArray count];
    }
    
    if (section == 0)
    {
        count = 1;
    }
    else
    {
        count = [self.baseList count];
    }
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView])
    {
        CityTableViewCell *cell = [CityTableViewCell cellForTableView:tableView];
        [cell updateCellData:self.searchArray[indexPath.row]];
        return cell;
    }
    if ([indexPath section] == 0)
    {
        __weak typeof(self)weakSelf = self;
        LocationCityTableViewCell *cell = [LocationCityTableViewCell cellForTableView:tableView];
        [cell updateCellData:_locationEntity.currentCity];
        cell.baseTableViewCellBlock = ^(id data)
        {// 刷新定位
            [weakSelf refreshLocation];
        };
        return cell;
    }
    else
    {
        CityTableViewCell *cell = [CityTableViewCell cellForTableView:tableView];
        [cell updateCellData:self.baseList[indexPath.row]];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = kCityTableViewCellHeight;
    
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView])
    {
        return nil;
    }
    NSString *str = nil;
    if (section == 0)
    {
        str = @"当前定位城市";
    }
    else
    {
        str = @"热门城市";
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], 32.0)];
    view.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    UILabel *label = [TYZCreateCommonObject createWithLabel:view labelFrame:CGRectMake(15, 0, [[UIScreen mainScreen] screenWidth] - 30, 32.0) textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    label.text = str;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView])
    {
        return 0.01;
    }
    return 32.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView])
    {
        CityDataEntity *cityEnt = self.searchArray[indexPath.row];
        debugLog(@"cityName=%@", cityEnt.city_name);
        self.cityDataEntity = cityEnt;
        [self showWithRestaurantNameVC];
        return;
    }
    
    if (indexPath.section == 1)
    {
        CityDataEntity *cityEnt = self.baseList[indexPath.row];
        debugLog(@"cityName=%@", cityEnt.city_name);
        self.cityDataEntity = cityEnt;
        [self showWithRestaurantNameVC];
    }
    else if (indexPath.section == 0)
    {
        LocationCityTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSString *title = objectNull(cell.descLabel.text);
        if ([title isEqualToString:@""])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"需要重新定位" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        else if ([title isEqualToString:@"定位失败"] || [title isEqualToString:@"定位中"])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:title delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        else
        {
            [SVProgressHUD showWithStatus:@"加载中"];
            [HCSNetHttp requestWithCitySearch:title completion:^(id result) {
                [self responseWithCitySearch:result];
            }];
        }
    }
}

- (void)responseWithCitySearch:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success)
    {
        self.cityDataEntity = respond.data;
        [self showWithRestaurantNameVC];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
}

- (void)showWithRestaurantNameVC
{
    _inputEntity.cityId = _cityDataEntity.city_id;
    _inputEntity.cityName = _cityDataEntity.city_name;
    
    [SVProgressHUD dismiss];
    // 第三步，选择菜系
    [MCYPushViewController showWithOpenRestaurantFirstVC:self data:nil inputEnt:_inputEntity completion:nil];
}


#pragma mark start UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar setText:@""];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    debugLog(@"%s--_searchBar=%@; searchText=%@", __func__, _searchBar.text, searchText);
    if (_searchBar.text.length > 0)
    {
        [self searchWithString:_searchBar.text];
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
}
#pragma mark end UISearchBarDelegate

#pragma mark start UISearchDisplayDelegate
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    debugMethod();
    return YES;
}
#pragma mark end UISearchDisplayDelegate




@end







