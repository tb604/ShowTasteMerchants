//
//  UserLoginStateObject.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/27.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "UserLoginStateObject.h"
#import "LocalCommon.h"
#import "SvUDIDTools.h"

@implementation UserLoginStateObject

/**
 *  得到用户登录的状态
 *
 *  @return EUserLogined表示没有登录；EUserUnlogin表示登录
 */
+ (NSInteger)userLoginState
{
    NSInteger loginState = EUserUnlogin;
    id userObj = [UtilityObject readCacheDataLocalKey:kCacheUserInfoData saveFilename:kCacheUserInfoFileName];
    if (!userObj)
    {
        debugLog(@"userObj is nil");
        return loginState;
    }
    
    UserDataKeyChain *userData = [self getUserInfoDataKeyChain];
    if (userData)
    {
        debugLog(@"userData is not nil");
        loginState = userData.loginState;
    }
    else
    {
        debugLog(@"没有登录");
        loginState = EUserLogined;
    }
    return loginState;
}

+ (NSString *)deviceToken
{
    return [self getUserInfoDataKeyChain].userDeviceToken;
}

+ (void)saveWithDeviceToken:(NSString *)token
{
    UserDataKeyChain *ent = [self getUserInfoDataKeyChain];
    if (ent)
    {
        ent.userDeviceToken = token;
    }
    else
    {
        debugLog(@"用户基础资料不存在");
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[SvUDIDTools UDID], @"userIdentifity", token, @"userDeviceToken", @(0), @"loginState", @"", @"userPhone", @"", @"travelersToken", @(0), @"userId", @(0), @"userLoginType", @"", @"userPsw", nil];
        ent = [UserDataKeyChain modelWithDictionary:dict];
    }
    [self saveUserDataKeyChain:ent];
}

/**
 *  得到保存的信息
 *
 *  @return return value description
 */
/**
 *  得到保存的信息
 *
 *  @return <#return value description#>
 */
+ (UserDataKeyChain *)getUserInfoDataKeyChain
{
    id userData = [TYZUserDataManager readUserData];
    
    
    return userData;
}

/**
 *  保存
 */
+ (void)saveUserDataKeyChainData:(NSDictionary *)userData
{
    UserDataKeyChain *ent = [UserDataKeyChain modelWithDictionary:userData];
    [self saveUserDataKeyChain:ent];
}

/**
 *  保存
 */
+ (void)saveUserDataKeyChain:(UserDataKeyChain *)userData
{
    [TYZUserDataManager saveUserData:userData];
}

/**
 *  获取用户信息
 *
 *  @return UserInfoDataEntity
 */
+ (UserInfoDataEntity *)getUserInfo
{
    id userObj = [UtilityObject readCacheDataLocalKey:kCacheUserInfoData saveFilename:kCacheUserInfoFileName];
    return userObj;
}

/**
 *  保存用户信息
 *
 *  @param userInfo 用户信息
 */
+ (void)saveWithUserInfo:(UserInfoDataEntity *)userInfo
{
    [UtilityObject saveCacheDataLocalKey:kCacheUserInfoData saveFilename:kCacheUserInfoFileName saveid:userInfo];
}

+ (void)saveWithPhone:(NSString *)phone
{
    UserInfoDataEntity *userInfo = [self getUserInfo];
    userInfo.mobile = phone;
    [self saveWithUserInfo:userInfo];
    
    UserDataKeyChain *ent = [self getUserInfoDataKeyChain];
    ent.userPhone = phone;
    [self saveUserDataKeyChain:ent];
}

/**
 *  保存用户登录类型
 *
 *  @param type 1表示老板登录；2表示员工登录
 */
+ (void)saveWithUserLoginType:(NSInteger)type
{
    UserDataKeyChain *ent = [self getUserInfoDataKeyChain];
    if (!ent)
    {
        [self saveWithDeviceToken:@""];
    }
    ent.userLoginType = type;
    [self saveUserDataKeyChain:ent];
}

/**
 *  读取用户登录类型
 *
 *  @return 返回用户登录类型(1表示老板登录；2表示员工登录)
 */
+ (NSInteger)readWithUserLoginType
{
    UserDataKeyChain *ent = [self getUserInfoDataKeyChain];
    if (!ent)
    {
        debugLog(@"userdatakeychain is nil");
    }
    return ent.userLoginType;
}

/**
 *  保存登录状态
 *
 *  @param loginState 0未登录；1已登录
 */
+ (void)saveLoginState:(NSInteger)loginState
{
    UserDataKeyChain *ent = [self getUserInfoDataKeyChain];
    ent.loginState = loginState;
    [self saveUserDataKeyChain:ent];
}

/**
 *  得到用户id
 *
 *  @return 返回用户id
 */
+ (NSInteger)getUserId
{
    return [self getUserInfo].user_id;
}

/**
 *  活的用户手机号码
 *
 *  @return 返回用户手机号码
 */
+ (NSString *)getUserMobile
{
    return [self getUserInfo].mobile;
}

/// 得到头像的url
+ (NSString *)getUserHeadIcon
{
    return [self getUserInfo].avatar;
}

/**
 *  昵称
 *
 *  @return 返回昵称
 */
+ (NSString *)getUserNickName
{
    return [self getUserInfo].nikename;
}

/**
 *  得到当前餐厅id
 *
 *  @return 餐厅id
 */
+ (NSInteger)getCurrentShopId
{
    return [self getUserInfo].shop_id;
}

+ (void)saveWithCurrentShopId:(NSInteger)shopId
{
    UserInfoDataEntity *userInfo = [self getUserInfo];
    userInfo.shop_id = shopId;
    [self saveWithUserInfo:userInfo];

}

/**
 *  获取当前餐厅名称
 */
+ (NSString *)getCurrentShopName
{
    return [self getUserInfo].shop_name;
}

/**
 *  保存当前餐厅名称
 *
 */
+ (void)saveWithCurrentShopName:(NSString *)shopName
{
    UserInfoDataEntity *userInfo = [self getUserInfo];
    userInfo.shop_name = shopName;
    [self saveWithUserInfo:userInfo];
}

+ (NSInteger)getWithCurrentState
{
    return [self getUserInfo].shop_state;
}


/**
 *  保存餐厅对应的状态
 *
 *  @param state state
 */
+ (void)saveWithShopState:(NSInteger)state
{
//    saveWithUserInfo
    UserInfoDataEntity *userInfo = [self getUserInfo];
    userInfo.shop_state = state;
    [self saveWithUserInfo:userInfo];
}

+ (NSString *)getWithAccessToken
{
    return [self getUserInfo].access_token;
}

/**
 *  获取身份证号
 */
+ (NSString *)getWithCardId
{
    return [self getUserInfo].identity_card;
}

/**
 *  保存身份证号
 */
+ (void)saveWithCardId:(NSString *)cardId
{
    UserInfoDataEntity *userInfo = [self getUserInfo];
    userInfo.identity_card = cardId;
    [self saveWithUserInfo:userInfo];
}


/**
 *  获取用户名
 */
+ (NSString *)getWithUserName
{
    return [self getUserInfo].username;
}

/**
 *  保存姓名
 *  @param userName 姓名
 */
+ (void)saveWithUserName:(NSString *)userName
{
    UserInfoDataEntity *userInfo = [self getUserInfo];
    userInfo.username = userName;
    [self saveWithUserInfo:userInfo];
}

/**
 *  得到用户权限
 */
+ (NSArray *)getWithUserAuthor
{
    return [self getUserInfo].role_permissions;
}

@end
