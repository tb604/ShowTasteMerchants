//
//  UserInfoModifyViewController.h
//  ChefDating
//
//  Created by 唐斌 on 16/5/28.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewController.h"

@class UserInfoDataEntity;

typedef NS_ENUM(NSInteger, EN_UIM_USERINFO_SECTIONS)
{
    EN_UIM_USERINFO_BASE_SECTION = 0,  ///< 个人基本信息
    EN_UIM_USERINFO_PRIVATE_SECTION, ///< 个人私密信息
    EN_UIM_USERINFO_MAX_SECTION
};

typedef NS_ENUM(NSInteger, EN_UIM_BASEINFO_ROWS)
{
    EN_UIM_BASEINFO_NAME_ROW = 0, ///< 姓名
    EN_UIM_BASEINFO_SEX_ROW, ///< 性别
    EN_UIM_BASEINFO_BIRTHDAY_ROW, ///< 出生日期
    EN_UIM_BASEINFO_PHONE_ROW, ///< 手机号码
    EN_UIM_BASEINFO_MAIL_ROW, ///< 邮箱
    EN_UIM_BASEINFO_PASSWORD_ROW, ///< 密码
    EN_UIM_BASEINFO_MAX_ROW
};

typedef NS_ENUM(NSInteger, EN_UIM_PRIVATEINFO_ROWS)
{
    EN_UIM_PRIVATEINFO_IDCARD_ROW = 0, ///< 身份证号
    EN_UIM_PRIVATEINFO_THIRDPAY_ROW,  ///< 第三方支付
    EN_UIM_PRIVATEINFO_MAX_ROW
};


/**
 *  用户信息编辑
 */
@interface UserInfoModifyViewController : TYZBaseTableViewController


@property (nonatomic, strong) UserInfoDataEntity *userInfoEntity;

@end



























