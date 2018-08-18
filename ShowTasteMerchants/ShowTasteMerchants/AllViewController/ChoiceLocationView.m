//
//  ChoiceLocationView.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/8.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ChoiceLocationView.h"
#import "LocalCommon.h"
//#import <BaiduMapAPI/BMapKit.h>  // 百度地图
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>
#import "HCSLocationManager.h"

@interface ChoiceLocationView () <BMKMapViewDelegate, BMKGeoCodeSearchDelegate>
{
    BMKMapView *_bmkMapView;
    
    UIImageView *_mapCurrIcon;
    
    /**
     *  geo搜索服务
     */
    BMKGeoCodeSearch *_bmkGeoCodeSearch;
}

/**
 *  当前城市名称
 */
@property (nonatomic, copy) NSString *currentCityName;


- (void)initWithBmkMapView;

/**
 *  定位按钮
 */
- (void)initWithBtnLocation;

- (void)initWithMapCurrIcon;

/// 初始化geo搜索服务
- (void)initWithBMKGeoCodeSearch;

/**
 *  根据经纬度搜索相关信息
 *
 *  @param coordinate 经纬度
 */
- (void)locationGeoCodeSearch:(CLLocationCoordinate2D)coordinate;

// 根据城市名称搜索，得到这个城市的经纬度
- (void)locationCityMapCodeSearch:(NSString *)cityName address:(NSString *)address;

/** 点击定位点按钮，触发的事件 */
- (void)clickedLocationMap:(id)sender;

- (void)didUpdateUserHeadingNote:(NSNotification *)note;

- (void)didUpdateBMKUserLocationNote:(NSNotification *)note;


@end

@implementation ChoiceLocationView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDidUpdateUserHeadingNote object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDidUpdateBMKUserLocationNote object:nil];
    CC_SAFE_NULL(_bmkMapView.delegate);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithVar
{
    [super initWithVar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateUserHeadingNote:) name:kDidUpdateUserHeadingNote object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateBMKUserLocationNote:) name:kDidUpdateBMKUserLocationNote object:nil];
}

- (void)initWithSubView
{
    [super initWithSubView];
    
//    self.backgroundColor = [UIColor orangeColor];
    
    [self initWithBmkMapView];
    
    /**
     *  定位按钮
     */
    [self initWithBtnLocation];
    
    /// 初始化geo搜索服务
    [self initWithBMKGeoCodeSearch];
    
    [self initWithMapCurrIcon];
}

- (void)initWithBmkMapView
{
    CGRect frame = CGRectMake(0, 0, self.width, self.height);
    _bmkMapView = [[BMKMapView alloc] initWithFrame:frame];
//    _bmkMapView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    _bmkMapView.layer.borderColor = [UIColor clearColor].CGColor;
//    _bmkMapView.layer.borderWidth = 0;
    [self addSubview:_bmkMapView];
    _bmkMapView.delegate = self;
    // 设定是否显示定位图层
    _bmkMapView.showsUserLocation = NO;
    // 设置定位的状态
    _bmkMapView.userTrackingMode = BMKUserTrackingModeNone;
    _bmkMapView.zoomLevel = 16.5;
    _bmkMapView.showsUserLocation = YES;
    _bmkMapView.mapType = BMKMapTypeStandard;
}

/**
 *  定位按钮
 */
- (void)initWithBtnLocation
{
    UIImage *image = [UIImage imageNamed:@"btn_loc_nor"];
    UIButton *btnLoc = [TYZCreateCommonObject createWithButton:self imgNameNor:@"btn_loc_nor" imgNameSel:@"btn_loc_sel" targetSel:@selector(clickedLocationMap:)];
    btnLoc.size = image.size;
    btnLoc.top = 10;
    btnLoc.left = 10;
    [self addSubview:btnLoc];
}

- (void)initWithMapCurrIcon
{
    UIImage *image = [UIImage imageNamed:@"ico_map_pin"];
    _mapCurrIcon = [[UIImageView alloc] initWithImage:image];
    [self addSubview:_mapCurrIcon];
    PREPCONSTRAINTS(_mapCurrIcon);
    [self addConstraints:CONSTRAINTS_CENTERING(_mapCurrIcon)];
}

/// 初始化geo搜索服务
- (void)initWithBMKGeoCodeSearch
{
    _bmkGeoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    _bmkGeoCodeSearch.delegate = self;
}

/**
 *  根据定位，搜素用户当前的所在地址
 */
- (void)locationGeoCodeSearch
{
    debugMethod();
    if (!_bmkGeoCodeSearch.delegate)
    {
        _bmkGeoCodeSearch.delegate = self;
    }
    BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc] init];
    CLLocation *location = [[HCSLocationManager shareInstance] userLocation];
    CLLocationCoordinate2D coordinate = location.coordinate;
    if (location)
    {
        option.reverseGeoPoint = coordinate;
        if (![_bmkGeoCodeSearch reverseGeoCode:option])
        {
            NSLog(@"根据地理坐标获取地址信息 失败");
        }
    }
#if !__has_feature(objc_arc)
    [option release], option = nil;
#endif
}

- (void)locationGeoCodeSearch:(CLLocationCoordinate2D)coordinate
{
    if (!_bmkGeoCodeSearch.delegate)
    {
        _bmkGeoCodeSearch.delegate = self;
    }
    BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc] init];
    option.reverseGeoPoint = coordinate;
    if (![_bmkGeoCodeSearch reverseGeoCode:option])
    {
        NSLog(@"根据地理坐标获取地址信息 失败");
    }
