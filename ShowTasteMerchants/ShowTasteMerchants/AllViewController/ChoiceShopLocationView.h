//
//  ChoiceShopLocationView.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/19.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopSeatInfoEntity.h"

/**
 *  选择餐厅位置视图
 */
@interface ChoiceShopLocationView : UIView

@property (nonatomic, copy) void (^choiceShopLocationBlock)(id data);

- (id)initWithFrame:(CGRect)frame locationList:(NSArray *)locationList;

- (void)updateWithLocation:(ShopSeatInfoEntity *)location;

@end
