//
//  ButtonAddFoodView.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/25.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"

@interface ButtonAddFoodView : TYZBaseView

- (void)updateWithTitleColor:(UIColor *)color;

@property (nonatomic, copy) void (^clickedBlock)();

@end
