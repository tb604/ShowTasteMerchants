//
//  TYZChoiceDateBackgroundView.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/3.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZChoiceDateBackgroundView.h"
#import "TYZKit.h"
#import "TYZChoiceDateView.h"

@interface TYZChoiceDateBackgroundView ()
{
    TYZChoiceDateView *_choiceDateView;
}
- (void)initWithSubView;

- (void)initWithChoiceDateView;

@end

@implementation TYZChoiceDateBackgroundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        
        [self initWithSubView];
    }
    return self;
}

- (void)initWithSubView
{
    [self initWithChoiceDateView];
    
    CGRect frame = CGRectMake(0, 0, _choiceDateView.width, _choiceDateView.top);
    UIView *view = [[UIView alloc]initWithFrame:frame];
    [self addSubview:view];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [view addGestureRecognizer:tap];
}

- (void)initWithChoiceDateView
{
    CGRect frame = CGRectMake(0.0f, self.height - 216 - 44, [[UIScreen mainScreen] screenWidth], 216 + 44);
    _choiceDateView = [[TYZChoiceDateView alloc] initWithFrame:frame];
    [self addSubview:_choiceDateView];
    __weak typeof(self)weakSelf = self;
    _choiceDateView.TouchDateBlock = ^(NSString *date, NSInteger type)
    {
        if (weakSelf.TouchDateBlock)
        {
            weakSelf.TouchDateBlock(date, type);
        }
    };
}

- (void)updateWithDate:(NSString *)date
{
    [_choiceDateView updateViewData:date];
}

- (void)tapGesture:(UITapGestureRecognizer *)tap
{
    if (self.TouchDateBlock)
    {
        _TouchDateBlock(nil, 2);
    }
}


@end



























