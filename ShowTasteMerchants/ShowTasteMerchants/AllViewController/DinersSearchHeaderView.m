//
//  DinersSearchHeaderView.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/9.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DinersSearchHeaderView.h"
#import "LocalCommon.h"

@interface DinersSearchHeaderView ()
{
    UILabel *_titleLabel;
}

@property (nonatomic, strong) NSArray *hotKeyList;

- (void)initWithTitleLabel;

- (void)initWithAllButtons;

@end

@implementation DinersSearchHeaderView

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithTitleLabel];
    
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        NSString *str = @"热门搜索";
        CGFloat width = [str widthForFont:FONTSIZE_15];
        CGRect frame = CGRectMake(15, 15, width, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
        _titleLabel.text = str;
    }
}

- (void)initWithAllButtons
{
    debugLog(@"list=%@", [_hotKeyList modelToJSONString]);
    CGFloat space = 15.0;
    CGFloat bottomSpace = 10.0;
    CGFloat height = 30.0;
    NSInteger col = 4; // 一行4个
    CGFloat width = ([[UIScreen mainScreen] screenWidth] - 15 * ( col + 1)) / col;
    if (kiPhone4 || kiPhone5)
    {
        width = ([[UIScreen mainScreen] screenWidth] - 15 * 2 - 8 * (col - 1)) / col;
    }
    CGRect frame = CGRectMake(0, 0, width, height);
    NSInteger j = 0;
    for (NSInteger i=0; i<[_hotKeyList count]; i++)
    {
//        debugLog(@"i=%d", (int)i);
        if (i % col == 0)
        {
            frame.origin.x = space;
            if (i == 0)
            {
                frame.origin.y = _titleLabel.bottom + 15;
            }
            else
            {
                frame.origin.y = frame.origin.y + frame.size.height + bottomSpace;
            }
            j++;
        }
        else
        {
            if (kiPhone4 || kiPhone5)
            {
                frame.origin.x = frame.origin.x + frame.size.width + space - 7;
            }
            else
            {
                frame.origin.x = frame.origin.x + frame.size.width + space;
            }
        }
        UIButton *button = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:_hotKeyList[i] titleColor:[UIColor colorWithHexString:@"#323232"] titleFont:FONTSIZE_14 targetSel:@selector(clickedWithButton:)];
//        button.titleLabel.font = FONTSIZE_15;
        button.frame = frame;
        button.tag = 100 + i;
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
        [self addSubview:button];
    }
}

- (void)clickedWithButton:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(btn.titleLabel.text);
    }
}

- (void)updateViewData:(id)entity
{
    self.hotKeyList = entity;
    
    [self initWithAllButtons];
    
}

@end


















