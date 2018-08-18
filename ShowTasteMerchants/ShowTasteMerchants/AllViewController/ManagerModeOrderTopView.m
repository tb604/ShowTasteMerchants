//
//  ManagerModeOrderTopView.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/14.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ManagerModeOrderTopView.h"
#import "LocalCommon.h"
#import "ManagerModeOrderButton.h"


@interface ManagerModeOrderTopView ()

@property (nonatomic, strong) NSArray *titleList;

@property (nonatomic, strong) CALayer *verticalLineOne;

@property (nonatomic, strong) CALayer *verticalLIneTwo;

@property (nonatomic, strong) NSMutableArray *buttonList;

- (void)initWithVerticalLineOne;

- (void)initWithVerticalLineTwo;

- (void)initWithAllButton;




@end

@implementation ManagerModeOrderTopView

- (void)initWithVar
{
    [super initWithVar];
    
    _selectIndex = -1;
    
    _buttonList = [[NSMutableArray alloc] initWithCapacity:0];
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithLine];
    
    [self initWithVerticalLineOne];
    
    [self initWithVerticalLineTwo];
    
    [self initWithAllButton];
    
}

- (void)initWithLine
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake(self.width, 1);
    line.left = 0;
    line.bottom = kManagerModeOrderTopViewHeight;
    line.backgroundColor = [UIColor colorWithHexString:@"#cbcbcb"].CGColor;
    [self.layer addSublayer:line];
}

- (void)initWithVerticalLineOne
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake(0.8, kManagerModeOrderTopViewHeight - 30);
    line.top = 15;
    line.left = self.width/3;
    line.backgroundColor = [UIColor colorWithHexString:@"#cbcbcb"].CGColor;
    [self.layer addSublayer:line];
    self.verticalLineOne = line;
}

- (void)initWithVerticalLineTwo
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake(0.8, kManagerModeOrderTopViewHeight - 30);
    line.top = 15;
    line.left = self.width/3 * 2;
    line.backgroundColor = [UIColor colorWithHexString:@"#cbcbcb"].CGColor;
    [self.layer addSublayer:line];
    self.verticalLineOne = line;
}

- (void)initWithAllButton
{
//    debugLog(@"count=%d", (int)_titleList.count);
    CGFloat width = ([[UIScreen mainScreen] screenWidth] - 2 - 6) / [_titleList count];
    CGRect frame = CGRectMake(1, 0, width, self.height-1);
    __weak typeof(self)weakSelf = self;
    for (NSInteger i=0; i<[_titleList count]; i++)
    {
        frame.origin.x = 1 + i * (width + 3);
        ManagerModeOrderButton *button = [[ManagerModeOrderButton alloc] initWithFrame:frame];
        button.backgroundColor = [UIColor whiteColor];
        button.tag = 100 + i;
        [self addSubview:button];
        [_buttonList addObject:button];
        [button updateViewData:_titleList[i]];
        button.viewCommonBlock = ^(id data)
        {
            [weakSelf clickedButton:data];
        };
    }

    /*
    CGFloat width = ([[UIScreen mainScreen] screenWidth] - 2 - 6) / 3;
    CGRect frame = CGRectMake(1, 0, width, self.height-1);
    __weak typeof(self)weakSelf = self;
    for (NSInteger i=0; i<3; i++)
    {
        frame.origin.x = 1 + i * (width + 3);
        ManagerModeOrderButton *button = [[ManagerModeOrderButton alloc] initWithFrame:frame];
        button.backgroundColor = [UIColor whiteColor];
        button.tag = 100 + i;
        [self addSubview:button];
        [_buttonList addObject:button];
        button.viewCommonBlock = ^(id data)
        {
            [weakSelf clickedButton:data];
        };
    }*/
}

/*
 CGFloat width = ([[UIScreen mainScreen] screenWidth] - 2 - 4) / [_titleList count];
 CGRect frame = CGRectMake(1, 0, width, self.height-1);
 __weak typeof(self)weakSelf = self;
 for (NSInteger i=0; i<[_titleList count]; i++)
 {
 frame.origin.x = 1 + i * (width + 3);
 ManagerModeOrderButton *button = [[ManagerModeOrderButton alloc] initWithFrame:frame];
 button.backgroundColor = [UIColor whiteColor];
 button.tag = 100 + i;
 [self addSubview:button];
 [_buttonList addObject:button];
 [button updateViewData:_titleList[i]];
 button.viewCommonBlock = ^(id data)
 {
 [weakSelf clickedButton:data];
 };
 }
 */

- (void)clickedButton:(id)sender
{
    ManagerModeOrderButton *button = (ManagerModeOrderButton *)sender;
    if ([self selectedIndex:button.tag - 100])
    {
        if (_clickedButtonBlock)
        {
            _clickedButtonBlock((int)(button.tag - 100));
        }
    }
}

- (BOOL)selectedIndex:(NSInteger)index
{
    if (index != _selectIndex)
    {
        ManagerModeOrderButton *selBtn = nil;
        for (ManagerModeOrderButton *btn in _buttonList)
        {
            //            btn.backgroundColor = [UIColor whiteColor];
            [btn updateWithSelect:NO];
            if (btn.tag == 100 + index)
            {
                selBtn = btn;
            }
        }
        [selBtn updateWithSelect:YES];
        //        selBtn.backgroundColor = [UIColor colorWithHexString:@"#ff5701"];
        _selectIndex = index;
        return YES;
    }
    return NO;
}

- (void)updateViewData:(id)entity
{
    self.titleList = entity;
    [self initWithAllButton];
    
}


@end













