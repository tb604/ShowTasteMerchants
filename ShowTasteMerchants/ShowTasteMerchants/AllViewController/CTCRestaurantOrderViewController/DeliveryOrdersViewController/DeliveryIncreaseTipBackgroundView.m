//
//  DeliveryIncreaseTipBackgroundView.m
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/18.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DeliveryIncreaseTipBackgroundView.h"
#import "DeliveryIncreaseTipView.h"
#import "LocalCommon.h"

@interface DeliveryIncreaseTipBackgroundView ()
{
    DeliveryIncreaseTipView *_tipView;
}

- (void)initWithSubView;

- (void)initWithTipView;

@end

@implementation DeliveryIncreaseTipBackgroundView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self initWithSubView];
    }
    return self;
}

- (void)initWithSubView
{
    self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    
    [self initWithTipView];
    __weak typeof(self)weakSelf = self;
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], _tipView.top)];
    [self addSubview:topView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
        [weakSelf endEditing:YES];
    }];
    [topView addGestureRecognizer:tap];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, _tipView.bottom, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight] - _tipView.bottom)];
    [self addSubview:bottomView];
    [bottomView addGestureRecognizer:tap];
}

- (void)initWithTipView
{
    if (!_tipView)
    {
        CGRect frame = CGRectMake(([[UIScreen mainScreen] screenWidth] - 300)/2., 0, 300, 180);
        _tipView = [[DeliveryIncreaseTipView alloc] initWithFrame:frame];
        _tipView.centerY = self.height / 2 - 60;
        [self addSubview:_tipView];
    }
    __weak typeof(self)weakSelf = self;
    _tipView.viewCommonBlock = ^(id data)
    {
        if (weakSelf.touchViewBlock)
        {
            weakSelf.touchViewBlock(data);
        }
    };
}

@end




















