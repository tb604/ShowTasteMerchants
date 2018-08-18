//
//  ShopOrderDetailBottomView.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/4.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopOrderDetailBottomView.h"
#import "LocalCommon.h"
//#import "OrderDataEntity.h"
#import "CTCOrderDetailEntity.h"

@interface ShopOrderDetailBottomView ()
{
    /**
     *  总金额
     */
    UILabel *_totalAmountLabel;
    
    /**
     *  已预付金额
     */
    UILabel *_prepaidAmountLabel;
    
    /**
     *  剩余金额
     */
    UILabel *_remainingAmountLabel;
    
    /**
     *  左边按钮
     */
    UIButton *_btnLeft;
    
    /**
     *  右边按钮
     */
    UIButton *_btnRight;
    
    /**
     *  已预付金额的frame
     */
    CGRect _pframe;
    
    CGRect _rframeOne;
    
    CGRect _rframeTwo;
}

@property (nonatomic, strong) CTCOrderDetailEntity *orderEntity;

/**
 * 总金额
 */
- (void)initWithTotalAmountLabel;

/**
 * 已预付金额
 */
- (void)initWithPrepaidAmountLabel;

/**
 * 剩余金额
 */
- (void)initWithRemainingAmountLabel;

- (void)initWithBtnLeft;

- (void)initWithBtnRight;

@end

@implementation ShopOrderDetailBottomView

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    // 总金额
    [self initWithTotalAmountLabel];
    
    // 已预付金额
    [self initWithPrepaidAmountLabel];
    
    // 剩余金额
    [self initWithRemainingAmountLabel];
    
    [self initWithBtnLeft];
    
    [self initWithBtnRight];
    
    
}

/**
 * 总金额
 */
- (void)initWithTotalAmountLabel
{
    
}

/**
 * 已预付金额
 */
- (void)initWithPrepaidAmountLabel
{
    if (!_prepaidAmountLabel)
    {
        CGRect frame = CGRectMake(15, 5, [[UIScreen mainScreen] screenWidth] / 3 * 2 - 30, 18);
        _prepaidAmountLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
//        _prepaidAmountLabel.backgroundColor = [UIColor lightGrayColor];
        
        _pframe = frame;
    }
}

/**
 * 剩余金额
 */
- (void)initWithRemainingAmountLabel
{
    if (!_remainingAmountLabel)
    {
        CGRect frame = _prepaidAmountLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 3;
        _remainingAmountLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
//        _remainingAmountLabel.backgroundColor = [UIColor lightGrayColor];
        _rframeOne = frame;
        _rframeTwo = frame;
        _rframeTwo.origin.y = (self.height - _remainingAmountLabel.height)/2;
    }
}

- (void)initWithBtnLeft
{
    if (!_btnLeft)
    {
        UIColor *color = [UIColor colorWithHexString:@"#646464"];
        _btnLeft = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:nil titleColor:color titleFont:FONTSIZE_17 targetSel:@selector(clickedButton:)];
//        color = [UIColor colorWithHexString:@"#ff5500"];
//        _btnLeft.backgroundColor = color;
        _btnLeft.tag = 100;
        _btnLeft.frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth]/2, self.height);
        [self addSubview:_btnLeft];
    }
}

- (void)initWithBtnRight
{
    if (!_btnRight)
    {
        UIColor *color = [UIColor colorWithHexString:@"#ffffff"];
        _btnRight = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:nil titleColor:color titleFont:FONTSIZE_17 targetSel:@selector(clickedButton:)];
        color = [UIColor colorWithHexString:@"#ff5500"];
        _btnRight.backgroundColor = color;
        _btnRight.tag = 101;
        _btnRight.frame = CGRectMake([[UIScreen mainScreen] screenWidth]/2, 0, [[UIScreen mainScreen] screenWidth]/2, self.height);
        [self addSubview:_btnRight];
    }
}

- (void)clickedButton:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (self.bottomClickedBlock)
    {
        self.bottomClickedBlock(btn.titleLabel.text, btn.tag);
    }
}

- (NSAttributedString *)attributedTextTitle:(NSString *)title value:(NSString *)value valueColor:(UIColor *)valueColor
{
    NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] init];
    UIColor *color = [UIColor colorWithHexString:@"#646464"];
    NSAttributedString *bTitle = [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName: FONTSIZE(13), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:bTitle];
    
    color = [UIColor colorWithHexString:@"#323232"];
    if (!valueColor)
    {
        valueColor = color;
    }
    NSAttributedString *bValue = [[NSAttributedString alloc] initWithString:value attributes:@{NSFontAttributeName: FONTSIZE(13), NSForegroundColorAttributeName: valueColor}];
    [mas appendAttributedString:bValue];
    
    return mas;
}


