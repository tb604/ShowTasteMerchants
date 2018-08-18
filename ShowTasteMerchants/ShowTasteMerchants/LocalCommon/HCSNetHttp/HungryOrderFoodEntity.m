//
//  HungryOrderFoodEntity.m
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/16.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "HungryOrderFoodEntity.h"
#import "TYZKit.h"

@implementation HungryOrderFoodEntity

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"garnish" : [HungryOrderFoodEntity class], @"specs":[NSString class]};
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    if ([[dic allKeys] containsObject:@"app_food_code"])
    {// erp方菜品id(等价于eDishCode)
        self.id = [dic[@"app_food_code"] integerValue];
    }
    
    if ([[dic allKeys] containsObject:@"food_name"])
    {// 菜品名称
        self.name = objectNull(dic[@"food_name"]);
    }
    
    if ([[dic allKeys] containsObject:@"price"])
    {// 价格
        self.price = [dic[@"price"] floatValue];
    }
    
    if ([[dic allKeys] containsObject:@"quantity"])
    {// 数量
        self.quantity = [dic[@"quantity"] intValue];
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
