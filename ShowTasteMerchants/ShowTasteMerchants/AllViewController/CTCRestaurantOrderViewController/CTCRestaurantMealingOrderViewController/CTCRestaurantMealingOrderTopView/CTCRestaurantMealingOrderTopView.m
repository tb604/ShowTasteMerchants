/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCRestaurantMealingOrderTopView.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/17 16:21
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCRestaurantMealingOrderTopView.h"
#import "LocalCommon.h"
#import "CTCRestaurantMealingOrderLeftView.h"
#import "CTCMealOrderDetailsEntity.h"


@interface CTCRestaurantMealingOrderTopView ()
{
    /// 台号
    UILabel *_deskNumLabel;
    
    UILabel *_serviceLabel;
    
    /// 订单号
    UILabel *_orderNoLabel;
}

@property (nonatomic, strong) CALayer *vline;

- (void)initWithDeskNumLabel;

- (void)initWithServiceLabel;

/**
 *  初始化订单号
 */
- (void)initWithOrderNoLabel;

@end

@implementation CTCRestaurantMealingOrderTopView

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
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithDeskNumLabel];
    
    CALayer *line = [CALayer drawLine:self frame:CGRectMake([CTCRestaurantMealingOrderLeftView getWithViewWidth] - 0.5, 7.5, 1, self.height - 7.5*2) lineColor:[UIColor colorWithHexString:@"#cbcbcb"]];
    self.vline = line;
    
    [self initWithServiceLabel];
    
    // 初始化订单号
    [self initWithOrderNoLabel];
}


#pragma mark -
#pragma mark private methods

- (void)initWithDeskNumLabel
{
    if (!_deskNumLabel)
    {
        CGRect frame = CGRectMake(1, (self.height-20)/2., [CTCRestaurantMealingOrderLeftView getWithViewWidth] - 2, 20);
        _deskNumLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_14 labelTag:0 alignment:NSTextAlignmentCenter];
        _deskNumLabel.text = @"台号";
    }
}

- (void)initWithServiceLabel
{
    if (!_serviceLabel)
    {
        CGRect frame = CGRectMake(self.width - 10 - 20, 5, 20, 20);
        _serviceLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor whiteColor] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentCenter];
        _serviceLabel.layer.masksToBounds = YES;
        _serviceLabel.layer.cornerRadius = 4;
        _serviceLabel.backgroundColor = [UIColor colorWithHexString:@"#81d1cb"];
        _serviceLabel.text = @"服";
        
    }
}

/**
 *  初始化订单号
 */
- (void)initWithOrderNoLabel
{
    if (!_orderNoLabel)
    {
        CGRect frame = _serviceLabel.frame;
        frame.origin.x = _vline.right + 10;
        frame.size.width = _serviceLabel.left - 10 - _vline.right - 10;
        _orderNoLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
    }
//    _orderNoLabel.text = @"订单号：213423423231";
}

- (void)updateViewData:(id)entity
{
    CTCMealOrderDetailsEntity *orderDetailEnt = entity;
    _orderNoLabel.text = [NSString stringWithFormat:@"订单号：%@", objectNull(orderDetailEnt.order_id)];
    
    if (orderDetailEnt.type == 3)
    {// 餐厅
        _serviceLabel.text = @"服";
    }
    else
    {
        _serviceLabel.text = @"客";
    }
}

@end




















