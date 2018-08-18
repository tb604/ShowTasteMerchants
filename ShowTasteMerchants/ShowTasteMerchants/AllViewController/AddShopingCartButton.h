//
//  AddShopingCartButton.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/27.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"

#define kAddShopingCartButtonWidth (90.0)
#define kAddShopingCartButtonHeight (30.0)


/**
 *  加入购物车
 */
@interface AddShopingCartButton : TYZBaseView

/**
 *
 */
@property (nonatomic, copy) void (^addFoodBlock)(UIButton *button);

- (void)updateWithAddNum:(NSInteger)num;

/**
 *  隐藏规格按钮
 *
 *  @param hidden YES隐藏
 *  @param specTitle 标题
 */
- (void)hiddenWithSpec:(BOOL)hidden specTitle:(NSString *)specTitle;;

@end
