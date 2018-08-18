//
//  MyRestaurantListViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/24.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantListViewCell.h"
#import "LocalCommon.h"
#import "ShopListDataEntity.h"
#import "UIImageView+WebCache.h"

@interface MyRestaurantListViewCell ()
{
    /// 餐厅图片
    UIImageView *_thumalImgView;
    
    /**
     *  餐厅名字
     */
    UILabel *_nameLabel;
    
    /// 餐厅编号
    UILabel *_shopIdLabel;
    
    /**
     *  菜系(类型)
     */
    UILabel *_cuisineLabel;
    
    /// 商圈
    UILabel *_mallLabel;
    
    /**
     *  餐厅状态
     */
    UILabel *_stateLabel;
    
    /// 是否是我的店
    UILabel *_owneShopLabel;
}

@property (nonatomic, strong) ShopListDataEntity *shopEntity;

/**
 *  餐厅图片
 */
- (void)initWithThumalImgView;

/**
 *  餐厅名字
 */
- (void)initWithNameLabel;

/**
 *  餐厅编号
*/
- (void)initWithShopIdLabel;

- (void)initWithOwneShopLabel;

/**
 *  菜系名称
 */
- (void)initWithCuisineLabel;

/**
 *  商圈
 */
- (void)initWithMallLabel;

/**
 *  餐厅状态
 */
- (void)initWithStateLabel;

@end

@implementation MyRestaurantListViewCell

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
    
    [CALayer drawLine:self.contentView frame:CGRectMake(15, kMyRestaurantListViewCellHeight - 0.5, [[UIScreen mainScreen] screenWidth] - 30, 0.5) lineColor:[UIColor colorWithHexString:@"#e0e0e0"]];
    
}

/**
 *  餐厅图片
 */
- (void)initWithThumalImgView
{
    if (!_thumalImgView)
    {
        CGRect frame = CGRectMake(15, 15, 150, 120);
        _thumalImgView = [[UIImageView alloc] initWithFrame:frame];
        _thumalImgView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_thumalImgView];
    }
    UIImage *image = [UIImage imageWithContentsOfFileName:@"restaurant_photo_icon.png"];
    [_thumalImgView sd_setImageWithURL:[NSURL URLWithString:_shopEntity.image] placeholderImage:image];
}

/**
 *  餐厅名字
 */
- (void)initWithNameLabel
{
    if (!_nameLabel)
    {
        CGRect frame = CGRectMake(_thumalImgView.right + 10, _thumalImgView.top, [[UIScreen mainScreen] screenWidth] - _thumalImgView.right - 10 - 15, 20);
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
        CGRect frame = CGRectMake(_nameLabel.left, _nameLabel.bottom + 12, _nameLabel.width, 15);
        _shopIdLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"646464"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    NSString *str = [NSString stringWithFormat:@"编号：%d", (int)_shopEntity.shop_id];
    float width = [str widthForFont:FONTSIZE_12];
    _shopIdLabel.width = width;
    _shopIdLabel.text = str;//[NSString stringWithFormat:@"编号：%d", (int)_shopEntity.shop_id];
}

- (void)initWithOwneShopLabel
{
    if (!_owneShopLabel)
    {
        CGRect frame = CGRectMake(0, 0, 40, 15);
        _owneShopLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor whiteColor] fontSize:FONTSIZE_10 labelTag:0 alignment:NSTextAlignmentCenter];
        _owneShopLabel.centerY = _shopIdLabel.centerY;
        _owneShopLabel.layer.masksToBounds = YES;
        _owneShopLabel.layer.cornerRadius = frame.size.height / 2.;
    }
    
    _owneShopLabel.left = _shopIdLabel.right + 10;
    // 我的店 #ff5500 我管理的店 #7ecff5
    _owneShopLabel.hidden = NO;
    if (_shopEntity.type == 1)
    {// 自己开得餐厅
        _owneShopLabel.backgroundColor = [UIColor colorWithHexString:@"#ff5500"];
        _owneShopLabel.text = @"我的店";
    }
    else if (_shopEntity.type == 2)
    {// 我管理的餐厅
        _owneShopLabel.backgroundColor = [UIColor colorWithHexString:@"#7ecff5"];
        _owneShopLabel.text = @"店管理"; // 我的店
    }
    else
    {
        _owneShopLabel.hidden = YES;
    }
}

