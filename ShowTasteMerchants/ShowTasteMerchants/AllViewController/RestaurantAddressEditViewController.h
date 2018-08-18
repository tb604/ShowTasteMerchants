//
//  RestaurantAddressEditViewController.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface RestaurantAddressEditViewController : TYZBaseViewController

/**
 *  用户选择的位置信息
 */
@property (nonatomic, copy) void (^ChoiceLocationInfoBlock)(NSString *name, NSString *address, CLLocationCoordinate2D coordinate);

/**
 *  是否有搜索
 */
@property (nonatomic, assign) BOOL isSearch;

@property (nonatomic, copy) NSString *cityName;

@end
