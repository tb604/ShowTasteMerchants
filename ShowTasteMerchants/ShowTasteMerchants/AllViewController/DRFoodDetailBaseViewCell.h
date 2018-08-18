//
//  DRFoodDetailBaseViewCell.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/27.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewCell.h"

#define kDRFoodDetailBaseViewCellHeight (100.)

/**
 *  菜品名称、价格、购物车
 */
@interface DRFoodDetailBaseViewCell : TYZBaseTableViewCell

/**
 *  更新信息
 *
 *  @param cellEntity   菜品信息
 *  @param shopingCarts 购物车数组
 *  @param selMode      选中的规格
 *  @param selTaste     选中
 */
- (void)updateCellData:(id)cellEntity shopingCarts:(NSArray *)shopingCarts selMode:(NSString *)selMode selTaste:(NSString *)selTaste isBrowse:(BOOL)isBrowse;

@property (nonatomic, copy) void (^addFoodBlock)(UIButton *button);

@end
