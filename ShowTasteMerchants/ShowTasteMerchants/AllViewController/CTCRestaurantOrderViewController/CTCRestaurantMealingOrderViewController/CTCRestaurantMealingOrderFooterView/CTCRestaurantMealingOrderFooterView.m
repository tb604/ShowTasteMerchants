/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCRestaurantMealingOrderFooterView.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/18 09:07
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCRestaurantMealingOrderFooterView.h"
#import "LocalCommon.h"


@interface CTCRestaurantMealingOrderFooterView ()
{
    UILabel *_titleLabel;
}

- (void)initWithTitleLabel;

@end

@implementation CTCRestaurantMealingOrderFooterView

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
    
    self.backgroundColor = [UIColor whiteColor];
    
    [CALayer drawLine:self frame:CGRectMake(0, 0, self.width, 0.5) lineColor:[UIColor colorWithHexString:@"#cdcdcd"]];
    
    [self initWithTitleLabel];
    
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        CGRect frame = CGRectMake(15, (kCTCRestaurantMealingOrderFooterViewHeight-20)/2., self.width, 20);
//        debugLogFrame(frame);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
//        _titleLabel.backgroundColor = [UIColor redColor];
    }
    
    _titleLabel.text = @"热菜8道 / 冷菜5道 / 主食10份";
    
}

- (void)updateViewData:(id)entity
{
    
}

@end

























