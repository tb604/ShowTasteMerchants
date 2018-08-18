//
//  DinersCreateOrderFoodViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/28.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DinersCreateOrderFoodViewCell.h"
#import "LocalCommon.h"
#import "ShopingCartEntity.h"

@interface DinersCreateOrderFoodViewCell ()
{
    /**
     *  金额
     */
    UILabel *_amountLabel;
    UILabel *_acAmountLabel;
    
    /**
     *  规格
     */
    UILabel *_unitLabel;
    UILabel *_acUnitLabel;
    
    /**
     *  数量
     */
    UILabel *_numberLabel;
    UILabel *_acNumberLabel;
    
    /**
     *  单价
     */
    UILabel *_unitPriceLabel;
    UILabel *_acUnitPriceLabel;
    
    /**
     *  菜名
     */
    UILabel *_nameLabel;
    
    /**
     *  规格
     */
    UILabel *_modeTasteLabel;
    
}
@property (nonatomic, strong) CALayer *line;

@property (nonatomic, strong) ShopingCartEntity *foodEntity;

/**
 *  金额
 */
- (void)initWithAmountLabel;
- (void)initWithAcAmountLabel;

/**
 *  规格
 */
- (void)initWithUnitLabel;
- (void)initWithAcUnitLabel;

/**
 *  数量
 */
- (void)initWithNumberLabel;
- (void)initWithAcNumberLabel;

/**
 *  单价
 */
- (void)initWithUnitPriceLabel;
- (void)initWithAcUnitPriceLabel;

/**
 *  菜名
 */
- (void)initWithNameLabel;

/**
 *  规格
 */
- (void)initWithModeTasteLabel;


@end

@implementation DinersCreateOrderFoodViewCell

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithLine];
    
    // 金额
    [self initWithAmountLabel];
    [self initWithAcAmountLabel];
    
    // 规格
    [self initWithUnitLabel];
    [self initWithAcUnitLabel];
    
    // 数量
    [self initWithNumberLabel];
    [self initWithAcNumberLabel];
    
    // 单价
    [self initWithUnitPriceLabel];
    [self initWithAcUnitPriceLabel];
    
    // 菜名
    [self initWithNameLabel];
}

- (void)initWithLine
{
    if (!_line)
    {
        CALayer *line = [CALayer layer];
        line.size = CGSizeMake([[UIScreen mainScreen] screenWidth], 0.6);
        line.left = 0;
        line.bottom = 0;
        line.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"].CGColor;
        [self.layer addSublayer:line];
        self.line = line;
    }
}

/**
 *  金额
 */
- (void)initWithAmountLabel
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
    if (!_amountLabel)
    {
        CGFloat width = [str widthForFont:FONTSIZE_15];
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - 15 - width, 10, width, 20);
        _amountLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentRight];
    }
}
- (void)initWithAcAmountLabel
{
    if (!_acAmountLabel)
    {
        CGRect frame = _amountLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _acAmountLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentRight];
    }
}

/**
 *  规格
 */
- (void)initWithUnitLabel
{
    if (!_unitLabel)
    {
        CGRect frame = _amountLabel.frame;
        frame.origin.x = _amountLabel.left - frame.size.width - 5;
        _unitLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentRight];
        //    _unitLabel.backgroundColor = [UIColor lightGrayColor];
    }
}
- (void)initWithAcUnitLabel
{
    if (!_acUnitLabel)
    {
        CGRect frame = _unitLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _acUnitLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentRight];
    }
}

/**
 *  数量
 */
- (void)initWithNumberLabel
{
    if (!_numberLabel)
    {
        CGRect frame = _unitLabel.frame;
        frame.origin.x = _unitLabel.left - frame.size.width - 5;
        _numberLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentRight];
        //    _numberLabel.backgroundColor = [UIColor lightGrayColor];
    }
}
- (void)initWithAcNumberLabel
{
    if (!_acNumberLabel)
    {
        CGRect frame = _numberLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _acNumberLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentRight];
    }
}

/**
 *  单价
 */
