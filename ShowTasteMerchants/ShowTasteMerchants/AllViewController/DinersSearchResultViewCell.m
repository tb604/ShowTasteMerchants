//
//  DinersSearchResultViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/10.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DinersSearchResultViewCell.h"
#import "LocalCommon.h"
#import "ShopListDataEntity.h"
#import "UIImageView+WebCache.h"
#import "TYZStarRateView.h"

@interface DinersSearchResultViewCell ()
{
    /**
     *  餐厅图片
     */
    UIImageView *_thumalImgView;
    
    /**
     *  餐厅名称
     */
    UILabel *_nameLabel;
    
    /**
     *  星级
     */
    TYZStarRateView *_starRateView;
    
    /**
     *  特色
     */
    UILabel *_featuresLabel;
    
    /**
     *  区域位置
     */
    UILabel *_areaLocationLabel;
    
    /**
     *  人均价格
     */
    UILabel *_averagePriceLabel;
    
    /**
     *  门市价格
     */
    UILabel *_retailPriceLabel;
    
    /**
     *  口味、环境、服务
     */
    UILabel *_khfLabel;
    
    /**
     *  备注
     */
    UILabel *_noteLabel;
}

@property (nonatomic, strong) ShopListDataEntity *shopEntity;

/**
 *  餐厅图片
 */
- (void)initWithThumalImgView;

/**
 *  餐厅名称
 */
- (void)initWithNameLabel;

- (void)initWithStarRateView;

- (void)initWithFeaturesLabel;

/**
 * 区域位置
 */
- (void)initWithAreaLocationLabel;

/**
 * 人均价格
 */
- (void)initWithAveragePriceLabel;

/**
 * 门市价格
 */
- (void)initWithRetailPriceLabel;

/**
 * 口味、环境、服务
 */
- (void)initWithKhfLabel;

/**
 * 备注
 */
- (void)initWithNoteLabel;

@end

@implementation DinersSearchResultViewCell

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithThumalImgView];
    
    [self initWithNameLabel];
    
    [self initWithStarRateView];
    
    [CALayer drawLine:self.contentView frame:CGRectMake(_nameLabel.left, _thumalImgView.bottom, _nameLabel.width, 0.6) lineColor:[UIColor colorWithHexString:@"#e0e0e0"]];
    
    [self initWithFeaturesLabel];
    
    [self initWithAreaLocationLabel];
    
    // 人均价格
    [self initWithAveragePriceLabel];
    
    // 门市价格
    [self initWithRetailPriceLabel];
    
    // 口味、环境、服务
    [self initWithKhfLabel];
    
    // 备注
    [self initWithNoteLabel];
    
}

- (void)initWithThumalImgView
{
    if (!_thumalImgView)
    {
        CGRect frame = CGRectMake(15, 15, 100, 80);
        _thumalImgView = [[UIImageView alloc] initWithFrame:frame];
        [self.contentView addSubview:_thumalImgView];
    }
}

- (void)initWithNameLabel
{
    if (!_nameLabel)
    {
        CGRect frame = CGRectMake(_thumalImgView.right + 10, _thumalImgView.top, [[UIScreen mainScreen] screenWidth] - _thumalImgView.right - 10 - 15, 20);
        _nameLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
    }
}

- (void)initWithStarRateView
{
    if (!_starRateView)
    {
        UIImage *image = [UIImage imageNamed:@"star_nor"];
        CGRect frame = CGRectMake(_nameLabel.left, 0, image.size.width*5+2*(5-1), image.size.height);
        _starRateView = [[TYZStarRateView alloc] initWithFrame:frame numberOfStars:5 isRecognizer:NO];
        [self.contentView addSubview:_starRateView];
        _starRateView.scorePercent = 1;
        _starRateView.centerY = _thumalImgView.centerY;
    }
}

- (void)initWithFeaturesLabel
{
    if (!_featuresLabel)
    {
        CGRect frame = _nameLabel.frame;
        frame.size.width = _starRateView.width;
        _featuresLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
        _featuresLabel.bottom = _thumalImgView.bottom - 3;
    }
}

