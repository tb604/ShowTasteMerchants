//
//  ShopAccountStatementBackgroundView.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/5.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopAccountStatementBackgroundView.h"
#import "LocalCommon.h"
#import "ShopAccountStatementView.h"

@interface ShopAccountStatementBackgroundView ()
{
    /**
     *  结算清单视图
     */
    ShopAccountStatementView *_accountStatementView;
}

- (void)initWithSubView;

- (void)initWithAccountStatementView;

@end

@implementation ShopAccountStatementBackgroundView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initWithSubView];
    }
    return self;
}

- (void)initWithSubView
{
    self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.6];
    
    [self initWithAccountStatementView];
}

- (void)initWithAccountStatementView
{
    if (!_accountStatementView)
    {
        AppDelegate *app = [UtilityObject appDelegate];
        CGRect frame = CGRectMake(0, STATUSBAR_HEIGHT + [app navBarHeight], [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight] - STATUSBAR_HEIGHT - [app navBarHeight]);
        _accountStatementView = [[ShopAccountStatementView alloc] initWithFrame:frame];
        [self addSubview:_accountStatementView];
    }
    __weak typeof(self)weakSelf = self;
    _accountStatementView.viewCommonBlock = ^(id data)
    {
        if (weakSelf.touchAccountStatementBlock)
        {
            weakSelf.touchAccountStatementBlock(data);
        }
    };
    _accountStatementView.modifyActuallyAmountBlock = ^(id data)
    {
        if (weakSelf.modifyActuallyAmountBlock)
        {
            weakSelf.modifyActuallyAmountBlock(data);
        }
    };
}

- (void)updateWithData:(id)data
{
    [_accountStatementView updateViewData:data];
}

@end












