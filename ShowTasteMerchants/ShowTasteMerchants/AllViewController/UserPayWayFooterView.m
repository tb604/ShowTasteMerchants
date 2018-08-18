//
//  UserPayWayFooterView.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "UserPayWayFooterView.h"
#import "LocalCommon.h"
#import "OrderDetailDataEntity.h"

@interface UserPayWayFooterView ()
{
    UIButton *_btnPay;
}

- (void)initWithBtnPay;

@end

@implementation UserPayWayFooterView

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithBtnPay];
}

- (void)initWithBtnPay
{
    CGRect frame = CGRectMake(15, 80, [[UIScreen mainScreen] screenWidth] - 30, 45);
    _btnPay = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"确认支付34.00元" titleColor:[UIColor whiteColor] titleFont:FONTSIZE_18 targetSel:@selector(clickedPay:)];
    _btnPay.frame = frame;
    _btnPay.backgroundColor = [UIColor colorWithHexString:@"#ff5500"];
    _btnPay.layer.masksToBounds = YES;
    _btnPay.layer.cornerRadius = 4;
    [self addSubview:_btnPay];
}

- (void)clickedPay:(id)sender
{
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(nil);
    }
}

- (void)updateViewData:(id)entity
{
    OrderDetailDataEntity *orderEnt = entity;
    
    NSString *str = nil;
    if (orderEnt.order.status == NS_ORDER_WAITING_PAY_DEPOSIT_STATE)
    {// 支付订金
        str = [NSString stringWithFormat:@"%.2f元，确认支付", orderEnt.order.book_deposit_amount];
    }
    else
    {
        str = [NSString stringWithFormat:@"%.2f元，确认支付", orderEnt.order.pay_actually];
    }
    [_btnPay setTitle:str forState:UIControlStateNormal];
    
}

@end




















