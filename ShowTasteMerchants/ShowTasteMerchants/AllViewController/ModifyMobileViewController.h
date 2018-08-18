//
//  ModifyMobileViewController.h
//  ChefDating
//
//  Created by 唐斌 on 16/5/31.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseViewController.h"

@class UserUpdateInputEntity;

/**
 *  修改手机号码，首先需要用户验证旧的手机号码，才可以重新绑定新的手机号码
 */
@interface ModifyMobileViewController : TYZBaseViewController

/**
 *  修改信息
 */
@property (nonatomic, strong) UserUpdateInputEntity *updateEntity;

@end
