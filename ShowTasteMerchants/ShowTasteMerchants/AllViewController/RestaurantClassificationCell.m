//
//  RestaurantClassificationCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/3.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "RestaurantClassificationCell.h"
#import "LocalCommon.h"
#import "ShowTypeDataEntity.h"
#import "UIImageView+WebCache.h"
#import "ShopListDataEntity.h"

@interface RestaurantClassificationCell ()
{
    UIImageView *_thumalImgView;
    
    UIImageView *_headImgView;
    
    /**
     *  收藏按钮
     */
    UIButton *_btnCollection;
    
    /**
     *  评价数
     */
    UILabel *_commentLabel;
    
    /**
     *  餐厅名称
     */
    UILabel *_nameLabel;
    
    /**
     *  餐厅口号
     */
    UILabel *_sloganLabel;
    
    /**
     *  人均价
     */
    UILabel *_averageLabel;
    
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

@property (nonatomic, strong) ShopListDataEntity *shopEntity;

- (void)initWithThumalImgView;

- (void)initWithHeadImgView;

/**
 *  收藏按钮
 */
- (void)initWithBtnCollection;


- (void)initWithCommentLabel;

- (void)initWithNameLabel;

/**
 *  初始化口号
 */
- (void)initWithSloganLabel;

/**
 *  人均价
 */
- (void)initWithAverageLabel;

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

@end

@implementation RestaurantClassificationCell

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
    
    [self initWithThumalImgView];
    
    [self initWithHeadImgView];
    
    [self initWithBtnCollection];
    
    [self initWithCommentLabel];
    
    [self initWithNameLabel];
    
    /**
     *  初始化口号
     */
    [self initWithSloganLabel];
    
    /**
     *  人均价
     */
    [self initWithAverageLabel];
    
    [self initWithCuisineImgView];
    
    [self initWithCuisineLabel];
    
    [self initWithMallImgView];
    
    [self initWithMallNameLabel];
}

- (void)initWithThumalImgView
{
    if (!_thumalImgView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [[self class] getImageHeight]);
        _thumalImgView = [[UIImageView alloc] initWithFrame:frame];
        [self.contentView addSubview:_thumalImgView];
    }
}

- (void)initWithHeadImgView
{
    if (!_headImgView)
    {
        CGRect frame = CGRectMake(15, 15, 45, 45);
        _headImgView = [[UIImageView alloc] initWithFrame:frame];
        _headImgView.layer.cornerRadius = frame.size.height / 2;
        _headImgView.layer.masksToBounds = YES;
//        _headImgView.backgroundColor = [UIColor purpleColor];
        _headImgView.centerY = _thumalImgView.bottom;
        _headImgView.right = [[UIScreen mainScreen] screenWidth] - 15;
        [self.contentView addSubview:_headImgView];
    }
}

/**
 *  收藏按钮
 */
- (void)initWithBtnCollection
{
    if (!_btnCollection)
    {
        UIImage *image = [UIImage imageNamed:@"hall_btn_like_nor"];
        CGRect frame = CGRectMake(0, 15, image.size.width, image.size.height);
        _btnCollection = [TYZCreateCommonObject createWithButton:self imgNameNor:@"hall_btn_like_nor" imgNameSel:@"hall_btn_like_sel" targetSel:@selector(clickedCollection:)];
        _btnCollection.frame = frame;
        _btnCollection.right = [[UIScreen mainScreen] screenWidth] - 15;
        [self.contentView addSubview:_btnCollection];
    }
}

- (void)initWithCommentLabel
{
    if (!_commentLabel)
    {
        CGRect frame = CGRectMake(0, 0, 20, 20);
        _commentLabel = [TYZCreateCommonObject createWithLabel:_thumalImgView labelFrame:frame textColor:[UIColor whiteColor] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentRight];
        _commentLabel.bottom = _thumalImgView.bottom - 10;
    }
}

- (void)initWithNameLabel
{
    if (!_nameLabel)
    {
        CGRect frame = CGRectMake(15, 0, 20, 20);
        _nameLabel = [TYZCreateCommonObject createWithLabel:_thumalImgView labelFrame:frame textColor:[UIColor whiteColor] fontSize:FONTSIZE_17 labelTag:0 alignment:NSTextAlignmentLeft];
        _nameLabel.centerY = _commentLabel.centerY;
    }
}

