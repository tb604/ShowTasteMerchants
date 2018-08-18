//
//  TYZNetworkHTTP.m
//  51tourGuide
//
//  Created by 唐斌 on 16/3/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZNetworkHTTP.h"
#import "AFNetworking.h"
#import "TYZKit.h"

@implementation TYZNetworkHTTP

/**
 *  请求网络
 *
 *  @param url        url
 *  @param param      请求参数
 *  @param httpHead   头参数
 *  @param respStyle  返回数据类型
 *  @param reqStyle   请求类型
 *  @param completion block，返回结果
 */
+ (NSURLSessionDataTask *)requestWithURL:(NSString *)url param:(NSDictionary *)param httpHead:(NSDictionary *)httpHead responseStyle:(responseStyle)respStyle requestStyle:(requestStyle)reqStyle completion:(void(^)(id result))completion
{
    // 创建一个网络请求管理
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 添加请求头
    if (httpHead)
    {
        for (NSString *key in [httpHead allKeys])
        {
            NSLog(@"key=%@; value=%@", key, httpHead[key]);
            [manager.requestSerializer setValue:httpHead[key] forHTTPHeaderField:key];
        }
    }
    
    // 判断返回数据类型
    switch (respStyle)
    {
        case WYXDATA:
        {
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        } break;
        case WYXJSON:
        {
//            debugLog(@"WYXJSON");
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
        } break;
        case WYXXML:
        {
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
        } break;
        default:
        {
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
        }
            break;
    }
    manager.requestSerializer.timeoutInterval = 10.0; // 设置超时时间
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"application/x-javascript", nil];
    
    NSURLSessionDataTask *dataTask = nil;
    if (WYXGET == reqStyle)
    {
        dataTask = [manager GET:url parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            debugLog(@"success");
            [self responseWithData:task respObj:responseObject error:nil completion:completion];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            debugLog(@"error");
//            debugLog(@"erro.desc=%@", [error description]);
            [self responseWithData:task respObj:nil error:error completion:completion];
        }];
    }
    else if (WYXPOST == reqStyle)
    {
        dataTask = [manager POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            debugLog(@"success");
            [self responseWithData:task respObj:responseObject error:nil completion:completion];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            debugLog(@"error=%@", [error description]);
            [self responseWithData:task respObj:nil error:error completion:completion];
        }];
    }
    else if (WYXPUT == reqStyle)
    {
        dataTask = [manager PUT:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self responseWithData:task respObj:responseObject error:nil completion:completion];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self responseWithData:task respObj:nil error:error completion:completion];
        }];
    }
    else if (WYXDELETE == reqStyle)
    {
        dataTask = [manager DELETE:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self responseWithData:task respObj:responseObject error:nil completion:completion];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self responseWithData:task respObj:nil error:error completion:completion];
        }];
    }
    return dataTask;
}

+ (void)responseWithData:(NSURLSessionDataTask * _Nullable)task respObj:(id  _Nullable)respObj error:(NSError * _Nullable)error completion:(void(^)(id result))completion
{
    NSUInteger statusCode = [(NSHTTPURLResponse *)task.response statusCode];
    debugLog(@"obj=%@", respObj);
    debugLog(@"statusCode=%d", (int)statusCode);
    debugLog(@"error=%@", [error description]);
    if (respObj)
    {
        if ([respObj isKindOfClass:[NSDictionary class]])
        {
            /*
             error =     {
             code = 3;
             "error_type" = "signature_error";
             message = "\U7b7e\U540d\U9a8c\U8bc1\U5931\U8d25";
             };
             */
            
            // 美团错误的时候，返回的数据结构
            NSDictionary *respDict = nil;
            if ([[respObj allKeys] containsObject:@"error"] && [respObj allKeys].count == 1)
            {
                respDict = respObj[error];
            }
            else
            {
                respDict = respObj;
            }
            TYZRespondDataEntity *respond = [TYZRespondDataEntity modelWithJSON:respDict];
            id data = respObj[@"data"];
            if ([data isEqual:[NSNull null]])
            {
                respond.data = nil;
            }
            else
            {
                respond.data = data;
            }
            if (completion)
            {
                completion(respond);
            }
        }
        else
        {
            NSString *idJson = @"   \
            {   \
            \"errcode\": 2,    \
            \"msg\": \"没有数据\"   \
            }";
            TYZRespondDataEntity *respond = [TYZRespondDataEntity modelWithJSON:idJson];
            if (completion)
            {
                completion(respond);
            }
        }
    }
    else
    {
        NSString *idJson = @"   \
        {   \
        \"errcode\": -3,    \
        \"msg\": \"没有网络\"   \
        }";
        TYZRespondDataEntity *respond = [TYZRespondDataEntity modelWithJSON:idJson];
        if (completion)
        {
            completion(respond);
        }
    }
}


@end
