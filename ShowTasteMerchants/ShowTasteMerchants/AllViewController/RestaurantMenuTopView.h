//
//  RestaurantMenuTopView.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/24.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"

#define kRestaurantMenuTopViewHeight (30.0)

@interface RestaurantMenuTopView : TYZBaseView

- (void)updateWithCategoryTitle:(NSAttributedString *)category numTitle:(NSAttributedString *)numTitle;

@end
