//
//  UserLoginStateObject.h
//  ChefDating
//
//  Created by 唐斌 on 16/5/27.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UserInfoDataEntity.h"
#import "TYZUserDataManager.h"
#import "UserDataKeyChain.h"


//@class UserDataKeyChain;
//@class UserInfoDataEntity;

typedef NS_ENUM(NSInteger, EUserLoginState)
{
    EUserUnlogin = 0,       /// 用户没有登录
    EUserLogined            /// 用户已登录了
};


@interface UserLoginStateObject : NSObject

/**
 *  得到用户登录的状态
 *
 *  @return EUserLogined表示没有登录；EUserUnlogin表示登录
 */
+ (NSInteger)userLoginState;

+ (NSString *)deviceToken;

+ (void)saveWithDeviceToken:(NSString *)token;

/**
 *  得到保存的信息
 *
 *  @return <#return value description#>
 */
+ (UserDataKeyChain *)getUserInfoDataKeyChain;

/**
 *  保存
 */
+ (void)saveUserDataKeyChainData:(NSDictionary *)userData;


/**
 *  获取用户信息
 *
 *  @return 用户信息
 */
+ (UserInfoDataEntity *)getUserInfo;

/**
 *  保存用户信息
 *
 *  @param userInfo userInfo description
 */
+ (void)saveWithUserInfo:(UserInfoDataEntity *)userInfo;

+ (void)saveWithPhone:(NSString *)phone;

/**
 *  保存用户登录类型
 *
 *  @param type 1表示老板登录；2表示员工登录
 */
+ (void)saveWithUserLoginType:(NSInteger)type;

/**
 *  读取用户登录类型
 *
 *  @return 返回用户登录类型(1表示老板登录；2表示员工登录)
 */
+ (NSInteger)readWithUserLoginType;

/**
 *  保存登录状态
 *
 *  @param loginState 0未登录；1已登录
 */
+ (void)saveLoginState:(NSInteger)loginState;

/**
 *  得到用户id
 *
 *  @return 返回用户id
 */
+ (NSInteger)getUserId;

/**
 *  活的用户手机号码
 *
 *  @return 返回用户手机号码
 */
+ (NSString *)getUserMobile;

/// 得到头像的url
+ (NSString *)getUserHeadIcon;

/**
 *  昵称
 *
 *  @return 返回昵称
 */
+ (NSString *)getUserNickName;

/**
 *  得到当前餐厅id
 *
 *  @return 餐厅id
 */
+ (NSInteger)getCurrentShopId;

+ (void)saveWithCurrentShopId:(NSInteger)shopId;

/**
 *  获取当前餐厅名称
 */
+ (NSString *)getCurrentShopName;

/**
 *  保存当前餐厅名称
 *
 */
+ (void)saveWithCurrentShopName:(NSString *)shopName;

/**
 *  得到餐厅对应的状态
 *
 *  @return 餐厅当前状态
 */
+ (NSInteger)getWithCurrentState;

/**
 *  保存餐厅对应的状态
 *
 *  @param state 状态
 */
+ (void)saveWithShopState:(NSInteger)state;


+ (NSString *)getWithAccessToken;

/**
 *  获取身份证号
 */
+ (NSString *)getWithCardId;

/**
 *  保存身份证号
 */
+ (void)saveWithCardId:(NSString *)cardId;

/**
 *  获取用户名
 */
+ (NSString *)getWithUserName;

/**
 *  保存姓名
 *  @param userName 姓名
 */
+ (void)saveWithUserName:(NSString *)userName;

/**
 *  得到用户权限
 */
+ (NSArray *)getWithUserAuthor;


@end





























