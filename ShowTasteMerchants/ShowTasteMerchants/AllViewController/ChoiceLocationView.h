//
//  ChoiceLocationView.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/8.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"
#import <CoreLocation/CoreLocation.h>

@interface ChoiceLocationView : TYZBaseView

@property (nonatomic, copy) void (^ReverseGeoCodeResultBlock)(NSString *province, NSString *city, NSString *address, CLLocationCoordinate2D coordinate);

/**
 *  数据
 */
@property (nonatomic, copy) void(^GetReverseGeoCodeResult)(NSArray *poiList, CLLocationCoordinate2D coordinate);

- (void)mapViewWillAppear;

- (void)mapViewWillDisappear;

- (void)searchAddress:(NSString *)address cityName:(NSString *)cityName;
@end
