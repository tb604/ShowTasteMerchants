//
//  UserLoginTextFieldView.h
//  ChefDating
//
//  Created by 唐斌 on 16/5/26.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"

#define kUserLoginTextFieldViewHeight (kiPhone4?80.0:98.0)

@interface UserLoginTextFieldView : TYZBaseView

- (NSString *)userPhone;

- (NSString *)userPsw;

@end
