//
//  ResetPawwordViewController.h
//  ChefDating
//
//  Created by 唐斌 on 16/5/26.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseViewController.h"

/**
 *  重置密码视图控制器
 */
@interface ResetPawwordViewController : TYZBaseViewController

/**
 *  存放，手机号码(phone)、验证码(code)NSDictionary *param = @{@"phone":phone, @"code":code, @"uuid":uuid};
 */
@property (nonatomic, strong) NSDictionary *pswCodeDict;

@end
