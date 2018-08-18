/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCCustomersPayFoodViewCell.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/28 09:53
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCCustomersPayFoodViewCell.h"
#import "LocalCommon.h"
#import "CTCMealOrderFoodEntity.h"


@interface CTCCustomersPayFoodViewCell ()
{
    
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

@property (nonatomic, strong) CTCMealOrderFoodEntity *foodEntity;

@property (nonatomic, strong) CALayer *line;

@property (nonatomic, strong) UIFont *font;

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
@end

@implementation CTCCustomersPayFoodViewCell

- (void)initWithVarCell
{
    [super initWithVarCell];
    
    self.font = FONTSIZE_15;
}

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithLine];
}

- (void)initWithLine
{
    if (!_line)
    {
        CALayer *line = [CALayer layer];
        line.size = CGSizeMake([[UIScreen mainScreen] screenWidth], 0.6);
        line.left = 0;
        line.bottom = 0;
        line.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"].CGColor;
        [self.contentView.layer addSublayer:line];
        self.line = line;
    }
}

/**
 *  金额
 */
- (void)initWithAmountLabel
{
    if (!_amountLabel)
    {
        NSString *str = @"￥123453459";
        if (kiPhone4 || kiPhone5)
        {
            str = @"￥123453";
        }
        float width = [str widthForFont:FONTSIZE_12];
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - 10 - width, 10, width, 20);
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
 *  数量
 */
- (void)initWithNumberLabel
{
    if (!_numberLabel)
    {
        NSString *str = @"数量你号我";
        if (kiPhone4 || kiPhone5)
        {
            str = @"数量你";
        }
        float width = [str widthForFont:FONTSIZE_12];
        CGRect frame = _amountLabel.frame;
        frame.size.width = width;
        frame.origin.x = _amountLabel.left - width - 5;
        _numberLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:_font labelTag:0 alignment:NSTextAlignmentRight];
//        _numberLabel.backgroundColor = [UIColor purpleColor];
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
        NSString *str = @"单价/规格哈和东";
        if (kiPhone4 || kiPhone5)
        {
            str = @"单价/规格哈";
        }
        float width = [str widthForFont:FONTSIZE_12];
        CGRect frame = _numberLabel.frame;
        frame.size.width = width;
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
        CGRect frame = CGRectMake(5, (40-image.size.height) / 2., image.size.width, image.size.height);
        _thanImgView = [[UIImageView alloc] initWithFrame:frame];
        _thanImgView.image = image;
        [self.contentView addSubview:_thanImgView];
    }
    
    if ([_foodEntity.details count] == 0)
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
        CGRect frame = CGRectMake(25, 10, _numberLabel.left - 5 - _thanImgView.right - 2, 20);
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

- (void)updateCellData:(id)cellEntity
{
    self.foodEntity = cellEntity;
    
    //    debugLog(@"foodEnt=%@", [_foodEntity modelToJSONString]);
    
    [self initWithThanImgView];
    
    // 金额
    [self initWithAmountLabel];
    [self initWithAcAmountLabel];
    
    // 数量
    [self initWithNumberLabel];
    [self initWithAcNumberLabel];
    
    // 单价
    [self initWithUnitPriceLabel];
    [self initWithAcUnitPriceLabel];
    
    
    [self initWithThanImgView];
    
    // 菜名
    [self initWithNameLabel];
    
    
    
    UIColor *color = [UIColor colorWithHexString:@"#323232"];
    
    // 已上桌
//    _thumalImgView.hidden = NO;
    // 100 已点菜 200 已下单 300 已上桌 700 已退菜
    debugLog(@"foodname=%@; status=%d", _foodEntity.food_name, (int)_foodEntity.status);
    if (_foodEntity.status == NS_ORDER_FOOD_DISHES_STATE)
    {// 已点菜
//        _thumalImgView.hidden = YES;
    }
    else if (_foodEntity.status == NS_ORDER_FOOD_HAVE_STATE)
    {// 已下单
//        _thumalImgView.hidden = YES;
    }
    else if (_foodEntity.status == NS_ORDER_FOOD_TABLE_STATE)
    {// 已上桌
        BOOL bRet = YES;
        //        CTCMealOrderFoodEntity
        // OrderFoodInfoEntity
        
        for (CTCMealOrderFoodEntity *ent in _foodEntity.details)
        {
            if (ent.status == NS_ORDER_FOOD_DISHES_STATE || ent.status == NS_ORDER_FOOD_HAVE_STATE)
            {
                bRet = NO;
            }
        }
        if (bRet)
        {
//            _thumalImgView.hidden = NO;
            UIImage *image = [UIImage imageNamed:@"pay_selected"];
//            _thumalImgView.image = image;
        }
        else
        {
//            _thumalImgView.hidden = YES;
        }
    }
    else if (_foodEntity.status == NS_ORDER_FOOD_RETIRED_STATE)
    {// 已退菜
        UIImage *image = [UIImage imageNamed:@"menu_icon_tui"];
//        _thumalImgView.image = image;
        color = [UIColor colorWithHexString:@"#999999"];
        
        // 1表示已退菜；2表示有在已点菜、已下单状态；3表示全部已上桌
        NSInteger bRet = 1;
        for (CTCMealOrderFoodEntity *ent in _foodEntity.details)
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
//            _thumalImgView.hidden = YES;
        }
        else if (bRet == 3)
        {
            color = [UIColor colorWithHexString:@"#323232"];
            UIImage *image = [UIImage imageNamed:@"pay_selected"];
//            _thumalImgView.image = image;
//            _thumalImgView.hidden = NO;
        }
        
        //        priceColor = [UIColor colorWithHexString:@"#999999"];
    }
    else
    {
//        _thumalImgView.hidden = YES;
        UIImage *image = [UIImage imageNamed:@"pay_selected"];
//        _thumalImgView.image = image;
        BOOL bRet = YES;
        for (CTCMealOrderFoodEntity *mepFoodEnt in _foodEntity.details)
        {
            if (mepFoodEnt.status != NS_ORDER_FOOD_TABLE_STATE)
            {
                bRet = NO;
                break;
            }
        }
        if (bRet)
        {
            _thanImgView.hidden = NO;
        }
    }
    
    if (_foodEntity.food_activity_price == 0.0)
    {// 活动价格没有
        
        //        debugLog(@"foodName=%@; price=%.2f; acprice=%.2f", _foodEntity.food_name, _foodEntity.food_price, _foodEntity.food_activity_price);
        // 金额
        _amountLabel.text = [NSString stringWithFormat:@"%.0f", _foodEntity.total];
        
        // 单价
        NSString *unitPrice = @"--";
        if (_foodEntity.food_price != 0.0)
        {
            unitPrice = [NSString stringWithFormat:@"%.0f", _foodEntity.food_price];
        }
        _unitPriceLabel.text = unitPrice;
        
        // 数量
        _numberLabel.text = [NSString stringWithFormat:@"%d", (int)_foodEntity.food_number];
        
        _acAmountLabel.hidden = YES;
        _acUnitPriceLabel.hidden = YES;
        _acNumberLabel.hidden = YES;
        
    }
    else
    {
        //        debugLog(@"else");
        // 金额
        _amountLabel.text = @"--";
        
        // 单价
        NSString *unitPrice = @"--";
        if (_foodEntity.food_price != 0.0)
        {
            unitPrice = [NSString stringWithFormat:@"%.0f", _foodEntity.food_price];
        }
        _unitPriceLabel.text = unitPrice;
        
        
        // 数量
        _numberLabel.text = @"--";
        
        //        _acAmountLabel.text = [NSString stringWithFormat:@"%.0f", _foodEntity.food_activity_price * _foodEntity.food_number];
        _acAmountLabel.text = [NSString stringWithFormat:@"%.0f", _foodEntity.total];
        
        
        NSString *acunitPrice = @"--";
        if (_foodEntity.food_activity_price != 0.0)
        {
            acunitPrice = [NSString stringWithFormat:@"%.0f", _foodEntity.food_activity_price];
        }
        _acUnitPriceLabel.text = acunitPrice;
        _acNumberLabel.text = [NSString stringWithFormat:@"%d", (int)_foodEntity.food_number];
        
        _acAmountLabel.hidden = NO;
        _acUnitPriceLabel.hidden = NO;
        _acNumberLabel.hidden = NO;
    }
    
    
    // 菜名
    _nameLabel.text = _foodEntity.food_name;
    _nameLabel.textColor = color;
    
    // 工艺、口味
    [self initWithStandardLabel];
    
    self.line.bottom = [[self class] getWithCellHeight:cellEntity];
    
}


+ (CGFloat)getWithCellHeight:(CTCMealOrderFoodEntity *)foodEntity
{
    NSString *mode = objectNull(foodEntity.mode);
    NSString *taste = objectNull(foodEntity.taste);
    //    debugLog(@"mode=%@; taste=%@", mode, taste);
    CGFloat height = 0;
    if ([mode isEqualToString:@""] && [taste isEqualToString:@""] && foodEntity.food_activity_price == 0.0)
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
