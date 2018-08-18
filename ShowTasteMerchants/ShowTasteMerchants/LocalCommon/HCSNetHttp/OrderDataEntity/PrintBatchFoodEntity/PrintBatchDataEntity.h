//
//  PrintBatchDataEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/8/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShopPrinterDataEntity.h"

@interface PrintBatchDataEntity : NSObject

/**
 *
 */
@property (nonatomic, copy) NSString *batch_no;

/**
 *
 */
@property (nonatomic, copy) NSString *batch_no_date;

/**
 *
 */
@property (nonatomic, strong) NSMutableArray *printers;


@end






















