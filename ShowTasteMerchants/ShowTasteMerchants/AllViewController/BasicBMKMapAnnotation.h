//
//  BasicBMKMapAnnotation.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/2.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Map/BMKAnnotation.h>

@interface BasicBMKMapAnnotation : NSObject <BMKAnnotation>

/**
 *  标题
 */
@property (nonatomic, copy) NSString *title;

/**
 *  副标题
 */
@property (nonatomic, copy) NSString *subtitle;

/**
 *  纬度
 */
@property (nonatomic, assign) double latitude;

/**
 *  经度
 */
@property (nonatomic, assign) double longitude;

@property (nonatomic, assign) NSInteger tag;

/**
 *  设置标注的坐标，在拖拽时会被调用
 *
 *  @param newCoordinate 新的坐标值
 */
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

- (id)initWithLatitude:(CLLocationDegrees)latitude
          andLongitude:(CLLocationDegrees)longitude;

@end
