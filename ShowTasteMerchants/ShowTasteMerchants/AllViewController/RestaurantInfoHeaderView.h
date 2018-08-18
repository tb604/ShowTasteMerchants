//
//  RestaurantInfoHeaderView.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/12.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"

#define kRestaurantInfoHeaderViewHeight (40.0)

@interface RestaurantInfoHeaderView : TYZBaseView

- (void)updateViewData:(id)entity hiddenThan:(BOOL)hiddenThan;

@end
