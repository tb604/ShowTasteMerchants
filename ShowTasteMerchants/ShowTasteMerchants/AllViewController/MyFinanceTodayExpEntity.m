//
//  MyFinanceTodayExpEntity.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/19.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyFinanceTodayExpEntity.h"

@implementation MyFinanceTodayExpEntity

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"records" : [MyFinanceTodayExpListEntity class]};
}

@end