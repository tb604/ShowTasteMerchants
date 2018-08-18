//
//  ShopDetailBaseCookStyleView.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/1.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopDetailBaseCookStyleView.h"
#import "LocalCommon.h"
#import "ShopBaseInfoDataEntity.h"
#import "RestaurantBaseDataEntity.h"

@interface ShopDetailBaseCookStyleView ()
{
    /**
     *  餐厅口号标语
     */
    UILabel *_sloganLabel;
    
    UIImageView *_cuisineImgView;
    
    /**
     *  菜系名称
     */
    UILabel *_cuisineLabel;
    
    UIImageView *_mallImgView;
    
    /**
     *  商圈名称
     */
    UILabel *_mallNameLabel;
}

- (void)initWithSloganLabel;

- (void)initWithCuisineImgView;

- (void)initWithCuisineLabel;

- (void)initWithMallImgView;

- (void)initWithMallNameLabel;


@end

@implementation ShopDetailBaseCookStyleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithLine];
    
    [self initWithSloganLabel];
    
    [self initWithCuisineImgView];
    
    [self initWithCuisineLabel];
    
    [self initWithMallImgView];
    
    [self initWithMallNameLabel];
}

- (void)initWithLine
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake([[UIScreen mainScreen] screenWidth] - 30, 0.6);
    line.left = 15;
    line.bottom = kShopDetailBaseCookStyleViewHeight;
    line.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"].CGColor;
    [self.layer addSublayer:line];
}

- (void)initWithSloganLabel
{
    if (!_sloganLabel)
    {
        
        CGRect frame = CGRectMake(15, 16, [[UIScreen mainScreen] screenWidth] - 30, 20);
        _sloganLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTBOLDSIZE(18) labelTag:0 alignment:NSTextAlignmentLeft];
    }
}

- (void)initWithCuisineImgView
{
    // hall_icon_caixi_normal
    if (!_cuisineImgView)
    {
        UIImage *image = [UIImage imageNamed:@"hall_icon_caixi_normal"];
        CGRect frame = CGRectMake(15, _sloganLabel.bottom + 12, image.size.width, image.size.height);
        _cuisineImgView = [[UIImageView alloc] initWithFrame:frame];
        _cuisineImgView.image = image;
        [self addSubview:_cuisineImgView];
    }
}

- (void)initWithCuisineLabel
{
    if (!_cuisineLabel)
    {
        CGRect frame = CGRectMake(_cuisineImgView.right+10, 0, [[UIScreen mainScreen] screenWidth] - _cuisineImgView.right - 10 - 15, 20);
        _cuisineLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
        _cuisineLabel.centerY = _cuisineImgView.centerY;
    }
}

- (void)initWithMallImgView
{
    // hall_icon_shangquan_nor
    if (!_mallImgView)
    {
        UIImage *image = [UIImage imageNamed:@"hall_icon_shangquan_nor"];
        CGRect frame = CGRectMake(15, _cuisineImgView.bottom + 10, image.size.width, image.size.height);
        _mallImgView = [[UIImageView alloc] initWithFrame:frame];
        _mallImgView.image = image;
        [self addSubview:_mallImgView];
    }
}

- (void)initWithMallNameLabel
{
    if (!_mallNameLabel)
    {
        CGRect frame = _cuisineLabel.frame;
        _mallNameLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
        _mallNameLabel.centerY = _mallImgView.centerY;
    }
}


- (void)updateViewData:(id)entity
{
    NSString *slogan = @"";
    NSString *cx = @"";
    NSString *mall_name = @"";
    if ([entity isKindOfClass:[RestaurantBaseDataEntity class]])
    {// RestaurantBaseDataEntity
        RestaurantBaseDataEntity *shopEntity = entity;
        slogan = objectNull(shopEntity.slogan);
        cx = objectNull(shopEntity.classify);
        mall_name = objectNull(shopEntity.mall_name);
    }
    else if ([entity isKindOfClass:[ShopBaseInfoDataEntity class]])
    {
        ShopBaseInfoDataEntity *shopEntity = entity;
        slogan = objectNull(shopEntity.slogan);
        cx = objectNull(shopEntity.cx);
        mall_name = objectNull(shopEntity.mall_name);
    }
    
    // 口号、标语
    _sloganLabel.text = slogan;
    
    // 菜系
    _cuisineLabel.text = cx;
    
    // 商圈
    _mallNameLabel.text = mall_name;
    
}


@end

























