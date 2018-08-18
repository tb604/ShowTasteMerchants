//
//  ShopFoodImageEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/7.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ShopFoodImageEntity : NSObject

/**
 *  图片url
 */
@property (nonatomic, copy) NSString *image;

/**
 *  描述
 */
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, assign) CGFloat descHeight;

@end
























