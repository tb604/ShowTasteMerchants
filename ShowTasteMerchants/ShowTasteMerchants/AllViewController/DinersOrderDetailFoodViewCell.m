//
//  DinersOrderDetailFoodViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/29.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DinersOrderDetailFoodViewCell.h"
#import "LocalCommon.h"


@interface DinersOrderDetailFoodViewCell ()
{
    UIImageView *_thumalImgView;
    
    /**
     *  金额
     */
    UILabel *_amountLabel;
    
    /**
     *  金额(活动)
     */
    UILabel *_acAmountLabel;
    
    /**
     *  单价(原价)
     */
    UILabel *_unitPriceLabel;
    
    /**
     *  活动价
     */
    UILabel *_acUnitPriceLabel;
    
    /**
     *  规格
     */
    UILabel *_unitLabel;
    
    /**
     *  规格(活动)
     */
    UILabel *_acUnitLabel;
    
    /**
     *  数量
     */
    UILabel *_numberLabel;
    
    /**
     *  数量(活动)
     */
    UILabel *_acNumberLabel;
    
    UIImageView *_thanImgView;
    
    /**
     *  菜名
     */
    UILabel *_nameLabel;
    
    /**
     *  口味、工艺
     */
    UILabel *_standardLabel;
    
    
}

@property (nonatomic, strong) OrderFoodInfoEntity *foodEntity;

@property (nonatomic, strong) CALayer *line;

@property (nonatomic, strong) UIFont *font;

- (void)initWithThumalImgView;

/**
 *  金额
 */
- (void)initWithAmountLabel;

- (void)initWithAcAmountLabel;

/**
 *  单价
 */
- (void)initWithUnitPriceLabel;

- (void)initWithAcUnitPriceLabel;

/**
 *  规格
 */
- (void)initWithUnitLabel;

- (void)initWithAcUnitLabel;

/**
 *  数量
 */
- (void)initWithNumberLabel;

- (void)initWithAcNumberLabel;

- (void)initWithThanImgView;

/**
 *  菜名
 */
- (void)initWithNameLabel;

/**
 *  工艺、口味
 */
- (void)initWithStandardLabel;

/**
 *  长按
 *
 *  @param tap tap
 */
- (void)tapLongGesture:(UILongPressGestureRecognizer *)tap;

@end

@implementation DinersOrderDetailFoodViewCell

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithLine];
    
    [self initWithThumalImgView];
    
    // 金额
    [self initWithAmountLabel];
    [self initWithAcAmountLabel];
    
    // 规格
    [self initWithUnitLabel];
    [self initWithAcUnitLabel];
    
    // 数量
    [self initWithNumberLabel];
    [self initWithAcNumberLabel];
    
    // 单价
    [self initWithUnitPriceLabel];
    [self initWithAcUnitPriceLabel];
    
    [self initWithThanImgView];
    
    // 菜名
    [self initWithNameLabel];
    
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tapLongGesture:)];
    longGesture.numberOfTouchesRequired = 1;
    [self.contentView addGestureRecognizer:longGesture];
}

- (void)initWithLine
{
    if (!_line)
    {
        CALayer *line = [CALayer layer];
        line.size = CGSizeMake([[UIScreen mainScreen] screenWidth], 0.6);
        line.left = 0;
        line.bottom = 0;
        line.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"].CGColor;
        [self.contentView.layer addSublayer:line];
        self.line = line;
    }
}

- (void)initWithThumalImgView
{
    if (!_thumalImgView)
    {
        UIImage *image = [UIImage imageNamed:@"pay_selected"];
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - image.size.width - 15, 10, image.size.width, image.size.height);
        _thumalImgView = [[UIImageView alloc] initWithFrame:frame];
        _thumalImgView.image = image;
        [self.contentView addSubview:_thumalImgView];
    }
}

/**
 *  金额
 */
- (void)initWithAmountLabel
{
    if (!_amountLabel)
    {
        NSString *str = @"22225";
        self.font = FONTSIZE_14;
        if (kiPhone6Plus || kiPhone6)
        {
            str = @"2222225";
            self.font = FONTSIZE_15;
        }
        CGFloat width = [str widthForFont:FONTSIZE_15];
        CGRect frame = CGRectMake(_thumalImgView.left - 5 - 5 - width, 10, width, 20);
        _amountLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:_font labelTag:0 alignment:NSTextAlignmentRight];
//        _amountLabel.backgroundColor = [UIColor lightGrayColor];
    }
}

- (void)initWithAcAmountLabel
{
    if (!_acAmountLabel)
    {
        CGRect frame = _amountLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _acAmountLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:_font labelTag:0 alignment:NSTextAlignmentRight];
//        _acAmountLabel.backgroundColor = [UIColor lightGrayColor];
    }
}

/**
 *  规格
 */