- (void)initWithAreaLocationLabel
{
    if (!_areaLocationLabel)
    {
        CGRect frame = CGRectMake(0, 0, _nameLabel.width - _starRateView.width, 20);
        _areaLocationLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentRight];
        _areaLocationLabel.centerY = _featuresLabel.centerY;
        _areaLocationLabel.right = [[UIScreen mainScreen] screenWidth] - 15;
    }
}

/**
 * 人均价格
 */
- (void)initWithAveragePriceLabel
{
    if (!_averagePriceLabel)
    {
        CGRect frame = CGRectMake(15, _thumalImgView.bottom + 5, _thumalImgView.width, 20);
        _averagePriceLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE_14 labelTag:0 alignment:NSTextAlignmentLeft];
    }
}

/**
 * 门市价格
 */
- (void)initWithRetailPriceLabel
{
    if (!_retailPriceLabel)
    {
        CGRect frame = CGRectMake(15, _averagePriceLabel.bottom, _averagePriceLabel.width, 20);
        _retailPriceLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    }
}

/**
 * 口味、环境、服务
 */
- (void)initWithKhfLabel
{
    if (!_khfLabel)
    {
        CGRect frame = _nameLabel.frame;
        _khfLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
        _khfLabel.centerY = _averagePriceLabel.centerY;
    }
}

/**
 * 备注
 */
- (void)initWithNoteLabel
{
    if (!_noteLabel)
    {
        CGRect frame = _khfLabel.frame;
        _noteLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
        _noteLabel.centerY = _retailPriceLabel.centerY;
    }
}

- (void)updateCellData:(id)cellEntity
{
    self.shopEntity = cellEntity;
    
    // 餐厅图片
    [_thumalImgView sd_setImageWithURL:[NSURL URLWithString:_shopEntity.default_image] placeholderImage:nil];
    
    // 餐厅名称
    _nameLabel.text = _shopEntity.name;
    
    // 星级
    _starRateView.scorePercent = 0.5;
    
    // 特色
    _featuresLabel.text = @"鱼火锅";
    
    // 区域位置
    _areaLocationLabel.text = @"浦口区 2.1km";
    
    // 人均价格
    _averagePriceLabel.text = [NSString stringWithFormat:@"%.0f元/人", _shopEntity.average];
    
    // 门市价格
    _retailPriceLabel.text = @"门市价:64元/人";
    
    // 口味、环境、服务
    NSMutableAttributedString *mas = [NSMutableAttributedString new];
    UIColor *color = [UIColor colorWithHexString:@"#646464"];
    NSAttributedString *bTitle = [[NSAttributedString alloc] initWithString:@"口味：" attributes:@{NSFontAttributeName: FONTSIZE(13), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:bTitle];
    color = [UIColor colorWithHexString:@"#ff5500"];
    NSAttributedString *bValue = [[NSAttributedString alloc] initWithString:@"9.0  " attributes:@{NSFontAttributeName: FONTSIZE(13), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:bValue];
    
    color = [UIColor colorWithHexString:@"#646464"];
    bTitle = [[NSAttributedString alloc] initWithString:@"环境：" attributes:@{NSFontAttributeName: FONTSIZE(13), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:bTitle];
    color = [UIColor colorWithHexString:@"#ff5500"];
    bValue = [[NSAttributedString alloc] initWithString:@"9.1  " attributes:@{NSFontAttributeName: FONTSIZE(13), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:bValue];
    
    color = [UIColor colorWithHexString:@"#646464"];
    bTitle = [[NSAttributedString alloc] initWithString:@"服务：" attributes:@{NSFontAttributeName: FONTSIZE(13), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:bTitle];
    color = [UIColor colorWithHexString:@"#ff5500"];
    bValue = [[NSAttributedString alloc] initWithString:@"8.8" attributes:@{NSFontAttributeName: FONTSIZE(13), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:bValue];
    
    _khfLabel.attributedText = mas;
    
    // 备注
    _noteLabel.text = @"App买单立享满100减15";
}

@end
























