//
//  DeliveryOrderFoodInfoViewCell.m
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/17.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DeliveryOrderFoodInfoViewCell.h"
#import "LocalCommon.h"
#import "HungryOrderFoodEntity.h"


@interface DeliveryOrderFoodInfoViewCell ()
{
    /// 物品名称
    UILabel *_foodNameLabel;
    
    /// 数量
    UILabel *_quantityLabel;
    
    /// 规格
    UILabel *_specsLabel;
}
@property (nonatomic, strong) CALayer *bottomLine;

@property (nonatomic, strong) HungryOrderFoodEntity *foodEntity;

/**
 *  物品名称
 */
- (void)initWithFoodNameLabel;

/**
 *  物品数量
 */
- (void)initWithQuantityLabel;

/**
 *  规格
 */
- (void)initWithSpecsLabel;


@end

@implementation DeliveryOrderFoodInfoViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    self.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    
    
    CALayer *line = [CALayer drawLine:self.contentView frame:CGRectMake(10, kDeliveryOrderFoodInfoViewCellHeight - 0.5, [[UIScreen mainScreen] screenWidth] - 20, 0.5) lineColor:[UIColor colorWithHexString:@"#e1e1e1"]];
    self.bottomLine = line;
    
}

/**
 *  物品名称
 */
- (void)initWithFoodNameLabel
{
    if (!_foodNameLabel)
    {
        CGRect frame = CGRectMake(10, 8, [[UIScreen mainScreen] screenWidth] - 20, 16);
        _foodNameLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    _foodNameLabel.text = _foodEntity.name;
}

/**
 *  物品数量
 */
- (void)initWithQuantityLabel
{
    if (!_quantityLabel)
    {
        NSString *str = @"x35";
        float width = [str widthForFont:FONTSIZE_15];
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - 10 - width, _foodNameLabel.bottom + 4, width, 16);
        _quantityLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentRight];
    }
    
    _quantityLabel.text = [NSString stringWithFormat:@"x%d", (int)_foodEntity.quantity];
}

/**
 *  规格
 */
- (void)initWithSpecsLabel
{
    if (!_specsLabel)
    {
        CGRect frame = CGRectMake(10, _foodNameLabel.bottom + 4, _quantityLabel.left - 10 - 10, 16);
        _specsLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    NSMutableString *mutStr = [NSMutableString new];
    for (NSString *str in _foodEntity.specs)
    {
        [mutStr appendFormat:@"、%@", str];
    }
    if ([mutStr length] > 0)
    {
        _specsLabel.text = [mutStr substringFromIndex:1];
    }
    else
    {
        _specsLabel.text = @"无规格";
    }
}


- (void)hiddenBottomLine:(BOOL)hidden
{
    _bottomLine.hidden = hidden;
}

- (void)updateCellData:(id)cellEntity
{
    self.foodEntity = cellEntity;
    
    // 物品名称
    [self initWithFoodNameLabel];
    
    // 物品数量
    [self initWithQuantityLabel];
    
    // 规格
    [self initWithSpecsLabel];
}

@end













