//
//  DinersRecipeViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/24.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DinersRecipeViewCell.h"
#import "LocalCommon.h"
#import "UIImageView+WebCache.h"
#import "ShopFoodDataEntity.h"
#import "AddFoodNumberview.h" // 添加菜品数量按钮

@interface DinersRecipeViewCell ()
{
    UIImageView *_thumalImgView;
    
    /**
     *  菜名
     */
    UILabel *_foodNameLabel;
    
    AddFoodNumberview *_addFoodNumView;
    
    /**
     *  价格
     */
    UILabel *_priceLabel;
    
    
}

@property (nonatomic, strong) ShopFoodDataEntity *foodEntity;

- (void)initWithThumalImgView;

- (void)initWithFoodNameLabel;

- (void)initWithAddFoodNumView;

- (void)initWithPriceLabel;

@end

@implementation DinersRecipeViewCell

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithLine];
    
    [self initWithThumalImgView];
    
    [self initWithFoodNameLabel];
    
    [self initWithAddFoodNumView];
    
    [self initWithPriceLabel];
    
}

- (void)initWithLine
{
    int leftWidth = (int)([[UIScreen mainScreen] screenWidth] / 4.16);
    int rightWidth = [[UIScreen mainScreen] screenWidth] - leftWidth;
    
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake(rightWidth, 0.8);
    line.left = 0;
    line.bottom = [[self class] getWithRecipeViewCellHeight];
    line.backgroundColor = [UIColor colorWithHexString:@"#cbcbcb"].CGColor;
    [self.layer addSublayer:line];
}

- (void)initWithThumalImgView
{
    if (!_thumalImgView)
    {
        int leftWidth = (int)([[UIScreen mainScreen] screenWidth] / 4.16);
        int rightWidth = [[UIScreen mainScreen] screenWidth] - leftWidth;
        CGRect frame = CGRectMake(0, 0, rightWidth, [[self class] getWithImgViewHeight]);
        _thumalImgView = [[UIImageView alloc] initWithFrame:frame];
        _thumalImgView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_thumalImgView];
    }
}

- (void)initWithFoodNameLabel
{
    CGRect frame = CGRectMake(15, _thumalImgView.bottom + 8, _thumalImgView.width - 30, 20);
    _foodNameLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_16 labelTag:0 alignment:NSTextAlignmentLeft];
//    _foodNameLabel.text = @"口水鸡";
//    _foodNameLabel.backgroundColor = [UIColor lightGrayColor];
}

- (void)initWithAddFoodNumView
{
    CGRect frame = CGRectMake(_thumalImgView.width - 15 - kAddFoodNumberviewWidth, 0, kAddFoodNumberviewWidth, kAddFoodNumberviewHeight);
    _addFoodNumView = [[AddFoodNumberview alloc] initWithFrame:frame];
    _addFoodNumView.bottom = [[self class] getWithRecipeViewCellHeight] - 8;
//    _addFoodNumView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_addFoodNumView];
    __weak typeof(self)weakSelf = self;
    _addFoodNumView.addFoodBlock = ^(NSInteger type, id button)
    {// 1表示减法；2表示加法
//        debugLog(@"3333");
        if (weakSelf.touchAddSubBlock)
        {
            weakSelf.touchAddSubBlock(type, button);
        }
    };
}

- (void)initWithPriceLabel
{
    CGRect frame = _foodNameLabel.frame;
    frame.size.width = _addFoodNumView.left - 15 - 10;
    _priceLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
    _priceLabel.bottom = _addFoodNumView.bottom;
//    _priceLabel.backgroundColor = [UIColor lightGrayColor];
}


+ (NSInteger)getWithImgViewHeight
{
    int leftWidth = (int)([[UIScreen mainScreen] screenWidth] / 4.16);
    int rightWidth = [[UIScreen mainScreen] screenWidth] - leftWidth;
    
    return (rightWidth / 1.425);
}

+ (NSInteger)getWithRecipeViewCellHeight
{
    return [self getWithImgViewHeight] + 67;
}


- (void)updateCellData:(id)cellEntity
{
    ShopFoodDataEntity *foodEntity = cellEntity;
    self.foodEntity = foodEntity;
//    debugLog(@"image=%@", _foodEntity.image);
    // 图片
    [_thumalImgView sd_setImageWithURL:[NSURL URLWithString:foodEntity.image] placeholderImage:nil];
    
    // 菜名
    _foodNameLabel.text = foodEntity.name;
    CGFloat price = _foodEntity.activity_price;
    if (price == 0.0)
    {
        price = _foodEntity.price;
    }
    NSString *str = [NSString stringWithFormat:@"￥%.0f  ", price];
    // 价格
    NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] init];
    NSAttributedString *butedStr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16], NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#ff5500"]}];
    [mas appendAttributedString:butedStr];
    if (_foodEntity.activity_price != 0.0)
    {
//        debugLog(@"ddfdfd");
        str = [NSString stringWithFormat:@"￥%.0f", _foodEntity.price];
//        debugLog(@"str=%@", str);
        NSAttributedString *bu = [MCYPushViewController middleSingleLine:objectNull(str) font:FONTSIZE_12 textColor:[UIColor colorWithHexString:@"#cecece"] lineColor:[UIColor colorWithHexString:@"#cecece"]];
        [mas appendAttributedString:bu];
    }
    _priceLabel.attributedText = mas;
    
    if (![objectNull(_foodEntity.mode) isEqualToString:@""] || ![objectNull(_foodEntity.taste) isEqualToString:@""])
    {
        [_addFoodNumView hiddenWithSpec:NO];
    }
    else
    {
        [_addFoodNumView hiddenWithSpec:YES];
    }
}

- (void)updateWithAddNum:(NSInteger)num
{
    
}

@end
















