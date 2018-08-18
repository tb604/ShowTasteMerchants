//
//  OrderFoodInfoEntity.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "OrderFoodInfoEntity.h"
#import "TYZKit.h"

@implementation OrderFoodInfoEntity

//+ (NSDictionary *)modelCustomPropertyMapper
//{
//    return @{@"userSex" : @"sex"};
//}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    //    uint64_t timestamp = [dic unsignedLongLongValueForKey:@"t" default:0];
    //    self.time = [NSDate dateWithTimeIntervalSince1970:timestamp / 1000.0];
    if ([[dic allKeys] containsObject:@"food_number"])
    {
        self.number = [dic[@"food_number"] integerValue];
    }
    //    else if ([[dic allKeys] containsObject:@"userSex"])
    //    {
    //        self.userSex = dic[@"userSex"];
    //    }
    return YES;
}
//- (void)modelCustomTransformToDictionary:(NSMutableDictionary *)dic
//{
//    debugLog(@"444");
//    //    dic[@"t"] = @([self.time timeIntervalSince1970] * 1000).description;
//}

@end
