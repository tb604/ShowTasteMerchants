//
//  UploadImageObject.h
//  ChefDating
//
//  Created by 唐斌 on 16/5/27.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  显示上传图片
 */
@interface UploadImageObject : NSObject

@property (nonatomic, assign) CGSize imgSize;

@property (nonatomic, copy) void (^dissPickerHeadImgDataBlock)(NSData *data, NSString *imgName);

/**
 *  1表示正方形图片(默认)；2表示长方形图片；3指定的长方形大小
 */
@property (nonatomic, assign) int imgType;

/**
 *  扩展名
 */
@property (nonatomic, copy) NSString *extName;


- (void)showActionSheet:(UIViewController *)view;

@end
