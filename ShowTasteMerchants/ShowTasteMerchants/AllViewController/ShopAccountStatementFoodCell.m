//
//  ShopAccountStatementFoodCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/7.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopAccountStatementFoodCell.h"
#import "LocalCommon.h"
#import "OrderFoodInfoEntity.h"
#import "CTCMealOrderFoodEntity.h"

@interface ShopAccountStatementFoodCell ()
{
    /**
     *  金额
     */
    UILabel *_amountLabel;
    UILabel *_acAmountLabel; // 活动的
    
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
     *  口味、工艺
     */
    UILabel *_modeTasteLabel;
}

@property (nonatomic, strong) CALayer *line;

@property (nonatomic, strong) OrderFoodInfoEntity *foodEntity;

@property (nonatomic, strong) CTCMealOrderFoodEntity *nfoodEntity;

//- (void)initWithThumalImgView;

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

@implementation ShopAccountStatementFoodCell

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

- (void)initWithLine
{
    if (!_line)
    {
        CALayer *line = [CALayer drawDashLine:self.contentView frame:CGRectMake(0, 2- 0.6, [[UIScreen mainScreen] screenWidth], 0.6) lineSpacing:5 lineColor:[UIColor colorWithHexString:@"#cdcdcd"] lineWidth:4];
        self.line = line;
    }
    CGFloat height = 0.0;
    if (_foodEntity)
    {
        [[self class] getWithCellHeight:_foodEntity];
    }
    else if (_nfoodEntity)
    {
        [[self class] getWithCellHeight:_nfoodEntity];
    }
    _line.top = height - 0.6;
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
        _amountLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentRight];
        //    _amountLabel.backgroundColor = [UIColor lightGrayColor];
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
        CGRect frame =_numberLabel.frame;
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

- (void)initWithModeTasteLabel
{
    if (!_modeTasteLabel)
    {
        CGRect frame = _nameLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _modeTasteLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_14 labelTag:0 alignment:NSTextAlignmentLeft];
//        _modeTasteLabel.backgroundColor = [UIColor lightGrayColor];
    }
}

+ (CGFloat)getWithCellHeight:(id)foodEntity
{
    OrderFoodInfoEntity *foodEnt = nil;
    CTCMealOrderFoodEntity *nfoodEnt = nil;
    float acprice = 0.0;
    NSString *mode = nil;
    NSString *taste = nil;
    if ([foodEntity isKindOfClass:[OrderFoodInfoEntity class]])
    {
        foodEnt = foodEntity;
        mode = objectNull(foodEnt.mode);
        taste = objectNull(foodEnt.taste);
        acprice = foodEnt.activity_price;
    }
    else if ([foodEntity isKindOfClass:[CTCMealOrderFoodEntity class]])
    {
        nfoodEnt = foodEntity;
        mode = objectNull(nfoodEnt.mode);
        taste = objectNull(nfoodEnt.taste);
        acprice = nfoodEnt.food_activity_price;
    }
    // OrderFoodInfoEntity
//    CTCMealOrderFoodEntity
//    NSString *mode = objectNull(foodEntity.mode);
//    NSString *taste = objectNull(foodEntity.taste);
    //    debugLog(@"mode=%@; taste=%@", mode, taste);
    CGFloat height = 0;
    if ([mode isEqualToString:@""] && [taste isEqualToString:@""] && acprice == 0.0)
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
    self.foodEntity = nil;
    self.nfoodEntity = nil;
    OrderFoodInfoEntity *foodEntity = cellEntity;
    if ([cellEntity isKindOfClass:[OrderFoodInfoEntity class]])
    {
        self.foodEntity = cellEntity;
    }
    else if ([cellEntity isKindOfClass:[CTCMealOrderFoodEntity class]])
    {
        self.nfoodEntity = cellEntity;
    }
//    self.foodEntity = foodEntity;
    
    float activity_price = 0.0;
    float price = 0.0;
    NSInteger number = 0;
    NSString *unit = @"";
    NSString *food_name = @"";
    NSString *mode = @"";//objectNull(foodEntity.mode);
    NSString *taste = @"";//objectNull(foodEntity.taste);
    if (_foodEntity)
    {
        activity_price = _foodEntity.activity_price;
        price = _foodEntity.price;
        number = _foodEntity.number;
        unit = _foodEntity.unit;
        food_name = _foodEntity.food_name;
        mode = objectNull(foodEntity.mode);
        taste = objectNull(foodEntity.taste);
    }
    else if (_nfoodEntity)
    {
        activity_price = _nfoodEntity.food_activity_price;
        price = _nfoodEntity.food_price;
        number = _nfoodEntity.food_number;
        unit = _nfoodEntity.unit;
        food_name = _nfoodEntity.food_name;
        mode = objectNull(_nfoodEntity.mode);
        taste = objectNull(_nfoodEntity.taste);
    }
    
    
    if (activity_price == 0.0)
    {// 活动价格没有
        // 金额
        _amountLabel.text = [NSString stringWithFormat:@"%.0f", price * number];
        
        // 单价
        _unitPriceLabel.text = [NSString stringWithFormat:@"%.0f", price];
        
        // 单位
        _unitLabel.text = unit;
        
        // 数量
        _numberLabel.text = [NSString stringWithFormat:@"%d", (int)number];
        
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
        _unitPriceLabel.text = [NSString stringWithFormat:@"%.0f", price];
        
        // 单位
        _unitLabel.text = unit;
        
        // 数量
        _numberLabel.text = @"--";
        
        _acAmountLabel.text = [NSString stringWithFormat:@"%.0f", activity_price * number];
        _acUnitPriceLabel.text = [NSString stringWithFormat:@"%.0f", activity_price];
        _acUnitLabel.text = _foodEntity.unit;
        _acNumberLabel.text = [NSString stringWithFormat:@"%d", (int)number];
        
        _acAmountLabel.hidden = NO;
        _acUnitPriceLabel.hidden = NO;
        _acUnitLabel.hidden = NO;
        _acNumberLabel.hidden = NO;
    }

    // 菜名
    _nameLabel.text = objectNull(food_name);
     
    
    [self initWithLine];
    
    
    if ([mode isEqualToString:@""] && [taste isEqualToString:@""])
    {
        _modeTasteLabel.text = nil;
    }
    else
    {
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
