//
//  ShopFoodDataEntity.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/1.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopFoodDataEntity.h"

@implementation ShopFoodDataEntity

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"content" : [ShopFoodImageEntity class]};
}


@end
