//
//  ShopManagePositionAuthEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/8/2.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShopPositionDataEntity.h"

@interface ShopManagePositionAuthEntity : NSObject

/**
 *  权限列表
 */
@property (nonatomic, strong) NSArray *auth;

/**
 *  职位列表
 */
@property (nonatomic, strong) NSArray *title;


/**
 *  权限列表(new)
 */
@property (nonatomic, strong) NSArray *roles;

/**
 *  职位列表(new)
 */
@property (nonatomic, strong) NSArray *titles;

@end
