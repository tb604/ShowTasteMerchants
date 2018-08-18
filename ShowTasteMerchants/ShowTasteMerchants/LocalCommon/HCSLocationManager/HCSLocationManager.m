//
//  HCSLocationManager.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "HCSLocationManager.h"
#import "LocalCommon.h"

@interface HCSLocationManager () <CLLocationManagerDelegate, BMKGeneralDelegate, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate, UIAlertViewDelegate>
{
    /**
     *  针对ios8以后定位用的
     */
    CLLocationManager *_locationManager;
    
    /**
     *  地理信息编码和反编码
     */
    CLGeocoder *_geocoder;
    
    /// 百度地图管理
    BMKMapManager *_mapManager;
    
    /// 百度定位服务变量声明
    BMKLocationService  *_locationService;
}

/**
 *  是否是主动切换；主动(手动切换)是YES；自动(自动定位)是NO；
 */
@property (nonatomic, assign) BOOL isInitiativeSwitch;

/**
 *  是否有点击AlerView上的按钮，如果点击过，为NO
 */
@property (nonatomic, assign) BOOL isAlertView;


/// geo搜索服务
@property (nonatomic, strong) BMKGeoCodeSearch *bmkGeoCodeSearch;

/**
 *  用户当前的经纬度信息
 */
@property (nonatomic, strong) CLLocation *currLocation;

@property (nonatomic, copy) NSString *keyCity;


/** 初始化CLLocationManager */
- (void)initWithLocationManager;

@end

@implementation HCSLocationManager

+ (HCSLocationManager *)shareInstance
{
    static HCSLocationManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
        [instance initWithLocationManager];
        [instance initWithBaiduMapManager];
        [instance initWithBMKLocationService];
        [instance initWithBMKGeoCodeSearch];
    });
    return instance;
}

/**
 *  初始化百度地址manager
 */
- (void)initWithBaiduMapManager
{
    if (!_mapManager)
    {
        _isInitiativeSwitch = NO;
        _mapManager = [[BMKMapManager alloc] init];
    }
    BOOL ret = [_mapManager start:kBaiDuMapKey  generalDelegate:self];
    if (!ret)
    {
        debugLog(@"baidu manager start failed.");
    }
}

- (void)initWithBMKGeoCodeSearch
{
    if (!_bmkGeoCodeSearch)
    {
        _isTipAlertView = YES;
        _bmkGeoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    }
    _bmkGeoCodeSearch.delegate = self;
}

/**
 *  初始化百度定位服务
 */
- (void)initWithBMKLocationService
{
    if (!_locationService)
    {
        _locationService = [[BMKLocationService alloc] init];
    }
    _locationService.delegate = self;
}

#pragma mark private methods
- (void)initWithLocationManager
{
    debugMethod();
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // 定位服务是否可用
    BOOL enable = [CLLocationManager locationServicesEnabled];
    
    // 是否具有定位权限
    int state = [CLLocationManager authorizationStatus];
    debugLog(@"state=%d", state);
    
    if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] && (!enable || state < 3))
    {
        debugLog(@"哈哈");
        [_locationManager requestAlwaysAuthorization];
    }
}

#pragma mark public methods

/**
 *  判断用户有无打开定位功能，如果没有打开，提示用户打开定位功能
 */
- (int)authorizationStatus
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusDenied)
    {// 定位功能没有打开
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"无法访问"  message:@"没有权限访问位置信息，请从设置-隐私-定位服务 中打开位置访问权限"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        return -1;
    }
    else
    {
        return status;
    }
}


- (void)startLocation
{
    debugLog(@"开启定位");
    [self stopLocation];
    NSInteger state = [self authorizationStatus];
    debugLog(@"--state = %d", (int)state);
    if (state != -1)
    {
        debugLog(@"执行");
        [_locationService startUserLocationService];
    }
}

- (void)stopLocation
{
    debugLog(@"定位关闭");
    [_locationService stopUserLocationService];
}

/**
 *  根据定位，搜索用户的位置
 *
 *  @param coordinate 如果coordinate都是0表示用户当前位置
 */
