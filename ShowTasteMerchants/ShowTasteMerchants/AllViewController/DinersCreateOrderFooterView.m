//
//  DinersCreateOrderFooterView.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/28.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DinersCreateOrderFooterView.h"
#import "LocalCommon.h"

@interface DinersCreateOrderFooterView ()
{
    UILabel *_totalLabel;
    
    UILabel *_totalNumLabel;
    
    UILabel *_totalPriceLabel;
    
    UILabel *_descLabel;
}

- (void)initWithTotalLabel;

- (void)initWithTotalNumLabel;

- (void)initWithTotalPriceLabel;

- (void)initWithDescLabel;

@end

@implementation DinersCreateOrderFooterView

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    
    [self initWithTotalLabel];
    
    [self initWithTotalNumLabel];
    
    [self initWithTotalPriceLabel];
    
    [self initWithDescLabel];
}

- (void)initWithTotalLabel
{
    if (!_totalLabel)
    {
        CGRect frame = CGRectMake(15, 10, 60, 18);
        _totalLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
        _totalLabel.text = @"合计";
    }
}

- (void)initWithTotalNumLabel
{
    if (!_totalNumLabel)
    {
        
        NSString *str = @"22222";
        if (kiPhone6Plus)
        {
            str = @"22222222";
        }
        else if (kiPhone6)
        {
            str = @"222222";
        }
        CGFloat width = [str widthForFont:FONTSIZE_15];
        
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - width*3 - 10 - 15, 10, width, 18);
        
        
//        NSString *str = @"555";
//        CGFloat width = [str widthForFont:FONTSIZE_13];
//        CGRect frame = CGRectMake(([[UIScreen mainScreen] screenWidth] - width)/2, 10, width, 18);
        _totalNumLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentRight];
//        _totalNumLabel.text = @"共计";
    }
}

- (void)initWithTotalPriceLabel
{
    if (!_totalPriceLabel)
    {
        NSString *str = @"5555643";
        CGFloat width = [str widthForFont:FONTSIZE_13];
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - width - 15, 10, width, 18);
        _totalPriceLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentRight];
    }
}

- (void)initWithDescLabel
{
    if (!_descLabel)
    {
        CGRect frame = CGRectMake(15, _totalLabel.bottom + 2, [[UIScreen mainScreen] screenWidth] - 30, 20);
        _descLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
        _descLabel.numberOfLines = 0;
//        _descLabel.backgroundColor = [UIColor purpleColor];
    }
}

- (void)updateViewData:(id)entity totalNum:(NSInteger)totalNum totalPrice:(CGFloat)totalPrice
{
    _totalNumLabel.text = [NSString stringWithFormat:@"%d", (int)totalNum];
    
    _totalPriceLabel.text = [NSString stringWithFormat:@"%.0f", totalPrice];
    
    _descLabel.text = entity;
    _descLabel.height = self.height - kDinersCreateOrderFooterViewHeight + 20;
}

@end
















