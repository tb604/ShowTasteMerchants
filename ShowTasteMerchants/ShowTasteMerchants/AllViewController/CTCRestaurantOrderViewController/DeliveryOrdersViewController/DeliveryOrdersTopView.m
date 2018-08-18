//
//  DeliveryOrdersTopView.m
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/17.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DeliveryOrdersTopView.h"
#import "LocalCommon.h"
#import "DeliveryOrdersSingleButton.h"


@interface DeliveryOrdersTopView ()
{
    float _screenWidth;
    
    UIScrollView *_contentView;
}
@property (nonatomic, strong) NSArray *titleList;

@property (nonatomic, strong) NSMutableArray *buttons;



- (void)initWithContentView;

/**
 *  初始化水平的蓝色的线条
 */
- (void)initWithHorizontalBlueLine;

@end

@implementation DeliveryOrdersTopView

- (id)initWithFrame:(CGRect)frame titleList:(NSArray *)titleList
{
    self.titleList = titleList;
    
    return [self initWithFrame:frame];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithVar
{
    [super initWithVar];
    
    _buttons = [NSMutableArray new];
    
    NSInteger count = _titleList.count;
    NSMutableString *mutStr = [NSMutableString new];
    for (NSString *str in _titleList)
    {
        [mutStr appendString:str];
    }
    float width = [mutStr widthForFont:FONTSIZE_13] + 6 * count;
    _screenWidth = 10 * 2 + width + 18 * (count-1);
    
    debugLog(@"widith=%.2f", _screenWidth);
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithContentView];
    
    float btnWidth = 0;
    CGRect frame = CGRectZero;
    for (NSInteger i=0; i<_titleList.count; i++)
    {
        NSString *title = _titleList[i];
        btnWidth = [title widthForFont:FONTSIZE_13] + 6;
        frame = CGRectMake(10, 0, btnWidth, self.height);
        DeliveryOrdersSingleButton *button = [[DeliveryOrdersSingleButton alloc] initWithFrame:frame];
        if (_buttons.count == 0)
        {
            frame.origin.x = 10;
            button.selectButton = YES;
        }
        else
        {
            DeliveryOrdersSingleButton *prevBtn = _buttons[i-1];
            frame.origin.x = prevBtn.right + 18;
        }
        button.frame = frame;
        button.tag = 100 + i;
//        button.backgroundColor = [UIColor lightGrayColor];
        [button updateViewData:_titleList[i] buttonWidth:btnWidth];
        [_buttons addObject:button];
        [_contentView addSubview:button];
        __weak typeof(self)weakSelf = self;
        button.selectButtonBlock = ^(DeliveryOrdersSingleButton *button)
        {// 点击按钮
            [weakSelf clickedWithButton:button];
        };
        
    }
    
    [self initWithHorizontalBlueLine];
}


- (void)initWithContentView
{
    if (!_contentView)
    {
        CGRect frame = self.bounds;
        _contentView = [[UIScrollView alloc] initWithFrame:frame];
        _contentView.showsVerticalScrollIndicator = NO;
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.contentSize = CGSizeMake(_screenWidth, self.height);
        [self addSubview:_contentView];
    }
}

/**
 *  初始化水平的蓝色的线条
 */
- (void)initWithHorizontalBlueLine
{
    if (!_horizontalBlueLine)
    {
        DeliveryOrdersSingleButton *btn = _buttons[0];
        float width = btn.width;
        CGRect frame = CGRectMake(btn.left, self.bounds.size.height - 2, width, 2.0f);
        _horizontalBlueLine = [[UIImageView alloc] initWithFrame:frame];
        _horizontalBlueLine.backgroundColor = [UIColor colorWithHexString:@"#ff5500"];
        [_contentView addSubview:_horizontalBlueLine];
    }
}


- (void)clickedWithButton:(DeliveryOrdersSingleButton *)button
{
    for (DeliveryOrdersSingleButton *btn in _buttons)
    {
        btn.selectButton = NO;
    }
    button.selectButton = YES;
    
    CGRect frame = _horizontalBlueLine.frame;
    frame.size.width = button.width;
    frame.origin.x = button.left;
    
    [UIView animateWithDuration:0.2 animations:^{
        _horizontalBlueLine.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
    
    if (_selectButtonBlock)
    {
        _selectButtonBlock(button.tag - 100);
    }
    
}

@end



















