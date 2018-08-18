//
//  UserRegisterTextFieldView.h
//  ChefDating
//
//  Created by 唐斌 on 16/5/26.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"

#define kUserRegisterTextFieldViewHeight ((kiPhone4||kiPhone5)?120.0:135.0)

@interface UserRegisterTextFieldView : TYZBaseView

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
 *  @return 返回验证码
 */
- (NSString *)getVerCode;

/**
 *  密码
 *
 *  @return return value description
 */
- (NSString *)getPassword;

@end
