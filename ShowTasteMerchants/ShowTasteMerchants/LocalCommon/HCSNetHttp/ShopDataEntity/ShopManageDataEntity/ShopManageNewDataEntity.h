/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: ShopManageNewDataEntity.h
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/26 14:32
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import <Foundation/Foundation.h>

@interface ShopManageNewDataEntity : NSObject

@property (nonatomic, assign) NSInteger shop_id;

/// 商户id
@property (nonatomic, assign) NSInteger seller_id;

/// 用户id
@property (nonatomic, assign) NSInteger user_id;

/// 用户姓名
@property (nonatomic, copy) NSString *username;

/// 职位id
@property (nonatomic, assign) NSInteger title_id;

/// 职位
@property (nonatomic, copy) NSString *title_name;

/// 手机号码
@property (nonatomic, copy) NSString *mobile;

/// 角色id
@property (nonatomic, assign) NSInteger role_id;

/// 权限
@property (nonatomic, copy) NSString *role_name;


@property (nonatomic, strong) NSArray *shopList;

@end

/*
 title_id":1,"role_id
 "user_id": 1,
 "username": "唐斌",
 "title_name": "老板",
 "mobile": "18261929604",
 "role_name": "高级权限"
 */















