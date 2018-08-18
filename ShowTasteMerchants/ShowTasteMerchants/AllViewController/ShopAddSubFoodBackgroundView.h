//
//  ShopAddSubFoodBackgroundView.h
//  ChefDating
//
//  Created by 唐斌 on 16/8/5.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopAddSubFoodView.h"


@interface ShopAddSubFoodBackgroundView : UIView

@property (nonatomic, copy) void (^touchAddSubFoodBlock)(id data);


// _operateFood
- (void)updateWithData:(id)data addSubType:(NSInteger)addSubType operateFood:(NSInteger)operateFood;

@end
