//
//  UserUpdateInputEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/5/24.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface UserUpdateInputEntity : NSObject

/**
 *  验证当前手机时，获取的
 */
@property (nonatomic, copy) NSString *uuid;

/**
 *  用户id
 */
@property (nonatomic, assign) NSInteger userId;

/**
 *  当前手机号码
 */
@property (nonatomic, copy) NSString *mobile;

/**
 *  使用的验证码
 */
@property (nonatomic, copy) NSString *smscode;


/**
 *  密码
 */
@property (nonatomic, copy) NSString *password;

/**
 *  新手机号码
 */
@property (nonatomic, copy) NSString *newmobile;

/**
 *  新手机号码接收到的验证码
 */
@property (nonatomic, copy) NSString *newsmscode;

/**
 *  短信渠道 1：注册 2：验证当前手机 号 3：绑定新手机号 4:找回密码
 */
@property (nonatomic, assign) NSInteger smschannel;


@end

NS_ASSUME_NONNULL_END


























