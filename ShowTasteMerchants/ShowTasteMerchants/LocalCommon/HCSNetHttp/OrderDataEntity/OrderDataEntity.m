//
//  OrderDataEntity.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/19.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "OrderDataEntity.h"

@implementation OrderDataEntity

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    if ([[dic allKeys] containsObject:@"status_desc"])
    {
        self.status_remark = dic[@"status_desc"];
    }
    if ([[dic allKeys] containsObject:@"type_desc"])
    {
        self.type_name = dic[@"type_desc"];
    }
    if ([[dic allKeys] containsObject:@"user_name"])
    {
        NSString *sname = dic[@"user_name"];
        if ([sname isEqualToString:@"<null>"])
        {
            sname = @"";
        }
//        NSLog(@"sname=%@", sname);
        self.name = sname;
    }
    if ([[dic allKeys] containsObject:@"user_mobile"])
    {
        self.mobile = dic[@"user_mobile"];
    }
    if ([[dic allKeys] containsObject:@"total_amount"])
    {
        self.total_price = [dic[@"total_amount"] floatValue];
    }
    if ([[dic allKeys] containsObject:@"eater_count"])
    {
        self.number = [dic[@"eater_count"] integerValue];
    }
    if ([[dic allKeys] containsObject:@"total_amount"])
    {// 实付金额
        self.pay_actually = [dic[@"total_amount"] floatValue];
    }
    
    if ([[dic allKeys] containsObject:@"seat_type_desc"])
    {
        self.seat_type_name = dic[@"seat_type_desc"];
    }
    
    return YES;
}

@end