- (void)initWithUnitLabel
{
    if (!_unitLabel)
    {
        CGRect frame = _amountLabel.frame;
        frame.size.width = frame.size.width - 10;
        frame.origin.x = _amountLabel.left - frame.size.width - 5;
        _unitLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:_font labelTag:0 alignment:NSTextAlignmentRight];
//        _unitLabel.backgroundColor = [UIColor lightGrayColor];
    }
}
- (void)initWithAcUnitLabel
{
    if (!_acUnitLabel)
    {
        CGRect frame = _unitLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _acUnitLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:_font labelTag:0 alignment:NSTextAlignmentRight];
//        _acUnitLabel.backgroundColor = [UIColor lightGrayColor];
    }
}

/**
 *  数量
 */
- (void)initWithNumberLabel
{
    if (!_numberLabel)
    {
        CGRect frame = _unitLabel.frame;
        frame.origin.x = _unitLabel.left - frame.size.width - 5;
        _numberLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:_font labelTag:0 alignment:NSTextAlignmentRight];
//        _numberLabel.backgroundColor = [UIColor lightGrayColor];
    }
}
- (void)initWithAcNumberLabel
{
    if (!_acNumberLabel)
    {
        CGRect frame = _numberLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _acNumberLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:_font labelTag:0 alignment:NSTextAlignmentRight];
//        _acNumberLabel.backgroundColor = [UIColor lightGrayColor];
    }
}

/**
 *  单价
 */
- (void)initWithUnitPriceLabel
{
    if (!_unitPriceLabel)
    {
        CGRect frame = _numberLabel.frame;
        frame.size.width = _amountLabel.width - 10;
        frame.origin.x = _numberLabel.left - frame.size.width - 5;
        _unitPriceLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:_font labelTag:0 alignment:NSTextAlignmentRight];
//        _unitPriceLabel.backgroundColor = [UIColor redColor];
    }
}

- (void)initWithAcUnitPriceLabel
{
    if (!_acUnitPriceLabel)
    {
        CGRect frame = _unitPriceLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _acUnitPriceLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:_font labelTag:0 alignment:NSTextAlignmentRight];
//        _acUnitPriceLabel.backgroundColor = [UIColor purpleColor];
    }
}

- (void)initWithThanImgView
{
    if (!_thanImgView)
    {
        UIImage *image = [UIImage imageNamed:@"menu_icon_xiala"];
        CGRect frame = CGRectMake(15, 0, image.size.width, image.size.height);
        _thanImgView = [[UIImageView alloc] initWithFrame:frame];
        _thanImgView.image = image;
        [self.contentView addSubview:_thanImgView];
        _thanImgView.centerY = _unitPriceLabel.centerY;
    }
    
    if ([_foodEntity.subFoods count] <= 1)
    {
        _thanImgView.hidden = YES;
    }
    else
    {
        _thanImgView.hidden = NO;
    }
    
    if (_foodEntity.isCheck)
    {
        [UIView animateWithDuration:0.3 animations:^{
            _thanImgView.transform = CGAffineTransformMakeRotation(M_PI);
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            _thanImgView.transform = CGAffineTransformMakeRotation(0);
        }];
    }

}

/**
 *  菜名
 */
- (void)initWithNameLabel
{
    if (!_nameLabel)
    {
//        UIFont *font = FONTSIZE_15;
        CGFloat width = 0;
        if (kiPhone4 || kiPhone5)
        {
//            font = FONTSIZE_14;
            width = 5;
        }
        
        CGRect frame = CGRectMake(_thanImgView.right + 5, 10, _unitPriceLabel.left - 15 - 5 + width - _thanImgView.right, 20);
        _nameLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:_font labelTag:0 alignment:NSTextAlignmentLeft];
//        _nameLabel.backgroundColor = [UIColor lightGrayColor];
    }
}

/**
 *  工艺、口味
 */
- (void)initWithStandardLabel
{
    if (!_standardLabel)
    {
        CGRect frame = CGRectMake(_nameLabel.left, _nameLabel.bottom + 4, _nameLabel.width, 16);
        _standardLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
//        _standardLabel.backgroundColor = [UIColor lightGrayColor];
    }
    
    _standardLabel.hidden = YES;
    NSString *mode = objectNull(_foodEntity.mode);
    NSString *taste = objectNull(_foodEntity.taste);
    if (![mode isEqualToString:@""] || ![taste isEqualToString:@""])
    {
        _standardLabel.hidden = NO;
        _standardLabel.text = [NSString stringWithFormat:@"%@ %@", mode, taste];
    }
}

/**
 *  长按
 *
 *  @param tap tao
 */
- (void)tapLongGesture:(UILongPressGestureRecognizer *)tap
{
    //    debugMethod();
    if (self.baseTableViewCellBlock)
    {
        if (tap.state == UIGestureRecognizerStateBegan)
        {
            //            debugLog(@"开始");
            self.baseTableViewCellBlock(_foodEntity);
        }
        else if (tap.state == UIGestureRecognizerStateEnded)
        {
            //            debugLog(@"结束");
        }
    }
}


