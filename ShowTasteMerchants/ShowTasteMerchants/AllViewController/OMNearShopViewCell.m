//
//  OMNearShopViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "OMNearShopViewCell.h"
#import "LocalCommon.h"
#import "UIImageView+WebCache.h"
#import "OrderMealContentEntity.h"

@interface OMNearShopViewCell ()
{
    UIImageView *_thumalImgView;
    
    /// 餐厅名称
    UILabel *_shopNameLabel;
    
    /// 餐厅菜品类别
    UILabel *_classifyLabel;
    
    /// 人均价格
    UILabel *_averageLabel;
    
    /// 距离
    UILabel *_distanceLabel;
}

/// 餐厅图片
- (void)initWithThumalImgView;

/// 初始化餐厅名称
- (void)initWithShopNameLabel;

/// 初始化餐厅菜品类别
- (void)initWithClassifyLabel;

/// 人均价格
- (void)initWithAverageLabel;

/// 初始化距离
- (void)initWithDistanceLabel;

@end

@implementation OMNearShopViewCell

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
    
    [CALayer drawLine:self.contentView frame:CGRectMake(0, [[self class] getWithCellHeight], [[self class] getWithCellWidth], 0.6) lineColor:[UIColor colorWithHexString:@"#e1e1e1"]];
    
    [self initWithThumalImgView];
    
    // 初始化餐厅名称
    [self initWithShopNameLabel];
    
    // 初始化餐厅菜品类别
    [self initWithClassifyLabel];
    
    // 人均价格
    [self initWithAverageLabel];
    
    // 初始化距离
    [self initWithDistanceLabel];
}

- (void)initWithThumalImgView
{
    if (!_thumalImgView)
    {
        CGRect frame = CGRectMake(0, 0, [[self class] getWithCellWidth], [[self class] getWithCellHeight] - 80);
        _thumalImgView = [[UIImageView alloc] initWithFrame:frame];
        _thumalImgView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_thumalImgView];
    }
}

/// 初始化餐厅名称
- (void)initWithShopNameLabel
{
    if (!_shopNameLabel)
    {
        CGRect frame = CGRectMake(0, _thumalImgView.bottom + 6, _thumalImgView.width, 18);
        _shopNameLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#1a1a1a"] fontSize:FONTBOLDSIZE(16) labelTag:0 alignment:NSTextAlignmentLeft];
//        _shopNameLabel.backgroundColor = [UIColor lightGrayColor];
    }
}

/// 初始化餐厅菜品类别
- (void)initWithClassifyLabel
{
    if (!_classifyLabel)
    {
        CGRect frame = _shopNameLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 6;
        _classifyLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE(13) labelTag:0 alignment:NSTextAlignmentLeft];
//        _classifyLabel.backgroundColor = [UIColor lightGrayColor];
    }
}

/// 人均价格
- (void)initWithAverageLabel
{
    if (!_averageLabel)
    {
        CGRect frame = _classifyLabel.frame;
        frame.size.width = frame.size.width / 3 * 2 - 5;
        frame.origin.y = frame.origin.y + frame.size.height + 6;
        _averageLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE(15) labelTag:0 alignment:NSTextAlignmentLeft];
//        _averageLabel.backgroundColor = [UIColor lightGrayColor];
    }
}

/// 初始化距离
- (void)initWithDistanceLabel
{
    if (!_distanceLabel)
    {
        CGRect frame = _averageLabel.frame;
        frame.size.width = _thumalImgView.width / 3;
        _distanceLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE(13) labelTag:0 alignment:NSTextAlignmentRight];
//        _distanceLabel.backgroundColor = [UIColor lightGrayColor];
        _distanceLabel.right = _thumalImgView.width;
    }
}

- (void)updateViewCell:(id)cellEntity
{
    OrderMealContentEntity *shopEnt = cellEntity;
    
    NSString *imgUrl = objectNull(shopEnt.default_image);
    if (![imgUrl isEqualToString:@""])
    {
        imgUrl = [NSString stringWithFormat:@"%@?imageView2/0/q/80", imgUrl];
    }
    // 餐厅图片
    [_thumalImgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:nil];
    
    // 初始化餐厅名称
    _shopNameLabel.text = shopEnt.name;
    
    // 初始化餐厅菜品类别
    _classifyLabel.text = shopEnt.classify;;
    
    // 人均价格
    _averageLabel.text = [NSString stringWithFormat:@"￥%@/人均", shopEnt.average];
    
    // 初始化距离
    _distanceLabel.text = @"1.1km";
}

+ (NSInteger)getWithCellWidth
{
    NSInteger width = 0;
    width = ([[UIScreen mainScreen] screenWidth] - 30 - 10) / 2;
    return width;
}

+ (NSInteger)getWithCellHeight
{
    NSInteger height = 0;
    height = [self getWithCellWidth] / 1.1928 + 80;
    return height;
}

@end




















