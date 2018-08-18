//
//  CuisineTypeDataEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/5/24.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CuisineContentDataEntity.h"

/**
 *  菜系(传统菜系)
 */
@interface CuisineTypeDataEntity : NSObject

@property (nonatomic, copy) NSString *imageName;

/**
 *  菜系名称
 */
@property (nonatomic, copy) NSString *title;

/**
 *  菜系名称(川菜)
 */
@property (nonatomic, strong) NSArray *content;

/**
 *  列表中最大的字的个数
 */
@property (nonatomic, assign) NSInteger listMaxFontNum;

@end



















