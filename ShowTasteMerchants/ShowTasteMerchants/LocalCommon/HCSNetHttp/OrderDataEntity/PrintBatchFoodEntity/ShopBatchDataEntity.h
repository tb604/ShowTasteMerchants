//
//  ShopBatchDataEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/9/6.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderFoodInfoEntity.h"

@interface ShopBatchDataEntity : NSObject

/**
 *  是否选中；NO没有选中
 */
@property (nonatomic, assign) BOOL isCheck;

@property (nonatomic, copy) NSString *batch_no;

@property (nonatomic, copy) NSString *timestamp;

@property (nonatomic, strong) NSArray *foods;

@property (nonatomic, strong) NSIndexPath *indexPath;

@end

// {"batch_no":"09\/06 17:11","foods":[{"food_id":11,"food_name":"六合猪头肉"}]}














