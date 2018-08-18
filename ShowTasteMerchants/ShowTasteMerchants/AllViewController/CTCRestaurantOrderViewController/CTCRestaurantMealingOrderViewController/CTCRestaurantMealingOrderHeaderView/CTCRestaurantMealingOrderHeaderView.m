/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCRestaurantMealingOrderHeaderView.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/17 16:27
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCRestaurantMealingOrderHeaderView.h"
#import "LocalCommon.h"

@interface CTCRestaurantMealingOrderHeaderView ()
{
    /// 已上菜的图标标记
//    UIImageView *_thumalImgView;
    
    /**
     *  金额
     */
    UILabel *_amountLabel;
    
    /**
     *  单价
     */
    UILabel *_unitPriceLabel;
    
    /**
     *  数量
     */
    UILabel *_numberLabel;
    
    /**
     *  菜名
     */
    UILabel *_foodNameLabel;
}

/**
 *  上菜等方面的图片标记
 */
//- (void)initWithThumalImgView;

/**
 *  ”金额“标题
 */
- (void)initWithAmountLabel;

/**
 *  “单价”标题
 */
- (void)initWithUnitPriceLabel;

/**
 *  “数量”标题
 */
- (void)initWithNumberLabel;

/**
 *  “菜名”标题
 */
- (void)initWithFoodNameLabel;

@end

@implementation CTCRestaurantMealingOrderHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code
}
*/

#pragma mark -
#pragma mark override methods

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    
    // 上菜等方面的图片标记
//    [self initWithThumalImgView];
    
    // ”金额“标题
    [self initWithAmountLabel];
    
    // “单价”标题
    [self initWithUnitPriceLabel];
    
    // “数量”标题
    [self initWithNumberLabel];
    
    // “菜名”标题
    [self initWithFoodNameLabel];
}


/**
 *  ”金额“标题
 */
- (void)initWithAmountLabel
{
    if (!_amountLabel)
    {
//        UIImage *image = [UIImage imageNamed:@"pay_selected"];
        UIImage *image = [UIImage imageWithContentsOfFileName:@"order_icon_yishang.png"];
        NSString *str = @"7689";
        if (kiPhone6Plus || kiPhone6)
        {
            str = @"877689";
        }
        float width = [str widthForFont:FONTSIZE_15];
        CGRect frame = CGRectMake(self.width - 5 - image.size.width - 5 - width, (self.height-20) / 2., width, 20);
        _amountLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor whiteColor] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentRight];
//        _amountLabel.backgroundColor = [UIColor purpleColor];
        _amountLabel.text = @"金额";
    }
}

/**
 *  “单价”标题
 */
- (void)initWithUnitPriceLabel
{
    if (!_unitPriceLabel)
    {
        NSString *str = @"9689";
        if (kiPhone6Plus)
        {
            str = @"877689";
        }
        float width = [str widthForFont:FONTSIZE_15];
        CGRect frame = _amountLabel.frame;
        frame.size.width = width;
        frame.origin.x = _amountLabel.left - 2 - width;
        _unitPriceLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor whiteColor] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentRight];
//        _unitPriceLabel.backgroundColor = [UIColor purpleColor];
        _unitPriceLabel.text = @"单价";
    }
}

/**
 *  “数量”标题
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
        frame.origin.x = _unitPriceLabel.left - 2 - width;
        _numberLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor whiteColor] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentRight];
//        _numberLabel.backgroundColor = [UIColor purpleColor];
        _numberLabel.text = @"数量";
    }
}

/**
 *  “菜名”标题
 */
- (void)initWithFoodNameLabel
{
    if (!_foodNameLabel)
    {
        UIImage *image = [UIImage imageNamed:@"menu_icon_xiala"];
        CGRect frame = CGRectMake(5 + image.size.width + 5, (self.height-20)/2., _numberLabel.left - 2 - 10 - image.size.width, 20);
        _foodNameLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor whiteColor] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
//        _foodNameLabel.backgroundColor = [UIColor purpleColor];
        _foodNameLabel.text = @"菜品";
    }
}


@end







