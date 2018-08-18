//
//  TYZUserDataManager.m
//  51tourGuide
//
//  Created by 唐斌 on 16/4/27.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZUserDataManager.h"
#import "TYZKeyChain.h"

static NSString * const KEY_IN_KEYCHAIN = @"com.chinatopchef.ShowTasteMerchants.allinformation";
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
//static NSString * const KEY_PASSWORD = @"com.wuqian.app.apssword";
#pragma clang diagnostic pop

@interface TYZUserDataManager ()

@end

@implementation TYZUserDataManager

- (void)dealloc
{
#if !__has_feature(objc_arc)
    
    [super dealloc];
#endif
}

/**
 *  保存用户信息
 *
 *  @param userData <#userData description#>
 */
+ (void)saveUserData:(id)userData
{
    [TYZKeyChain save:KEY_IN_KEYCHAIN data:userData];
}

/**
 *  读取用户信息
 *
 *  @return <#return value description#>
 */
+ (id)readUserData
{
    return [TYZKeyChain load:KEY_IN_KEYCHAIN];
}

/**
 *  删除用户信息
 */
+ (void)removeUserData
{
    [TYZKeyChain remove:KEY_IN_KEYCHAIN];
}

@end
