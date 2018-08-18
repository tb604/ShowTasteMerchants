//
//  UserDataKeyChain.h
//  51tourGuide
//
//  Created by 唐斌 on 16/4/27.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDataKeyChain : NSObject
/**
 *  唯一标识
 */
@property (nonatomic, copy) NSString *userIdentifity;

/**
 *  同送通知用的token
 */
@property (nonatomic, copy) NSString *userDeviceToken;

/**
 *  用户手机号码
 */
@property (nonatomic, copy) NSString *userPhone;

/**
 *  登录状态 1表示已登录；0表示未登录
 */
@property (nonatomic, assign) NSInteger loginState;

/**
 *  融云，交友的token
 */
@property (nonatomic, copy) NSString *travelersToken;

/**
 *  用户id
 */
@property (nonatomic, assign) NSInteger userId;

/**
 *  用户密码
 */
@property (nonatomic, copy) NSString *userPsw;

/// 1表示老板登录；2表示员工登录
@property (nonatomic, assign) NSInteger userLoginType;


@end
