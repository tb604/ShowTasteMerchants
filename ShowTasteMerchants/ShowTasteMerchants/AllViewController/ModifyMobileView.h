//
//  ModifyMobileView.h
//  ChefDating
//
//  Created by 唐斌 on 16/5/31.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"

#define kModifyMobileViewHeight ((kiPhone4||kiPhone5)?80.0:90.0)

#define kModifyMobileViewAllHeight (kModifyMobileViewHeight + 65+40)


@interface ModifyMobileView : TYZBaseView

/**
 *  设置时间，更新时间，描述
 *
 *  @param second    秒数
 */
- (void)updateTimeSecond:(NSNumber *)second;


- (NSString *)getPhone;

- (NSString *)getCode;

@end
