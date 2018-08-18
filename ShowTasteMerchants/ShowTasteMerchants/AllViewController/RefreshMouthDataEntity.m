//
//  RefreshMouthDataEntity.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/5.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "RefreshMouthDataEntity.h"

@implementation RefreshMouthDataEntity

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"printers" : [RefreshMouthFoodEntity class]};
}

@end
