//
//  MallRangDataEntity.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/20.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MallRangDataEntity.h"

@implementation MallRangDataEntity

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"rangs" : [RangDataEntity class], @"areas" : [MallDataEntity class]};
}


@end
