//
//  WaitingNoticeOrderView.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/15.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "WaitingNoticeOrderView.h"
#import "LocalCommon.h"

@interface WaitingNoticeOrderView ()
{
    UILabel *_tipLabel;
    
    UILabel *_numberLabel;
    
    // btn_tiaozhuan
    UIButton *_btnWait;
}

- (void)initWithTipLabel;

- (void)initWithNumberLabel;

- (void)initWithBtnWait;

- (void)tapGesture:(UITapGestureRecognizer *)tap;

@end

@implementation WaitingNoticeOrderView

- (void)initWithVar
{
    [super initWithVar];
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor colorWithHexString:@"#ff5500"];
    
    [self initWithTipLabel];
    
    [self initWithNumberLabel];
    
    [self initWithBtnWait];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self addGestureRecognizer:tap];
}

- (void)initWithTipLabel
{
    if (!_tipLabel)
    {
        NSString *str = @"待处理订单消息";
        CGFloat width = [str widthForFont:FONTSIZE_14] + 5;
        CGRect frame = CGRectMake(15, (self.height-20)/2, width, 20);
        _tipLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor whiteColor] fontSize:FONTSIZE_14 labelTag:0 alignment:NSTextAlignmentLeft];
        _tipLabel.text = str;
    }
}

- (void)initWithNumberLabel
{
    if (!_numberLabel)
    {
        CGRect frame = CGRectMake(_tipLabel.right, (self.height - 20)/2, 20, 20);
        _numberLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentCenter];
        _numberLabel.layer.masksToBounds = YES;
        _numberLabel.layer.cornerRadius = frame.size.width / 2;
        _numberLabel.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
//        _numberLabel.text = @"7";
    }
}

- (void)initWithBtnWait
{
    if (!_btnWait)
    {
        UIImage *image = [UIImage imageNamed:@"btn_tiaozhuan"];
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - 15 - image.size.width, (self.height - image.size.height*1.5)/2, image.size.width*1.5, image.size.height*1.5);
        _btnWait = [TYZCreateCommonObject createWithButton:self imgNameNor:@"btn_tiaozhuan" imgNameSel:@"btn_tiaozhuan" targetSel:@selector(clickedWithButton:)];
//        _btnWait.backgroundColor = [UIColor purpleColor];
        _btnWait.frame = frame;
        [self addSubview:_btnWait];
    }
}

- (void)tapGesture:(UITapGestureRecognizer *)tap
{
    [self clickedWithButton:nil];
}

- (void)clickedWithButton:(id)sender
{
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(nil);
    }
}

- (void)updateViewData:(id)entity
{
    _numberLabel.text = entity;
}

@end
