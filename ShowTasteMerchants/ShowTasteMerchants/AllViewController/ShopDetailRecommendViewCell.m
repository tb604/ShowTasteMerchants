//
//  ShopDetailRecommendViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/2.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopDetailRecommendViewCell.h"
#import "LocalCommon.h"
#import "ShopRecommendDataEntity.h"
#import "UIImageView+WebCache.h"


@interface ShopDetailRecommendViewCell ()
{
    UIImageView *_thumalImgView;
    
    UILabel *_namelabel;
    
    /**
     *  "详情"
     */
    UILabel *_detailLabel;
    
    UILabel *_descLabel;
    
    CGFloat _descMaxHeight;
    
    UILabel *_priceLabel;
    
}

@property (nonatomic, strong) ShopRecommendDataEntity *recommendEntity;

@property (nonatomic, strong) CALayer *line;




- (void)initWithThumalImgView;

- (void)initWithNameLabel;

- (void)initWithDetailLabel;

- (void)initWithDescLabel;

- (void)initWithPriceLabel;

@end

@implementation ShopDetailRecommendViewCell

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
    
    
    
    [self initWithLine];
    
    [self initWithThumalImgView];
    
    [self initWithNameLabel];
    
//    [self initWithDetailLabel];
    
    [self initWithDescLabel];
    
    [self initWithPriceLabel];
    
    _descMaxHeight =  _thumalImgView.height - _namelabel.height-8;
    
    
}

- (void)initWithLine
{
    CALayer *line = [CALayer drawLine:self.contentView frame:CGRectMake(15, kShopDetailRecommendViewCellHeight-0.6, [[UIScreen mainScreen] screenWidth] - 30, 0.6) lineColor:[UIColor colorWithHexString:@"#e0e0e0"]];
    self.line = line;
//    CALayer *line = [CALayer layer];
//    line.size = CGSizeMake([[UIScreen mainScreen] screenWidth] - 30, 0.8);
//    line.left = 15;
//    line.bottom = kShopDetailRecommendViewCellHeight;
//    line.backgroundColor = [UIColor colorWithHexString:@"#999999"].CGColor;
//    [self.contentView.layer addSublayer:line];
}

- (void)initWithThumalImgView
{
    if (!_thumalImgView)
    {
        CGRect frame = CGRectMake(15, 0, 120, 85);
        _thumalImgView = [[UIImageView alloc] initWithFrame:frame];
        _thumalImgView.centerY = kShopDetailRecommendViewCellHeight / 2;
//        _thumalImgView.backgroundColor = [UIColor lightGrayColor];
        _thumalImgView.layer.masksToBounds = YES;
        _thumalImgView.layer.cornerRadius = 4;
        [self.contentView addSubview:_thumalImgView];
    }
}

- (void)initWithNameLabel
{
    if (!_namelabel)
    {
        CGRect frame = CGRectMake(_thumalImgView.right + 10, _thumalImgView.top, [[UIScreen mainScreen] screenWidth] - _thumalImgView.right-10 - 15 - 40 - 10, 20);
        _namelabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
    }
}

- (void)initWithDetailLabel
{
    if (!_detailLabel)
    {
        /*CGRect frame = CGRectMake(0, 0, 40, 18);
        _detailLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentCenter];
        _detailLabel.text = @"详情";
        _detailLabel.layer.borderColor = [UIColor colorWithHexString:@"#ff5500"].CGColor;
        _detailLabel.layer.borderWidth = 1;
        _detailLabel.right = [[UIScreen mainScreen] screenWidth] - 15;
        _detailLabel.centerY = _namelabel.centerY;
        _detailLabel.backgroundColor = [UIColor lightGrayColor];
         */
    }
}

- (void)initWithDescLabel
{
    if (!_descLabel)
    {
        CGRect frame = CGRectMake(_thumalImgView.right + 10, _namelabel.bottom + 4, [[UIScreen mainScreen] screenWidth] - _thumalImgView.right - 10 - 15, 40);
        
        _descLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
        _descLabel.numberOfLines = 2;
//        _descLabel.backgroundColor = [UIColor lightGrayColor];
    }
}

- (void)initWithPriceLabel
{
    if (!_priceLabel)
    {
        CGRect frame = CGRectMake(_namelabel.left, _thumalImgView.bottom - 20, _descLabel.width, 20);
        _priceLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    }
}

- (void)hiddenWithLine:(BOOL)hidden
{
    _line.hidden = hidden;
}



- (void)updateCellData:(id)cellEntity
{
    self.recommendEntity = cellEntity;
    
//    debugLog(@"recommend=%@", [_recommendEntity modelToJSONString]);
//
//    debugLog(@"image=%@", _recommendEntity.images);
    
    // 图片
    [_thumalImgView sd_setImageWithURL:[NSURL URLWithString:_recommendEntity.image] placeholderImage:nil];
    
    // 名称
    _namelabel.text = _recommendEntity.name;
    
//    if (_recommendEntity.introHeight == 0.0)
//    {
//        _recommendEntity.introHeight = [UtilityObject mulFontHeights:_recommendEntity.intro font:_descLabel.font maxWidth:_descLabel.width];
//    }
//    debugLog(@"heig=%.2f", _recommendEntity.introHeight);
    
//    CGRect frame = _descLabel.frame;
//    frame.size.height = (_recommendEntity.introHeight>_descMaxHeight?_descMaxHeight:_recommendEntity.introHeight);
//    _descLabel.frame = frame;
    _descLabel.text = _recommendEntity.intro;
    
    
    /*NSString *str = [NSString stringWithFormat:@"￥%.0f  ", _recommendEntity.price];
    // 价格
    NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] init];
    NSAttributedString *butedStr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16], NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#ff5500"]}];
    [mas appendAttributedString:butedStr];
    if (_recommendEntity.activity_price != 0.0)
    {
        //        debugLog(@"ddfdfd");
        str = [NSString stringWithFormat:@"￥%.0f", _recommendEntity.activity_price];
        //        debugLog(@"str=%@", str);
        NSAttributedString *bu = [MCYPushViewController middleSingleLine:objectNull(str) font:FONTSIZE_12 textColor:[UIColor colorWithHexString:@"#cecece"] lineColor:[UIColor colorWithHexString:@"#cecece"]];
        [mas appendAttributedString:bu];
    }
     */
    
    
    CGFloat price = _recommendEntity.activity_price;
    if (price == 0.0)
    {
        price = _recommendEntity.price;
    }
    NSString *str = [NSString stringWithFormat:@"￥%.0f  ", price];
        // 价格
    NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] init];
    NSAttributedString *butedStr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16], NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#ff5500"]}];
    [mas appendAttributedString:butedStr];
    if (_recommendEntity.activity_price != 0.0)
    {
        str = [NSString stringWithFormat:@"￥%.0f", _recommendEntity.price];
        NSAttributedString *bu = [MCYPushViewController middleSingleLine:objectNull(str) font:FONTSIZE_12 textColor:[UIColor colorWithHexString:@"#cecece"] lineColor:[UIColor colorWithHexString:@"#cecece"]];
        [mas appendAttributedString:bu];
    }
    _priceLabel.attributedText = mas;
}

/*
 "id": 58,
 "name": "特色东坡肉",
 "category_id": 48,
 "intro": "美味qweqweasdasdasdsad",
 "price": 88,
 "activity_price": 0,
 "image_host": "http://7xsdmx.com2.z0.glb.qiniucdn.com/",
 "images": "[\"shop/8/1b2dfda4-db94-fefd-ce60-649c4a16ad35.jpg\"]",
 "remark": "",
 "sort_index": 3

 */


@end
