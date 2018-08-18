//
//  ShopPrinterEntity.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/6.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopPrinterEntity.h"

@implementation ShopPrinterEntity

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"batch_foods" : [ShopBatchDataEntity class]};
}

@end
