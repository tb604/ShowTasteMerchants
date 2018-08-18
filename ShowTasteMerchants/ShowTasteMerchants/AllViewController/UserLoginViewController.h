//
//  UserLoginViewController.h
//  ChefDating
//
//  Created by 唐斌 on 16/5/16.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseViewController.h"

/**
 *  用户登录视图控制器
 */
@interface UserLoginViewController : TYZBaseViewController

/**
 *  1表示pop到上一级；2表示到主界面； 3表示没有返回
 */
@property (nonatomic, assign) NSInteger type;

@end
