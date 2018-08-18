//
//  HCSLocationManager.h
//  ChefDating
//
//  Created by 唐斌 on 16/5/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "UserLocationEntity.h"
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>

#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Base/BMKMapManager.h>
#import <BaiduMapAPI_Base/BMKUserLocation.h>
#import <BaiduMapAPI_Search/BMKShareUrlSearchOption.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearchOption.h>
#import <BaiduMapAPI_Search/BMKSearchBase.h>


#import "UserLocationEntity.h"
#import "CityDataEntity.h"

// 搜索到城市后调用
//#define kReverseGeocodeNote @"ReverseGeocodeNote"


@interface HCSLocationManager : NSObject

/**
 *  当城市发生变化的时候，是否提示alertview
 */
@property (nonatomic, assign) BOOL isTipAlertView;

/**
 *  返回地址信息搜索结果
 */
@property (nonatomic, copy) void (^onGetGeoCodeResultBlock)(BMKGeoCodeSearch * searcher, BMKGeoCodeResult *result, BMKSearchErrorCode errorCode);

/**
 *  返回反地理编码搜索结果
 */
@property (nonatomic, copy) void (^onGetReverseGeoCodeResultBlock)(BMKGeoCodeSearch * searcher, BMKReverseGeoCodeResult *result, BMKSearchErrorCode errorCode);

/**
 *  切换城市名称
 */
@property (nonatomic, copy) void (^switchCityNameBlock)(CityDataEntity *cityEnt);

@property (nonatomic, copy) void(^currentCityInfoBlock)(CityDataEntity *cityEnt, NSInteger errorCode);

/**
 *  定位状态；NO表示定位失败；YES表示定位成功
 */
@property (nonatomic, assign, readonly) BOOL locationState;

@property (nonatomic, assign, readonly) int authorizeStatus;

+ (HCSLocationManager *)shareInstance;

/**
 *  初始化百度地址manager
 */
- (void)initWithBaiduMapManager;

- (void)initWithBMKGeoCodeSearch;

/**
 *  判断用户有无打开定位功能，如果没有打开，提示用户打开定位功能,YES表示打开定位功能了
 */
- (int)authorizationStatus;

/**
 *  当视图将要显示的时候调用
 */
- (void)BMKviewWillAppear;

/**
 *  当视图将要不显示的时候调用
 */
- (void)BMKviewWillDisappear;


/**
 *  打开定位服务
 */
- (void)startLocation;

/**
 *  关闭定位服务
 */
- (void)stopLocation;

//- (void)reverseGeocode:(CLLocation *)location reverseInfo:(void(^)(UserLocationEntity *locationEnt))reverseInfo;

/**
 *  根据关键字查询信息
 *
 *  @param strKey 比如城市名；地名呀
 */
//- (void)geocodeQuery:(NSString *)strKey reverseInfo:(void(^)(UserLocationEntity *locationEnt))reverseInfo;

/**
 *  根据定位，搜索用户的位置
 *
 *  @param coordinate 如果coordinate都是0表示用户当前位置
 *  @param isiniSwitch 是否是主动切换
 */
- (void)locationGetCodeSearch:(CLLocationCoordinate2D)coordinate isiniSwitch:(BOOL)isiniSwitch;

/**
 *  根据关键字定位
 *
 *  @param key key
 *  @param isiniSwitch 是否是主动切换
 */
- (void)locationCodeSearchKey:(NSString *)key isCity:(BOOL)isCity isiniSwitch:(BOOL)isiniSwitch;


/**
 *  保存实体对象
 *
 *  @param entity 实体类
 */
- (void)saveUserLocationInfo:(UserLocationEntity *)entity;

/**
 *  保存城市id
 *
 *  @param cityEnt 城市信息
 */
- (void)saveWithCityInfo:(CityDataEntity *)cityEnt;

/**
 *  读取城市id
 *
 *  @return return value description
 */
- (CityDataEntity *)readWithCityInfo;

/**
 *  读取地址
 *
 *  @return return value description
 */
- (NSString *)readWithAddress;

/**
 *  获取用户定位的信息
 *
 *  @return return value description
 */
- (UserLocationEntity *)readUserLocationInfo;

- (CLLocation *)userLocation;

/**
 *  读取城市名称
 */
- (NSString *)readCityName;

/**
 *  保存用户选择的城市信息
 *
 *  @param cityEnt 城市信息
 */
- (void)saveUserChoiceCityInfo:(CityDataEntity *)cityEnt;



@end
