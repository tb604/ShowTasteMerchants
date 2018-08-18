//
//  StandardDataEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/27.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  菜品规格实体类
 */
@interface StandardDataEntity : NSObject

/**
 *  1 有规格；0无规格
 */
@property (nonatomic, assign) NSInteger state;

@property (nonatomic, assign) CGFloat totalHeight;

/**
 *  工艺
 */
@property (nonatomic, strong) NSArray *mode;
/**
 *  视图的高度
 */
@property (nonatomic, assign) CGFloat modeHeight;

/**
 *  口味
 */
@property (nonatomic, strong) NSArray *taste;

@property (nonatomic, assign) CGFloat tasteHeight;

@end

/*
 "standard": {
 "state": 1,
 "mode": [
 "太说我是"
 ],
 "taste": [
 "太胖了"
 ]
 }
*/