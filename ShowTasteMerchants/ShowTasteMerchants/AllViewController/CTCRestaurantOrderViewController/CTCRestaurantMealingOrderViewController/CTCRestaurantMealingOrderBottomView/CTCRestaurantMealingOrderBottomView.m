/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCRestaurantMealingOrderBottomView.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/17 16:45
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCRestaurantMealingOrderBottomView.h"
#import "LocalCommon.h"
#import "CTCMealOrderDetailsEntity.h"


@interface CTCRestaurantMealingOrderBottomView ()
{
    /// 加菜、下单
    UIButton *_btnMore;
    
    /// 买单
    UIButton *_btnPay;
    
    ///总金额
    UILabel *_totalAmountLabel;
}

- (void)initWithBtnMore;

- (void)initWithBtnPay;

/**
 *  总金额
 */
- (void)initWithTotalAmountLabel;

@end

@implementation CTCRestaurantMealingOrderBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code
}
*/

#pragma mark -
#pragma mark override

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    
    [CALayer drawLine:self frame:CGRectMake(0, 0, self.width, 0.5) lineColor:[UIColor colorWithHexString:@"#999999"]];
    
    
    [self initWithBtnMore];
    
    [self initWithBtnPay];
    
    // 总金额
    [self initWithTotalAmountLabel];
    
}

- (void)initWithBtnMore
{
    if (!_btnMore)
    {
        UIImage *image = [UIImage imageWithContentsOfFileName:@"order_btn_more.png"];
        CGRect frame = CGRectMake(self.width - self.height, 0, self.height, self.height);
        _btnMore = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnMore setImage:image forState:UIControlStateNormal];
        [_btnMore addTarget:self action:@selector(clickedWithbutton:) forControlEvents:UIControlEventTouchUpInside];
        _btnMore.frame = frame;
        _btnMore.tag = NS_MEALINGORDER_BUTTON_MORE_TAG;
        _btnMore.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
        [self addSubview:_btnMore];
    }
}

- (void)initWithBtnPay
{
    if (!_btnPay)
    {
        CGRect frame = _btnMore.frame;
        frame.size.width = 75.;
        frame.origin.x = _btnMore.left - frame.size.width;
        _btnPay = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"买单" titleColor:[UIColor whiteColor] titleFont:FONTSIZE_16 targetSel:@selector(clickedWithbutton:)];
        _btnPay.frame = frame;
        _btnPay.tag = NS_MEALINGORDER_BUTTON_PAY_TAG;
        _btnPay.backgroundColor = [UIColor colorWithHexString:@"#ff5500"];
        [self addSubview:_btnPay];
    }
}

/**
 *  总金额
 */
- (void)initWithTotalAmountLabel
{
    if (!_totalAmountLabel)
    {
        CGRect frame = CGRectMake(10, (self.height - 20)/2., _btnPay.left - 10 * 2, 20);
        _totalAmountLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE_16 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    
//    _totalAmountLabel.text = @"￥246.00";
}

- (void)clickedWithbutton:(id)sender
{
//    debugMethod();
    UIButton *button = (UIButton *)sender;
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(button);
    }
}

- (void)updateViewData:(id)entity
{
    CTCMealOrderDetailsEntity *orderDetailEnt = entity;
    
    _totalAmountLabel.text = [NSString stringWithFormat:@"￥%.2f", orderDetailEnt.sf_amount];
}


@end






















