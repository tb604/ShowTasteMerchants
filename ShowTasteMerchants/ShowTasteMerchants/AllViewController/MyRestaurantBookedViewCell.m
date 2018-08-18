//
//  MyRestaurantBookedViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/13.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantBookedViewCell.h"
#import "LocalCommon.h"
#import "MyRestaurantBookedDateView.h"
#import "MyRestaurantBookedMealView.h"
#import "MyRestaurantBookedRoomView.h"

@interface MyRestaurantBookedViewCell ()
{
    MyRestaurantBookedDateView *_leftDateView;
    
    /**
     *  上午餐
     */
    MyRestaurantBookedMealView *_rightMorningMealView;
    
    /**
     *  下午餐
     */
    MyRestaurantBookedMealView *_rightAfternoonMealView;
}

- (void)initWithLeftDateView;

/**
 *  初始化上午餐
 */
- (void)initWithRightMorningMealView;

/**
 *  初始化下午餐
 */
- (void)initWithRightAfternoonMealView;

@end

@implementation MyRestaurantBookedViewCell


- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithLeftDateView];
    
    // 初始化上午餐
    [self initWithRightMorningMealView];
    
    // 初始化下午餐
    [self initWithRightAfternoonMealView];
}

/**
 *  初始化左边的日期视图
 */
- (void)initWithLeftDateView
{
    CGFloat height = [[self class] getWithCellHeight:10];
    CGRect frame = CGRectMake(0, 0, [MyRestaurantBookedDateView getWithViewWidth], height);
    _leftDateView = [[MyRestaurantBookedDateView alloc] initWithFrame:frame];
    [self.contentView addSubview:_leftDateView];
}

/**
 *  初始化上午餐
 */
- (void)initWithRightMorningMealView
{
    CGFloat height = [[self class] getWithCellHeight:5]+1;
    CGRect frame = CGRectMake(_leftDateView.right, 0, [[UIScreen mainScreen] screenWidth] - _leftDateView.width, height);
    _rightMorningMealView = [[MyRestaurantBookedMealView alloc] initWithFrame:frame isDual:YES];
    [self.contentView addSubview:_rightMorningMealView];
    [_rightMorningMealView updateWithMealType:@"上\n午"];
}

/**
 *  初始化下午餐
 */
- (void)initWithRightAfternoonMealView
{
    CGRect frame = _rightMorningMealView.frame;
    frame.origin.y = _rightMorningMealView.bottom;
    _rightAfternoonMealView = [[MyRestaurantBookedMealView alloc] initWithFrame:frame isDual:NO];
    [self.contentView addSubview:_rightAfternoonMealView];
    [_rightAfternoonMealView hiddenWithLine:YES];
    [_rightAfternoonMealView updateWithMealType:@"下\n午"];
}

- (void)updateCellData:(id)cellEntity
{
    [_leftDateView updateViewData:cellEntity];
    
    [_rightMorningMealView updateViewData:cellEntity];
    
    [_rightAfternoonMealView updateViewData:cellEntity];
}

+ (CGFloat)getWithCellHeight:(NSInteger)count
{
    return kMyRestaurantBookedRoomViewHeight * count;
}

@end
