//
//  ShopSeatInfoEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/8/27.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  餐厅位置信息(包间，大厅)
 */
@interface ShopSeatInfoEntity : NSObject

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *remark;

/**
 *  YES表示添加；NO表示修改
 */
@property (nonatomic, assign) BOOL isAdd;

@end
