//
//  ShopDetailDataEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/1.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShopDetailBaseDataEntity.h"
#import "ShopRecommendDataEntity.h" // 餐厅推荐
#import "ShopCommentDataEntity.h" // 餐厅评论
#import "CommentInfoDataEntity.h"

/**
 *  餐厅详细信息、推荐列表、评论列表
 */
@interface ShopDetailDataEntity : NSObject

//@property (nonatomic, strong) ShopDetailBaseDataEntity *shop;

/**
 *  餐厅图片数组
 */
@property (nonatomic, strong) NSArray *images;

/**
 *  餐厅信息
 */
@property (nonatomic, strong) RestaurantBaseDataEntity *details;

/**
 *  厨师信息
 */
@property (nonatomic, strong) RestaurantChefDataEntity *topchef;


/**
 *  推荐列表(名厨推荐)
 */
@property (nonatomic, strong) NSArray *recommends;

/**
 *  评论列表
 */
@property (nonatomic, strong) NSArray *comments;

@end

/*
 comments,
 shop,
 recommends
 */










