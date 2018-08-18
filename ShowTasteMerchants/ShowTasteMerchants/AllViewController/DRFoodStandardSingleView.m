//
//  DRFoodStandardSingleView.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/27.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DRFoodStandardSingleView.h"
#import "LocalCommon.h"
#import "FoodStandardButton.h"

@interface DRFoodStandardSingleView ()
{
    UILabel *_titleLabel;
}

@property (nonatomic, assign) BOOL isBrowse;

@property (nonatomic, strong) NSArray *standardList;

@property (nonatomic, strong) NSMutableArray *buttons;



- (void)initWithTitleLabel;

- (void)initWithAllButtons;

@end

@implementation DRFoodStandardSingleView

- (void)initWithVar
{
    [super initWithVar];
    
    _buttons = [[NSMutableArray alloc] initWithCapacity:0];
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithTitleLabel];
    
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        NSString *str = @"工艺：";
        CGFloat width = [str widthForFont:FONTSIZE_15];
        CGRect frame = CGRectMake(15, (30-20)/2, width, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
    }
}

- (void)initWithAllButtons
{
    if ([_buttons count] == 0)
    {
        CGFloat midSpace = 10;
        CGFloat space = 15;
        if ([[UIScreen mainScreen] screenWidth] == 320)
        {
            space = 8;
        }
        CGFloat width = 75;
        CGFloat height = 30;
        CGRect frame = CGRectMake(0, 0, width, height);
        NSInteger j = 0;
        for (NSInteger i=0; i<[_standardList count]; i++)
        {
            NSString *title = _standardList[i];
            if (i % 3 == 0)
            {
                frame.origin.x = _titleLabel.right + space;
                frame.origin.y = j * (midSpace + height);
                j++;
            }
            else
            {
                frame.origin.x = frame.origin.x + frame.size.width + space;
            }
            FoodStandardButton *button = [[FoodStandardButton alloc] initWithFrame:frame];
            [button addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 100 + i;
            button.titleLabel.font = FONTSIZE_14;
            [button setTitle:title forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHexString:@"#ff5500"] forState:UIControlStateSelected];
            button.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
            button.layer.borderWidth = 1;
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 2;
            [self addSubview:button];
            [_buttons addObject:button];
        }
        
        if (!_isBrowse)
        {
            FoodStandardButton *btn = [_buttons objectOrNilAtIndex:0];
            btn.selected = YES;
            [self updateWithborderColor:[UIColor colorWithHexString:@"#ff5500"] button:btn];
            self.currentButton = btn;
        }
    }
}

- (void)clickedButton:(id)sender
{
    if (_isBrowse)
    {
        return;
    }
    FoodStandardButton *btn = (FoodStandardButton *)sender;
    
    for (FoodStandardButton *button in _buttons)
    {
        button.selected = NO;
        [self updateWithborderColor:[UIColor colorWithHexString:@"#999999"] button:button];
    }
    btn.selected = YES;
    [self updateWithborderColor:[UIColor colorWithHexString:@"#ff5500"] button:btn];
    self.currentButton = btn;
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(_standardList[btn.tag - 100]);
    }
}

- (void)updateWithborderColor:(UIColor *)color button:(FoodStandardButton *)button
{
    button.layer.borderColor = color.CGColor;
}

- (void)updateViewData:(id)entity title:(NSString *)title
{
    self.standardList = entity;
    _titleLabel.text = [NSString stringWithFormat:@"%@：", title];
    
    [self initWithAllButtons];
    
}

- (void)updateViewData:(id)entity title:(NSString *)title isBrowse:(BOOL)isBrowse
{
    self.isBrowse = isBrowse;
    [self updateViewData:entity title:title];
}

@end












