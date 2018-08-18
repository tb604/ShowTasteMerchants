//
//  MyRestaurantMouthArchiveFoodCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/5.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantMouthArchiveFoodCell.h"
#import "LocalCommon.h"
#import "ShopFoodDataEntity.h"

@interface MyRestaurantMouthArchiveFoodCell ()
{
    UILabel *_foodNameLabel;
}

@property (nonatomic, strong) ShopFoodDataEntity *foodEntity;

- (void)initWithFoodNameLabel;

@end

@implementation MyRestaurantMouthArchiveFoodCell

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    self.backgroundView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    
    [CALayer drawLine:self.contentView frame:CGRectMake(15, 40, [[UIScreen mainScreen] screenWidth] / 2, 0.6) lineColor:[UIColor colorWithHexString:@"#e0e0e0"]];
}

- (void)initWithFoodNameLabel
{
    if (!_foodNameLabel)
    {
        CGRect frame = CGRectMake(15, (40-20)/2, [[UIScreen mainScreen] screenWidth] / 2 - 30, 20);
        _foodNameLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    _foodNameLabel.text = _foodEntity.name;
}

- (void)updateCellData:(id)cellEntity
{
    self.foodEntity = cellEntity;
    
    [self initWithFoodNameLabel];
}

@end
