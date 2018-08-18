//
//  HungryOrderBodyEntity.m
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/23.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "HungryOrderBodyEntity.h"
#import "TYZKit.h"

@implementation HungryOrderBodyEntity

- (id)init
{
    self = [super init];
    if (self)
    {
        self.shop_id = 0;
        self.type = 0;
        self.commend = 0;
        self.body = nil;
        self.desc = @"";
        self.request_id = @"";
    }
    return self;
}

// 编码讲当前对象转换成json数据
- (NSData *)encode
{
    debugMethod();
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    dataDict[@"shop_id"] = @(_shop_id);
    dataDict[@"type"] = @(_type);
    dataDict[@"commend"] = @(_commend);
    dataDict[@"desc"] = objectNull(_desc);
    dataDict[@"request_id"] = objectNull(_request_id);
    if (_body)
    {
        dataDict[@"body"] = _body;
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict options:kNilOptions error:nil];
#if !__has_feature(objc_arc)
    [dataDict release], dataDict = nil;
#endif
    return data;
}

/**
 *  根据给定的JSON数据设置当前实例
 *
 *  @param data 传入的JSON数据
 */
- (void)decodeWithData:(NSData *)data
{
    debugMethod();
#if 1
    __autoreleasing NSError *error = nil;
    if (!data)
    {
        return;
    }
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//    debugLog(@"if--json=%@", json);
#else
    NSString *jsongStream = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *json = [RCJSONConverter dictionaryWithJSONString:jsongStream];
#endif
    
    if (json)
    {
        NSDictionary *dict = json[@"content"];
        
//        debugLog(@"json.class=%@", NSStringFromClass([json class]));
//        debugLog(@"dict.class=%@", NSStringFromClass([dict class]));
        self.shop_id = [dict[@"shop_id"] integerValue];
        self.type = [dict[@"type"] integerValue];
        self.commend = [dict[@"cmd"] integerValue];
        self.desc = objectNull(dict[@"description"]);
        self.request_id = objectNull(dict[@"request_id"]);
        
        HungryOrdersEntity *body = [HungryOrdersEntity modelWithJSON:dict[@"body"]];
        self.body = body;
    }
}



// 应返回消息名称，此字段需个平台保持一致，每个消息类型是唯一的
+ (NSString *)getObjectName
{
    return JCBNotifyHungryMsgTypeIdentifier;
}

// 返回遵循此Protocol的类对象持久化的标识
+ (RCMessagePersistent)persistentFlag
{
    return MessagePersistent_NONE;
    //    return (MessagePersistent_ISPERSISTED | MessagePersistent_ISCOUNTED);
}


@end