/**
 *  菜系名称
 */
- (void)initWithCuisineLabel
{
    if (!_cuisineLabel)
    {
        CGRect frame = _shopIdLabel.frame;
        frame.size.width = _nameLabel.width;
        frame.origin.y = frame.origin.y + frame.size.height + 8;
        _cuisineLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    _cuisineLabel.text = [NSString stringWithFormat:@"类型：%@", objectNull(_shopEntity.classify)];
}

/**
 *  商圈
 */
- (void)initWithMallLabel
{
    if (!_mallLabel)
    {
        CGRect frame = _cuisineLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 8;
        _mallLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    _mallLabel.text = [NSString stringWithFormat:@"商圈：%@", objectNull(_shopEntity.mall_name)];
}

/**
 *  初始化餐厅状态
 */
- (void)initWithStateLabel
{
    if (!_stateLabel)
    {
        CGRect frame = _nameLabel.frame;
        _stateLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
        _stateLabel.bottom = _thumalImgView.bottom;
    }
    // _stateLabel.text = @"状态：";
    
    NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] init];
    UIColor *color = [UIColor colorWithHexString:@"#646464"];
    NSAttributedString *bTitle = [[NSAttributedString alloc] initWithString:@"状态：" attributes:@{NSFontAttributeName: FONTSIZE(12), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:bTitle];
    
    color = [self getWithStateColor:_shopEntity.state];
    bTitle = [[NSAttributedString alloc] initWithString:[self getWithStateDesc:_shopEntity.state] attributes:@{NSFontAttributeName: FONTSIZE(12), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:bTitle];
    _stateLabel.attributedText = mas;
}

- (UIColor *)getWithStateColor:(NSInteger)state
{
    // 餐厅的状态 1完成开店前三部 未发布；2上传资质，待审核；3审核失败；4审核通过；5餐厅已发布；6餐厅下架
    UIColor *color = nil;
    switch (state)
    {
        case 1: // 完成开店前三部 未发布
            color = [UIColor colorWithHexString:@"#999999"];
            break;
        case 2: // 上传资质，待审核
            color = [UIColor colorWithHexString:@"#ffaa00"];
            break;
        case 3: // 审核失败
            color = [UIColor colorWithHexString:@"#cc0000"];
            break;
        case 4: // 审核通过
            color = [UIColor colorWithHexString:@"#3cb200"];
            break;
        case 5: // 餐厅已发布
            color = [UIColor colorWithHexString:@"#3cb200"];
            break;
        case 6: // 餐厅下架
            color = [UIColor colorWithHexString:@"#999999"];
            break;
        default:
            color = [UIColor colorWithHexString:@"#999999"];
            break;
    }
    return color;
}

- (NSString *)getWithStateDesc:(NSInteger)state
{
    NSString *title = @"";
    switch (state)
    {
        case 1: // 完成开店前三部 未发布
            title = @"";
            break;
        case 2: // 上传资质，待审核
            title = @"待审核";
            break;
        case 3: // 审核失败
            title = @"审核未通过，请查看";
            break;
        case 4: // 审核通过
            title = @"审核通过";
            break;
        case 5: // 餐厅已发布
            title = @"已发布";
            break;
        case 6: // 餐厅下架
            title = @"已下架";
            break;
        default:
            title = @"";
            break;
    }
    return title;
}

- (void)updateCellData:(id)cellEntity
{
    self.shopEntity = cellEntity;
//    debugLog(@"listEnt=%@", [listEntity modelToJSONString]);
    
    // 餐厅图片
    [self initWithThumalImgView];
    
    // 餐厅名字
    [self initWithNameLabel];
    
    // 餐厅编号
    [self initWithShopIdLabel];
    
    [self initWithOwneShopLabel];
    
    // 菜系名称
    [self initWithCuisineLabel];
    
    // 商圈
    [self initWithMallLabel];
    
    // 餐厅状态
    [self initWithStateLabel];
}

@end















