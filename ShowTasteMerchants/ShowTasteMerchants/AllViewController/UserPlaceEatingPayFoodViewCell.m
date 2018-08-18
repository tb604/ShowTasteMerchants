//
//  UserPlaceEatingPayFoodViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "UserPlaceEatingPayFoodViewCell.h"
#import "LocalCommon.h"
#import "OrderFoodInfoEntity.h"

@interface UserPlaceEatingPayFoodViewCell ()
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
    
    UILabel *_modeTasteLabel;
    
}
//@property (nonatomic, strong) CALayer *line;

@property (nonatomic, strong) OrderFoodInfoEntity *foodEntity;

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

- (void)initWithModeTasteLabel;

@end

@implementation UserPlaceEatingPayFoodViewCell

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
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
    
    [self initWithModeTasteLabel];
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
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - 15 - 5 - width, 10, width, 20);
        _amountLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_14 labelTag:0 alignment:NSTextAlignmentRight];
//        _amountLabel.backgroundColor = [UIColor lightGrayColor];
    }
}
- (void)initWithAcAmountLabel
{
    if (!_acAmountLabel)
    {
        CGRect frame = _amountLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _acAmountLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE_14 labelTag:0 alignment:NSTextAlignmentRight];
//        _acAmountLabel.backgroundColor = [UIColor lightGrayColor];
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
        _unitLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_14 labelTag:0 alignment:NSTextAlignmentRight];
//        _unitLabel.backgroundColor = [UIColor lightGrayColor];
    }
}
- (void)initWithAcUnitLabel
{
    if (!_acUnitLabel)
    {
        CGRect frame = _unitLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _acUnitLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE_14 labelTag:0 alignment:NSTextAlignmentRight];
//        _acUnitLabel.backgroundColor = [UIColor lightGrayColor];
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
        _numberLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_14 labelTag:0 alignment:NSTextAlignmentRight];
//        _numberLabel.backgroundColor = [UIColor lightGrayColor];
    }
}
- (void)initWithAcNumberLabel
{
    if (!_acNumberLabel)
    {
        CGRect frame = _numberLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _acNumberLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE_14 labelTag:0 alignment:NSTextAlignmentRight];
//        _acNumberLabel.backgroundColor = [UIColor lightGrayColor];
    }
}

/**
 *  单价
 */
- (void)initWithUnitPriceLabel
{
    if (!_unitPriceLabel)
    {
        CGRect frame =_numberLabel.frame;
        frame.origin.x = _numberLabel.left - frame.size.width - 5;
        _unitPriceLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_14 labelTag:0 alignment:NSTextAlignmentRight];
//        _unitPriceLabel.backgroundColor = [UIColor lightGrayColor];
    }
}
- (void)initWithAcUnitPriceLabel
{
    if (!_acUnitPriceLabel)
    {
        CGRect frame = _unitPriceLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _acUnitPriceLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE_14 labelTag:0 alignment:NSTextAlignmentRight];
//        _acUnitPriceLabel.backgroundColor = [UIColor lightGrayColor];
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
        _nameLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_14 labelTag:0 alignment:NSTextAlignmentLeft];
//        _nameLabel.backgroundColor = [UIColor purpleColor];
    }
}

- (void)initWithModeTasteLabel
{
    if (!_modeTasteLabel)
    {
        CGRect frame = _nameLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _modeTasteLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_14 labelTag:0 alignment:NSTextAlignmentLeft];
//        _modeTasteLabel.backgroundColor = [UIColor purpleColor];
    }
}

+ (CGFloat)getWithCellHeight:(OrderFoodInfoEntity *)foodEntity
{
    NSString *mode = objectNull(foodEntity.mode);
    NSString *taste = objectNull(foodEntity.taste);
    //    debugLog(@"mode=%@; taste=%@", mode, taste);
    CGFloat height = 0;
    if ([mode isEqualToString:@""] && [taste isEqualToString:@""] && foodEntity.activity_price == 0.0)
    {// 菜品的工艺、口味为空，活动价格没有的时候
        height = 40.0;
    }
    else
    {
        height = 58.0;
    }
    //    debugLog(@"ddf==%.2f", height);
    return height;
}



