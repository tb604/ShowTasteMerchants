//
//  WYXCalendarDayCell.h
//  51tour
//
//  Created by 唐斌 on 15/12/31.
//  Copyright © 2015年 51tour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYXCalendarDayModel.h"
#import "WYXCalendarColor.h"

@interface WYXCalendarDayCell : UICollectionViewCell

/**
 *  日期
 */
@property (nonatomic, strong, nullable) UILabel *dayLabel;

/**
 *  农历
 */
@property (nonatomic, strong, nullable) UILabel *dayTitleLabel;

//@property (nonatomic, strong, nullable) UIImageView *imgView;

@property (nonatomic, strong, nullable) CAShapeLayer *backgroundLayer;

//@property (nonatomic, strong, nullable) WYXCalendarDayModel *model;


- (void)updateCalendarData:(id __nullable)entity;

@end






























