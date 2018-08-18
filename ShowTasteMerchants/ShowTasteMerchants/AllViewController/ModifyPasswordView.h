//
//  ModifyPasswordView.h
//  ChefDating
//
//  Created by 唐斌 on 16/5/30.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"

#define kModifyPasswordViewHeight (38+120+62+40)

@interface ModifyPasswordView : TYZBaseView


- (NSString *)getOldPsw;

- (NSString *)getNewPsw;

- (NSString *)getSubPsw;

@end
