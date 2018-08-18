//
//  ShopingCartEntity.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/25.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopingCartEntity.h"
#import "TYZKit.h"

@implementation ShopingCartEntity

//+ (NSDictionary *)modelContainerPropertyGenericClass
//{
//    return @{@"photos" : [TYZPhoto class], @"likedUsers" : [TYZUser class], @"likedUserIds" : [NSNumber class]};
//}


//+ (NSDictionary *)modelCustomPropertyMapper
//{
//    return @{@"messageId" : @"i", @"content" : @"c", @"time" : @"t"};
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
