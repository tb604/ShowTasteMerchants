//
//  MyRestaurantBookedMealView.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/13.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"

@interface MyRestaurantBookedMealView : TYZBaseView

/**
 *  初始化
 *
 *  @param frame  frame
 *  @param isDual 是否双数
 *
 *  @return id
 */
- (id)initWithFrame:(CGRect)frame isDual:(BOOL)isDual;

- (void)updateWithMealType:(NSString *)meal;

//+ (CGFloat)getWithViewWidth;

- (void)hiddenWithLine:(BOOL)hidden;

@end
