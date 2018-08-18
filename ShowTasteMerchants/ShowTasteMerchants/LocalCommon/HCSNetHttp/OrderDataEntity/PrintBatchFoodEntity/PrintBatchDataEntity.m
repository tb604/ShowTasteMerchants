//
//  PrintBatchDataEntity.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "PrintBatchDataEntity.h"

@implementation PrintBatchDataEntity

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"printers" : [ShopPrinterDataEntity class]};
}


@end
