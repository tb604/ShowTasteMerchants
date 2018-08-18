//
//  DinersRecipeBottomView.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/24.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"

#define kDinersRecipeBottomViewHeight (54.0)

@interface DinersRecipeBottomView : TYZBaseView

/**
 *  点解购物车
 */
@property (nonatomic, copy)void (^TouchShopingCartBlock)();


- (void)updateWithBtnTitle:(NSString *)title;

@end
