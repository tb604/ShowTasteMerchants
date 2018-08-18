//
//  TYZRespondDataEntity.h
//  51tourGuide
//
//  Created by 唐斌 on 16/3/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYZRespondDataEntity : NSObject
/**
 *  访问网络，之后的状态。0表示成功；其它表示失败
 */
@property (nonatomic, assign) int errcode;

/**
 *  返回状态，对应的状态表述
 */
@property (nonatomic, copy) NSString *msg;

/**
 *  从服务端返回的数据
 */
@property (nonatomic, strong) id data;

/// 饿了吗的请求的id
@property (nonatomic, copy) NSString *request_id;

/// 美团用到的
@property (nonatomic, copy) NSString *error_type;

@end


/*
 code = 1000;
 data = "<null>";
 message = "permission denied with food id 2345";
 "request_id" = 61d9620d3bb04f0db39daf955550a113;
 */