- (void)locationGetCodeSearch:(CLLocationCoordinate2D)coordinate isiniSwitch:(BOOL)isiniSwitch
{
    debugMethod();
    int state = [self authorizationStatus];
    if (state == -1)
    {
        return;
    }
    else
    {
        if (!_locationService.userLocation.location)
        {
            [self startLocation];
        }
    }
    
    if (!_locationService.userLocation.location)
    {
//        CLLocationCoordinate2D coordinate = _locationService.userLocation.location.coordinate;
        debugLog(@"定位有问题。lon=%f; lat=%f", coordinate.longitude, coordinate.latitude);
        return;
    }
    [self startLocation];
    //    debugLog(@"isiniSwitch=%d", isiniSwitch);
    self.isInitiativeSwitch = isiniSwitch;
    if (!_bmkGeoCodeSearch.delegate)
    {
        _bmkGeoCodeSearch.delegate = self;
    }
    
    if (coordinate.longitude == 0.0 && coordinate.latitude == 0.0)
    {
        coordinate = _locationService.userLocation.location.coordinate;
        //        debugLog(@"lon=%f; lat=%f", coordinate.longitude, coordinate.latitude);
    }
    
    BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc] init];
    option.reverseGeoPoint = coordinate;
    if (![_bmkGeoCodeSearch reverseGeoCode:option])
    {
        debugLog(@"根据地理坐标获取地址信息 失败");
    }
}

/**
 *  根据关键字定位
 *
 *  @param key <#key description#>
 */
- (void)locationCodeSearchKey:(NSString *)key isCity:(BOOL)isCity isiniSwitch:(BOOL)isiniSwitch
{
    debugMethod();
    if ([self authorizationStatus] != -1)
    {
        return;
    }
    
    if (!_locationService.userLocation.location)
    {
        return;
    }
    [self startLocation];
    //    debugLog(@"isiniSwitch=%d", isiniSwitch);
    self.isInitiativeSwitch = isiniSwitch;
    if (!_bmkGeoCodeSearch.delegate)
    {
        _bmkGeoCodeSearch.delegate = self;
    }
    
    BMKGeoCodeSearchOption *geocodeSearchOption = [[BMKGeoCodeSearchOption alloc] init];
    if (isCity)
    {
        geocodeSearchOption.city = key;
    }
    geocodeSearchOption.address = key;
    if (![_bmkGeoCodeSearch geoCode:geocodeSearchOption])
    {
        debugLog(@"%s--geo检索发送失败--城市：%@", __func__, key);
    }
    
}

/**
 *  保存实体对象
 *
 *  @param entity 实体类
 */
- (void)saveUserLocationInfo:(UserLocationEntity *)entity
{
    if (!entity)
    {
        return;
    }
    [UIApplication saveCacheDataLocalKey:kCacheLocationData saveFilename:kCacheLocationFileName saveid:entity];
}

/**
 *  当视图将要显示的时候调用
 */
- (void)BMKviewWillAppear
{
    debugMethod();
    _bmkGeoCodeSearch.delegate = self;
}

/**
 *  当视图将要不显示的时候调用
 */
- (void)BMKviewWillDisappear
{
    debugMethod();
    _bmkGeoCodeSearch.delegate = nil;
}

/**
 *  获取用户定位的信息
 *
 *  @return <#return value description#>
 */
- (UserLocationEntity *)readUserLocationInfo
{
    UserLocationEntity *entity = nil;
    id empEnt = [UIApplication readCacheDataLocalKey:kCacheLocationData saveFilename:kCacheLocationFileName];
    if (empEnt)
    {
        entity = empEnt;
        return entity;
    }
    else
    {
        entity = [[UserLocationEntity alloc] init];
        return entity;
    }
}

- (CLLocation *)userLocation
{
    if (_locationService.userLocation.location)
    {
        return _locationService.userLocation.location;
    }
    UserLocationEntity *location = [self readUserLocationInfo];
    CLLocation *locations = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
    return locations;
}

/**
 *  读取城市名称
 */
