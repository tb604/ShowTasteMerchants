//
//  OrderMealDataEntity.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "OrderMealDataEntity.h"
#import "NSObject+TYZModel.h"

@implementation OrderMealDataEntity
//+ (NSDictionary *)modelContainerPropertyGenericClass
//{
//    return @{@"banners" : [OrderMealBannerEntity class], @"recommends" : [OrderMealRecommendEntity class], @"borads" : [OrderMealBoradEntity class], @"nearbys":[OrderMealRecommendEntity class]};
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
