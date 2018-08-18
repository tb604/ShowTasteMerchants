//
//  MyRestaurantMouthFoodCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/3.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantMouthFoodCell.h"
#import "LocalCommon.h"
#import "ShopFoodDataEntity.h"

@interface MyRestaurantMouthFoodCell ()
{
    UILabel *_titleLabel;
}

@property (nonatomic, strong) CALayer *line;

@property (nonatomic, strong) ShopFoodDataEntity *foodEntity;

- (void)initWithTitleLabel;

@end

@implementation MyRestaurantMouthFoodCell

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor colorWithHexString:@"#fafafa"];
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#fafafa"];
    self.backgroundColor = [UIColor colorWithHexString:@"#fafafa"];
    
    UIImage *image = [UIImage imageNamed:@"budan_icon_sel"];
    CALayer *line = [CALayer drawLine:self.contentView frame:CGRectMake(15 + image.size.width + 10, kMyRestaurantMouthFoodCellHeight, [[UIScreen mainScreen] screenWidth] - 15 - image.size.width - 10, 0.6) lineColor:[UIColor colorWithHexString:@"#cccccc"]];
    self.line = line;
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        CGRect frame = CGRectMake(_line.left, (kMyRestaurantMouthFoodCellHeight - 20)/2, _line.width - 15, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame  textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    _titleLabel.text = _foodEntity.name;
}

- (void)updateCellData:(id)cellEntity
{
    self.foodEntity = cellEntity;
    
    [self initWithTitleLabel];
}

@end
