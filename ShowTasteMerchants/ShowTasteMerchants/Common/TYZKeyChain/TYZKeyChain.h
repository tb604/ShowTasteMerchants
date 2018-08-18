//
//  TYZKeyChain.h
//  51tourGuide
//
//  Created by 唐斌 on 16/4/27.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYZKeyChain : NSObject
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service;

/**
 *  通过keyChain来保存信息
 *
 *  @param service service
 *  @param data    保存的信息
 */
+ (void)save:(NSString *)service data:(id)data;

/**
 *  读取信息
 *
 *  @param service 通过这个读取信息
 *
 *  @return 返回读取到信息
 */
+ (id)load:(NSString *)service;

/**
 *  删除信息
 *
 *  @param service 通过这个读取信息
 */
+ (void)remove:(NSString *)service;
@end
