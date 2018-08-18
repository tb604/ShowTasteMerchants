//
//  ShopSupplementFoodCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/24.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopSupplementFoodCell.h"
#import "LocalCommon.h"
#import "OrderFoodInfoEntity.h"

@interface ShopSupplementFoodCell ()
{
    
    UIImageView *_thumalImgView;
    
    /**
     *  金额
     */
    UILabel *_amountLabel;
        
    /**
     *  单价(原价)
     */
    UILabel *_unitPriceLabel;
    
    /**
     *  规格
     */
    UILabel *_unitLabel;
    
    /**
     *  数量
     */
    UILabel *_numberLabel;
    
    /**
     *  菜名
     */
    UILabel *_nameLabel;

}

@property (nonatomic, strong) OrderFoodInfoEntity *foodEntity;

@property (nonatomic, strong) CALayer *line;

@property (nonatomic, strong) UIFont *font;

- (void)initWithThumalImgView;

/**
 *  金额
 */
- (void)initWithAmountLabel;

/**
 *  规格
 */
- (void)initWithUnitLabel;

/**
 *  数量
 */
- (void)initWithNumberLabel;

/**
 *  单价
 */
- (void)initWithUnitPriceLabel;


/**
 *  菜名
 */
- (void)initWithNameLabel;



@end

@implementation ShopSupplementFoodCell

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    self.contentView.backgroundColor =  [UIColor colorWithHexString:@"#f5f5f5"];
    self.backgroundColor =  [UIColor colorWithHexString:@"#f5f5f5"];
    
    UIImage *image = [UIImage imageNamed:@"menu_icon_xiala"];
    UIImage *payImage = [UIImage imageNamed:@"pay_selected"];
    CALayer *line = [CALayer drawLine:self.contentView frame:CGRectMake(15 + image.size.width + 5, kShopSupplementFoodCellHeight, [[UIScreen mainScreen] screenWidth] - 30 -image.size.width - payImage.size.width - 10, 0.6) lineColor:[UIColor colorWithHexString:@"#e6e6e6"]];
    self.line = line;
}

- (void)initWithThumalImgView
{
    if (!_thumalImgView)
    {
        UIImage *image = [UIImage imageNamed:@"pay_selected"];
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - image.size.width - 15, (kShopSupplementFoodCellHeight-image.size.height)/2, image.size.width, image.size.height);
        _thumalImgView = [[UIImageView alloc] initWithFrame:frame];
        _thumalImgView.image = image;
        [self.contentView addSubview:_thumalImgView];
    }
    debugLog(@"name=%@; status=%d", _foodEntity.food_name, (int)_foodEntity.status);
    if (_foodEntity.status == NS_ORDER_FOOD_TABLE_STATE)
    {// 已上菜
        _thumalImgView.hidden = NO;
        _thumalImgView.image = [UIImage imageNamed:@"pay_selected"];
    }
    else if (_foodEntity.status == NS_ORDER_FOOD_RETIRED_STATE)
    {// 已退菜
        debugLog(@"已退菜");
        _thumalImgView.hidden = NO;
        _thumalImgView.image = [UIImage imageNamed:@"menu_icon_tui"];
    }
    else
    {
        _thumalImgView.hidden = YES;
    }
}


/**
 *  金额
 */
- (void)initWithAmountLabel
{
    if (!_amountLabel)
    {
        NSString *str = @"22225";
        self.font = FONTSIZE_14;
        if (kiPhone6Plus || kiPhone6)
        {
            str = @"2222225";
            self.font = FONTSIZE_15;
        }
        CGFloat width = [str widthForFont:FONTSIZE_15];
        UIImage *payImage = [UIImage imageNamed:@"pay_selected"];
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - 15 - payImage.size.width - 5 - width - 5, 10, width, 20);
        _amountLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentRight];
//        _amountLabel.backgroundColor = [UIColor lightGrayColor];
    }
    CGFloat price = (_foodEntity.activity_price==0.0?_foodEntity.price:_foodEntity.activity_price);
    _amountLabel.text = [NSString stringWithFormat:@"%.0f", price * _foodEntity.number];
}

/**
 *  规格
 */
- (void)initWithUnitLabel
{
    if (!_unitLabel)
    {
        CGRect frame = _amountLabel.frame;
        frame.size.width = frame.size.width - 10;
        frame.origin.x = _amountLabel.left - frame.size.width - 5;
        _unitLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentRight];
//        _unitLabel.backgroundColor = [UIColor lightGrayColor];
    }
    _unitLabel.text = _foodEntity.unit;
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
        _numberLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentRight];
//        _numberLabel.backgroundColor = [UIColor lightGrayColor];
    }
    _numberLabel.text = [NSString stringWithFormat:@"%d", (int)_foodEntity.number];
}

/**
 *  单价
 */
- (void)initWithUnitPriceLabel
{
    if (!_unitPriceLabel)
    {
        CGRect frame = _numberLabel.frame;
        frame.size.width = _amountLabel.width - 10;
        frame.origin.x = _numberLabel.left - frame.size.width - 5;
        _unitPriceLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentRight];
//        _unitPriceLabel.backgroundColor = [UIColor redColor];
    }
    CGFloat price = (_foodEntity.activity_price==0.0?_foodEntity.price:_foodEntity.activity_price);
    _unitPriceLabel.text = [NSString stringWithFormat:@"%.0f", price];
}

/**
 *  菜名
 */
- (void)initWithNameLabel
{
    if (!_nameLabel)
    {
        CGFloat width = 0;
        if (kiPhone4 || kiPhone5)
        {
            width = 5;
        }
        
        UIImage *image = [UIImage imageNamed:@"menu_icon_xiala"];
        CGRect frame = CGRectMake(_line.left, 10, _unitPriceLabel.left - 15 - 5 + width - 15 - image.size.width, 20);
        _nameLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
//        _nameLabel.backgroundColor = [UIColor lightGrayColor];
    }
    
    NSString *date =[NSDate stringWithDateInOut:_foodEntity.op_datetime inFormat:@"yyyy-MM-dd HH:mm:ss" outFormat:@"HH:mm"];
    if ([objectNull(date) isEqualToString:@""])
    {
        _nameLabel.text = @"未下单";
    }
    else
    {
        _nameLabel.text = date;
    }
}


- (void)updateCellData:(id)cellEntity
{
    self.foodEntity = cellEntity;
    
    [self initWithThumalImgView];
    
    // 金额
    [self initWithAmountLabel];
    
    // 规格
    [self initWithUnitLabel];
    
    // 数量
    [self initWithNumberLabel];
    
    // 单价
    [self initWithUnitPriceLabel];

    
    // 菜名
    [self initWithNameLabel];
    
}

@end









