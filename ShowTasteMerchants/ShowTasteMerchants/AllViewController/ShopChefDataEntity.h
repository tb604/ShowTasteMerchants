//
//  ShopChefDataEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/1.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ShopChefImageDataEntity.h"

/**
 *  餐厅厨师信息
 */
@interface ShopChefDataEntity : NSObject

@property (nonatomic, strong) NSArray *chef_image;

@property (nonatomic, copy) NSString *chef_name;

@property (nonatomic, copy) NSString *chef_intro;
@property (nonatomic, assign) CGFloat chef_introHeight;

@property (nonatomic, copy) NSString *chef_title;

@end
