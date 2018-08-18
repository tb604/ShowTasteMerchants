//
//  NSNotificationCenter+TYZAdd.m
//  YYStudyDemo
//
//  Created by 唐斌 on 16/3/1.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "NSNotificationCenter+TYZAdd.h"
#import "TYZKitMacro.h"
#import <paths.h>

TYZSYNTH_DUMMY_CLASS(NSNotificationCenter_TYZAdd)

@implementation NSNotificationCenter (TYZAdd)
/**
 Posts a given notification to the receiver on main thread.
 If current thread is main thread, the notification is posted synchronously;
 otherwise, is posted asynchronously.
 
 @param notification  The notification to post.
 An exception is raised if notification is nil.
 */
- (void)postNotificationOnMainThread:(NSNotification *)notification
{
    if (pthread_main_np())
    {
        [self postNotification:notification];
        return;
    }
    [self postNotificationOnMainThread:notification waitUntilDone:NO];
}

/**
 Posts a given notification to the receiver on main thread.
 
 @param notification The notification to post.
 An exception is raised if notification is nil.
 
 @param wait         A Boolean that specifies whether the current thread blocks
 until after the specified notification is posted on the
 receiver on the main thread. Specify YES to block this
 thread; otherwise, specify NO to have this method return
 immediately.
 */
- (void)postNotificationOnMainThread:(NSNotification *)notification
                       waitUntilDone:(BOOL)wait
{
    if (pthread_main_np())
    {
        [self postNotification:notification];
        return;
    }
    [[self class] performSelectorOnMainThread:@selector(_tyz_postNotification:) withObject:notification waitUntilDone:wait];
}

/**
 Creates a notification with a given name and sender and posts it to the
 receiver on main thread. If current thread is main thread, the notification
 is posted synchronously; otherwise, is posted asynchronously.
 
 @param name    The name of the notification.
 
 @param object  The object posting the notification.
 */
- (void)postNotificationOnMainThreadWithName:(NSString *)name
                                      object:(id)object
{
    if (pthread_main_np())
    {
        [self postNotificationName:name object:object userInfo:nil];
        return;
    }
    [self postNotificationOnMainThreadWithName:name object:object userInfo:nil waitUntilDone:NO];
}

/**
 Creates a notification with a given name and sender and posts it to the
 receiver on main thread. If current thread is main thread, the notification
 is posted synchronously; otherwise, is posted asynchronously.
 
 @param name      The name of the notification.
 
 @param object    The object posting the notification.
 
 @param userInfo  Information about the the notification. May be nil.
 */
- (void)postNotificationOnMainThreadWithName:(NSString *)name
                                      object:(id)object
                                    userInfo:(NSDictionary *)userInfo
{
    if (pthread_main_np())
    {
        [self postNotificationName:name object:object userInfo:userInfo];
        return;
    }
    [self postNotificationOnMainThreadWithName:name object:object userInfo:userInfo waitUntilDone:NO];
}

/**
 Creates a notification with a given name and sender and posts it to the
 receiver on main thread.
 
 @param name     The name of the notification.
 
 @param object   The object posting the notification.
 
 @param userInfo Information about the the notification. May be nil.
 
 @param wait     A Boolean that specifies whether the current thread blocks
 until after the specified notification is posted on the
 receiver on the main thread. Specify YES to block this
 thread; otherwise, specify NO to have this method return
 immediately.
 */
- (void)postNotificationOnMainThreadWithName:(NSString *)name
                                      object:(id)object
                                    userInfo:(NSDictionary *)userInfo
                               waitUntilDone:(BOOL)wait
{
    if (pthread_main_np())
    {
        [self postNotificationName:name object:object userInfo:userInfo];
        return;
    }
    NSMutableDictionary *info = [[NSMutableDictionary alloc] initWithCapacity:3];
    if (name)
    {
        info[@"name"] = name;
    }
    if (object)
    {
        info[@"object"] = object;
    }
    if (userInfo)
    {
        info[@"userInfo"] = userInfo;
    }
    // [self class] 因为_tyz_postNotificationName是类方法
    [[self class] performSelectorOnMainThread:@selector(_tyz_postNotificationName:) withObject:info waitUntilDone:wait];
}

+ (void)_tyz_postNotification:(NSNotification *)notification
{
    [[self defaultCenter] postNotification:notification];
}

+ (void)_tyz_postNotificationName:(NSDictionary *)info
{
    NSString *name = info[@"name"];
    id object = info[@"object"];
    NSDictionary *userInfo = info[@"userInfo"];
    [[self defaultCenter] postNotificationName:name object:object  userInfo:userInfo];
}

@end




























