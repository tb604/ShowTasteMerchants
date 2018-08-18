//
//  TYZShowImageInfoObject.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/11.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EN_IMAGE_ACTION)
{
    EN_IMAGE_NONE_ACTION = 0,
    EN_IMAGE_SQUARE_ACTION, ///< 正方形
    EN_IMAGE_LANDSCAPE_ACTION,  ///< 扁的长方形(width>height)
    EN_IMAGE_PORTRAIT_ACTION  ///< 竖的长方形(width<height)
};


@interface TYZShowImageInfoObject : NSObject


@property (nonatomic, assign) CGSize imgSize;

@property (nonatomic, copy) void (^dissPickerHeadImgDataBlock)(NSData *data, NSString *imgName);

/**
 *  
 */
@property (nonatomic, assign) EN_IMAGE_ACTION imgType;

/**
 *  扩展名
 */
@property (nonatomic, copy) NSString *extName;


- (void)showActionSheet:(UIViewController *)view;


@end