- (void)updateCellData:(id)cellEntity
{
    OrderFoodInfoEntity *foodEntity = cellEntity;
    self.foodEntity = foodEntity;
    
    if (_foodEntity.activity_price == 0.0)
    {// 活动价格没有
        // 金额
        _amountLabel.text = [NSString stringWithFormat:@"%.0f", _foodEntity.price * _foodEntity.number];
        
        // 单价
        _unitPriceLabel.text = [NSString stringWithFormat:@"%.0f", _foodEntity.price];
        
        // 单位
        _unitLabel.text = _foodEntity.unit;
        
        // 数量
        _numberLabel.text = [NSString stringWithFormat:@"%d", (int)_foodEntity.number];
        
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
        _unitPriceLabel.text = [NSString stringWithFormat:@"%.0f", _foodEntity.price];
        
        // 单位
        _unitLabel.text = _foodEntity.unit;
        
        // 数量
        _numberLabel.text = @"--";
        
        _acAmountLabel.text = [NSString stringWithFormat:@"%.0f", _foodEntity.activity_price * _foodEntity.number];
        _acUnitPriceLabel.text = [NSString stringWithFormat:@"%.0f", _foodEntity.activity_price];
        _acUnitLabel.text = _foodEntity.unit;
        _acNumberLabel.text = [NSString stringWithFormat:@"%d", (int)_foodEntity.number];
        
        _acAmountLabel.hidden = NO;
        _acUnitPriceLabel.hidden = NO;
        _acUnitLabel.hidden = NO;
        _acNumberLabel.hidden = NO;
    }

    // 金额
   /* if (foodEntity.activity_price == 0.0)
    {
        _amountLabel.text = [NSString stringWithFormat:@"%.0f", foodEntity.price*foodEntity.number];
        _amountLabel.hidden = NO;
        _acAmountLabel.hidden = YES;
        _acUnitPriceLabel.hidden = YES;
        _acNumberLabel.hidden = YES;
        _acUnitLabel.hidden = YES;
    }
    else
    {
        _acAmountLabel.text = [NSString stringWithFormat:@"%.0f", foodEntity.activity_price*foodEntity.number];
        _amountLabel.hidden = YES;
        _acAmountLabel.hidden = NO;
        _acUnitPriceLabel.hidden = NO;
        _acNumberLabel.hidden = NO;
        _acUnitLabel.hidden = NO;
    }
    
    
//    NSMutableAttributedString *mas = [NSMutableAttributedString new];
//    UIColor *color = [UIColor colorWithHexString:@"#ff5500"];
//    NSAttributedString *bTitle = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.0f", ] attributes:@{NSFontAttributeName: FONTSIZE(12), NSForegroundColorAttributeName: color}];
    
//    NSString *strPrice = [NSString stringWithFormat:@"%.0f/%.0f", foodEntity.price,  foodEntity.activity_price];
    // 单价
    _unitPriceLabel.text = [NSString stringWithFormat:@"%.0f", foodEntity.price];
    _acUnitPriceLabel.text = [NSString stringWithFormat:@"%.0f", foodEntity.activity_price];
    
    // 规格
    _unitLabel.text = [NSString stringWithFormat:@"%@", foodEntity.unit];
    _acUnitLabel.text = _unitLabel.text;
    
    // 数量
    _numberLabel.text = [NSString stringWithFormat:@"%d", (int)foodEntity.number];
    _acNumberLabel.text = _numberLabel.text;
    */
    
    // 菜名
    _nameLabel.text = objectNull(foodEntity.food_name);
    
    NSString *mode = objectNull(foodEntity.mode);
    NSString *taste = objectNull(foodEntity.taste);
    if ([mode isEqualToString:@""] && [taste isEqualToString:@""])
    {
        _modeTasteLabel.hidden = YES;
    }
    else
    {
        _modeTasteLabel.hidden = NO;
        NSMutableString *mutStr = [NSMutableString new];
        if (![mode isEqualToString:@""])
        {
            [mutStr appendFormat:@"%@ ", mode];
        }
        [mutStr appendString:taste];
        _modeTasteLabel.text = mutStr;
    }
    
}


@end
