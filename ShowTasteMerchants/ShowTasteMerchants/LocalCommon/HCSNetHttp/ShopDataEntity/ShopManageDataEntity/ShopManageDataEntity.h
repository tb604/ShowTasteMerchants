//
//  ShopManageDataEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/8/2.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  餐厅管理信息列表
 */
@interface ShopManageDataEntity : NSObject

@property (nonatomic, assign) NSInteger id;

/**
 *  餐厅id
 */
@property (nonatomic, assign) NSInteger shop_id;

/**
 *  用户id
 */
@property (nonatomic, assign) NSInteger user_id;

/**
 *  用户姓名
 */
@property (nonatomic, copy) NSString *user_name;

/**
 *  电话
 */
@property (nonatomic, copy) NSString *user_mobile;

/**
 *  职位id
 */
@property (nonatomic, assign) NSInteger user_title_id;

/**
 *  用户职位描述
 */
@property (nonatomic, copy) NSString *user_title;

/**
 *  权限id
 */
@property (nonatomic, assign) NSInteger user_auth_id;

/**
 *  权限描述
 */
@property (nonatomic, copy) NSString *user_auth;

@end


/*
 "id": 2,
 "shop_id": 1,
 "user_id": 6,
 "user_name": "暂无",
 "user_mobile": "15221673616",
 "user_title_id": 1,
 "user_title": "店长",
 "user_auth_id": 1,
 "user_auth": "高级"
 */
























