//
//  RestaurantIntroEditViewController.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseViewController.h"

/**
 *  餐厅介绍编辑视图控制器
 */
@interface RestaurantIntroEditViewController : TYZBaseViewController

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *placeholder;

/**
 *  字数，为0表示不显示字数
 */
@property (nonatomic, assign) NSInteger fontNumber;

@end
