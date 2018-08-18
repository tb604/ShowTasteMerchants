//
//  DinersOrderDetailBottomView.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/20.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DinersOrderDetailBottomView.h"
#import "LocalCommon.h"
#import "OrderDataEntity.h"

@interface DinersOrderDetailBottomView ()
{
    /**
     *  总金额
     */
    UILabel *_totalPriceLabel;
    
    UILabel *_descLabel;
    
    UIButton *_btnSubmit;
}

@property (nonatomic, strong) OrderDataEntity *orderEntity;

- (void)initWithTotalPriceLabel;

- (void)initWithDescLabel;

- (void)initWithBtnSubmit;
@end

@implementation DinersOrderDetailBottomView

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithTotalPriceLabel];
    
    [self initWithDescLabel];

    
    [self initWithBtnSubmit];
}

- (void)initWithTotalPriceLabel
{
    if (!_totalPriceLabel)
    {
        CGRect frame = CGRectZero;
        CGFloat width = [[UIScreen mainScreen] screenWidth];
        frame = CGRectMake(15, (self.height - 20) / 2 - 8, width - width / 3 - 15 - 10, 20);
        _totalPriceLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE(17) labelTag:0 alignment:NSTextAlignmentLeft];
    }
    
    CGFloat price = 0.0;
    NSString *str = [NSString stringWithFormat:@"总额：￥%.0f", price];
    _totalPriceLabel.text = str;
}

- (void)initWithDescLabel
{
    if (!_descLabel)
    {
        CGRect frame = CGRectMake(15, _totalPriceLabel.bottom, _totalPriceLabel.width, 16);
        _descLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#cccccc"] fontSize:FONTSIZE(12) labelTag:0 alignment:NSTextAlignmentLeft];
        _descLabel.text = @"预付金额为订餐金额的20%";
    }
}


- (void)initWithBtnSubmit
{
    if (!_btnSubmit)
    {
        UIColor *color = [UIColor colorWithHexString:@"#ffffff"];
        _btnSubmit = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:nil titleColor:color titleFont:FONTSIZE_17 targetSel:@selector(clickedButton:)];
        color = [UIColor colorWithHexString:@"#ff5500"];
        _btnSubmit.backgroundColor = color;
        _btnSubmit.tag = 101;
        _btnSubmit.frame = CGRectMake([[UIScreen mainScreen] screenWidth]/2, 0, [[UIScreen mainScreen] screenWidth]/2, self.height);
        [self addSubview:_btnSubmit];
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

/**
 *  更新
 *
 *  @param data           data
 *  @param buttonWithType 宽度类型；1表示屏幕宽度；2表示屏幕宽度的一半；3表示屏幕宽度的三分之一
 *  @param buttonTitle    按钮标题
 */
- (void)updateWithBottom:(id)data buttonWidthType:(NSInteger)buttonWithType buttonTitle:(NSString *)buttonTitle
{
    self.orderEntity = data;
    _totalPriceLabel.hidden = NO;
    _descLabel.hidden = NO;
    [_btnSubmit setTitle:buttonTitle forState:UIControlStateNormal];
    CGFloat screenWidth = [[UIScreen mainScreen] screenWidth];
    if (buttonWithType == 1)
    {
        _btnSubmit.left = 0;
        _btnSubmit.width = screenWidth;
        _totalPriceLabel.hidden = YES;
        _descLabel.hidden = YES;
    }
    else if (buttonWithType == 2)
    {
        _totalPriceLabel.hidden = YES;
        _descLabel.hidden = YES;
        _btnSubmit.left = screenWidth / 2;
        _btnSubmit.width = screenWidth / 2;
    }
    else
    {
        _btnSubmit.left = screenWidth / 3 * 2;
        _btnSubmit.width = screenWidth / 3;
        
        if (_orderEntity.type == 1)
        {// 预订
            if (_orderEntity.status == NS_ORDER_WAITING_PAY_DEPOSIT_STATE)
            {// 待支付订金(已接单)
                NSString *str = [NSString stringWithFormat:@"订金：%.2f", _orderEntity.book_deposit_amount];
                _totalPriceLabel.text = str;
                _descLabel.text = @"预付金为订餐金额的20%";
            }
        }
        else if (_orderEntity.type == 2)
        {// 即时
            if (_orderEntity.status == NS_ORDER_ORDER_NOT_ACTIVE_STATE)
            {// 订单未激活(即时订单)
                NSString *str = [NSString stringWithFormat:@"总额：%.0f", _orderEntity.pay_amount];
                _totalPriceLabel.text = str;
                _descLabel.text = @"秀味App支付，可获分佣收益";
            }
        }
        
    }
}


/*- (void)updateBottomCancel:(NSString *)cancelTitle submitTitle:(NSString *)submitTitle
{
    [self initwithBtnCancel];
    
    [self initWithBtnSubmit];
    
    _btnCancel.hidden = NO;
    _btnSubmit.hidden = NO;
    if (cancelTitle && !submitTitle)
    {
        _btnCancel.frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], self.height);
        _btnSubmit.hidden = YES;
    }
    else if (!cancelTitle && submitTitle)
    {
        _btnSubmit.frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], self.height);
        _btnCancel.hidden = YES;
    }
    else if (cancelTitle && submitTitle)
    {
        _btnSubmit.frame = CGRectMake([[UIScreen mainScreen] screenWidth]/2, 0, [[UIScreen mainScreen] screenWidth]/2, self.height);
        _btnCancel.frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth]/2, self.height);
    }
    
    //    debugLog(@"can=%@; sub=%@", cancelTitle, submitTitle);
    [_btnCancel setTitle:cancelTitle forState:UIControlStateNormal];
    [_btnSubmit setTitle:submitTitle forState:UIControlStateNormal];
}*/


@end
