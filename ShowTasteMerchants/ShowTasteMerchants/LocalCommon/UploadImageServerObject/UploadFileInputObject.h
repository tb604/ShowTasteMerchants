//
//  UploadFileInputObject.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/16.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadFileInputObject : NSObject

/**
 *  用户id
 */
@property (nonatomic, assign) NSInteger userId;

/**
 *  餐厅id
 */
@property (nonatomic, assign) NSInteger shopId;

/**
 *  图片id，新增时，image_id＝0；更新为图片id
 */
@property (nonatomic, assign) NSInteger imageId;

/**
 *  更新的时候需要
 */
@property (nonatomic, copy) NSString *imageUrl;

/**
 *  根据imageType来决定sourceId的值；imagetype为1，则sourceId为用户id；imagetype＝1000-1004,则sourceId为餐厅id
 */
@property (nonatomic, assign) NSInteger sourceId;

/**
 *  EN_UPLOAD_IMAGE_TYPE
 图片类型id(
 2000：餐厅首图 1张
 2001：餐厅大厅图 2张
 2002：餐厅包间图 2张
 2003：餐厅景观图 1张
 3000：厨师头像 1张
 4000：餐厅营业执照 1张
 4001：餐厅经营许可证 1张
 4002：餐厅消防安全证 1张
 4003：餐厅卫生许可证 1张
 4004：餐厅从业人员健康证1
 4005：餐厅从业人员健康证2
 )
 */
@property (nonatomic, assign) NSInteger imageType;

/**
 *  上传文件的扩展名
 */
@property (nonatomic, copy) NSString *extName;

@property (nonatomic, strong) NSData *data;



@end
