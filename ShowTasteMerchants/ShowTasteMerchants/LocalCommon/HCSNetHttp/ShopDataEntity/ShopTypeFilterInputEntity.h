//
//  ShopTypeFilterInputEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/5/31.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  餐厅分类筛选条件参数
 */
@interface ShopTypeFilterInputEntity : NSObject

/**
 *  当前页数
 */
@property (nonatomic, assign) NSInteger pageIndex;

/**
 *  分类id
 */
@property (nonatomic, assign) NSInteger classId;

/**
 *  商圈Id(开店时填写的)
 */
@property (nonatomic, assign) NSInteger mallId;

/**
 *  传统菜系(开店时填写的)
 */
@property (nonatomic, assign) NSInteger traditionCuisineId;

/**
 *  特色菜系(开店时填写的)
 */
@property (nonatomic, assign) NSInteger featureCuisinedId;

/**
 *  国际菜系(开店时填写的)
 */
@property (nonatomic, assign) NSInteger interCusinedId;


@end



























