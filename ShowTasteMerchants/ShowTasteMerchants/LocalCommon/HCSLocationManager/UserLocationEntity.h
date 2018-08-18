//
//  UserLocationEntity.h
//  51tourGuide
//
//  Created by 唐斌 on 16/3/23.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


//保存用户当前地图所在的信息，包括用户选择的城市名称
#define kCacheLocationFileName @"LocationCacheData.plist"
#define kCacheLocationData @"LocationData"

@interface UserLocationEntity : NSObject <NSCoding, NSCopying>

/**
 *  用户所在的省份名称
 */
@property (nonatomic, copy) NSString *currentProvince;

/**
 *  选择的省份名称
 */
@property (nonatomic, copy) NSString *choiceProvince;

/**
 *  用户当前的城市名称
 */
@property (nonatomic, copy) NSString *currentCity;
//debugLog(@"country=%@; state=%@; city=%@; area=%@; address=%@;", country, state, city, area, address);
/**
 *  用户选择的城市名称
 */
@property (nonatomic, copy)NSString *choiceCity;

/// 区县名称(用户当前的)
@property (nonatomic, copy) NSString *district;

///地址名称号码(用户当前的)
@property (nonatomic, copy) NSString *address;

/**
 *  经度(用户当前的)
 */
@property (nonatomic, assign) double longitude;

/**
 *  纬度(用户当前的)
 */
@property (nonatomic, assign) double latitude;

/**
 *  用户选择城市的经度
 */
@property (nonatomic, assign) double choiceLongitude;

/**
 *  用户选择城市的纬度
 */
@property (nonatomic, assign) double choiceLatitude;

/**
 *  定位状态，3表示允许定位；其他表示不允许定位
 */
@property (nonatomic, assign) NSInteger locationStatus;

@property (nonatomic, assign) NSInteger cityId;

/**
 *  导游抢单，是否开通城市，0未开通；1已开通
 */
@property (nonatomic, assign) NSInteger  guideFlag;

/**
 *  用户当前的位置
 *
 *  @return 返回位置
 */
- (CLLocationCoordinate2D)currentLocation;

/**
 *  用户选择城市的位置
 *
 *  @return 返回位置
 */
- (CLLocationCoordinate2D)choiceLocation;

/**
 *  当前城市，跟用户选择的城市是否相同
 *
 *  @return <#return value description#>
 */
- (BOOL)currentCityIsEqualChoiceCity;

@end