- (void)updateCellData:(id)cellEntity
{
    self.foodEntity = cellEntity;
    
    [self initWithThanImgView];
    
    UIColor *color = [UIColor colorWithHexString:@"#323232"];
    
        // 已上桌
    _thumalImgView.hidden = NO;
    // 100 已点菜 200 已下单 300 已上桌 700 已退菜
    if (_foodEntity.status == NS_ORDER_FOOD_DISHES_STATE)
    {// 已点菜
        _thumalImgView.hidden = YES;
    }
    else if (_foodEntity.status == NS_ORDER_FOOD_HAVE_STATE)
    {// 已下单
        _thumalImgView.hidden = YES;
    }
    else if (_foodEntity.status == NS_ORDER_FOOD_TABLE_STATE)
    {// 已上桌
        BOOL bRet = YES;
        for (OrderFoodInfoEntity *ent in _foodEntity.subFoods)
        {
            if (ent.status == NS_ORDER_FOOD_DISHES_STATE || ent.status == NS_ORDER_FOOD_HAVE_STATE)
            {
                bRet = NO;
            }
        }
        if (bRet)
        {
            _thumalImgView.hidden = NO;
            UIImage *image = [UIImage imageNamed:@"pay_selected"];
            _thumalImgView.image = image;
        }
        else
        {
            _thumalImgView.hidden = YES;
        }
    }
    else if (_foodEntity.status == NS_ORDER_FOOD_RETIRED_STATE)
    {// 已退菜
        UIImage *image = [UIImage imageNamed:@"menu_icon_tui"];
        _thumalImgView.image = image;
        color = [UIColor colorWithHexString:@"#999999"];
        
        // 1表示已退菜；2表示有在已点菜、已下单状态；3表示全部已上桌
        NSInteger bRet = 1;
        for (OrderFoodInfoEntity *ent in _foodEntity.subFoods)
        {
            if (ent.status == NS_ORDER_FOOD_DISHES_STATE || ent.status == NS_ORDER_FOOD_HAVE_STATE)
            {// 已点菜、已下单
                bRet = 2;
                break;
            }
            else if (ent.status == NS_ORDER_FOOD_RETIRED_STATE)
            {// 已退菜
                bRet = 1;
            }
            else
            {
                bRet = 3;
            }
        }
        if (bRet == 2)
        {
            color = [UIColor colorWithHexString:@"#323232"];
            _thumalImgView.hidden = YES;
        }
        else if (bRet == 3)
        {
            color = [UIColor colorWithHexString:@"#323232"];
            UIImage *image = [UIImage imageNamed:@"pay_selected"];
            _thumalImgView.image = image;
            _thumalImgView.hidden = NO;
        }
        
//        priceColor = [UIColor colorWithHexString:@"#999999"];
    }
    
    if (_foodEntity.activity_price == 0.0)
    {// 活动价格没有
        // 金额
        _amountLabel.text = [NSString stringWithFormat:@"%.0f", _foodEntity.price * _foodEntity.allNumber];
        
        // 单价
        _unitPriceLabel.text = [NSString stringWithFormat:@"%.0f", _foodEntity.price];
        
        // 单位
        _unitLabel.text = _foodEntity.unit;
        
        // 数量
        _numberLabel.text = [NSString stringWithFormat:@"%d", (int)_foodEntity.allNumber];
        
        _acAmountLabel.hidden = YES;
        _acUnitPriceLabel.hidden = YES;
        _acUnitLabel.hidden = YES;
        _acNumberLabel.hidden = YES;
        
    }
    else
    {
        // 金额
        _amountLabel.text = @"--";
        
        // 单价
        _unitPriceLabel.text = [NSString stringWithFormat:@"%.0f", _foodEntity.price];
        
        // 单位
        _unitLabel.text = _foodEntity.unit;
        
        // 数量
        _numberLabel.text = @"--";
        
        _acAmountLabel.text = [NSString stringWithFormat:@"%.0f", _foodEntity.activity_price * _foodEntity.allNumber];
        _acUnitPriceLabel.text = [NSString stringWithFormat:@"%.0f", _foodEntity.activity_price];
        _acUnitLabel.text = _foodEntity.unit;
        _acNumberLabel.text = [NSString stringWithFormat:@"%d", (int)_foodEntity.allNumber];
        
        _acAmountLabel.hidden = NO;
        _acUnitPriceLabel.hidden = NO;
        _acUnitLabel.hidden = NO;
        _acNumberLabel.hidden = NO;
    }

    
    // 菜名
    _nameLabel.text = _foodEntity.food_name;
    _nameLabel.textColor = color;
    
    // 工艺、口味
    [self initWithStandardLabel];
    
    self.line.bottom = [[self class] getWithCellHeight:cellEntity];
    
}


+ (CGFloat)getWithCellHeight:(OrderFoodInfoEntity *)foodEntity
{
    NSString *mode = objectNull(foodEntity.mode);
    NSString *taste = objectNull(foodEntity.taste);
//    debugLog(@"mode=%@; taste=%@", mode, taste);
    CGFloat height = 0;
    if ([mode isEqualToString:@""] && [taste isEqualToString:@""] && foodEntity.activity_price == 0.0)
    {// 菜品的工艺、口味为空，活动价格没有的时候
        height = 40.0;
    }
    else
    {
        height = 58.0;
    }
    return height;
}

@end
