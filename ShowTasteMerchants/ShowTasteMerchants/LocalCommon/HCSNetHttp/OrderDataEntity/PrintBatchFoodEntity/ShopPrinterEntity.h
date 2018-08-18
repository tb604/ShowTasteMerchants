//
//  ShopPrinterEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/9/6.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShopBatchDataEntity.h"

@interface ShopPrinterEntity : NSObject

@property (nonatomic, assign) NSInteger printer_id;

@property (nonatomic, copy) NSString *printer_name;

@property (nonatomic, strong) NSMutableArray *batch_foods;

@end


















