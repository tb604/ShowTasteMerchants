//
//  RestaurantClassifiySmallSingleView.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/6.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"
#import "CuisineContentDataEntity.h"

@interface RestaurantClassifiySmallSingleView : TYZBaseView

@property (nonatomic, strong, readonly) CuisineContentDataEntity *contentEntity;

- (void)updateButtonUnSelected;

- (BOOL)getButtonSelected;

@end
