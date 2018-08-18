/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCRestaurantMealingOrderLeftCell.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/17 17:40
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCRestaurantMealingOrderLeftCell.h"
#import "LocalCommon.h"
#import "CTCRestaurantMealingOrderLeftView.h"
#import "OrderDiningSeatEntity.h"


@interface CTCRestaurantMealingOrderLeftCell ()
{
    /// 房号
    UIButton *_btnNum;
    
    /// 异常订单视图
    UIView *_abnormalView;
}

- (void)initWithBtnNum;

/**
 *  异常订单视图
 */
- (void)initWithAbnormalView;

@end

@implementation CTCRestaurantMealingOrderLeftCell

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
    
    self.backgroundView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    self.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    
    [self initWithBtnNum];
    
    // 异常订单视图
    [self initWithAbnormalView];
    
    [CALayer drawLine:self.contentView frame:CGRectMake(0, [CTCRestaurantMealingOrderLeftView getWithViewWidth]-0.5, [CTCRestaurantMealingOrderLeftView getWithViewWidth], 0.5) lineColor:[UIColor colorWithHexString:@"#cdcdcd"]];
    
}

- (void)initWithBtnNum
{
    if (!_btnNum)
    {
        CGRect frame = CGRectMake(0, 0, [CTCRestaurantMealingOrderLeftView getWithViewWidth], [CTCRestaurantMealingOrderLeftView getWithViewWidth]);
        _btnNum = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnNum.frame = frame;
        _btnNum.titleLabel.font = FONTSIZE(20);
        [_btnNum setTitle:@"306" forState:UIControlStateNormal];
        [_btnNum setTitleColor:[UIColor colorWithHexString:@"#646464"] forState:UIControlStateNormal];
        [_btnNum setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_btnNum setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_btnNum setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#e6e6e6"]] forState:UIControlStateNormal];
        [_btnNum setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#ff5500"]] forState:UIControlStateSelected];
        [_btnNum setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#ff5500"]] forState:UIControlStateHighlighted];
        [self.contentView addSubview:_btnNum];
        _btnNum.userInteractionEnabled = NO;
    }
}

/**
 *  异常订单视图
 */
- (void)initWithAbnormalView
{
    if (!_abnormalView)
    {
        CGRect frame = _btnNum.frame;
        _abnormalView = [[UIView alloc] initWithFrame:frame];
        _abnormalView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        UILabel *label = [TYZCreateCommonObject createWithLabel:_abnormalView labelFrame:CGRectMake(0, (CGRectGetHeight(frame)-20)/2., CGRectGetWidth(frame), 20) textColor:[UIColor whiteColor] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentCenter];
        label.text = @"异常";
        [self.contentView addSubview:_abnormalView];
        _abnormalView.hidden = YES;
    }
}

- (void)selectedWithCell:(BOOL)selected
{
    _btnNum.selected = selected;
}

- (void)updateCellData:(id)cellEntity
{
    OrderDiningSeatEntity *ent = cellEntity;
    debugLog(@"ent=%@", [ent modelToJSONString]);
    [_btnNum setTitle:ent.seat_number forState:UIControlStateNormal];
    _abnormalView.hidden = YES;
    if (ent.sign_end == 150)
    {
        _abnormalView.hidden = NO;
    }
}

@end














