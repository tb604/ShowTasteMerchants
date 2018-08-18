//
//  TYZUserDataManager.h
//  51tourGuide
//
//  Created by 唐斌 on 16/4/27.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYZUserDataManager : NSObject
/**
 *  保存用户信息
 *
 *  @param userData <#userData description#>
 */
+ (void)saveUserData:(id)userData;

/**
 *  读取用户信息
 *
 *  @return <#return value description#>
 */
+ (id)readUserData;

/**
 *  删除用户信息
 */
+ (void)removeUserData;

@end
