//
//  MyRestaurantMenuFoodViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/3.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantMenuFoodViewCell.h"
#import "LocalCommon.h"
#import "ShopFoodDataEntity.h"
#import "UIImageView+WebCache.h"

@interface MyRestaurantMenuFoodViewCell ()
{
    
    UIView *_bgView;
    
    UIImageView *_thumalImgView;
    
    /**
     *  菜名
     */
    UILabel *_foodNameLabel;
    
    /**
     *  价格
     */
    UILabel *_priceLabel;
    
    /**
     *  下架的标记
     */
    UIImageView *_offLineImgView;

}

@property (nonatomic, strong) ShopFoodDataEntity *foodEntity;

- (void)initWithBgView;

- (void)initWithThumalImgView;

- (void)initWithFoodNameLabel;

- (void)initWithPriceLabel;

- (void)initWithOffLineImgView;


@end

@implementation MyRestaurantMenuFoodViewCell


- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
//    self.backgroundView.backgroundColor = [UIColor whiteColor];
//    self.contentView.backgroundColor = [UIColor whiteColor];
//    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithBgView];
    
    [self initWithThumalImgView];
//
//    [self initWithLine];
//    
    [self initWithFoodNameLabel];
//
    [self initWithPriceLabel];
    
    [self initWithOffLineImgView];
//
//    [self initWithAddFoodNumView];
    
    self.layer.shadowColor = [UIColor blackColor].CGColor; // 阴影颜色
    self.layer.shadowOffset = CGSizeMake(0, 2); // shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    self.layer.shadowOpacity = 0.05; // 阴影透明度，默认0
    self.layer.shadowRadius = 2; // 阴影半径，默认3
    
    
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tapLongGesture:)];
    longGesture.numberOfTouchesRequired = 1;
    [self.contentView addGestureRecognizer:longGesture];
}

- (void)initWithBgView
{
    if (!_bgView)
    {
        CGRect frame = CGRectMake(0, 0, [[self class] getWithCellWidth], [[self class] getWithCellHeight]);
        _bgView = [[UIView alloc] initWithFrame:frame];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgView];
        
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 2;
        
        //        _bgView.layer.shadowColor = [UIColor blackColor].CGColor; // 阴影颜色
        //        _bgView.layer.shadowOffset = CGSizeMake(0, 2); // shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        //        _bgView.layer.shadowOpacity = 0.05; // 阴影透明度，默认0
        //        _bgView.layer.shadowRadius = 2; // 阴影半径，默认3
    }
}


- (void)initWithThumalImgView
{
    CGRect frame = CGRectMake(0, 0, [[self class] getWithImgViewWidth], [[self class] getWithImgViewHeight]);
    _thumalImgView = [[UIImageView alloc] initWithFrame:frame];
    _thumalImgView.backgroundColor = [UIColor lightGrayColor];
    _thumalImgView.image = [UIImage imageNamed:@"menu_icon_default"];
    [_bgView addSubview:_thumalImgView];
}

