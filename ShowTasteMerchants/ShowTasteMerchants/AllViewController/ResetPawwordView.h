//
//  ResetPawwordView.h
//  ChefDating
//
//  Created by 唐斌 on 16/5/27.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"


#define kResetPawwordViewHeight ((kiPhone4 || kiPhone5)?40.0:45.0)

@interface ResetPawwordView : TYZBaseView

/**
 *  密码
 *
 *  @return <#return value description#>
 */
- (NSString *)getWithPassword;


@end
