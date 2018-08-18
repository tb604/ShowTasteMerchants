//
//  MyRestaurantChoiceMouthBackgroundView.h
//  ChefDating
//
//  Created by 唐斌 on 16/9/5.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyRestaurantChoiceMouthBackgroundView : UIView

@property (nonatomic, copy) void (^choiceMouthBlock)(id data);

- (id)initWithFrame:(CGRect)frame mouthList:(NSArray *)mouthList;

@end
