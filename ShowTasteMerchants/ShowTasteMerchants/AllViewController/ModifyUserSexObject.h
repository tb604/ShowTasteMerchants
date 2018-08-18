//
//  ModifyUserSexObject.h
//  ChefDating
//
//  Created by 唐斌 on 16/5/30.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  修改性别
 */
@interface ModifyUserSexObject : NSObject

@property (nonatomic, copy) void (^hiddObjectBlock)(id data);

/**
 *  1表示正方形图片(默认)；2表示长方形图片
 */
@property (nonatomic, assign) int imgType;


- (void)showActionSheet:(UIViewController *)view;


@end
