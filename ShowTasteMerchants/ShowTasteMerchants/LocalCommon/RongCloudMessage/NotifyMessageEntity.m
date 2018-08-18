//
//  NotifyMessageEntity.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/23.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "NotifyMessageEntity.h"
#import "TYZKit.h"

@implementation NotifyMessageEntity

- (id)init
{
    self = [super init];
    if (self)
    {
        self.notify_type = 0;
        self.notify_body = nil;
    }
    return self;
}

// 编码讲当前对象转换成json数据
- (NSData *)encode
{
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    dataDict[@"notify_type"] = @(_notify_type);
    
    if (_notify_body)
    {
        [dataDict setObject:_notify_body forKey:@"notify_body"];
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict options:kNilOptions error:nil];
#if !__has_feature(objc_arc)
    [dataDict release], dataDict = nil;
#endif
    return data;
}

// 根据给定的JSON数据设置当前实例
- (void)decodeWithData:(NSData *)data
{
#if 1
    __autoreleasing NSError *error = nil;
    if (!data)
    {
        return;
    }
//    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    json = json[@"content"];
//    NSLog(@"json=%@", json);
#else
    NSString *jsongStream = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *json = [jsongStream modelToJSONObject];
    NSLog(@"json=%@", json);
//    NSDictionary *json = [RCJSONConverter dictionaryWithJSONString:jsongStream];
#endif
    
    if (json)
    {
//        NSLog(@"type=%@", json[@"notify_type"]);
//        NSLog(@"body=%@", json[@"notify_body"]);
        self.notify_type = [json[@"notify_type"] integerValue];
        self.notify_body = json[@"notify_body"];
    }
}

// 应返回消息名称，此字段需个平台保持一致，每个消息类型是唯一的
+ (NSString *)getObjectName
{
    return JCBNotifyMessageTypeIdentifier;
}

// 返回遵循此Protocol的类对象持久化的标识
+ (RCMessagePersistent)persistentFlag
{
    return MessagePersistent_NONE;
    //    return (MessagePersistent_ISPERSISTED | MessagePersistent_ISCOUNTED);
}


@end
