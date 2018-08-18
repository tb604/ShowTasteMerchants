//
//  ShopRecommendDataEntity.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/1.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopRecommendDataEntity.h"
#import "NSObject+TYZModel.h"

@implementation ShopRecommendDataEntity

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"images" : [NSString class]};
}

//+ (NSDictionary *)modelCustomPropertyMapper
//{
//    return @{@"imageId" : @"id"};
//}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self modelEncodeWithCoder:aCoder];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    return [self modelInitWithCoder:aDecoder];
}
- (id)copyWithZone:(NSZone *)zone
{
    return [self modelCopy];
}
- (NSUInteger)hash
{
    return [self modelHash];
}
- (BOOL)isEqual:(id)object
{
    return [self modelIsEqual:object];
}


@end