- (NSString *)readCityName
{
    NSString *cityName = [self readUserLocationInfo].choiceCity;
    if ([cityName hasSuffix:@"市"])
    {
        cityName = [cityName substringToIndex:cityName.length-1];
        return cityName;
    }
    else
    {
        return cityName;
    }
}

/**
 *  保存用户选择的城市信息
 *
 *  @param cityEnt
 */
- (void)saveUserChoiceCityInfo:(CityDataEntity *)cityEnt
{
    UserLocationEntity *entity = [self readUserLocationInfo];
    entity.choiceCity = cityEnt.city_name;
    entity.cityId = cityEnt.city_id;
    entity.guideFlag = cityEnt.guideFlag;
    if (cityEnt.longitude != 0.0)
    {
        entity.choiceLongitude = cityEnt.longitude;
        entity.choiceLatitude = cityEnt.latitude;
    }
    [self saveUserLocationInfo:entity];
}

/**
 *  保存城市id
 *
 *  @param cityId
 */
- (void)saveWithCityInfo:(CityDataEntity *)cityEnt
{
    UserLocationEntity *entity = [self readUserLocationInfo];
    entity.cityId = cityEnt.city_id;
    entity.guideFlag = cityEnt.guideFlag;
    [self saveUserLocationInfo:entity];
}

/**
 *  读取城市id
 *
 *  @return <#return value description#>
 */
- (CityDataEntity *)readWithCityInfo
{
    UserLocationEntity *loc = [self readUserLocationInfo];
    CityDataEntity *cityInfo = [[CityDataEntity alloc] init];
    cityInfo.city_id = loc.cityId;
    cityInfo.city_name = loc.choiceCity;
    cityInfo.guideFlag = loc.guideFlag;
    return cityInfo;
}

/**
 *  读取地址
 *
 *  @return <#return value description#>
 */
- (NSString *)readWithAddress
{
    return [self readUserLocationInfo].address;
}


#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    debugMethod();
    _authorizeStatus = status;
    if (status == kCLAuthorizationStatusAuthorized || status == kCLAuthorizationStatusAuthorizedAlways)
    {
        debugLog(@"打开定位");
        // 打开定位
        [self startLocation];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CLLocationCoordinate2D coordinate = {0.0, 0.0};
            [self locationGetCodeSearch:coordinate isiniSwitch:NO];
        });
    }
}

#pragma mark 百度初始化回掉BMKGeneralDelegate
// 返回网络状态
- (void)onGetNetworkState:(int)iError
{
//    debugMethod();
    if (iError == 0)
    {
        debugLog(@"百度地图api联网成功");
    }
    else
    {
        debugLog(@"百度地图api联网失败");
    }
}

// 返回授权验证状态
- (void)onGetPermissionState:(int)iError
{
//    debugMethod();
    if (iError == 0)
    {
        debugLog(@"百度api授权成功");
        [self initWithBMKLocationService];
    }
    else
    {
        debugLog(@"百度api授权失败");
    }
}

#pragma mark BMKLocationServiceDelegate
// 在将要启动定位时，会调用此函数
- (void)willStartLocatingUser
{
    debugLog(@"在将要启动定位时，会调用此函数");
    debugMethod();
}

// 在停止定位后，会调用此函数
- (void)didStopLocatingUser
{
    debugLog(@"在停止定位后，会调用此函数");
    debugMethod();
}

// 定位失败后，会调用此函数
- (void)didFailToLocateUserWithError:(NSError *)error
{
    debugLog(@"定位失败后，会调用此函数");
    debugMethod();
}

// 用户方向更新后，会调用此函数
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
//    debugMethod();
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidUpdateUserHeadingNote object:userLocation];
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    debugMethod();
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidUpdateBMKUserLocationNote object:userLocation];
}

