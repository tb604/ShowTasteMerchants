//
//  OrderMealDataEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/5/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderMealContentEntity.h"

@interface OrderMealDataEntity : NSObject

/*
 "borad_name": "欢迎语",
 "broad_type": 2,
 "content": [
 {
 "subcontent": "请跟随秀味，开始独一无二的美食之旅。"
 }
 ]
 */

@property (nonatomic, copy) NSString *borad_name;

/**
 *  类型 1表示App首页轮播；2表示App欢迎语；3表示热卖美食；4表示后台配置板块（友情聚餐好取出、商务活动好选择、情侣约会理想地）；5表示附近美食；0表示最近浏览和分享
 */
@property (nonatomic, assign) NSInteger broad_type;

/**
 *  内容
 */
@property (nonatomic, strong) id content;



@end

















