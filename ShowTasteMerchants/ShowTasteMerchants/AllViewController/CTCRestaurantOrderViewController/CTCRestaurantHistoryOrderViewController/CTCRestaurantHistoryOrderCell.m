
/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCRestaurantHistoryOrderCell.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/23 20:57
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCRestaurantHistoryOrderCell.h"
#import "LocalCommon.h"
#import "OrderDataEntity.h"

@interface CTCRestaurantHistoryOrderCell ()
{
    /// 订单编号
    UILabel *_orderNoLabel;
    
    /// 订单状态
    UILabel *_orderStateLabel;
    
    /// 是服务员还是食客自己发布的订单
    UIImageView *_serviceImgView;
    
    /// 订单类型，预定还是即时
    UIImageView *_orderTypeImgView;
    
    /// 桌号
    UILabel *_tableNoLabel;
    
    /// 食客姓名
    UILabel *_userNameLabel;
    
    /// 订单金额
    UILabel *_orderAmountLabel;
    
    /// 结算时间
    UILabel *_clearingTime;
    
    /// 订单人数
    UILabel *_orderNumLabel;
    
}
@property (nonatomic, strong) CALayer *line;

@property (nonatomic, strong) OrderDataEntity *orderEntity;


- (void)initWithOrderNoLabel;

- (void)initWithOrderStateLabel;

/// 是服务员还是食客自己发布的订单
- (void)initWithServiceImgView;

- (void)initWithOrderTypeImgView;

/**
 *  初始化桌号
 */
- (void)initWithTableNoLabel;

/**
 *  食客姓名
 */
- (void)initWithUserNameLabel;

/**
 *  订单金额
 */
- (void)initWithOrderAmountLabel;

/**
 *  结算时间
 */
- (void)initWithClearingTime;

/**
 *  订单人数
 */
- (void)initWithOrderNumLabel;

@end

@implementation CTCRestaurantHistoryOrderCell

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
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    CALayer *line = [CALayer drawLine:self.contentView frame:CGRectMake(70, 30, [[UIScreen mainScreen] screenWidth] - 70, 0.5) lineColor:[UIColor colorWithHexString:@"#e0e0e0"]];
    self.line = line;
    
    [self initWithOrderNoLabel];
    
    [self initWithOrderStateLabel];
    
    /// 是服务员还是食客自己发布的订单
    [self initWithServiceImgView];
    
    [self initWithOrderTypeImgView];
    
    // 初始化桌号
    [self initWithTableNoLabel];
    
    
    // 食客姓名
    [self initWithUserNameLabel];
    
    // 订单金额
    [self initWithOrderAmountLabel];
    
    // 结算时间
    [self initWithClearingTime];
    
    // 订单人数
    [self initWithOrderNumLabel];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, _tableNoLabel.bottom, [[UIScreen mainScreen] screenWidth], 5)];
    view.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    [self.contentView addSubview:view];
}

- (void)initWithOrderNoLabel
{
    if (!_orderNoLabel)
    {
        float leftSpace = 10;
        if (kiPhone4 || kiPhone5)
        {
            leftSpace = 8;
        }
        NSString *str = @"订单编号：123456789012345678901234";
        float width = [str widthForFont:FONTSIZE_11];
        CGRect frame = CGRectMake(leftSpace, (30.0-20)/2., width, 20);
        _orderNoLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_11 labelTag:0 alignment:NSTextAlignmentLeft];
//        _orderNoLabel.text = str;
//        _orderNoLabel.backgroundColor = [UIColor lightGrayColor];
    }
    
    NSString *order = [NSString stringWithFormat:@"订单编号：%@", _orderEntity.order_id];
    _orderNoLabel.text = order;
}

- (void)initWithOrderStateLabel
{
    if (!_orderStateLabel)
    {
        float rightSpace = 10;
        if (kiPhone5 || kiPhone4)
        {
            rightSpace = 8;
        }
        NSString *str = @"交易完成";
        float width = [str widthForFont:FONTSIZE_12];
        CGRect frame = CGRectMake(0, (30.-20)/2., width, 20);
        _orderStateLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#00b21e"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentRight];
        _orderStateLabel.right = [[UIScreen mainScreen] screenWidth] - rightSpace;
        _orderStateLabel.text = str;
    }
    
    _orderStateLabel.text = objectNull(_orderEntity.status_remark);
    _orderStateLabel.textColor = [UtilityObject dinersWithOrderStateColor:_orderEntity.status];
}

/// 是服务员还是食客自己发布的订单
- (void)initWithServiceImgView
{
    if (!_serviceImgView)
    {
        UIImage *image = [UIImage imageWithContentsOfFileName:@"history-order_icon_fu.png"];
        float space = 10;
        if (kiPhone4 || kiPhone5)
        {
            space = 3;
        }
        CGRect frame = CGRectMake(_orderNoLabel.right + space, (30-image.size.height)/2., image.size.width, image.size.height);
        _serviceImgView = [[UIImageView alloc] initWithFrame:frame];
        _serviceImgView.image = image;
        [self.contentView addSubview:_serviceImgView];
    }
    
    UIImage *image = nil;
    if (_orderEntity.source_user_type == 0)
    {// 服务员
        // history-order_icon_fu
        image = [UIImage imageWithContentsOfFileName:@"history-order_icon_fu.png"];
    }
    else if (_orderEntity.source_user_type == 1)
    {// 用户
        // history-order_icon_ke
        image = [UIImage imageWithContentsOfFileName:@"history-order_icon_ke.png"];
    }
    _serviceImgView.image = image;
}

