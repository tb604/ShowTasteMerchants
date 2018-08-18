//
//  MyWalletDetailConditionBackgroundView.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/19.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyWalletDetailConditionBackgroundView.h"
#import "LocalCommon.h"
#import "MyWalletDetailConditionView.h"

@interface MyWalletDetailConditionBackgroundView ()
{
    MyWalletDetailConditionView *_conditionView;
}

- (void)initWithSubView;

- (void)initWithConditionView;

@end

@implementation MyWalletDetailConditionBackgroundView

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
    self.backgroundColor = [UIColor colorWithWhite:-.5 alpha:0.5];
    
    [self initWithConditionView];
}


- (void)initWithConditionView
{
    if (!_conditionView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kMyWalletDetailConditionViewHeight);
        _conditionView = [[MyWalletDetailConditionView alloc] initWithFrame:frame];
        [self addSubview:_conditionView];
    }
    __weak typeof(self)weakSelf = self;
    _conditionView.viewCommonBlock = ^(id data)
    {
        if (weakSelf.choiceConditionBlock)
        {
            weakSelf.choiceConditionBlock(data);
        }
    };
}

@end
