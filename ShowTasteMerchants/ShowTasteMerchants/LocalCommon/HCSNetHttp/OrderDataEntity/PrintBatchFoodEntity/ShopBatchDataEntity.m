//
//  ShopBatchDataEntity.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/6.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopBatchDataEntity.h"

@implementation ShopBatchDataEntity

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"foods" : [OrderFoodInfoEntity class]};
}

@end
