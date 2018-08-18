//
//  HungryOrdersEntity.m
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/23.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "HungryOrdersEntity.h"
#import "NSObject+TYZModel.h"

@implementation HungryOrdersEntity

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"orderIds" : [NSString class]};
}

@end

//\"platform\":\"ele\",\"orderIds\":[\"101582797453145710\"]
