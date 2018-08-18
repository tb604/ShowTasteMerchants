//
//  DRFoodDetailBaseViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/27.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DRFoodDetailBaseViewCell.h"
#import "LocalCommon.h"
//#import "AddFoodNumberview.h"
#import "AddShopingCartButton.h"
#import "ShopFoodDataEntity.h" // 菜品详情
#import "ShopingCartEntity.h" // 购物车里面的字段

@interface DRFoodDetailBaseViewCell ()
{
    AddShopingCartButton *_addFoodNumView;
    
    /**
     *  菜品的名称
     */
    UILabel *_foodNameLabel;
    
    /**
     *  价格
     */
    UILabel *_priceLabel;
    
    /**
     *  月售数量
     */
    UILabel *_mothSellNumLabel;
    
    /**
     *  点赞的图标
     */
    UIImageView *_praiseImgView;
    
    /**
     *  点赞的数量
     */
    UILabel *_praiseNumLabel;
    
    BOOL _isBrowse;
}

/**
 *  购物车里面的数据
 */
@property (nonatomic, strong) NSArray *shopingCartList;

- (void)initWithAddFoodNumView;

- (void)initWithFoodNameLabel;

- (void)initWithPriceLabel;

/**
 *  月售数量
 */
- (void)initWithMothSellNumLabel;

/**
 *  赞的图标
 */
- (void)initWithPraiseImgView;

/**
 *  赞的数量
 */
- (void)initWithPraiseNumLabel;

@end

@implementation DRFoodDetailBaseViewCell

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithLine];
    
    [self initWithAddFoodNumView];
    
    [self initWithFoodNameLabel];
    
    [self initWithPriceLabel];
    
    // 月售数量
    [self initWithMothSellNumLabel];
    
    // 赞的图标
    [self initWithPraiseImgView];
    
    // 赞的数量
    [self initWithPraiseNumLabel];
}

- (void)initWithLine
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake([[UIScreen mainScreen] screenWidth], 0.6);
    line.left = 0;
    line.bottom = kDRFoodDetailBaseViewCellHeight;
    line.backgroundColor = [UIColor colorWithHexString:@"#cacaca"].CGColor;
    [self.contentView.layer addSublayer:line];
}


- (void)initWithAddFoodNumView
{
    CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - 15 - kAddShopingCartButtonWidth, kDRFoodDetailBaseViewCellHeight - 15 - kAddShopingCartButtonHeight, kAddShopingCartButtonWidth, kAddShopingCartButtonHeight);
    _addFoodNumView = [[AddShopingCartButton alloc] initWithFrame:frame];
    [self.contentView addSubview:_addFoodNumView];
    __weak typeof(self)weakSelf = self;
    _addFoodNumView.addFoodBlock = ^(UIButton *button)
    {
        if (weakSelf.addFoodBlock)
        {
            weakSelf.addFoodBlock(button);
        }
    };
}

- (void)initWithFoodNameLabel
{
    if (!_foodNameLabel)
    {
        CGRect frame = CGRectMake(15, 15, [[UIScreen mainScreen] screenWidth] - 30, 20);
        _foodNameLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_18 labelTag:0 alignment:NSTextAlignmentLeft];
    }
}

- (void)initWithPriceLabel
{
    if (!_priceLabel)
    {
        CGRect frame = CGRectMake(10, _foodNameLabel.bottom + 5, _addFoodNumView.left - 10 - 10, 20);
        _priceLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
    }
}

/**
 *  月售数量
 */
- (void)initWithMothSellNumLabel
{
    if (!_mothSellNumLabel)
    {
        CGRect frame = CGRectMake(15, _priceLabel.bottom + 5, 20, 20);
        _mothSellNumLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
    }
}

/**
 *  赞的图标
 */
- (void)initWithPraiseImgView
{
    if (!_praiseImgView)
    {
        UIImage *image = [UIImage imageNamed:@"order-o_icon_zan"];
        CGRect frame = CGRectMake(_mothSellNumLabel.right + 10 , 0, image.size.width, image.size.height);
        _praiseImgView = [[UIImageView alloc] initWithFrame:frame];
        _praiseImgView.image = image;
        _praiseImgView.centerY = _mothSellNumLabel.centerY;
        [self.contentView addSubview:_praiseImgView];
    }
}

/**
 *  赞的数量
 */
- (void)initWithPraiseNumLabel
{
    if (!_praiseNumLabel)
    {
        CGRect frame = CGRectMake(0, 0, 20, 20);
        _praiseNumLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
        _praiseNumLabel.centerY = _mothSellNumLabel.centerY;
    }
}


- (void)updateCellData:(id)cellEntity shopingCarts:(NSArray *)shopingCarts selMode:(NSString *)selMode selTaste:(NSString *)selTaste isBrowse:(BOOL)isBrowse
{
    _isBrowse = isBrowse;
    if (_isBrowse)
    {
        _addFoodNumView.hidden = YES;
    }
    else
    {
        _addFoodNumView.hidden = NO;
    }
    ShopFoodDataEntity *foodEntity = cellEntity;
    self.shopingCartList = shopingCarts;
    // 菜品名称
    _foodNameLabel.text = objectNull(foodEntity.name);
    
    // 价格
    CGFloat price = foodEntity.activity_price;
    if (price == 0.0)
    {
        price = foodEntity.price;
    }
    NSString *str = [NSString stringWithFormat:@"￥%.0f ", price];
    NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] init];
    NSAttributedString *butedStr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: FONTSIZE(18), NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#ff5500"]}];
    [mas appendAttributedString:butedStr];
    if (foodEntity.activity_price != 0.0)
    {
        //        debugLog(@"ddfdfd");
        str = [NSString stringWithFormat:@"￥%.0f", foodEntity.price];
        //        debugLog(@"str=%@", str);
        NSAttributedString *bu = [MCYPushViewController middleSingleLine:objectNull(str) font:FONTSIZE_13 textColor:[UIColor colorWithHexString:@"#999999"] lineColor:[UIColor colorWithHexString:@"#999999"]];
        [mas appendAttributedString:bu];
    }
    _priceLabel.attributedText = mas;
    
    // 月售数量
    str = [NSString stringWithFormat:@"月售%d", 234];
    CGFloat width = [str widthForFont:_mothSellNumLabel.font];
    _mothSellNumLabel.width = width;
    _mothSellNumLabel.text = str;
    
    // 点赞图标
    _praiseImgView.left = _mothSellNumLabel.right + 10;
    str = [NSString stringWithFormat:@"%d", 23];
    width = [str widthForFont:_priceLabel.font];
    _praiseNumLabel.width = width;
    _praiseNumLabel.left = _praiseImgView.right + 2;
    _praiseNumLabel.text = str;
    
    NSInteger num = 0;
    for (ShopingCartEntity *ent in _shopingCartList)
    {
        if ([objectNull(ent.mode) isEqualToString:objectNull(selMode)] && [objectNull(ent.taste) isEqualToString:objectNull(selTaste)])
        {
            num += ent.number;
        }
    }
    if (num == 0)
    {
        [_addFoodNumView hiddenWithSpec:NO specTitle:@"加入购物车"];
    }
    else
    {
        [_addFoodNumView hiddenWithSpec:YES specTitle:@"加入购物车"];
    }
    [_addFoodNumView updateWithAddNum:num];
    
}

@end











