//
//  ShopPrinterDataEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/8/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderFoodInfoEntity.h"

@interface ShopPrinterDataEntity : NSObject

/**
 *  是否选中；NO没有选中
 */
@property (nonatomic, assign) BOOL isCheck;

/**
 *
 */
@property (nonatomic, assign) NSInteger printer_id;

/**
 *
 */
@property (nonatomic, copy) NSString *printer_name;

@property (nonatomic, strong) NSArray *foods;

@property (nonatomic, strong) NSIndexPath *indexPath;

@end



























