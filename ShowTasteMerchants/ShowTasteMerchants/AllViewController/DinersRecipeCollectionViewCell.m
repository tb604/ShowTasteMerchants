//
//  DinersRecipeCollectionViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/25.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DinersRecipeCollectionViewCell.h"
#import "LocalCommon.h"
#import "ShopFoodDataEntity.h"
#import "UIImageView+WebCache.h"
#import "AddFoodNumberNewView.h" // 添加菜品数量按钮
#import "ShopingCartEntity.h"

@interface DinersRecipeCollectionViewCell ()
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
    
    AddFoodNumberNewView *_addFoodNumView;
    
    /**
     *  下架的标记
     */
    UIImageView *_offLineImgView;
}

@property (nonatomic, strong) CALayer *line;

@property (nonatomic, strong) ShopFoodDataEntity *foodEntity;

- (void)initWithBgView;

- (void)initWithThumalImgView;

- (void)initWithFoodNameLabel;

- (void)initWithPriceLabel;

- (void)initWithAddFoodNumView;

- (void)initWithOffLineImgView;

@end

@implementation DinersRecipeCollectionViewCell

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
//    self.backgroundView.backgroundColor = [UIColor whiteColor];
//    self.contentView.backgroundColor = [UIColor whiteColor];
//    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithBgView];
    
    [self initWithThumalImgView];
 
    [self initWithLine];
    
    [self initWithFoodNameLabel];
    
    [self initWithPriceLabel];
    
    [self initWithAddFoodNumView];
    
    [self initWithOffLineImgView];
    
//    self.layer.masksToBounds = YES;
//    self.layer.cornerRadius = 4;
    self.layer.shadowColor = [UIColor blackColor].CGColor; // 阴影颜色
    self.layer.shadowOffset = CGSizeMake(0, 2); // shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    self.layer.shadowOpacity = 0.05; // 阴影透明度，默认0
    self.layer.shadowRadius = 2; // 阴影半径，默认3
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
//    _thumalImgView.backgroundColor = [UIColor lightGrayColor];
    _thumalImgView.image = [UIImage imageNamed:@"menu_icon_default"];
    [_bgView addSubview:_thumalImgView];
}

- (void)initWithLine
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake(_thumalImgView.width, 0.8);
    line.left = 0;
    line.top = _thumalImgView.height + 48.0;
    line.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"].CGColor;
    [_bgView.layer addSublayer:line];
    self.line = line;
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

- (void)initWithAddFoodNumView
{
    CGRect frame = CGRectMake(0, 0, _thumalImgView.width, kAddFoodNumberNewViewHeight);
    _addFoodNumView = [[AddFoodNumberNewView alloc] initWithFrame:frame];
    _addFoodNumView.centerY = _line.bottom + 40.0/2;
    _addFoodNumView.centerX = _thumalImgView.width / 2;
//    _addFoodNumView.bottom = [[self class] getWithRecipeViewCellHeight] - 8;
    //    _addFoodNumView.backgroundColor = [UIColor lightGrayColor];
    [_bgView addSubview:_addFoodNumView];
    __weak typeof(self)weakSelf = self;
    _addFoodNumView.addFoodBlock = ^(NSInteger type, id button)
    {// 1表示减法；2表示加法；3选择规格；4添加
        if (weakSelf.touchAddSubBlock)
        {
            if (weakSelf.foodEntity.state != 0)
            {
                return;
            }
            weakSelf.touchAddSubBlock(type, button, weakSelf.foodEntity);
        }
    };
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
    return [self getWithImgViewHeight] + 48 + 40;
    
    // http://test-img.xiuwei.chinatopchef.com/xw-test/food/details/4/3ce106ea-83c3-cad1-ace7-d3e3096daf44.jpg?imageView2/0/w/134/h/134
    
   // http://test-img.xiuwei.chinatopchef.com/xw-test/food/details/4/3ce106ea-83c3-cad1-ace7-d3e3096daf44.jpg
    
    // http://test-img.xiuwei.chinatopchef.com/xw-test/food/1/d0a2134b-a334-61ef-de6d-d19e28e1b847.jpg
    // http://test-img.xiuwei.chinatopchef.com/xw-test/food/1/d0a2134b-a334-61ef-de6d-d19e28e1b847.jpg?imageView2/0/w/134/h/134
}


- (void)updateViewCell:(id)cellEntity
{
    ShopFoodDataEntity *foodEntity = cellEntity;
    self.foodEntity = foodEntity;
//    debugLog(@"image=%@", _foodEntity.image);
    NSString *imgUrl = objectNull(_foodEntity.image);
    if (![imgUrl isEqualToString:@""])
    {
        imgUrl = [NSString stringWithFormat:@"%@?imageView2/0/q/50", imgUrl];
//        debugLog(@"imgeUrl=%@", imgUrl);
    }
    // 图片
    [_thumalImgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"menu_icon_default"]];
    
    NSString *str = nil;
    // 菜名
    _foodNameLabel.text = foodEntity.name;
  
    
    // 菜品工艺
    NSString *mode = objectNull(_foodEntity.mode);
    // 口味
    NSString *taste = objectNull(_foodEntity.taste);
    NSInteger count = 0;
    for (ShopingCartEntity *ent in _foodEntity.shopCartList)
    {
        count += ent.number;
    }
    if ([mode isEqualToString:@""] && [taste isEqualToString:@""])
    {// 没有工艺、没有口味、此菜品对应的购物车为空
        if (count == 0)
        {
            [_addFoodNumView hiddenWithSpec:NO specTitle:@"添加"];
            [_addFoodNumView updateWithAddNum:count isRule:NO];
        }
        else
        {
            [_addFoodNumView hiddenWithSpec:YES specTitle:@"添加"];
            [_addFoodNumView updateWithAddNum:count isRule:NO];
        }
    }
    else
    {
        [_addFoodNumView hiddenWithSpec:NO specTitle:@"可选规格"];
        [_addFoodNumView updateWithAddNum:count isRule:YES];
    }
    
    
    CGFloat price = _foodEntity.activity_price;
    if (price == 0.0)
    {
        price = _foodEntity.price;
    }
    str = [NSString stringWithFormat:@"￥%.0f  ", price];
    NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] init];
    if (_foodEntity.state == 0)
    {// 线上
        [_addFoodNumView updateWithSpecColor:[UIColor colorWithHexString:@"#ff5500"]];
        _foodNameLabel.textColor = [UIColor colorWithHexString:@"#323232"];
        // 价格
        NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] init];
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
        _priceLabel.attributedText = mas;
        _offLineImgView.hidden = YES;
    }
    else if (_foodEntity.state == 1)
    {// 下架
        [_addFoodNumView updateWithSpecColor:[UIColor colorWithHexString:@"#999999"]];
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
        _priceLabel.attributedText = mas;
        _offLineImgView.hidden = NO;
    }
    
    
    
}


@end












