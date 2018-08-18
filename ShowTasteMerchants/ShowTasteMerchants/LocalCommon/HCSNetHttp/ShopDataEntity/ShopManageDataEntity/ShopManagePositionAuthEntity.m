//
//  ShopManagePositionAuthEntity.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/2.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopManagePositionAuthEntity.h"

@implementation ShopManagePositionAuthEntity


+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"auth" : [ShopPositionDataEntity class], @"title" : [ShopPositionDataEntity class], @"roles":[ShopPositionDataEntity class], @"titles":[ShopPositionDataEntity class]};
}


@end
