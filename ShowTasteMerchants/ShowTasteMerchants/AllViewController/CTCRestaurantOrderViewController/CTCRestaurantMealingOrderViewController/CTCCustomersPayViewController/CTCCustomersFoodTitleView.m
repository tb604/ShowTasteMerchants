/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCCustomersFoodTitleView.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/27 18:30
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCCustomersFoodTitleView.h"
#import "LocalCommon.h"

@interface CTCCustomersFoodTitleView ()
{
    /// 金额
    UILabel *_totalAmountLabel;
    
    /// 数量
    UILabel *_foodNumberLabel;
    
    /// 单价/规格
    UILabel *_unitPriceLabel;
    
    /// 菜品
    UILabel *_foodNameLabel;
}

/**
 *  初始化金额
 */
- (void)initWithTotalAmountLabel;

/**
 *  初始化数量
 */
- (void)initWithFoodNumberLabel;

/**
 *  初始化 单价/规格
 */
- (void)initWithUnitPriceLabel;

/**
 *  初始化菜名
 */
- (void)initWithFoodNameLabel;

@end

@implementation CTCCustomersFoodTitleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code
}
*/

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    
    
    // 初始化金额
    [self initWithTotalAmountLabel];
    
    // 初始化数量
    [self initWithFoodNumberLabel];
    
    // 初始化 单价/规格
    [self initWithUnitPriceLabel];
    
    // 初始化菜名
    [self initWithFoodNameLabel];
    
}

/**
 *  初始化金额
 */
- (void)initWithTotalAmountLabel
{
    if (!_totalAmountLabel)
    {
        NSString *str = @"￥123453459";
        if (kiPhone4 || kiPhone5)
        {
            str = @"￥123453";
        }
        float width = [str widthForFont:FONTSIZE_12];
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - 10 - width, (kCTCCustomersFoodTitleViewHeight-20)/2., width, 20);
        _totalAmountLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor whiteColor] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentRight];
        _totalAmountLabel.text = @"金额";
//        _totalAmountLabel.backgroundColor = [UIColor redColor];
    }
}

/**
 *  初始化数量
 */
- (void)initWithFoodNumberLabel
{
    if (!_foodNumberLabel)
    {
        NSString *str = @"数量你号我";
        if (kiPhone4 || kiPhone5)
        {
            str = @"数量你";
        }
        float width = [str widthForFont:FONTSIZE_12];
        CGRect frame = CGRectMake(_totalAmountLabel.left - 5 - width, _totalAmountLabel.y, width, 20);
        _foodNumberLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor whiteColor] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentRight];
        _foodNumberLabel.text = @"数量";
//        _foodNumberLabel.backgroundColor = [UIColor redColor];
    }
}

/**
 *  初始化 单价/规格
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
        CGRect frame = CGRectMake(_foodNumberLabel.left - 5 - width, _foodNumberLabel.y, width, 20);
        _unitPriceLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor whiteColor] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentRight];
        _unitPriceLabel.text = @"单价/规格";
//        _unitPriceLabel.backgroundColor = [UIColor redColor];
    }
}

/**
 *  初始化菜名
 */
- (void)initWithFoodNameLabel
{
    if (!_foodNameLabel)
    {
        CGRect frame = CGRectMake(25, _unitPriceLabel.y, _unitPriceLabel.left - 5 - 25, 20);
        _foodNameLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor whiteColor] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
        _foodNameLabel.text = @"菜品";
//        _foodNameLabel.backgroundColor = [UIColor redColor];
    }
}

@end















