//
//  HungryOrderDetailCategoryExtraEntity.m
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/16.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "HungryOrderDetailCategoryExtraEntity.h"
#import "TYZKit.h"

@implementation HungryOrderDetailCategoryExtraEntity

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"desc" : @"description"};
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    if ([[dic allKeys] containsObject:@"reduce_fee"])
    {// 活动优惠金额，是美团承担活动费用和商户承担活动费用的总和
        self.price = [dic[@"reduce_fee"] floatValue];
    }
    
    if ([[dic allKeys] containsObject:@"remark"])
    {// 优惠说明（满10元减2.5元）
        self.name = objectNull(dic[@"remark"]);
        self.desc = objectNull(dic[@"remark"]);
    }
    
    if ([[dic allKeys] containsObject:@"type"])
    {// 活动类型
        self.type = [dic[@"type"] integerValue];
    }
    
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self modelEncodeWithCoder:aCoder];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    return [self modelInitWithCoder:aDecoder];
}
- (id)copyWithZone:(NSZone *)zone
{
    return [self modelCopy];
}
- (NSUInteger)hash
{
    return [self modelHash];
}
- (BOOL)isEqual:(id)object
{
    return [self modelIsEqual:object];
}

@end
