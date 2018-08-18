//
//  RestaurantEditImageView.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/4.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestaurantEditImageView : UIImageView

@property (nonatomic, strong) void (^touchwithImgViewBlock)(RestaurantEditImageView *imgView);

- (void)updateWithTitle:(NSString *)title;

@property (nonatomic, strong) id imageEntity;

@end
