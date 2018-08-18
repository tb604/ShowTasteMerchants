//
//  TYZNetworkHTTP.h
//  51tourGuide
//
//  Created by 唐斌 on 16/3/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalCommon.h"
#import "TYZRespondDataEntity.h"

@interface TYZNetworkHTTP : NSObject

/**
 *  请求网络
 *
 *  @param url        url
 *  @param param      请求参数
 *  @param httpHead   头参数
 *  @param respStyle  返回数据类型(默认json)
 *  @param reqStyle   请求类型(默认get)
 *  @param completion block，返回结果
 */
+ (NSURLSessionDataTask *)requestWithURL:(NSString *)url param:(NSDictionary *)param httpHead:(NSDictionary *)httpHead responseStyle:(responseStyle)respStyle requestStyle:(requestStyle)reqStyle completion:(void(^)(id result))completion;

@end
