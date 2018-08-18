//
//  HungryOrderDetailCategoryEntity.m
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/16.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "HungryOrderDetailCategoryEntity.h"
#import "NSObject+TYZModel.h"

@implementation HungryOrderDetailCategoryEntity

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"newgroups":[NSMutableArray class], @"group" : [NSArray class], @"newextra":[HungryOrderDetailCategoryExtraEntity class], @"extra":[HungryOrderDetailCategoryExtraEntity class]};
}

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
