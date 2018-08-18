//
//  RestaurantImageViewCell.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/13.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewCell.h"

/**
 *  餐厅形象图Cell
 */
@interface RestaurantImageViewCell : TYZBaseTableViewCell

/**
 *  添加图片
 */
@property (nonatomic, copy) void (^restaurantAddImageBlock)(id data);

+ (NSInteger)getRestaurantImgCellMinHeight:(NSInteger)count;

+ (NSInteger)getRestaurantImgViewHeight;



@end
