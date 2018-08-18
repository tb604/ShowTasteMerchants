//
//  AddFoodNumberNewView.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/25.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"

//#define kAddFoodNumberNewViewWidth (100.0)
#define kAddFoodNumberNewViewHeight (40.0)


@interface AddFoodNumberNewView : TYZBaseView

/**
 *  type 1表示减法；2表示加法；3选择规格
 */
@property (nonatomic, copy) void (^addFoodBlock)(NSInteger type, id button);

- (void)updateWithAddNum:(NSInteger)num isRule:(BOOL)isRule;

/**
 *  隐藏规格按钮
 *
 *  @param hidden YES隐藏
 *  @param specTitle 标题
 */
- (void)hiddenWithSpec:(BOOL)hidden specTitle:(NSString *)specTitle;

- (void)updateWithSpecColor:(UIColor *)color;

@end
