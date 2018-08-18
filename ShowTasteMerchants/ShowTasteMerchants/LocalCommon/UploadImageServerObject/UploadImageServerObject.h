//
//  UploadImageServerObject.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/16.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UploadFileInputObject.h"

/**
 *  把图片上传到七牛平台
 */
@interface UploadImageServerObject : NSObject

- (void)getUploadFileToken:(UploadFileInputObject *)inputEntity complete:(void(^)(int status, NSString *host, NSString *filePath, NSInteger imageId))complete;



@end



























