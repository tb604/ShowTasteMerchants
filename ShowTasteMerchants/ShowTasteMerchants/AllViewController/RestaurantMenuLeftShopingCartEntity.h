//
//  RestaurantMenuLeftShopingCartEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/9/1.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface RestaurantMenuLeftShopingCartEntity : NSObject

@property (nonatomic, assign) NSInteger categoryId;

/**
 *  YES表示添加；NO表示减少
 */
@property (nonatomic, assign) BOOL isAdd;

@end
NS_ASSUME_NONNULL_END