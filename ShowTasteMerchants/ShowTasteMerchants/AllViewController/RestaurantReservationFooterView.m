//
//  RestaurantReservationFooterView.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/19.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "RestaurantReservationFooterView.h"
#import "LocalCommon.h"

@interface RestaurantReservationFooterView ()
{
    /**
     *  立即预订
     */
    UIButton *_btnReservation;
}

/**
 *  初始化立即预订
 */
- (void)initWithBtnReservation;

@end

@implementation RestaurantReservationFooterView

- (void)initWithSubView
{
    [super initWithSubView];
    
//    self.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    
    /**
     *  初始化立即预订
     */
    [self initWithBtnReservation];
}

/**
 *  初始化立即预订
 */
- (void)initWithBtnReservation
{
    CGRect frame = CGRectMake(15, 50, [[UIScreen mainScreen] screenWidth] - 30, 40);
    _btnReservation = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"去点菜" titleColor:[UIColor colorWithHexString:@"#ffffff"] titleFont:FONTSIZE_18 targetSel:@selector(clickedButton:)];
    _btnReservation.frame = frame;
    _btnReservation.backgroundColor = [UIColor colorWithHexString:@"#ff5701"];
    _btnReservation.layer.masksToBounds = YES;
    _btnReservation.layer.cornerRadius = 3.0;
    [self addSubview:_btnReservation];
}

- (void)clickedButton:(id)sender
{
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(nil);
    }
}

@end



























