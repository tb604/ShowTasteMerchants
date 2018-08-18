//
//  UserInfoDataEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/5/27.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

//保存用户当前地图所在的信息，包括用户选择的城市名称
#define kCacheUserInfoFileName @"UserInfoCacheData.plist"
#define kCacheUserInfoData @"UserInfoData"


@interface UserInfoDataEntity : NSObject

/**
 *  用户Id
 */
@property (nonatomic, assign) NSInteger user_id;

/**
 *  城市id
 */
@property (nonatomic, assign) NSInteger city_id;

/**
 *  姓氏
 */
@property (nonatomic, copy) NSString *family_name;

/**
 *  名
 */
@property (nonatomic, copy) NSString *name;

/**
 *  昵称
 */
@property (nonatomic, copy) NSString *nikename;

/// 用户姓名
@property (nonatomic, copy) NSString *username;

/**
 *  性别。0女；1男
 */
@property (nonatomic, assign) NSInteger sex;

/**
 *  余额
 */
@property (nonatomic, assign) float balance;

/**
 *  手机号码
 */
@property (nonatomic, copy) NSString *mobile;

/**
 *  头像
 */
@property (nonatomic, copy) NSString *avatar;

/**
 *  用户类型  1 普通用户 2 开店用户 4 推广者
 */
@property (nonatomic, assign) NSInteger user_type;

/**
 *  餐厅id
 */
@property (nonatomic, assign) NSInteger shop_id;

/// 餐厅名称
@property (nonatomic, copy) NSString *shop_name;

/**
 *  当前餐厅的状态 1完成开店前三部 未发布；2上传资质，待审核；3审核失败；4审核通过；5餐厅已发布；6餐厅下架
 */
@property (nonatomic, assign) NSInteger shop_state;

/// 员工数
@property (nonatomic, assign) NSInteger shop_employee_count;

/**
 *  当前餐厅的状态 1完成开店前三部 未发布；2上传资质，待审核；3审核失败；4审核通过；5餐厅已发布；6餐厅下架
 */
//@property (nonatomic, assign) NSInteger state;

/**
 *  访问的token
 */
@property (nonatomic, copy) NSString *access_token;


// 自己加的，要看看跟实际的是否一样
/**
 *  出生年月日
 */
@property (nonatomic, copy) NSString *birthday;

/**
 *  邮箱
 */
@property (nonatomic, copy) NSString *email;

@property (nonatomic, copy) NSString *password;

/**
 *  用户模式 0普通模式；1经营模式
 */
@property (nonatomic, assign) NSInteger userMode;

/**
 *  身份证号
 */
@property (nonatomic, copy) NSString *identity_card;

/**
 *  第三方支付(支付方式) 0 微信 和 1 支付宝
 */
@property (nonatomic, assign) NSInteger pay_type;

/**
 *  支付账号
 */
@property (nonatomic, copy) NSString *pay_account;

/**
 *  邀请码
 */
@property (nonatomic, copy) NSString *invite_code;

/**
 *  融云token
 */
@property (nonatomic, copy) NSString *msg_token;

/// 职位名称
@property (nonatomic, copy) NSString *title_name;

/// 用户角色
@property (nonatomic, copy) NSString *role_name;

/**
 *  用户角色(在首页显示的功能哪些功能模块)--等级
 *  1(101/102/103)；2(100)；3(101,102,103,1)；4(100,1)；5(100,201,202,203,204)；6(200,100,1)；老板(200,100,300)；管理员权限(0)
 */
@property (nonatomic, assign) NSInteger role_id;

/// 权限(在首页显示的功能)
@property (nonatomic, strong) NSArray *role_permissions;

/// 商户id
@property (nonatomic, assign) NSInteger seller_id;

//role_id
//role_permissions

@end






