#if !__has_feature(objc_arc)
    [option release], option = nil;
#endif
    
}

// 根据城市名称搜索，得到这个城市的经纬度
- (void)locationCityMapCodeSearch:(NSString *)cityName address:(NSString *)address
{
    debugLog(@"%s--cityname=%@", __func__, cityName);
    if (!_bmkGeoCodeSearch.delegate)
    {
        _bmkGeoCodeSearch.delegate = self;
    }
    BMKGeoCodeSearchOption *geocodeSearchOption = [[BMKGeoCodeSearchOption alloc] init];
    if (cityName)
    {
        geocodeSearchOption.city = cityName;
    }
    geocodeSearchOption.address = (address == nil?cityName:address);
    if (![_bmkGeoCodeSearch geoCode:geocodeSearchOption])
    {
        debugLog(@"%s--geo检索发送失败--城市：%@", __func__, cityName);
    }
    
#if !__has_feature(objc_arc)
    [geocodeSearchOption release], geocodeSearchOption = nil;
#endif
}


/** 点击定位点按钮，触发的事件 */
- (void)clickedLocationMap:(id)sender
{
//    debugMethod();
    CLLocationCoordinate2D coordinate = [[HCSLocationManager shareInstance] userLocation].coordinate;
//    debugLog(@"lon=%f; lat=%f", coordinate.longitude, coordinate.latitude);
    [_bmkMapView setCenterCoordinate:coordinate animated:YES];
}

- (void)mapViewWillAppear
{
    [_bmkMapView viewWillAppear];
    _bmkMapView.delegate = self;
    _bmkGeoCodeSearch.delegate = self;
    
    [self performSelector:@selector(clickedLocationMap:) withObject:nil afterDelay:0.5];
    
    [self performSelector:@selector(locationGeoCodeSearch) withObject:nil afterDelay:1];
}

- (void)mapViewWillDisappear
{
    [_bmkMapView viewWillDisappear];
    _bmkMapView.delegate = nil;
    _bmkGeoCodeSearch.delegate = nil;
}

#pragma mark start BMKMapViewDelegate
/**
 *地图初始化完毕时会调用此接口
 *@param mapView 地图View
 */
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView
{
    //    NSLog(@"%s--地图初始化完毕时会调用此接口", __FUNCTION__);
}

/**
 *地图区域改变完成后会调用此接口
 *@param mapView 地图View
 *@param animated 是否动画
 */
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [SVProgressHUD showWithStatus:@"更新中"];
    [self locationGeoCodeSearch:mapView.centerCoordinate];
}
#pragma mark end BMKMapViewDelegate

#pragma mark start BMKLocationServiceDelegate

- (void)didUpdateUserHeadingNote:(NSNotification *)note
{
    BMKUserLocation *userLocation = [note object];
    [_bmkMapView updateLocationData:userLocation];
}

- (void)didUpdateBMKUserLocationNote:(NSNotification *)note
{
    BMKUserLocation *userLocation = [note object];
    [_bmkMapView updateLocationData:userLocation];
}

- (void)searchAddress:(NSString *)address cityName:(NSString *)cityName
{
    [self locationCityMapCodeSearch:cityName address:address];
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
//- (void)didFailToLocateUserWithError:(NSError *)error
//{
//    debugMethod();
//}
#pragma mark end BMKLocationServiceDelegate

#pragma mark start BMKGeoCodeSearchDelegate
/**
 *返回地址信息搜索结果(根据用户输入的地址，如城市名称，得到相关信息。如经纬度)
 *@param searcher 搜索对象
 *@param result 搜索结BMKGeoCodeSearch果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    [self locationGeoCodeSearch:result.location];
    [_bmkMapView setCenterCoordinate:result.location animated:YES];
    //    CLLocationCoordinate2D coordinate = _locationService.userLocation.location.coordinate;
    //    debugLog(@"longitude=%f; latitude=%f", coordinate.longitude, coordinate.latitude);
}

/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    self.currentCityName = result.addressDetail.city;
    //    NSString *cityName = result.addressDetail.city;
    //    if (!cityName)
    //    {
    //        return;
    //    }
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:result.poiList];
    BMKPoiInfo *poiInfo = [[BMKPoiInfo alloc] init];
    poiInfo.name = @"[位置]";
    poiInfo.address = result.address;
    [array insertObject:poiInfo atIndex:0];
    if (_GetReverseGeoCodeResult)
    {
        _GetReverseGeoCodeResult(array, result.location);
    }
    if (_ReverseGeoCodeResultBlock)
    {
        _ReverseGeoCodeResultBlock(result.addressDetail.province, result.addressDetail.city, result.address, result.location);
    }
//    CC_SAFE_RELEASE_NULL(poiInfo);
//    CC_SAFE_RELEASE_NULL(array);
    //    debugLog(@"addre=%@", result.address);
    //    for (BMKPoiInfo *str in result.poiList)
    //    {
    //        debugLog(@"poiName=%@", str.name);
    //        debugLog(@"poiaddress=%@", str.address);
    //        debugLog(@"city=%@", str.city);
    //    }
    
    [SVProgressHUD dismiss];
}
#pragma mark end BMKGeoCodeSearchDelegate


@end

















