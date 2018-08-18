//
//  OrderMealMainDataEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/18.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderMealDataEntity.h"

/**
 *  客户版，首页订餐 entity
 */
@interface OrderMealMainDataEntity : NSObject

/**
 *  轮播广告
 */
@property (nonatomic, strong) OrderMealDataEntity *playBannerEntity;

/**
 *  欢迎语
 */
@property (nonatomic, strong) OrderMealDataEntity *welcomeLanEntity;

/**
 *  热卖美食
 */
@property (nonatomic, strong) OrderMealDataEntity *hotFoodEntity;

/**
 *  附近美食
 */
@property (nonatomic, strong) OrderMealDataEntity *nearFoodEntity;

/**
 *  后台配置板块（亲友聚餐好去处、商务活动好选择、情侣约会理想地）状态为4
 */
@property (nonatomic, strong) NSMutableArray *platInfoList;

/**
 *  分享
 */
@property (nonatomic, strong)OrderMealDataEntity *shareEntity;


@end
