//
//  ShopCommentDataEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/1.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RestaurantImageEntity.h"

/**
 *  餐厅评论
 */
@interface ShopCommentDataEntity : NSObject

/**
 *  评论id
 */
@property (nonatomic, assign) NSInteger id;

/**
 *  评论者名称
 */
@property (nonatomic, copy) NSString *name;

/**
 *  评论者头像
 */
@property (nonatomic, copy) NSString *avatar;

/**
 *  餐厅id
 */
@property (nonatomic, assign) NSInteger shop_id;

/**
 *  订单id
 */
@property (nonatomic, copy) NSString *order_id;

/**
 *  评分
 */
@property (nonatomic, assign) float score;

/**
 *  菜品图片HOST
 */
@property (nonatomic, copy) NSString *image_host;

/**
 *  菜品图片地址
 */
@property (nonatomic, strong) NSArray *images;

/**
 *  评论内容
 */
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) CGFloat contentHeight;

@property (nonatomic, assign) CGFloat imgWidth;

/**
 *  评论时间
 */
@property (nonatomic, copy) NSString *create_datetime;

@end

/*
 {"score":4,"id":7,"create_datetime":"2016-08-17 16:21:26","content":"一个人是从得了啦啊吐了","user_avatar":"http:\/\/test-img.xiuwei.chinatopchef.com\/xw-test\/1\/1470751190.jpg","images":[],"user_name":"何***"}
 */

/*
 "id": 514,
 "name": "吴***",
 "avatar": "user/1/1461481624.jpg",
 "shop_id": 8,
 "order_id": "2016050655100561",
 "score": 1,
 "image_host": "http://7xsdmx.com2.z0.glb.qiniucdn.com/",
 "image": [
 "shop/22/b050f87c-477c-09fb-5df1-5609fb43fea8.jpg",
 "shop/22/b050f87c-477c-09fb-5df1-5609fb43fea8.jpg",
 "shop/22/b050f87c-477c-09fb-5df1-5609fb43fea8.jpg"
 ],
 "content": "这是评论呀",
 "create_datetime": "2016-05-13 11:25:54"
*/