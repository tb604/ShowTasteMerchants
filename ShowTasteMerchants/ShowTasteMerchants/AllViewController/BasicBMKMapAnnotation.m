//
//  BasicBMKMapAnnotation.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/2.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "BasicBMKMapAnnotation.h"

@implementation BasicBMKMapAnnotation

- (id)initWithLatitude:(CLLocationDegrees)latitude
          andLongitude:(CLLocationDegrees)longitude
{
    if (self = [super init])
    {
        self.latitude = latitude;
        self.longitude = longitude;
    }
    return self;
}

// 标注view中心坐标(重写基类的)
- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = self.latitude;
    coordinate.longitude = self.longitude;
    return coordinate;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    self.latitude = newCoordinate.latitude;
    self.longitude = newCoordinate.longitude;
}


@end
