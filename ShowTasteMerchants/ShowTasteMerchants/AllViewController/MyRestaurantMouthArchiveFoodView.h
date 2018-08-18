//
//  MyRestaurantMouthArchiveFoodView.h
//  ChefDating
//
//  Created by 唐斌 on 16/9/5.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"

/**
 *  归档的菜品视图
 */
@interface MyRestaurantMouthArchiveFoodView : TYZBaseView

- (void)addWithFood:(id)entity;

@property (nonatomic, copy) void (^refreshMouthBlock)(id data);

@end
