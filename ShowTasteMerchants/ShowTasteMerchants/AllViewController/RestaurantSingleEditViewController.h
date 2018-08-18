//
//  RestaurantSingleEditViewController.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseViewController.h"

/**
 *  修改单行信息的视图控制器
 */
@interface RestaurantSingleEditViewController : TYZBaseViewController


@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *placeholder;

@property (nonatomic, assign) BOOL isNumber;

@end
