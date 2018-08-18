//
//  ResaurantAddFoodImageView.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/8.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResaurantAddFoodImageView : UIImageView

@property (nonatomic, copy) void (^touchUploadImageBlock)();

+ (NSInteger)getWithHeight;

- (void)updateWithTitle:(NSString *)title;

- (void)hiddenWithThumalImage:(BOOL)hidden;

@end