- (void)initWithOrderTypeImgView
{
    if (!_orderTypeImgView)
    {
        UIImage *image = [UIImage imageWithContentsOfFileName:@"history-order_icon_ji.png"];
        float space = 5;
        if (kiPhone4 || kiPhone5)
        {
            space = 1;
        }
        CGRect frame = CGRectMake(_serviceImgView.right + space, (30-image.size.height)/2., image.size.width, image.size.height);
        _orderTypeImgView = [[UIImageView alloc] initWithFrame:frame];
        _orderTypeImgView.backgroundColor = [UIColor redColor];
        _orderTypeImgView.image = image;
        [self.contentView addSubview:_orderTypeImgView];
    }
    
    UIImage *image = nil;
    // 1预订订单 2即时订单 3餐厅订单
    if (_orderEntity.type == 1)
    {// 预定
        image = [UIImage imageWithContentsOfFileName:@"history-order_icon_yu.png"];
    }
    else if (_orderEntity.type == 2)
    {// 即时
        image = [UIImage imageWithContentsOfFileName:@"history-order_icon_ji.png"];
    }
    else
    {// 餐厅订单
        image = [UIImage imageWithContentsOfFileName:@"history-order_icon_ji.png"];
    }
    
    _orderTypeImgView.image = image;
}

/**
 *  初始化桌号
 */
- (void)initWithTableNoLabel
{
    if (!_tableNoLabel)
    {
        CGRect frame = CGRectMake(0, _line.bottom, 70.0, kCTCRestaurantHistoryOrderCellHeight - _line.bottom - 5);
        _tableNoLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE(20) labelTag:0 alignment:NSTextAlignmentCenter];
        _tableNoLabel.numberOfLines = 2;
        _tableNoLabel.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"];
//        _tableNoLabel.text = @"万里长城";
    }
    
    _tableNoLabel.text = objectNull(_orderEntity.seat_number);
    
}

/**
 *  食客姓名
 */
- (void)initWithUserNameLabel
{
    if (!_userNameLabel)
    {
        CGRect frame = CGRectMake(_tableNoLabel.right + 10, _line.bottom+8, _orderNoLabel.right - _tableNoLabel.width - 10, 18);
        _userNameLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
//        _userNameLabel.text = @"食客姓名：莫永妹";
    }
//    _orderEntity.name
    NSString *str = [NSString stringWithFormat:@"食客姓名：%@", objectNull(_orderEntity.name)];
    _userNameLabel.text = str;
}

/**
 *  订单金额
 */
- (void)initWithOrderAmountLabel
{
    if (!_orderAmountLabel)
    {
        CGRect frame = _userNameLabel.frame;
        _orderAmountLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
        _orderAmountLabel.centerY = _tableNoLabel.centerY;
//        _orderAmountLabel.text = @"订单金额：￥12376";
    }
    
    NSString *amount = [NSString stringWithFormat:@"订单金额：%.2f", _orderEntity.pay_actually];
    _orderAmountLabel.text = amount;
}

/**
 *  结算时间
 */
- (void)initWithClearingTime
{
    if (!_clearingTime)
    {
        CGRect frame = _orderAmountLabel.frame;
        frame.size.width = [[UIScreen mainScreen] screenWidth] - _tableNoLabel.right - 20;
        _clearingTime = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
        _clearingTime.bottom = _tableNoLabel.bottom - 8;
//        _clearingTime.text = @"结算时间：2016-10-24 12:32:22";
    }
    NSString *time = [NSString stringWithFormat:@"结算时间：%@", objectNull(_orderEntity.settle_date)];
    _clearingTime.text = time;
}

/**
 *  订单人数
 */
- (void)initWithOrderNumLabel
{
    if (!_orderNumLabel)
    {
        CGRect frame = CGRectMake(_serviceImgView.left, 0, [[UIScreen mainScreen] screenWidth] - _serviceImgView.left - 10, 18);
        _orderNumLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
//        _orderNumLabel.text = @"订单人数：8";
        _orderNumLabel.centerY = _userNameLabel.centerY;
    }
    NSString *num = [NSString stringWithFormat:@"订单人数：%d", (int)_orderEntity.number];
    _orderNumLabel.text = num;
}


- (void)updateCellData:(id)cellEntity
{
    self.orderEntity = cellEntity;
    
    [self initWithOrderNoLabel];
    
    [self initWithOrderStateLabel];
    
    /// 是服务员还是食客自己发布的订单
    [self initWithServiceImgView];
    
    [self initWithOrderTypeImgView];
    
    // 初始化桌号
    [self initWithTableNoLabel];
    
    
    // 食客姓名
    [self initWithUserNameLabel];
    
    // 订单金额
    [self initWithOrderAmountLabel];
    
    // 结算时间
    [self initWithClearingTime];
    
    // 订单人数
    [self initWithOrderNumLabel];
}

@end

















