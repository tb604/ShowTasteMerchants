//
//  DinersCreateOrderBottomView.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/28.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DinersCreateOrderBottomView.h"
#import "LocalCommon.h"
#import "RestaurantReservationInputEntity.h"
#import "ShopingCartEntity.h" // 购物车里面的数据实体类

@interface DinersCreateOrderBottomView ()
{
    UIButton *_btnSubmit;
    
    /**
     *  总金额
     */
    UILabel *_totalPriceLabel;
    
    UILabel *_descLabel;
}

@property (nonatomic, strong) RestaurantReservationInputEntity *foodEntity;

- (void)initWithBtnSubmit;

- (void)initWithTotalPriceLabel;

- (void)initWithDescLabel;

@end

@implementation DinersCreateOrderBottomView

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithBtnSubmit];
}

- (void)initWithBtnSubmit
{
    CGFloat width = [[UIScreen mainScreen] screenWidth] / 3.125;
    CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - width, 0, width, self.height);
    _btnSubmit = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"提交" titleColor:[UIColor whiteColor] titleFont:FONTSIZE_18 targetSel:@selector(clickedWithSubmit:)];
    _btnSubmit.frame = frame;
    _btnSubmit.backgroundColor = [UIColor colorWithHexString:@"#ff5500"];
    [self addSubview:_btnSubmit];
}

- (void)initWithTotalPriceLabel
{
    if (!_totalPriceLabel)
    {
        CGRect frame = CGRectZero;
//        if (_foodEntity.type == 1)
//        {// 预订就餐
//            frame = CGRectMake(15, 8, _btnSubmit.left - 15 - 10, 20);
//        }
//        else
//        {// 即时就餐
            frame = CGRectMake(15, (self.height - 20) / 2, _btnSubmit.left - 15 - 10, 20);
//        }
        _totalPriceLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE(18) labelTag:0 alignment:NSTextAlignmentLeft];
    }
    
    CGFloat price = 0.0;
    for (ShopingCartEntity *ent in _foodEntity.foodList)
    {
        price += ((ent.activityPrice==0.0?ent.price:ent.activityPrice) * ent.number);
    }
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

- (void)clickedWithSubmit:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(btn.titleLabel.text);
    }
}

- (void)updateWithTitle:(NSString *)title
{
    [_btnSubmit setTitle:title forState:UIControlStateNormal];
}

- (void)updateViewData:(id)entity
{
    self.foodEntity = entity;
    
    [self initWithTotalPriceLabel];
    
//    if (_foodEntity.type == 1)
//    {// 预订
//        [self initWithDescLabel];
//    }
//    else if (_foodEntity.type == 2)
//    {// 即时
//        [self initWithDescLabel];
//    }
}

@end













