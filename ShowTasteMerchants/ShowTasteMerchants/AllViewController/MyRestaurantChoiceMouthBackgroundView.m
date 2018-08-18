//
//  MyRestaurantChoiceMouthBackgroundView.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/5.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantChoiceMouthBackgroundView.h"
#import "LocalCommon.h"
#import "MyRestaurantChoiceMouthView.h"

@interface MyRestaurantChoiceMouthBackgroundView ()
{
    MyRestaurantChoiceMouthView *_choiceMouthView;
}

@property (nonatomic, strong) NSArray *mouthList;

- (void)initWithSubView;

- (void)initWithChoiceMouthView;

@end

@implementation MyRestaurantChoiceMouthBackgroundView

- (id)initWithFrame:(CGRect)frame mouthList:(NSArray *)mouthList
{
    self.mouthList = mouthList;
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initWithSubView];
    }
    return self;
}

- (void)initWithSubView
{
    self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    
    [self initWithChoiceMouthView];
    
    CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], self.height - _choiceMouthView.height);
    UIView *view = [[UIView alloc] initWithFrame:frame];
    [self addSubview:view];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [view addGestureRecognizer:tap];
}

- (void)tapGesture:(UITapGestureRecognizer *)tap
{
    if (_choiceMouthBlock)
    {
        _choiceMouthBlock(nil);
    }
}

- (void)initWithChoiceMouthView
{
    if (!_choiceMouthView)
    {
        CGRect frame = CGRectMake(0, self.height - 40 * 5, [[UIScreen mainScreen] screenWidth], 40 * 5);
        _choiceMouthView = [[MyRestaurantChoiceMouthView alloc] initWithFrame:frame];
        [self addSubview:_choiceMouthView];
    }
    [_choiceMouthView updateViewData:_mouthList];
    __weak typeof(self)weakSelf = self;
    _choiceMouthView.viewCommonBlock = ^(id data)
    {
        if (weakSelf.choiceMouthBlock)
        {
            weakSelf.choiceMouthBlock(data);
        }
    };
}

@end
