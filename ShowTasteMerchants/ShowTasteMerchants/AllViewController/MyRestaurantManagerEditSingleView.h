//
//  MyRestaurantManagerEditSingleView.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/28.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"

#define kMyRestaurantManagerEditSingleViewHeight (40.0)

@interface MyRestaurantManagerEditSingleView : TYZBaseView

@property (nonatomic, strong) UITextField *valueTxtField;

- (void)updateWithTitle:(NSString *)title value:(NSString *)value placeholder:(NSString *)placeholder returnKeyType:(UIReturnKeyType)returnKeyType;

@end
