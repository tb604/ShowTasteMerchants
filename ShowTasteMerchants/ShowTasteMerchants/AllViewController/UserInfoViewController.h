//
//  UserInfoViewController.h
//  ChefDating
//
//  Created by 唐斌 on 16/5/27.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewController.h"

@class UserInfoDataEntity;


typedef NS_ENUM(NSInteger, EN_USER_INFO_ROWS)
{
    EN_USER_INFO_NAME_ROW = 0, ///< 姓名
    EN_USER_INFO_SEX_ROW,   ///< 性别
    EN_USER_INFO_BIRTHDAY_ROW, ///< 出生日期
    EN_USER_INFO_PHONE_ROW, ///< 手机号码
    EN_USER_INFO_IDCARD_ROW,  ///< 身份证号
    EN_USER_INFO_THIRDPAY_ROW, ///< 第三方支付
    EN_USER_INFO_MAX_ROW
};

/**
 *  用户个人信息视图控制器
 */
@interface UserInfoViewController : TYZBaseTableViewController

/**
 *  用户信息
 */
@property (nonatomic, strong) UserInfoDataEntity *userInfoEntity;

@end




























