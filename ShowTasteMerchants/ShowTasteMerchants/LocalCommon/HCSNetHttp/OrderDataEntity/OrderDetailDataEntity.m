//
//  OrderDetailDataEntity.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "OrderDetailDataEntity.h"

@implementation OrderDetailDataEntity

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"details" : [OrderFoodInfoEntity class]};
}


@end
