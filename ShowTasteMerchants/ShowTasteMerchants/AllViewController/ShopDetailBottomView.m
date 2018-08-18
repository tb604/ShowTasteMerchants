//
//  ShopDetailBottomView.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/1.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopDetailBottomView.h"
#import "LocalCommon.h"

@interface ShopDetailBottomView ()

@property (nonatomic, strong) CALayer *line;

/**
 *  即时就餐
 */
@property (nonatomic, strong) UIButton *btnNowDin;

/**
 *  餐厅预订
 */
@property (nonatomic, strong) UIButton *btnShopReserve;

/**
 *  即时就餐
 */
- (void)initWithBtnNowDin;

/**
 *  餐厅预订
 */
- (void)initWithBtnShopReserve;

@end

@implementation ShopDetailBottomView

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
    
    [self initWithLine];
    
    /**
     *  即时就餐
     */
    [self initWithBtnNowDin];
    
    /**
     *  餐厅预订
     */
    [self initWithBtnShopReserve];
}

- (void)initWithLine
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake(0.8, self.height - 20);
    line.top = 10;
    line.centerX = [[UIScreen mainScreen] screenWidth] / 2;
    line.backgroundColor = [UIColor colorWithHexString:@"#ffffff"].CGColor;
    [self.layer addSublayer:line];
    self.line = line;
}

/**
 *  即时就餐
 */
- (void)initWithBtnNowDin
{
    CGRect frame = CGRectMake(0, 0, self.width/2, self.height);
    _btnNowDin = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"即时就餐" titleColor:[UIColor whiteColor] titleFont:FONTSIZE_16 targetSel:@selector(clickedButton:)];
    _btnNowDin.tag = 100;
    _btnNowDin.frame = frame;
    [self addSubview:_btnNowDin];
}

/**
 *  餐厅预订
 */
- (void)initWithBtnShopReserve
{
    CGRect frame = CGRectMake(_line.right, 0, self.width/2, self.height);
    _btnShopReserve = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"餐厅预订" titleColor:[UIColor whiteColor] titleFont:FONTSIZE_16 targetSel:@selector(clickedButton:)];
    _btnShopReserve.tag = 101;
    _btnShopReserve.frame = frame;
    [self addSubview:_btnShopReserve];

}


- (void)clickedButton:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(btn.titleLabel.text);
    }
}

@end