- (void)initWithUnitPriceLabel
{
    if (!_unitPriceLabel)
    {
        CGRect frame = _numberLabel.frame;
        frame.origin.x = _numberLabel.left - frame.size.width - 5;
        _unitPriceLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentRight];
        //    _unitPriceLabel.backgroundColor = [UIColor lightGrayColor];
    }
}
- (void)initWithAcUnitPriceLabel
{
    if (!_acUnitPriceLabel)
    {
        CGRect frame = _unitPriceLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _acUnitPriceLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentRight];
    }
}

/**
 *  菜名
 */
- (void)initWithNameLabel
{
    if (!_nameLabel)
    {
        CGRect frame = CGRectMake(15, 10, _unitPriceLabel.left - 15, 20);
        _nameLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
        //    _nameLabel.backgroundColor = [UIColor purpleColor];
    }
}

/**
 *  规格
 */
- (void)initWithModeTasteLabel
{
    if (!_modeTasteLabel)
    {
        CGRect frame = CGRectMake(15, _nameLabel.bottom + 2, _nameLabel.width, 16);
        _modeTasteLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    _modeTasteLabel.hidden = NO;
    
    NSMutableString *mutStr = [NSMutableString new];
    if (![objectNull(_foodEntity.mode) isEqualToString:@""])
    {
        [mutStr appendString:_foodEntity.mode];
    }
    if (![objectNull(_foodEntity.taste) isEqualToString:@""])
    {
        if ([mutStr length] == 0)
        {
            [mutStr appendString:_foodEntity.taste];
        }
        else
        {
            [mutStr appendFormat:@" %@", _foodEntity.taste];
        }
    }
    _modeTasteLabel.text = mutStr;
}


- (void)updateCellData:(id)cellEntity
{
    ShopingCartEntity *foodEnt = cellEntity;
    self.foodEntity = foodEnt;
    CGFloat height = 0;
    BOOL ret = NO;
    if ([objectNull(foodEnt.mode) isEqualToString:@""] && [objectNull(foodEnt.taste) isEqualToString:@""] && foodEnt.activityPrice == 0.0)
    {
        height = kDinersCreateOrderFoodViewCellMinHeight;
    }
    else
    {
        ret = YES;
        height = kDinersCreateOrderFoodViewCellMaxHeight;
    }
    _line.bottom = height;
    
    if (foodEnt.activityPrice == 0.0)
    {// 活动价格没有
        // 金额
        _amountLabel.text = [NSString stringWithFormat:@"%.0f", foodEnt.price * foodEnt.number];
        
        // 单价
        _unitPriceLabel.text = [NSString stringWithFormat:@"%.0f", foodEnt.price];
        
        // 单位
        _unitLabel.text = foodEnt.unit;
        
        // 数量
        _numberLabel.text = [NSString stringWithFormat:@"%d", (int)foodEnt.number];
        
        _acAmountLabel.hidden = YES;
        _acUnitPriceLabel.hidden = YES;
        _acUnitLabel.hidden = YES;
        _acNumberLabel.hidden = YES;
    }
    else
    {
        // 金额
        _amountLabel.text = @"--";
        
        // 单价
        _unitPriceLabel.text = [NSString stringWithFormat:@"%.0f", foodEnt.price];
        
        // 单位
        _unitLabel.text = foodEnt.unit;
        
        // 数量
        _numberLabel.text = @"--";
        
        _acAmountLabel.text = [NSString stringWithFormat:@"%.0f", foodEnt.activityPrice * foodEnt.number];
        _acUnitPriceLabel.text = [NSString stringWithFormat:@"%.0f", foodEnt.activityPrice];
        _acUnitLabel.text = foodEnt.unit;
        _acNumberLabel.text = [NSString stringWithFormat:@"%d", (int)foodEnt.number];
        _acAmountLabel.hidden = NO;
        _acUnitPriceLabel.hidden = NO;
        _acUnitLabel.hidden = NO;
        _acNumberLabel.hidden = NO;
    }
    
    // 菜名
    _nameLabel.text = foodEnt.name;
    
    if (ret)
    {
        // 规格
        [self initWithModeTasteLabel];
    }
    else
    {
        _modeTasteLabel.hidden = YES;
    }
}

@end