#pragma mark BMKGeoCodeSearchDelegate
/**
 *返回地址信息搜索结果(根据用户输入的地址，如城市名称，得到相关信息。如经纬度)
 *@param searcher 搜索对象
 *@param result 搜索结BMKGeoCodeSearch果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    debugMethod();
    // 根据城市查询到，那个城市的经纬度后，根据用户当前的经纬度，得到
    //    CLLocationCoordinate2D coordinate = {0.0, 0.0};
    if (error == BMK_OPEN_NO_ERROR)
    {
        [self locationGetCodeSearch:result.location isiniSwitch:_isInitiativeSwitch];
    }
}

/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    //    debugMethod();
    debugLog(@"address=%@", result.address);
    NSString *cityName = result.addressDetail.city;
    if (!cityName)
    {
        return;
    }
    
    BOOL isCurr = NO;
    
    if ([cityName rangeOfString:@"市"].location == [cityName length]-1)
    {
        cityName = [cityName substringToIndex:cityName.length-1];
    }
    
    UserLocationEntity *entity = [self readUserLocationInfo];
    
    BOOL emp = NO;
    if ([cityName isEqualToString:entity.choiceCity])
    {
        emp = YES;
    }
    if (entity.choiceCity && ![entity.choiceCity isEqualToString:@""] && ![entity.choiceCity isEqualToString:entity.currentCity] && !_isInitiativeSwitch)
    {
        if (!_isAlertView && _isTipAlertView)
        {
            emp = YES;
            NSString *strMsg = [NSString stringWithFormat:@"监测到您所在城市发生变化，当前城市为\n%@，是否切换到当前城市？", cityName];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"切换城市提示" message:strMsg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"切换", nil];
            [alertView show];
        }
        _isAlertView = YES;
        _isTipAlertView = YES;
    }
    
    
//    debugLog(@"switch=%d", _isInitiativeSwitch);
    debugLog(@"address=%@", result.address);
    if (!_isInitiativeSwitch)
    {// 自动定位
        entity.currentCity = cityName;
        entity.currentProvince = result.addressDetail.province;
        entity.address = result.address;
        entity.longitude = result.location.longitude;
        entity.latitude = result.location.latitude;
        if (!entity.choiceCity || [entity.choiceCity isEqualToString:@""])
        {
            entity.choiceCity = cityName;
            entity.choiceProvince = result.addressDetail.province;
            entity.choiceLongitude = result.location.longitude;
            entity.choiceLatitude = result.location.latitude;
        }
    }
    else
    {
        entity.choiceCity = cityName;
        entity.choiceProvince = result.addressDetail.province;
        entity.choiceLongitude = result.location.longitude;
        entity.choiceLatitude = result.location.latitude;
    }
    
    [self saveUserLocationInfo:entity];
    
    if (_onGetReverseGeoCodeResultBlock && !isCurr)
    {
        _onGetReverseGeoCodeResultBlock(searcher, result, error);
    }
    
    CityDataEntity *cityEnt = [[CityDataEntity alloc] init];
    cityEnt.city_name = entity.choiceCity;
    cityEnt.longitude = entity.choiceLongitude;
    cityEnt.latitude = entity.choiceLatitude;
    cityEnt.address = entity.address;
    
    
    if (_switchCityNameBlock && !_isInitiativeSwitch && !emp)
    {
        _switchCityNameBlock(cityEnt);
    }
    
    if (_currentCityInfoBlock)
    {
        CityDataEntity *cityEnt = [[CityDataEntity alloc] init];
        cityEnt.city_name = cityName;
        cityEnt.longitude = result.location.longitude;
        cityEnt.latitude = result.location.latitude;
        cityEnt.address = result.address;
        _currentCityInfoBlock(cityEnt, error);
    }
    
    
    [self BMKviewWillDisappear];
    // 关闭定位
    [self performSelector:@selector(stopLocation) withObject:nil afterDelay:5];
    
    if (!emp)
    {
        _isInitiativeSwitch = NO;
    }
}

#pragma mark start UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    _isAlertView = NO;
    if (buttonIndex == 1)
    {//  切换
        UserLocationEntity *entity = [self readUserLocationInfo];
        CityDataEntity *cityEnt = [[CityDataEntity alloc] init];
        cityEnt.city_name = entity.currentCity;
        cityEnt.city_id = 0;
        [self saveUserChoiceCityInfo:cityEnt];
        
        if (_switchCityNameBlock)
        {
            _switchCityNameBlock(cityEnt);
        }
    }
    _isInitiativeSwitch = NO;
}
#pragma mark end UIAlertViewDelegate



@end
