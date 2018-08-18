//
//  CommentInputDataEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/31.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  评论的传入参数
 */
@interface CommentInputDataEntity : NSObject

/**
 *  用户id
 */
@property (nonatomic, assign) NSInteger userId;

/**
 *  餐厅id
 */
@property (nonatomic, assign) NSInteger shopId;

/**
 *  订单id
 */
@property (nonatomic, copy) NSString *orderId;

/**
 *  被评论的分类id
 */
//@property (nonatomic, assign) NSInteger classId;
/*
 class_txt JSON格式串
 [
 {
 "classify_id": 40001,
 "classify_name": "亲朋聚餐好去处"
 },
 {
 "classify_id": 40002,
 "classify_name": "情侣约会理想地"
 }
 ]
 */
@property (nonatomic, strong) NSMutableArray *classList;

/**
 *  总体评分
 */
@property (nonatomic, assign) NSInteger vote;

/**
 *  口味
 */
@property (nonatomic, assign) NSInteger score1;

/**
 *  服务
 */
@property (nonatomic, assign) NSInteger score2;

/**
 *  环境
 */
@property (nonatomic, assign) NSInteger score3;

/**
 *  评论内容
 */
@property (nonatomic, copy) NSString *content;

/**
 *  图片，json字符串
 */
//@property (nonatomic, copy) NSString *images;

@property (nonatomic, strong) NSMutableArray *images;

@end




























