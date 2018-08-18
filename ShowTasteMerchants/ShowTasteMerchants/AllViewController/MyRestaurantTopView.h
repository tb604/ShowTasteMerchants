//
//  MyRestaurantTopView.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/16.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"

@interface MyRestaurantTopView : TYZBaseView

@property (nonatomic, copy) void(^clickedButtonBlock)(int index);

@property (nonatomic, copy) void(^clickedBtnEditBlock)();

@property (nonatomic, strong) NSMutableArray *buttonLists;

/**
 *  水平的蓝色的线条
 */
@property (nonatomic, strong) UIImageView *horizontalBlueLine;

- (id)initWithFrame:(CGRect)frame btnTitles:(NSArray *)btnTitles;

/**
 *  修改_selectedIndex的值
 *
 *  @param index index
 */
- (void)updateSelectedButtonIndex:(NSInteger)index;

/**
 *  更改线条的位置
 *
 *  @param index index description
 */
- (void)updateHorizonTalPosition:(NSInteger)index;



@end
