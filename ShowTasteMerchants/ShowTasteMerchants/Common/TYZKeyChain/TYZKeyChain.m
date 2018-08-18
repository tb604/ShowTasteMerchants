//
//  TYZKeyChain.m
//  51tourGuide
//
//  Created by 唐斌 on 16/4/27.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZKeyChain.h"
#import <Security/Security.h>

@implementation TYZKeyChain
- (void)dealloc
{
#if !__has_feature(objc_arc)
    
    [super dealloc];
#endif
}

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service
{
    /*
     * __bridge  值做类型转换，但是不修改对象管理权
     * __bridge_transfer(CFBridgingRelease)  将Core Foundation对象转换为Objective-C对象，同时将对象的管理权交给ARC
     例如：
     CFStringRef cfName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
     NSString *name = (NSString *)CFBridgingRelease(cfName);
     
     
     * __bridge_retained(CFBridgingRetain)  将Objective-C对象转换为Core Foundation对象，同时将对象的管理权交给我们(自己处理内存)
     例如：
     NSString *string = @"heooo";
     CFStringRef cfString = (CFStringRef)CFBridgingRetain(string);
     // Use the CF string.
     CFRelease(cfString);
     */
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge_transfer id)kSecClassGenericPassword,(__bridge_transfer id)kSecClass,
            service, (__bridge_transfer id)kSecAttrService,
            service, (__bridge_transfer id)kSecAttrAccount,
            (__bridge_transfer id)kSecAttrAccessibleAfterFirstUnlock,(__bridge_transfer id)kSecAttrAccessible,
            nil];
}

+ (void)save:(NSString *)service data:(id)data
{
    // Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    
    // Delete old item before add new item
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    
    // Add new object to search dictionary(Attentiion:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge id)kSecValueData];
    
    // Add item to keychain with the search dictionary
    SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);
}

+ (id)load:(NSString *)service
{
    id ret = nil;
    NSMutableDictionary *keychainQuery = [TYZKeyChain getKeychainQuery:service];
    //Configure the search setting
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    [keychainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge_retained CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr)
    {
        @try
        {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge_transfer NSData *)keyData];
        }
        @catch (NSException *e)
        {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        }
        @finally
        {
        }
    }
    return ret;
}

+ (void)remove:(NSString *)service
{
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
#if !__has_feature(objc_arc)
    SecItemDelete((CFDictionaryRef)keychainQuery);
#else
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
#endif
}

@end
