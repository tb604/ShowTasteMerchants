//
//  DRFoodStandardSingleView.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/27.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"
#import "FoodStandardButton.h"

@interface DRFoodStandardSingleView : TYZBaseView

@property (nonatomic, strong) FoodStandardButton *currentButton;

- (void)updateViewData:(id)entity title:(NSString *)title;

- (void)updateViewData:(id)entity title:(NSString *)title isBrowse:(BOOL)isBrowse;

@end