- (void)updateViewData:(id)entity
{
    if (_orderEntity.type == 1)
    {// 预订
        _prepaidAmountLabel.frame = _pframe;
        _remainingAmountLabel.frame = _rframeOne;
        _prepaidAmountLabel.hidden = NO;
        _remainingAmountLabel.hidden = NO;
        
        // 已预支付
        NSString *str = [NSString stringWithFormat:@"已预支付：￥%.2f", _orderEntity.book_deposit_amount];
        NSAttributedString *bTitle = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: FONTSIZE(14), NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#323232"]}];
        _prepaidAmountLabel.attributedText = bTitle;
        
        // 剩下支付
        NSMutableAttributedString *mas = [NSMutableAttributedString new];
        bTitle = [[NSAttributedString alloc] initWithString:@"剩下支付：" attributes:@{NSFontAttributeName: FONTSIZE(14), NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#323232"]}];
        [mas appendAttributedString:bTitle];
        str = [NSString stringWithFormat:@"￥%.2f", _orderEntity.pay_amount];
        bTitle = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: FONTSIZE(14), NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#ff5500"]}];
        [mas appendAttributedString:bTitle];
        _remainingAmountLabel.attributedText = mas;
        
    }
    else if (_orderEntity.type == 2)
    {// 即时
//        _orderEntity.pay_amount
        NSString *str = [NSString stringWithFormat:@"应付金额：￥%.2f", _orderEntity.pay_amount];
        NSAttributedString *bTitle = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: FONTSIZE(16), NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#ff5500"]}];
        _remainingAmountLabel.attributedText = bTitle;
        _remainingAmountLabel.frame = _rframeTwo;
        _remainingAmountLabel.hidden = NO;
    }
}

/**
 *  更新
 *
 *  @param entity
 *  @param type       1表示显示左边的信息，leftButton隐藏，rightButton显示；2值显示信息，左右边按钮都以你藏；3只显示右边的按钮；4只显示左边的按钮；5左右按钮都显示，各占一半的宽度；6左右按钮都显示，左边占三分之一，右边占三分之二
 *  @param leftTitle
 *  @param rightTitle
 */
- (void)updateViewData:(id)entity type:(NSInteger)type leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle;
{
    self.orderEntity = entity;
//    _totalAmountLabel.hidden = YES;
    _prepaidAmountLabel.hidden = YES;
    _remainingAmountLabel.hidden = YES;
    _btnLeft.hidden = YES;
    _btnRight.hidden = YES;
    if (type == 1)
    {//  1表示显示左边的信息，leftButton隐藏，rightButton显示
        [self updateViewData:entity];
        _btnRight.frame = CGRectMake([[UIScreen mainScreen] screenWidth] / 3 * 2, 0, [[UIScreen mainScreen] screenWidth] / 3, self.height);
        _btnRight.hidden = NO;
        [_btnRight setTitle:rightTitle forState:UIControlStateNormal];
    }
    else if (type == 2)
    {// 2值显示信息，左右边按钮都隐藏
        _prepaidAmountLabel.hidden = NO;
        _remainingAmountLabel.hidden = NO;
    }
    else if (type == 3)
    {// 3只显示右边的按钮；
        _btnRight.hidden = NO;
        _btnRight.frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], self.height);
        [_btnRight setTitle:rightTitle forState:UIControlStateNormal];
    }
    else if (type == 4)
    {// 4只显示左边的按钮
        _btnLeft.hidden = NO;
        _btnLeft.frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], self.height);
        [_btnLeft setTitle:leftTitle forState:UIControlStateNormal];
    }
    else if (type == 5)
    {// 5左右按钮都显示，各占一半；
        _btnLeft.hidden = NO;
        _btnLeft.frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth] / 2, self.height);
        [_btnLeft setTitle:leftTitle forState:UIControlStateNormal];
        _btnRight.hidden = NO;
        _btnRight.frame = CGRectMake([[UIScreen mainScreen] screenWidth] / 2, 0, [[UIScreen mainScreen] screenWidth] / 2, self.height);
        [_btnRight setTitle:rightTitle forState:UIControlStateNormal];
    }
    else if (type == 6)
    {// 左右按钮都显示，左边占三分之一，右边占三分之二
        _btnLeft.hidden = NO;
        _btnLeft.frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth] / 3, self.height);
        [_btnLeft setTitle:leftTitle forState:UIControlStateNormal];
        _btnRight.hidden = NO;
        _btnRight.frame = CGRectMake([[UIScreen mainScreen] screenWidth] / 3, 0, [[UIScreen mainScreen] screenWidth] / 3 * 2, self.height);
        [_btnRight setTitle:rightTitle forState:UIControlStateNormal];
    }
}

@end
