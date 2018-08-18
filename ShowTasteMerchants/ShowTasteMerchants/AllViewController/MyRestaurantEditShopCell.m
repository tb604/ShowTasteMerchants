//
//  MyRestaurantEditShopCell.m
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/4.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantEditShopCell.h"
#import "LocalCommon.h"
#import "ShopListDataEntity.h"
#import "UIImageView+WebCache.h"

@interface MyRestaurantEditShopCell ()
{
    /// 餐厅图片
    UIImageView *_thumalImgView;
    
    /// 选中
    UIImageView *_checkImgView;
    
    /**
     *  餐厅名字
     */
    UILabel *_nameLabel;
    
    /// 餐厅编号
    UILabel *_shopIdLabel;
}

@property (nonatomic, strong) ShopListDataEntity *shopEntity;

/**
 *  餐厅图片
 */
- (void)initWithThumalImgView;

/**
 *  选中(restaurant_icon_sel)
 */
- (void)initWithCheckImgView;

/**
 *  餐厅名字
 */
- (void)initWithNameLabel;

/**
 *  餐厅编号
 */
- (void)initWithShopIdLabel;

@end

@implementation MyRestaurantEditShopCell

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
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    [CALayer drawLine:self.contentView frame:CGRectMake(10, kMyRestaurantEditShopCellHeight - 0.5, [[UIScreen mainScreen] screenWidth] - 20, 0.5) lineColor:[UIColor colorWithHexString:@"#e0e0e0"]];
    
}

/**
 *  餐厅图片
 */
- (void)initWithThumalImgView
{
    if (!_thumalImgView)
    {
        CGRect frame = CGRectMake(10, 10, 62, 50);
        _thumalImgView = [[UIImageView alloc] initWithFrame:frame];
        _thumalImgView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_thumalImgView];
    }
    UIImage *image = [UIImage imageWithContentsOfFileName:@"restaurant_photo_icon.png"];
    [_thumalImgView sd_setImageWithURL:[NSURL URLWithString:_shopEntity.image] placeholderImage:image];
}

/**
 *  选中(restaurant_icon_sel)
 */
- (void)initWithCheckImgView
{
    if (!_checkImgView)
    {
        UIImage *image = [UIImage imageWithContentsOfFileName:@"restaurant_icon_sel.png"];
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - image.size.width - 10, (kMyRestaurantEditShopCellHeight-image.size.height)/2., image.size.width, image.size.height);
        _checkImgView = [[UIImageView alloc] initWithFrame:frame];
        _checkImgView.image = image;
        [self.contentView addSubview:_checkImgView];
    }
    
    if (_shopEntity.selCheck)
    {
        _checkImgView.hidden = NO;
    }
    else
    {
        _checkImgView.hidden = YES;
    }
}

/**
 *  餐厅名字
 */
- (void)initWithNameLabel
{
    if (!_nameLabel)
    {
        CGRect frame = CGRectMake(_thumalImgView.right + 10, _thumalImgView.top, _checkImgView.left - _thumalImgView.right - 10 - 10, 20);
        _nameLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_16 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    _nameLabel.text = objectNull(_shopEntity.name);
}

/**
 *  餐厅编号
 */
- (void)initWithShopIdLabel
{
    if (!_shopIdLabel)
    {
        CGRect frame = CGRectMake(_nameLabel.left, _thumalImgView.bottom - 16, _nameLabel.width, 15);
        _shopIdLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"646464"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    _shopIdLabel.text = [NSString stringWithFormat:@"编号：%d", (int)_shopEntity.shop_id];
}

- (void)updateCellData:(id)cellEntity
{
    self.shopEntity = cellEntity;
    //    debugLog(@"listEnt=%@", [listEntity modelToJSONString]);
    
    // 餐厅图片
    [self initWithThumalImgView];
    
    // 选中(restaurant_icon_sel)
    [self initWithCheckImgView];
    
    // 餐厅名字
    [self initWithNameLabel];
    
    // 餐厅编号
    [self initWithShopIdLabel];
}


@end

























