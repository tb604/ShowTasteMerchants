//
//  ShopAccountStatementRealPayView.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/6.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopAccountStatementRealPayView.h"
#import "LocalCommon.h"
#import "OrderDataEntity.h"
#import "CTCMealOrderFoodEntity.h"

@interface ShopAccountStatementRealPayView ()
{
    /**
     *  “实付：”
     */
    UILabel *_titleLabel;
    
    UILabel *_valueLabel;
}

- (void)initWithTitleLabel;

- (void)initWithValueLabel;

- (void)tapGesture:(UITapGestureRecognizer *)tap;

@end

@implementation ShopAccountStatementRealPayView

- (void)initWithSubView
{
    [super initWithSubView];
    self.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    
    [self initWithTitleLabel];
    
    [self initWithValueLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self addGestureRecognizer:tap];
    
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        CGRect frame = CGRectMake(15, (self.height - 20) / 2, self.width / 3, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
        _titleLabel.text = @"实付：";
    }
}

- (void)initWithValueLabel
{
    if (!_valueLabel)
    {
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - 15 - 150, (self.height - 20) / 2, 150, 20);
        _valueLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE_18 labelTag:0 alignment:NSTextAlignmentRight];
//        _valueLabel.backgroundColor = [UIColor lightGrayColor];
    }
}

- (void)tapGesture:(UITapGestureRecognizer *)tap
{
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(nil);
    }
}

- (void)updateViewData:(id)entity
{
//    CTCMealOrderFoodEntity *orderEntity = entity;
//    NSString *str = [NSString stringWithFormat:@"%.2f", orderEntity.];
//    _valueLabel.text = str;
}

@end


















