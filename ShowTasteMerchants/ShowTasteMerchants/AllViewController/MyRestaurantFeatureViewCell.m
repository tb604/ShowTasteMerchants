//
//  MyRestaurantFeatureViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantFeatureViewCell.h"
#import "LocalCommon.h"
#import "RestaurantBaseDataEntity.h"


@interface MyRestaurantFeatureViewCell ()
{
    /**
     *  餐厅名字
     */
    UILabel *_nameLabel;
    
    /**
     *  菜系图标
     */
    UIImageView *_cuisineImgView;
    
    /**
     *  菜系名称
     */
    UILabel *_cuisineLabel;
    
    /**
     *  商圈图标
     */
    UIImageView *_mallImgView;
    
    /**
     *  商圈名称
     */
    UILabel *_mallNameLabel;
    
    /**
     *  餐厅口号
     */
    UILabel *_sloganLabel;
}

/**
 *  餐厅名称
 */
- (void)initWithNameLabel;

- (void)initWithCuisineImgView;

/**
 *  菜系名称
 */
- (void)initWithCuisineLabel;

- (void)initWithMallImgView;

/**
 *  商圈名称
 */
- (void)initWithMallNameLabel;

/**
 *  餐厅口号
 */
- (void)initWithSloganLabel;

@end

@implementation MyRestaurantFeatureViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithVarCell
{
    [super initWithVarCell];
    
}

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
//    [self initWithLine];
    
    // 餐厅名称
    [self initWithNameLabel];
    
    [self initWithCuisineImgView];
    
    // 菜系名称
    [self initWithCuisineLabel];
    
    [self initWithMallImgView];
    
    // 商圈名称
    [self initWithMallNameLabel];
    
    // 餐厅口号
    [self initWithSloganLabel];
}

- (void)initWithLine
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake([[UIScreen mainScreen] screenWidth], 0.8);
    line.left = 0;
    line.bottom = kMyRestaurantFeatureViewCellHeight;
    line.backgroundColor = [UIColor colorWithHexString:@"#9a9a9a"].CGColor;
    [self.contentView.layer addSublayer:line];
}

/**
 *  餐厅名称
 */
- (void)initWithNameLabel
{
    if (!_nameLabel)
    {
        CGRect frame = CGRectMake(15, 15, [[UIScreen mainScreen] screenWidth] - 30, 20);
        _nameLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE(20) labelTag:0 alignment:NSTextAlignmentLeft];
    }
}

- (void)initWithCuisineImgView
{
    if (!_cuisineImgView)
    {
        UIImage *image = [UIImage imageNamed:@"hall_icon_caixi_normal"];
        CGRect frame = CGRectMake(15, _nameLabel.bottom + 15, image.size.width, image.size.height);
        _cuisineImgView = [[UIImageView alloc] initWithFrame:frame];
        _cuisineImgView.image = image;
        [self addSubview:_cuisineImgView];
    }
}

/**
 *  菜系名称
 */
- (void)initWithCuisineLabel
{
    if (!_cuisineLabel)
    {
        CGRect frame = CGRectMake(_cuisineImgView.right+10, 0, [[UIScreen mainScreen] screenWidth] - _cuisineImgView.right - 10 - 15, 20);
        _cuisineLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
        _cuisineLabel.centerY = _cuisineImgView.centerY;
    }
}

- (void)initWithMallImgView
{
    if (!_mallImgView)
    {
        UIImage *image = [UIImage imageNamed:@"hall_icon_shangquan_nor"];
        CGRect frame = CGRectMake(15, _cuisineImgView.bottom + 10, image.size.width, image.size.height);
        _mallImgView = [[UIImageView alloc] initWithFrame:frame];
        _mallImgView.image = image;
        [self addSubview:_mallImgView];
    }
}

/**
 *  商圈名称
 */
- (void)initWithMallNameLabel
{
    if (!_mallNameLabel)
    {
        CGRect frame = _cuisineLabel.frame;
        _mallNameLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
        _mallNameLabel.centerY = _mallImgView.centerY;
    }
}

/**
 *  餐厅口号
 */
- (void)initWithSloganLabel
{
    if (!_sloganLabel)
    {
        CGRect frame = CGRectMake(15, _mallNameLabel.bottom + 10, [[UIScreen mainScreen] screenWidth] - 30, 20);
        _sloganLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
        _sloganLabel.numberOfLines = 0;
    }
}


- (void)updateCellData:(id)cellEntity
{
//    debugLog(@"cell=%@", [cellEntity modelToJSONString]);
    RestaurantBaseDataEntity *entity = cellEntity;
    
    // 餐厅名字
    _nameLabel.text = objectNull(entity.name);
    
    // 菜系
    _cuisineLabel.text = objectNull(entity.classify);
    
    // 商圈
    _mallNameLabel.text = objectNull(entity.mall_name);
    
    // 口号
    _sloganLabel.height = entity.sloganHeight;
    _sloganLabel.text = objectNull(entity.slogan);
}

@end











