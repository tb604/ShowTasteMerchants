//
//  ShopModifyActuallyAmountBackgroundView.h
//  ChefDating
//
//  Created by 唐斌 on 16/8/7.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopModifyActuallyAmountBackgroundView : UIView

@property (nonatomic, copy) void (^modifyAmountBlock)(id data);


- (void)updateWithData:(id)data;

@end
