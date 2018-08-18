//
//  RestaurantMenuLeftView.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/24.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"
#import "RestaurantMenuLeftShopingCartEntity.h"

// 添加到购物，或者减少。发送通知
#define kAddShopingCartMenuNote @"AddShopingCartMenuNote"

@interface RestaurantMenuLeftView : TYZBaseView

@property (nonatomic, copy) void (^selectCategoryBlock)(id data);

+ (NSInteger)getMenuLeftViewWidth;

- (void)updateViewData:(id)entity isReset:(BOOL)isReset;

- (void)updateWithSelectedFoodNum:(NSArray *)cartList;

@end
