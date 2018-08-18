//
//  DinersSearchResultTopView.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/11.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DinersSearchResultTopView.h"
#import "LocalCommon.h"

@interface DinersSearchResultTopView ()
{
    /**
     *  附近
     */
    UIButton *_btnNearby;
    
    /**
     *  菜系
     */
    UIButton *_btnCuisine;
}
@property (nonatomic, strong) CALayer *line;

/**
 *  附近
 */
- (void)initWithBtnNearby;

/**
 *  菜系
 */
- (void)initWithBtnCuisine;

@end

@implementation DinersSearchResultTopView

- (void)initWithSubView
{
    [super initWithSubView];
    self.backgroundColor = [UIColor whiteColor];
    
    CALayer *line = [CALayer drawLine:self frame:CGRectMake([[UIScreen mainScreen] screenWidth] / 2, 10, 0.8, self.height - 20) lineColor:[UIColor colorWithHexString:@"#e6e6e6"]];
    self.line = line;
    
    // 附近
    [self initWithBtnNearby];
    
    // 菜系
    [self initWithBtnCuisine];
    
    [CALayer drawLine:self frame:CGRectMake(0, self.height, self.width, 0.8) lineColor:[UIColor colorWithHexString:@"#ff5700"]];
}

/**
 *  附近
 */
- (void)initWithBtnNearby
{
    if (!_btnNearby)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth] / 2, self.height - 0.8);
        _btnNearby = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"附近" titleColor:[UIColor colorWithHexString:@"#646464"] titleFont:FONTSIZE_13 targetSel:@selector(clickedWithButton:)];
        _btnNearby.frame = frame;
        _btnNearby.tag = 100;
        [self addSubview:_btnNearby];
    }
}

/**
 *  菜系
 */
- (void)initWithBtnCuisine
{
    if (!_btnCuisine)
    {
        CGRect frame = CGRectMake( [[UIScreen mainScreen] screenWidth] / 2, 0, [[UIScreen mainScreen] screenWidth] / 2, self.height - 0.8);
        _btnCuisine = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"菜系" titleColor:[UIColor colorWithHexString:@"#646464"] titleFont:FONTSIZE_13 targetSel:@selector(clickedWithButton:)];
        _btnCuisine.frame = frame;
        _btnCuisine.tag = 101;
        [self addSubview:_btnCuisine];
    }
}

- (void)clickedWithButton:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(@(btn.tag));
    }
}

@end












