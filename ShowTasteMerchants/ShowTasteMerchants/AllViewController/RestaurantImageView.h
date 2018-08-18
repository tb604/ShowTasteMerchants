//
//  RestaurantImageView.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/16.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestaurantImageEntity.h"

/**
 *  餐厅形象图片
 */
@interface RestaurantImageView : UIImageView

/**
 *  type 1表示点击；2表示长按
 */
@property (nonatomic, copy) void (^touchImageViewBlock)(id data, int type);

@property (nonatomic, strong) RestaurantImageEntity *imageEntity;

- (void)updateWithTitle:(NSString *)title desc:(NSString *)desc;

- (void)hiddenLabel:(BOOL)hidden;

@end
