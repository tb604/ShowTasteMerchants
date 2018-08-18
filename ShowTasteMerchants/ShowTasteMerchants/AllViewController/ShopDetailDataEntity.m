//
//  ShopDetailDataEntity.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/1.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopDetailDataEntity.h"
#import "NSObject+TYZModel.h"

@implementation ShopDetailDataEntity


+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"recommends" : [ShopRecommendDataEntity class], @"comments" : [CommentInfoDataEntity class]};
    
    // CommentInfoDataEntity
    // ShopCommentDataEntity
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
