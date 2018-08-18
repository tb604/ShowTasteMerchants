//
//  CuisineContentDataEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/5/24.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CuisineContentDataEntity : NSObject

@property (nonatomic, assign) NSInteger id;

/**
 *  菜系名称
 */
@property (nonatomic, copy) NSString *name;

/**
 *  宽度
 */
@property (nonatomic, assign) CGFloat menu_nameWidth;

/**
 *  字的个数
 */
@property (nonatomic, assign) NSInteger menu_nameNum;

@property (nonatomic, copy) NSString *sort_index;

@end


























