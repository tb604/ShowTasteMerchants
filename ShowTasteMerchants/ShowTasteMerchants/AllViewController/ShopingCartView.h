//
//  ShopingCartView.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/25.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"

/**
 *  购物车按钮视图
 */
@interface ShopingCartView : TYZBaseView

/**
 *  点解购物车
 */
@property (nonatomic, copy)void (^TouchShopingCartBlock)();

@end
