//
//  CellCommonDataEntity.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/16.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "CellCommonDataEntity.h"

@implementation CellCommonDataEntity
+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"title" : @"reason", @"tag":@"id"};
}

@end
