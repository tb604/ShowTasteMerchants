//
//  CommentInfoDataEntity.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/31.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "CommentInfoDataEntity.h"

@implementation CommentInfoDataEntity
+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"images" : [RestaurantImageEntity class]};
}

@end
