//
//  RestaurantClassifiyBottomView.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/6.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "RestaurantClassifiyBottomView.h"
#import "LocalCommon.h"


@interface RestaurantClassifiyBottomView ()
{
    UIButton *_btnSubmit;
}

- (void)initWithBtnSubmit;

@end

@implementation RestaurantClassifiyBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self topLineWithHidden:YES];
    
    [self initWithBtnSubmit];
}

- (void)initWithBtnSubmit
{
    if (!_btnSubmit)
    {
        AppDelegate *app = [UtilityObject appDelegate];
        CGRect frame = CGRectMake(0, 0, 100, 38);
        _btnSubmit = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"确认" titleColor:[UIColor whiteColor] titleFont:FONTSIZE_15 targetSel:@selector(clickedButton:)];
        _btnSubmit.frame = frame;
        _btnSubmit.center = CGPointMake([[UIScreen mainScreen] screenWidth] / 2, [app tabBarHeight]/2);
        
        [self addSubview:_btnSubmit];
    }
}

- (void)clickedButton:(id)sender
{
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(nil);
    }
}

@end
