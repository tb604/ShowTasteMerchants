//
//  ShopOrderDetailStateCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/4.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopOrderDetailStateHeaderView.h"
#import "LocalCommon.h"
//#import "OrderDataEntity.h"
#import "CTCOrderDetailEntity.h"

@interface ShopOrderDetailStateHeaderView ()
{
    UILabel *_stateLabel;
    
    /**
     *  下单，只有在就餐中才有的
     */
    UIButton *_btnPlaceOrder;
}

@property (nonatomic, strong) CTCOrderDetailEntity *orderEntity;

- (void)initWithStateLabel;

/**
 *  初始化下单按钮
 */
- (void)initWithBtnPlaceOrder;

@end

@implementation ShopOrderDetailStateHeaderView

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithStateLabel];
    
    // 初始化下单按钮
//    [self initWithBtnPlaceOrder];
    
}

- (void)initWithStateLabel
{
    if (!_stateLabel)
    {
        CGRect frame = CGRectMake(20, (kShopOrderDetailStateHeaderViewHeight - 20) / 2, [[UIScreen mainScreen] screenWidth] - 40, 20);
        _stateLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE(20) labelTag:0 alignment:NSTextAlignmentCenter];
    }
}

/**
 *  初始化下单按钮
 */
- (void)initWithBtnPlaceOrder
{
    if (!_btnPlaceOrder)
    {
        NSString *str = @"下单";
        CGFloat width = [str widthForFont:FONTSIZE_15] + 30;
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - 15 - width, (kShopOrderDetailStateHeaderViewHeight - 30) / 2, width, 30);
        _btnPlaceOrder = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:str titleColor:[UIColor colorWithHexString:@"#ff5500"] titleFont:FONTSIZE_15 targetSel:@selector(clickedPlaceOrder:)];
        _btnPlaceOrder.frame = frame;
        _btnPlaceOrder.layer.borderColor = [UIColor colorWithHexString:@"#ff5500"].CGColor;
        _btnPlaceOrder.layer.borderWidth = 1;
        _btnPlaceOrder.layer.masksToBounds = YES;
        _btnPlaceOrder.layer.cornerRadius = 3;
        [self addSubview:_btnPlaceOrder];
    }
    _btnPlaceOrder.hidden = YES;
    if (_orderEntity.status == NS_ORDER_DINING_STATE && _orderEntity.sign_end != 150)
    {// 就餐中
        _btnPlaceOrder.hidden = NO;
    }
}

- (void)clickedPlaceOrder:(id)sender
{
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(nil);
    }
}

- (void)updateViewData:(id)entity
{
    CTCOrderDetailEntity *orderEnt = entity;
    self.orderEntity = orderEnt;
    if (_orderEntity.sign_end == 150)
    {// 异常
        NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] init];
        UIColor *color = [UtilityObject dinersWithOrderStateColor:orderEnt.status];
        NSString *str = [UtilityObject dinersWithOrderState:orderEnt.status];
        NSAttributedString *bTitle = [[NSAttributedString alloc] initWithString:objectNull(str) attributes:@{NSFontAttributeName:FONTSIZE(20), NSForegroundColorAttributeName: color}];
        [mas appendAttributedString:bTitle];
        
        str = [NSString stringWithFormat:@"-%@", objectNull(_orderEntity.sign_end_desc)];
        color = [UIColor colorWithHexString:@"#00cc66"];
        bTitle = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:FONTSIZE_14, NSForegroundColorAttributeName: color}];
        [mas appendAttributedString:bTitle];
        _stateLabel.attributedText = mas;
    }
    else
    {
        _stateLabel.text = [UtilityObject dinersWithOrderState:orderEnt.status];
        _stateLabel.textColor = [UtilityObject dinersWithOrderStateColor:orderEnt.status];
    }
    
    [self initWithBtnPlaceOrder];
    
}


@end
