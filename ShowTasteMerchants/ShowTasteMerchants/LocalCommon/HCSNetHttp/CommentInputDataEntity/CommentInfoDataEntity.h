//
//  CommentInfoDataEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/31.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "RestaurantDetailDataEntity.h"
#import "RestaurantImageEntity.h"

@interface CommentInfoDataEntity : NSObject

/**
 *  评论id
 */
@property (nonatomic, assign) NSInteger id;

/**
 *  评论者名称
 */
@property (nonatomic, copy) NSString *user_name;

/**
 *  评论者的头像
 */
@property (nonatomic, copy) NSString *user_avatar;

/**
 *  评分值(前端显示为几颗星)
 */
@property (nonatomic, assign) NSInteger score;

/**
 *  评论内容
 */
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) CGFloat contentHeight;

/**
 *  图片列表
 */
@property (nonatomic, strong) NSArray *images;

@property (nonatomic, assign) CGFloat imgWidth;

/**
 *  时间
 */
@property (nonatomic, copy) NSString *create_datetime;

@end




























