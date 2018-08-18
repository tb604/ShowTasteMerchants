//
//  DinersShopingCartViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/26.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DinersShopingCartViewCell.h"
#import "LocalCommon.h"
#import "ShopingCartEntity.h"
#import "AddFoodNumberview.h"

@interface DinersShopingCartViewCell ()
{
    UILabel *_priceLabel;
    
    /**
     *  菜品名称
     */
    UILabel *_foodNameLabel;
    
    UILabel *_descLabel;
    
    AddFoodNumberview *_addFoodNumView;
}

@property (nonatomic, strong) CALayer *line;

@property (nonatomic, strong) ShopingCartEntity *cartEntity;

- (void)initWithPriceLabel;

- (void)initWithFoodNameLabel;

- (void)initWithDescLabel;

- (void)initWithAddFoodNumView;

@end

@implementation DinersShopingCartViewCell

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];

    
}


- (void)initWithLine
{
    if (!_line)
    {
        CALayer *line = [CALayer layer];
        line.size = CGSizeMake([[UIScreen mainScreen] screenWidth] - 30, 0.8);
        line.left = 15;
        line.bottom = [[self class] getWithCellHeight:_cartEntity];
        line.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"].CGColor;
        [self.contentView.layer addSublayer:line];
        self.line = line;
    }
}

- (void)initWithPriceLabel
{
    if (!_priceLabel)
    {
        NSString *str = @"￥12345";
        CGFloat width = [str widthForFont:FONTSIZE_15];
        CGRect frame = CGRectMake(([[UIScreen mainScreen] screenWidth] - width) / 2, 15, width, 20);
        _priceLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentCenter];
    }
}

- (void)initWithFoodNameLabel
{
    if (!_foodNameLabel)
    {
        CGRect frame = CGRectMake(15, _priceLabel.top, _priceLabel.left - 15 - 10, 20);
        _foodNameLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
    }
}

- (void)initWithDescLabel
{
    if (!_descLabel)
    {
        CGRect frame = CGRectMake(15, _foodNameLabel.bottom+2, [[UIScreen mainScreen] screenWidth] - 30, 18);
        _descLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    }
}

- (void)initWithAddFoodNumView
{
    if (!_addFoodNumView)
    {
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - 15 - kAddFoodNumberviewWidth, 10, kAddFoodNumberviewWidth, kAddFoodNumberviewHeight);
        _addFoodNumView = [[AddFoodNumberview alloc] initWithFrame:frame];
        [self.contentView addSubview:_addFoodNumView];
        [_addFoodNumView hiddenWithSpec:YES];
    }
    
    __weak typeof(self)weakSelf = self;
    _addFoodNumView.addFoodBlock = ^(NSInteger type, id button)
    {// 1表示减法；2表示加法
        if (weakSelf.touchAddSubBlock)
        {
            weakSelf.touchAddSubBlock(type, button, weakSelf.cartEntity);
        }
    };
}

+ (CGFloat)getWithCellHeight:(ShopingCartEntity *)cartEnt
{
    NSString *mode = objectNull(cartEnt.mode);
    NSString *taste = objectNull(cartEnt.taste);
    if ([mode isEqualToString:@""] && [taste isEqualToString:@""])
    {
        return 50;
    }
    else
    {
        return 50 + 20;
    }
}


- (void)updateCellData:(id)cellEntity
{
    ShopingCartEntity *cartEnt = cellEntity;
    self.cartEntity = cartEnt;
    
    [self initWithLine];
    
    [self initWithPriceLabel];
    
    [self initWithFoodNameLabel];
    
    [self initWithDescLabel];
    
    [self initWithAddFoodNumView];

    
    
    CGFloat price = (cartEnt.activityPrice==0.0?cartEnt.price:cartEnt.activityPrice) * cartEnt.number;
    NSString *str = [NSString stringWithFormat:@"￥%.0f", price];
    _priceLabel.text = str;
    
    // 菜品名称
    _foodNameLabel.text = cartEnt.name;
    
    // 规格
    NSMutableString *mutStr = [NSMutableString new];
    NSString *mode = objectNull(cartEnt.mode);
    NSString *taste = objectNull(cartEnt.taste);
    if (![mode isEqualToString:@""])
    {
        [mutStr appendFormat:@"%@ ", mode];
    }
    if (![taste isEqualToString:@""])
    {
        [mutStr appendString:taste];
    }
    if ([mutStr length] <= 0)
    {
        _descLabel.hidden = YES;
    }
    else
    {
        _descLabel.hidden = NO;
    }
    _descLabel.text = mutStr;
    
    // 数量
    [_addFoodNumView updateWithAddNum:cartEnt.number];
}


@end