- (void)initWithFoodNameLabel
{
    CGRect frame = CGRectMake(8, _thumalImgView.bottom + 5, _thumalImgView.width - 16, 18);
    _foodNameLabel = [TYZCreateCommonObject createWithLabel:_bgView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
//    _foodNameLabel.text = @"口水鸡";
//    _foodNameLabel.backgroundColor = [UIColor lightGrayColor];
}


- (void)initWithPriceLabel
{
    CGRect frame = _foodNameLabel.frame;
    frame.origin.y = _foodNameLabel.bottom + 2;
    _priceLabel = [TYZCreateCommonObject createWithLabel:_bgView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
//    _priceLabel.backgroundColor = [UIColor lightGrayColor];
}

- (void)initWithOffLineImgView
{
    CGRect frame = _thumalImgView.frame;
    _offLineImgView = [[UIImageView alloc] initWithFrame:frame];
    _offLineImgView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [_bgView addSubview:_offLineImgView];
    _offLineImgView.hidden = YES;
    
    UILabel *label = [TYZCreateCommonObject createWithLabel:_offLineImgView labelFrame:CGRectMake(10, (_offLineImgView.height - 20)/2, _offLineImgView.width - 20, 20) textColor:[UIColor whiteColor] fontSize:FONTSIZE(20) labelTag:0 alignment:NSTextAlignmentCenter];
    label.text = @"已下架";
    
}

/**
 *  长按
 *
 *  @param tap tap
 */
- (void)tapLongGesture:(UILongPressGestureRecognizer *)tap
{
    if (self.baseCollectionCellBlock)
    {
        if (tap.state == UIGestureRecognizerStateBegan)
        {
            //            debugLog(@"开始");
            self.baseCollectionCellBlock(_foodEntity);
        }
        else if (tap.state == UIGestureRecognizerStateEnded)
        {
            //            debugLog(@"结束");
        }
    }
}


- (void)updateViewCell:(id)cellEntity
{
    self.foodEntity = cellEntity;
    
    NSString *imgUrl = objectNull(_foodEntity.image);
    if (![imgUrl isEqualToString:@""])
    {
        imgUrl = [NSString stringWithFormat:@"%@?imageView2/0/q/50", imgUrl];
    }

    
    [_thumalImgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"menu_icon_default"]];
    
    CGFloat price = _foodEntity.activity_price;
    if (price == 0.0)
    {
        price = _foodEntity.price;
    }
    NSString *str = [NSString stringWithFormat:@"￥%.0f  ", price];
    NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] init];
    if (_foodEntity.state == 0)
    {// 线上
        _foodNameLabel.textColor = [UIColor colorWithHexString:@"#323232"];
        
        NSAttributedString *butedStr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16], NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#ff5500"]}];
        [mas appendAttributedString:butedStr];
        if (_foodEntity.activity_price != 0.0)
        {
            //        debugLog(@"ddfdfd");
            str = [NSString stringWithFormat:@"￥%.0f", _foodEntity.price];
            //        debugLog(@"str=%@", str);
            NSAttributedString *bu = [MCYPushViewController middleSingleLine:objectNull(str) font:FONTSIZE_12 textColor:[UIColor colorWithHexString:@"#cecece"] lineColor:[UIColor colorWithHexString:@"#cecece"]];
            [mas appendAttributedString:bu];
        }
        
        _offLineImgView.hidden = YES;
    }
    else if (_foodEntity.state == 1)
    {// 下架
        _foodNameLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        
        NSAttributedString *butedStr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16], NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#999999"]}];
        [mas appendAttributedString:butedStr];
        if (_foodEntity.activity_price != 0.0)
        {
            //        debugLog(@"ddfdfd");
            str = [NSString stringWithFormat:@"￥%.0f", _foodEntity.price];
            //        debugLog(@"str=%@", str);
            NSAttributedString *bu = [MCYPushViewController middleSingleLine:objectNull(str) font:FONTSIZE_12 textColor:[UIColor colorWithHexString:@"#999999"] lineColor:[UIColor colorWithHexString:@"#999999"]];
            [mas appendAttributedString:bu];
        }
        _offLineImgView.hidden = NO;
    }
    _foodNameLabel.text = _foodEntity.name;
    
    _priceLabel.attributedText = mas;
}

+ (NSInteger)getWithImgViewWidth
{
    int leftWidth = (int)([[UIScreen mainScreen] screenWidth] / 4.16);
    int rightWidth = [[UIScreen mainScreen] screenWidth] - leftWidth;
    int imgWidth = ceilf((rightWidth - 10 - 5) / 2);
    return imgWidth;
}


+ (NSInteger)getWithImgViewHeight
{
    return ceilf([self getWithImgViewWidth] / 1.125);
}

+ (NSInteger)getWithCellWidth
{
    return [self getWithImgViewWidth];
}

+ (NSInteger)getWithCellHeight
{
    return [self getWithImgViewHeight] + 48;
}


@end
