//
//  ShopManageInputEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/8/2.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  餐厅管理的，传入参数
 */
@interface ShopManageInputEntity : NSObject

/**
 * 权限信息id
 */
@property (nonatomic, assign) NSInteger id;

/**
 * 餐厅id
 */
@property (nonatomic, assign) NSInteger shopId;

/**
 * 被操作的用户id
 */
@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, copy) NSString *userName;

/**
 * 当前操作的用户id
 */
@property (nonatomic, assign) NSInteger opUserId;

/// 商户id
@property (nonatomic, assign) NSInteger sellerId;

/**
 *  角色权限id
 */
@property (nonatomic, assign) NSInteger auth;

@property (nonatomic, copy) NSString *authName;

/**
 *  工位(职位)id
 */
@property (nonatomic, assign) NSInteger title;

@property (nonatomic, copy) NSString *titleName;

/**
 *  手机号码
 */
@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *password;

@property (nonatomic, strong) NSMutableArray *shopList;

@end





























