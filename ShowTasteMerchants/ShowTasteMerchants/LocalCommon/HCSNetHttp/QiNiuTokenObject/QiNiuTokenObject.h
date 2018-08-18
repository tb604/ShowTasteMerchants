//
//  QiNiuTokenObject.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/16.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QiNiuTokenObject : NSObject

/**
 *  图片服务器域名地址
 */
@property (nonatomic, copy) NSString *host;

/**
 *  上传文件的名称(new)
 */
@property (nonatomic, copy) NSString *name;

/// 头像专用
@property (nonatomic, copy) NSString *temp_name;

/**
 *  上传文件的名称(old)
 */
@property (nonatomic, copy) NSString *fname;

/**
 *  七牛的token
 */
@property (nonatomic, copy) NSString *token;

/**
 *  图片id
 */
@property (nonatomic, assign) NSInteger image_id;

@end
























