//
//  ShopMouthDataEntity.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/1.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopMouthDataEntity.h"

@implementation ShopMouthDataEntity
+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"foods" : [ShopFoodDataEntity class]};
}

@end
