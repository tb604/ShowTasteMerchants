//
//  DinersShopingCartView.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/26.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"
#import "ShopingCartEntity.h"
#import "DinersShopingCartTopView.h"

/**
 *  点击购物车后，显示的视图
 */
@interface DinersShopingCartView : TYZBaseView

@property (nonatomic, strong) DinersShopingCartTopView *topView;

@property (nonatomic, strong) UITableView *shopCartTableView;

/**
 *  清除购物车
 */
@property (nonatomic, copy) void (^clearShoppingCartBlock)();

@property (nonatomic, copy) void (^touchAddSubBlock)(NSInteger type, id button, ShopingCartEntity *cartEntity);

- (void)showWithSubView:(BOOL)show;

@end