/**
 *  初始化口号
 */
- (void)initWithSloganLabel
{
    if (!_sloganLabel)
    {
        CGRect frame = CGRectMake(15, _thumalImgView.bottom + 10, [[UIScreen mainScreen] screenWidth] - 30, 20);
        _sloganLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
    }
}

/**
 *  人均价
 */
- (void)initWithAverageLabel
{
    if (!_averageLabel)
    {
        CGRect frame = CGRectMake(0, 0, 20, 20);
        _averageLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentRight];
        _averageLabel.bottom = [[self class] getClassificationCellHeight] - 10;
    }
}

- (void)initWithCuisineImgView
{
    if (!_cuisineImgView)
    {
        UIImage *image = [UIImage imageNamed:@"hall_icon_caixi_normal"];
        CGRect frame = CGRectMake(15, _sloganLabel.bottom + 8, image.size.width, image.size.height);
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
        _cuisineLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
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
        _mallImgView.centerY = _averageLabel.centerY;
        [self addSubview:_mallImgView];
    }
}

- (void)initWithMallNameLabel
{
    if (!_mallNameLabel)
    {
        CGRect frame = _cuisineLabel.frame;
        _mallNameLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
        _mallNameLabel.centerY = _mallImgView.centerY;
    }
}

- (void)clickedCollection:(id)sender
{
    UIButton *btn = (UIButton *)sender;
//    btn.selected = !btn.selected;
    
    if (self.baseTableViewCellBlock)
    {
        self.baseTableViewCellBlock(@(btn.selected));
    }
}

+ (NSInteger)getImageHeight
{
    return [[UIScreen mainScreen] screenWidth] / 1.63043;
}

+ (NSInteger)getClassificationCellHeight
{
    return ([self getImageHeight] + 86.0);
}


- (void)updateCellData:(id)cellEntity
{
//    ShowTypeDataEntity *shopEnt = cellEntity;
    self.shopEntity = cellEntity;
    
    NSString *imgUrl = objectNull(_shopEntity.default_image);
    if (![imgUrl isEqualToString:@""])
    {
        imgUrl = [NSString stringWithFormat:@"%@?imageView2/0/q/70", imgUrl];
        debugLog(@"imgUrl=%@", imgUrl);
    }

    
    [_thumalImgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:nil];
    
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:_shopEntity.topchef_image] placeholderImage:nil];
    
    NSString *str = [NSString stringWithFormat:@"%d条评价", (int)_shopEntity.comments];
    CGFloat fontWidth = [str widthForFont:_commentLabel.font height:20];
    _commentLabel.width = fontWidth;
    _commentLabel.right = [[UIScreen mainScreen] screenWidth] - 15;
    _commentLabel.text = str;
    
    _nameLabel.width = _commentLabel.left - 10 - 15;
    _nameLabel.text = _shopEntity.name;
    
    // 口号
    _sloganLabel.text = _shopEntity.slogan;
    
    // 人均价
    NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] init];
    UIColor *color = [UIColor colorWithHexString:@"#ff5500"];
    NSAttributedString *butedStr = [[NSAttributedString alloc] initWithString:@"人均" attributes:@{NSFontAttributeName: FONTSIZE(12), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:butedStr];
    
    butedStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.0f", _shopEntity.average] attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:butedStr];
    butedStr = [[NSAttributedString alloc] initWithString:@"元" attributes:@{NSFontAttributeName: FONTSIZE(12), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:butedStr];
    fontWidth = [[mas string] widthForFont:_averageLabel.font height:_averageLabel.height];
    _averageLabel.width = fontWidth;
    _averageLabel.right = [[UIScreen mainScreen] screenWidth] - 15;
    _averageLabel.attributedText = mas;
    
    // 菜系
    _cuisineLabel.text = _shopEntity.classify;
    
    // 商圈
    CGRect frame = _mallNameLabel.frame;
    frame.size.width = _averageLabel.right - _mallImgView.right - 10 - 10;
    _mallNameLabel.text = _shopEntity.mall_name;
    
    if (_shopEntity.favorite == 0)
    {
        _btnCollection.selected = NO;
    }
    else
    {
        _btnCollection.selected = YES;
    }
}

@end













