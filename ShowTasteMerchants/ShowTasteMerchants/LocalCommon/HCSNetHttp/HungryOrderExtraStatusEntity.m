//
//  HungryOrderExtraStatusEntity.m
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/24.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "HungryOrderExtraStatusEntity.h"
#import "NSObject+TYZModel.h"

@implementation HungryOrderExtraStatusEntity

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"desc" : @"description"};
}

@end
