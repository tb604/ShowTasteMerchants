//
//  MyWalletDetailConditionBackgroundView.h
//  ChefDating
//
//  Created by 唐斌 on 16/8/19.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyWalletDetailConditionBackgroundView : UIView

@property (nonatomic, copy) void (^choiceConditionBlock)(id data);

@end
