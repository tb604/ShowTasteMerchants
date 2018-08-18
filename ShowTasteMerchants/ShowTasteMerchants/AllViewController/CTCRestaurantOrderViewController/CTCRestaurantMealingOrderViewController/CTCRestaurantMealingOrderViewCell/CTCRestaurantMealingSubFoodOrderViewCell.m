/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCRestaurantMealingSubFoodOrderViewCell.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/18 09:44
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCRestaurantMealingSubFoodOrderViewCell.h"
#import "LocalCommon.h"
#import "OrderFoodInfoEntity.h"
#import "CTCMealOrderFoodEntity.h"
#import "CTCRestaurantMealingOrderLeftView.h"


@interface CTCRestaurantMealingSubFoodOrderViewCell ()
{
    
    UIImageView *_thumalImgView;
    
    /**
     *  金额
     */
    UILabel *_amountLabel;
    
    /**
     *  单价(原价)
     */
    UILabel *_unitPriceLabel;
    
    /**
     *  规格
     */
//    UILabel *_unitLabel;
    
    /**
     *  数量
     */
    UILabel *_numberLabel;
    
    /**
     *  菜名
     */
    UILabel *_nameLabel;
    
}

@property (nonatomic, strong) CTCMealOrderFoodEntity *foodEntity;

@property (nonatomic, strong) CALayer *line;

@property (nonatomic, strong) UIFont *font;

- (void)initWithThumalImgView;

/**
 *  金额
 */
- (void)initWithAmountLabel;

/**
 *  规格
 */
//- (void)initWithUnitLabel;

/**
 *  数量
 */
- (void)initWithNumberLabel;

/**
 *  单价
 */
- (void)initWithUnitPriceLabel;


/**
 *  菜名
 */
- (void)initWithNameLabel;

@end

@implementation CTCRestaurantMealingSubFoodOrderViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code
}
*/

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5f5"];
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5f5"];
    self.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5f5"];
    
    UIImage *image = [UIImage imageNamed:@"menu_icon_xiala"];
//    UIImage *payImage = [UIImage imageNamed:@"pay_selected"];
    CALayer *line = [CALayer drawLine:self.contentView frame:CGRectMake(5 + image.size.width + 5, kCTCRestaurantMealingSubFoodOrderViewCellHeight - 0.5, [[UIScreen mainScreen] screenWidth] - [CTCRestaurantMealingOrderLeftView getWithViewWidth] -image.size.width - 10, 0.5) lineColor:[UIColor colorWithHexString:@"#e6e6e6"]];
    self.line = line;
    
}

- (void)initWithThumalImgView
{
    if (!_thumalImgView)
    {
        UIImage *image = [UIImage imageWithContentsOfFileName:@"order_icon_yishang.png"];
//        UIImage *image = [UIImage imageNamed:@"pay_selected"];
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - [CTCRestaurantMealingOrderLeftView getWithViewWidth] - image.size.width - 5, 10, image.size.width, image.size.height);
        _thumalImgView = [[UIImageView alloc] initWithFrame:frame];
        _thumalImgView.image = image;
        [self.contentView addSubview:_thumalImgView];
    }
//    debugLog(@"name=%@; status=%d", _foodEntity.food_name, (int)_foodEntity.status);
    if (_foodEntity.status == NS_ORDER_FOOD_TABLE_STATE)
    {// 已上菜
        _thumalImgView.hidden = NO;
        _thumalImgView.image = [UIImage imageNamed:@"pay_selected"];
    }
    else if (_foodEntity.status == NS_ORDER_FOOD_RETIRED_STATE)
    {// 已退菜
//        debugLog(@"已退菜");
        _thumalImgView.hidden = NO;
        _thumalImgView.image = [UIImage imageNamed:@"menu_icon_tui"];
    }
    else
    {
        _thumalImgView.hidden = YES;
    }
}


/**
 *  金额
 */
- (void)initWithAmountLabel
{
    if (!_amountLabel)
    {
        NSString *str = @"7689";
        self.font = FONTSIZE_14;
        if (kiPhone6Plus || kiPhone6)
        {
            str = @"877689";
            self.font = FONTSIZE_15;
        }
        CGFloat width = [str widthForFont:FONTSIZE_15];
//        UIImage *image = [UIImage imageWithContentsOfFileName:@"order_icon_yishang.png"];
        CGRect frame = CGRectMake(_thumalImgView.left - 5 - width, 5, width, 20);
        _amountLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentRight];
//        _amountLabel.backgroundColor = [UIColor lightGrayColor];
    }
    CGFloat price = (_foodEntity.food_activity_price==0.0?_foodEntity.food_price:_foodEntity.food_activity_price);
    _amountLabel.text = [NSString stringWithFormat:@"%.0f", price * _foodEntity.food_number];
}

/**
 *  单价
 */
- (void)initWithUnitPriceLabel
{
    if (!_unitPriceLabel)
    {
        CGRect frame = _amountLabel.frame;
//        frame.size.width = _amountLabel.width;
        frame.origin.x = _amountLabel.left - frame.size.width - 2;
        _unitPriceLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentRight];
//        _unitPriceLabel.backgroundColor = [UIColor redColor];
    }
    CGFloat price = (_foodEntity.food_activity_price==0.0?_foodEntity.food_price:_foodEntity.food_activity_price);
    _unitPriceLabel.text = [NSString stringWithFormat:@"%.0f", price];
}

/**
 *  数量
 */
- (void)initWithNumberLabel
{
    if (!_numberLabel)
    {
        NSString *str = @"数量";
        if (kiPhone6Plus)
        {
            str = @"数量地";
        }
        float width = [str widthForFont:FONTSIZE_15];
        CGRect frame = _unitPriceLabel.frame;
        frame.size.width = width;
        frame.origin.x = _unitPriceLabel.left - width - 2;
        _numberLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentRight];
//        _numberLabel.backgroundColor = [UIColor purpleColor];
    }
    _numberLabel.text = [NSString stringWithFormat:@"%d", (int)_foodEntity.food_number];
}


/**
 *  菜名
 */
- (void)initWithNameLabel
{
    if (!_nameLabel)
    {
        CGFloat width = 0;
        if (kiPhone4 || kiPhone5)
        {
            width = 5;
        }
        
        UIImage *image = [UIImage imageNamed:@"menu_icon_xiala"];
        CGRect frame = CGRectMake(_line.left, 5, _numberLabel.left - 2 - 5 - 5 - image.size.width, 20);
        _nameLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
//        _nameLabel.backgroundColor = [UIColor lightGrayColor];
    }
    
    NSString *date =[NSDate stringWithDateInOut:_foodEntity.operate_time inFormat:@"yyyy-MM-dd HH:mm:ss" outFormat:@"HH:mm"];
    if ([objectNull(date) isEqualToString:@""])
    {
        _nameLabel.text = @"未下单";
    }
    else
    {
        _nameLabel.text = date;
    }
}


- (void)updateCellData:(id)cellEntity
{
    self.foodEntity = cellEntity;
    
//    debugLog(@"name=%@; status=%d", _foodEntity.food_name, (int)_foodEntity.status);
    
    [self initWithThumalImgView];
    
    // 金额
    [self initWithAmountLabel];
    
    // 单价
    [self initWithUnitPriceLabel];
    
    // 数量
    [self initWithNumberLabel];
    
    // 菜名
    [self initWithNameLabel];
    
}


@end
