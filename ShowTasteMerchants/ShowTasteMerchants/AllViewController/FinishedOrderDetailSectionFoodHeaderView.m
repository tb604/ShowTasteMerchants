//
//  FinishedOrderDetailSectionFoodHeaderView.m
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/15.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "FinishedOrderDetailSectionFoodHeaderView.h"
#import "LocalCommon.h"
#import "DinersCreateOrderFoodHeaderView.h"
#import "DinersOrderDetailFoodTitleView.h"
#import "CTCOrderDetailEntity.h"


@interface FinishedOrderDetailSectionFoodHeaderView ()
{
    /// 实收金额
    UILabel *_payAmountLabel;
    
    /// 菜品明细
    UILabel *_descLabel;
    
    DinersOrderDetailFoodTitleView *_foodHeaderView;
}

@property (nonatomic, strong) CTCOrderDetailEntity *orderEntity;

/**
 *  实收金额
 */
- (void)initWithPayAmountLabel;

- (void)initWithDescLabel;

- (void)initWithFoodHeaderView;

@end

@implementation FinishedOrderDetailSectionFoodHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    // 实收金额
    [self initWithPayAmountLabel];
    
    [self initWithDescLabel];
    
    [self initWithFoodHeaderView];
    
}

- (NSAttributedString *)attributedTextTitle:(NSString *)title value:(NSString *)value valueColor:(UIColor *)valueColor
{
    NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] init];
    UIColor *color = [UIColor colorWithHexString:@"#646464"];
    NSAttributedString *bTitle = [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:bTitle];
    
    if (valueColor)
    {
        color = valueColor;
    }
    else
    {
        color = [UIColor colorWithHexString:@"#323232"];
    }
    NSAttributedString *bValue = [[NSAttributedString alloc] initWithString:value attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:bValue];
    
    return mas;
}

/**
 *  实收金额
 */
- (void)initWithPayAmountLabel
{
    if (!_payAmountLabel)
    {
        CGRect frame = CGRectMake(15, (45.0-20)/2., [[UIScreen mainScreen] screenWidth] / 2. + 20, 20);
        _payAmountLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    
    NSString *amount = [NSString stringWithFormat:@"￥%.2f", _orderEntity.pay_actually];
    _payAmountLabel.attributedText = [self attributedTextTitle:@"实收金额：" value:amount valueColor:[UIColor colorWithHexString:@"#ff5500"]];
    
}

- (void)initWithDescLabel
{
    if (!_descLabel)
    {
        float width = [[UIScreen mainScreen] screenWidth]/2 - 40;
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - width - 15, (45.0-20)/2., width, 20);
        _descLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentRight];
        _descLabel.text = @"菜品明细";
    }
}

- (void)initWithFoodHeaderView
{
    if (!_foodHeaderView)
    {
        CGRect frame = CGRectMake(0, kFinishedOrderDetailSectionFoodHeaderViewHeight - 30, [[UIScreen mainScreen] screenWidth], 30);
        _foodHeaderView = [[DinersOrderDetailFoodTitleView alloc] initWithFrame:frame titleColor:[UIColor colorWithHexString:@"#646464"]];
        _foodHeaderView.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
        [self addSubview:_foodHeaderView];
    }
}

- (void)updateViewData:(id)entity
{
    self.orderEntity = entity;
    
    [self initWithPayAmountLabel];
}

@end
