//
//  RestaurantDetailDataEntity.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/20.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "RestaurantDetailDataEntity.h"

@implementation RestaurantDetailDataEntity

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"images" : [RestaurantImageEntity class]};
}


@end