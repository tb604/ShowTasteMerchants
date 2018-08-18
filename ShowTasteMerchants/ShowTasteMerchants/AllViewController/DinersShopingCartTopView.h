//
//  DinersShopingCartTopView.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/26.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"

#define kDinersShopingCartTopViewHeight (40.0)

@interface DinersShopingCartTopView : TYZBaseView

/**
 *  清除购物车
 */
@property (nonatomic, copy) void (^clearShoppingCartBlock)();

- (void)showWithSubView:(BOOL)show;

@end
