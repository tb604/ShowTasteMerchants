//
//  CuisineFlavorDataEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/17.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CuisineTypeDataEntity.h"

@interface CuisineFlavorDataEntity : NSObject

/**
 *  传统菜系
 */
@property (nonatomic, strong) CuisineTypeDataEntity *chuantong;

/**
 *  特色饮食
 */
@property (nonatomic, strong) CuisineTypeDataEntity *tese;

/**
 *  国际菜系
 */
@property (nonatomic, strong) CuisineTypeDataEntity *guoji;

/**
 *  口味
 */
@property (nonatomic, strong) CuisineTypeDataEntity *kouwei;

@end
