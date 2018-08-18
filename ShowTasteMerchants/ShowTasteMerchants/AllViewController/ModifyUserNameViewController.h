//
//  ModifyUserNameViewController.h
//  ChefDating
//
//  Created by 唐斌 on 16/5/30.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseViewController.h"

/**
 *  修改用户姓名视图控制器
 */
@interface ModifyUserNameViewController : TYZBaseViewController

/**
 *  姓名 @{@"familyName":_userInfoEntity.family_name, @"lastName":_userInfoEntity.name}
 */
@property (nonatomic, strong) NSDictionary *nameDict;

@end
