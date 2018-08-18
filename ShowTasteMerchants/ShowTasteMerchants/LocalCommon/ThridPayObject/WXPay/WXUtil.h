//
//  WXUtil.h
//  51tourGuide
//
//  Created by 唐斌 on 16/5/19.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface WXUtil : NSObject <NSXMLParserDelegate>
/*
 加密实现MD5和SHA1
 */
+ (NSString *)md5:(NSString *)str;
+ (NSString *)sha1:(NSString *)str;

+ (NSString *)getIPAddress:(BOOL)preferIPv4;
/**
 实现http GET/POST 解析返回的json数据
 */
+ (NSData *)httpSend:(NSString *)url method:(NSString *)method data:(NSString *)data;
@end
