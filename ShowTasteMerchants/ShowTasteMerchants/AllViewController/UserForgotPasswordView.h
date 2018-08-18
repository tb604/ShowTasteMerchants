//
//  UserForgotPasswordView.h
//  ChefDating
//
//  Created by 唐斌 on 16/5/26.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"

#define kUserForgotPasswordViewHeight (kiPhone4?80.0:90.0)

@interface UserForgotPasswordView : TYZBaseView

/**
 *  设置时间，更新时间，描述
 *
 *  @param second    秒数
 */
- (void)updateTimeSecond:(NSNumber *)second;

/**
 *  手机号码
 *
 *  @return return value description
 */
- (NSString *)getPhone;

/**
 *  验证码
 *
 *  @return vercode
 */
- (NSString *)getVerCode;


@end
