//
//  ShopPositionDataEntity.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/2.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopPositionDataEntity.h"

@implementation ShopPositionDataEntity

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
//    NSLog(@"dic=%@", dic);
    if ([[dic allKeys] containsObject:@"title_id"])
    {
        self.id = [dic[@"title_id"] integerValue];
    }
    if ([[dic allKeys] containsObject:@"role_id"])
    {
        self.id = [dic[@"role_id"] integerValue];
    }
    if ([[dic allKeys] containsObject:@"title_name"])
    {
//        NSLog(@"titlename=%@", dic[@"title_name"]);
        self.name = dic[@"title_name"];
    }
    if ([[dic allKeys] containsObject:@"role_name"])
    {
        self.name = dic[@"role_name"];
    }
    
    return YES;
}

@end
