//
//  MyRestaurantManagerEditViewBg.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/28.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopManagePositionAuthEntity.h"

@interface MyRestaurantManagerEditViewBg : UIView

@property (nonatomic, strong) ShopManagePositionAuthEntity *postionAuthEntity;

@property (nonatomic, copy) void (^editViewBlock)(id data);

- (void)updateWithData:(id)data title:(NSString *)title;

@end
