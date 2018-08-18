//
//  ShowTypeDataEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/5/31.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  餐厅分类数据
 */
@interface ShowTypeDataEntity : NSObject

/**
 *  餐厅id
 */
@property (nonatomic, assign) NSInteger shop_id;

/**
 *  餐厅名称
 */
@property (nonatomic, copy) NSString *name;

/**
 *  餐厅口号
 */
@property (nonatomic, copy) NSString *slogan;

/**
 *  餐厅简介
 */
@property (nonatomic, copy) NSString *intro;

/**
 *  人均价
 */
@property (nonatomic, assign) float average;

/**
 *  评论次数
 */
@property (nonatomic, assign) NSInteger comments;

/**
 *  
 */
@property (nonatomic, copy) NSString *image1;

/**
 *
 */
@property (nonatomic, copy) NSString *image2;

/**
 *  餐厅地址
 */
@property (nonatomic, copy) NSString *address;

/**
 *  商圈中文名称
 */
@property (nonatomic, copy) NSString *mall_name;

/**
 *  菜系
 */
@property (nonatomic, copy) NSString *cx;

/**
 *  口味
 */
@property (nonatomic, copy) NSString *kw;

@end
























