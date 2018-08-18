//
//  ShopMealingOrderViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/18.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopMealingOrderViewCell.h"
#import "LocalCommon.h"
#import "OrderDataEntity.h"

@interface ShopMealingOrderViewCell ()
{
    
    /**
     *  异常订单的标记
     */
    UIImageView *_cashImgView;
    
    /**
     *  桌号(大厅 | 桌号)
     */
    UILabel *_tableNoLabel;
    
    /**
     *  订单状态类型
     */
    UILabel *_orderStateLabel;
    
    /**
     *  订单号(预订 | 订单号)
     */
    UILabel *_orderNoLabel;
    
    /**
     *  姓名
     */
    UILabel *_nameLabel;
    
    /**
     *  到店时间
     */
    UILabel *_arriveDateLabel;
    
    /**
     *  餐桌类型
     */
    UILabel *_tableTypeLabel;
    
    /**
     *  查看订单
     */
    UIButton *_btnLookOrder;
}

@property (nonatomic, strong) OrderDataEntity *orderEntity;

- (void)initWithCashImgView;

/**
 * 桌号(大厅 | 桌号)
 */
- (void)initWithTableNoLabel;

/**
 * 订单状态类型
 */
- (void)initWithOrderStateLabel;

/**
 * 订单号(预订 | 订单号)
 */
- (void)initWithOrderNoLabel;

/**
 * 姓名
 */
- (void)initWithNameLabel;

/**
 * 到店时间
 */
- (void)initWithArriveDateLabel;

/**
 * 餐桌类型
 */
- (void)initWithTableTypeLabel;

/**
 * 查看订单
 */
- (void)initWithBtnLookOrder;


@end

@implementation ShopMealingOrderViewCell

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    /*
    // 桌号(大厅 | 桌号)
    [self initWithTableNoLabel];
    
    // 订单状态类型
    [self initWithOrderStateLabel];
    
    // 订单号(预订 | 订单号)
    [self initWithOrderNoLabel];
    
    // 姓名
    [self initWithNameLabel];
    
    // 到店时间
    [self initWithArriveDateLabel];
    
    // 餐桌类型
    [self initWithTableTypeLabel];
    
    // 查看订单
    [self initWithBtnLookOrder];
    */
}

- (void)initWithCashImgView
{
    if (!_cashImgView)
    {
        // order_icon_abnormal
        CGFloat height = [[self class] getWithCellHeight:_orderEntity.type];
        UIImage *image = [UIImage imageNamed:@"order_icon_abnormal"];
        CGRect frame = CGRectMake(0, (height-image.size.height)/2, image.size.width, image.size.height);
        _cashImgView = [[UIImageView alloc] initWithFrame:frame];
        _cashImgView.image = image;
        _cashImgView.right = [[UIScreen mainScreen] screenWidth] - 15;
        [self.contentView addSubview:_cashImgView];
    }
    _cashImgView.hidden = YES;
    if (_orderEntity.sign_end == 150)
    {
        _cashImgView.hidden = NO;
    }
}

/**
 * 桌号(大厅 | 桌号)
 */
- (void)initWithTableNoLabel
{
    if (!_tableNoLabel)
    {
        CGRect frame = CGRectMake(15, 10, [[UIScreen mainScreen] screenWidth] / 2, 20);
        _tableNoLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE(20) labelTag:0 alignment:NSTextAlignmentLeft];
        //    _tableNoLabel.backgroundColor = [UIColor lightGrayColor];
    }
    
    
    CGFloat width = [_orderEntity.status_remark widthForFont:FONTSIZE_16];
    
    // 桌号(大厅 | 桌号)
    NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] init];
    UIColor *color = [UIColor colorWithHexString:@"#323232"];
    NSAttributedString *bTitle = nil;
    NSString *str = @"";
    NSString *type = @"即时";
    if (_orderEntity.type == 1)
    {
        type = @"预订";
    }
    str = [NSString stringWithFormat:@"%@ | %@ | ", objectNull(type), objectNull(_orderEntity.seat_type_name)];
    bTitle = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: FONTSIZE(18), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:bTitle];
    
    color = [UIColor colorWithHexString:@"#ff5500"];
    NSAttributedString *bValue = [[NSAttributedString alloc] initWithString:objectNull(_orderEntity.seat_number) attributes:@{NSFontAttributeName: FONTSIZE(18), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:bValue];
    _tableNoLabel.width =  [[UIScreen mainScreen] screenWidth] - 30 - 10 - width;
     _tableNoLabel.attributedText = mas;
    /*NSMutableAttributedString *mas = [NSMutableAttributedString new];
    NSString *str = @"预订 | ";
    if (_orderEntity.type == 2)
    {
        str = @"即时 | ";
    }
    NSAttributedString *bTitle = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: FONTSIZE(14), NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#ff5500"]}];
    [mas appendAttributedString:bTitle];
    NSAttributedString *value =  [self attributedTextTitle:@"订单编号：" value:objectNull(_orderEntity.order_id)];
    [mas appendAttributedString:value];
    _orderNoLabel.attributedText = mas;
    _tableNoLabel.attributedText = mas;
    _tableNoLabel.width =  [[UIScreen mainScreen] screenWidth] - 30 - 10 - width;
     */
}

/**
 * 订单状态类型
 */
- (void)initWithOrderStateLabel
{
    if (!_orderStateLabel)
    {
        NSString *str = @"未下单";
        CGFloat width = [str widthForFont:FONTSIZE_16];
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - 15 - width, 0, width, 20);
        _orderStateLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#00ce68"] fontSize:FONTSIZE_16 labelTag:0 alignment:NSTextAlignmentRight];
        _orderStateLabel.centerY = _tableNoLabel.centerY;
        //    _orderStateLabel.backgroundColor = [UIColor lightGrayColor];
    }

    if (_orderEntity.sign_end == 150)
    {// 异常订单
        _orderStateLabel.hidden = YES;
        /*NSString *str = [NSString stringWithFormat:@"%@-唐斌", _orderEntity.status_remark];
        CGFloat width = [str widthForFont:FONTSIZE_16];
        
        NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] init];
        UIColor *color = [UIColor colorWithHexString:@"#00ce68"];
        NSAttributedString *bTitle = [[NSAttributedString alloc] initWithString:objectNull(_orderEntity.status_remark) attributes:@{NSFontAttributeName:FONTSIZE_16, NSForegroundColorAttributeName: color}];
        [mas appendAttributedString:bTitle];
        
        str = [NSString stringWithFormat:@"-%@", objectNull(_orderEntity.sign_end_desc)];
        color = [UIColor colorWithHexString:@"#ff5500"];
        bTitle = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:FONTSIZE_12, NSForegroundColorAttributeName: color}];
        [mas appendAttributedString:bTitle];
        
        _orderStateLabel.attributedText = mas;
        _orderStateLabel.width = width;
        _orderStateLabel.right = [[UIScreen mainScreen] screenWidth] - 15;
         */
    }
    else
    {
        _orderStateLabel.hidden = NO;
    // 订单状态类型
        CGFloat width = [_orderEntity.status_remark widthForFont:FONTSIZE_16];
        _orderStateLabel.text = _orderEntity.status_remark;
        _orderStateLabel.width = width;
        _orderStateLabel.right = [[UIScreen mainScreen] screenWidth] - 15;
    }

}

/**
 * 订单号(预订 | 订单号)
 */
- (void)initWithOrderNoLabel
{
    if (!_orderNoLabel)
    {
        CGRect frame = CGRectMake(15, _tableNoLabel.bottom + 4, [[UIScreen mainScreen] screenWidth] - 30, 20);
        _orderNoLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
        //    _orderNoLabel.backgroundColor = [UIColor lightGrayColor];
    }
    // 订单号(预订 | 订单号)
    _orderNoLabel.attributedText = [self attributedTextTitle:@"订单编号：" value:objectNull(_orderEntity.order_id)];
}

/**
 * 姓名
 */
- (void)initWithNameLabel
{
    if (!_nameLabel)
    {
        CGRect frame = CGRectMake(15, _orderNoLabel.bottom + 4, [[UIScreen mainScreen] screenWidth] - 30, 20);
        _nameLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
        //    _nameLabel.backgroundColor = [UIColor lightGrayColor];
    }
    // 姓名
    _nameLabel.attributedText = [self attributedTextTitle:@"食客姓名：" value:objectNull(_orderEntity.customer_name)];
}

/**
 * 到店时间
 */
- (void)initWithArriveDateLabel
{
    if (!_arriveDateLabel)
    {
        CGRect frame = CGRectMake(15, _nameLabel.bottom + 4, [[UIScreen mainScreen] screenWidth] - 30, 20);
        _arriveDateLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
        //    _arriveDateLabel.backgroundColor = [UIColor lightGrayColor];
    }
    
    NSString *date = [NSDate stringWithDateInOut:_orderEntity.create_date inFormat:@"yyyy-MM-dd HH:mm:ss" outFormat:@"yyyy-MM-dd HH:mm"];
    _arriveDateLabel.attributedText = [self attributedTextTitle:@"到店时间：" value:date];
}

/**
 * 餐桌类型
 */
- (void)initWithTableTypeLabel
{
    if (!_tableTypeLabel)
    {
        CGRect frame = CGRectMake(15, _arriveDateLabel.bottom + 4, ([[UIScreen mainScreen] screenWidth] - 30) / 3 * 2, 20);
        _tableTypeLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
        //    _tableTypeLabel.backgroundColor = [UIColor lightGrayColor];
    }
    
    
    
    // 餐桌类型
    NSString *str = [NSString stringWithFormat:@"%d人桌", (int)_orderEntity.number];
    _tableTypeLabel.attributedText = [self attributedTextTitle:@"餐桌类型：" value:str];
}

/**
 * 查看订单
 */
- (void)initWithBtnLookOrder
{
    /*if (!_btnLookOrder)
    {
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - 15 - 75, 0, 75, 25);
        _btnLookOrder = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"查看订单" titleColor:[UIColor colorWithHexString:@"#ff5100"] titleFont:FONTSIZE_13 targetSel:@selector(clickedLook:)];
        _btnLookOrder.frame = frame;
        _btnLookOrder.layer.masksToBounds = YES;
        _btnLookOrder.layer.cornerRadius = 3.0;
        _btnLookOrder.layer.borderWidth = 1;
        _btnLookOrder.layer.borderColor = [UIColor colorWithHexString:@"#ff5100"].CGColor;
        [self.contentView addSubview:_btnLookOrder];
    }
    if (_orderEntity.type == 1)
    {
        _btnLookOrder.bottom = _tableTypeLabel.bottom;
    }
    else
    {
        _btnLookOrder.bottom = _arriveDateLabel.bottom;
    }*/
}

- (void)clickedLook:(id)sender
{
    if (self.baseTableViewCellBlock)
    {
        self.baseTableViewCellBlock(_orderEntity);
    }
}

- (NSAttributedString *)attributedTextTitle:(NSString *)title value:(NSString *)value
{
    NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] init];
    UIColor *color = [UIColor colorWithHexString:@"#666666"];
    NSAttributedString *bTitle = [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName: FONTSIZE(14), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:bTitle];
    
    color = [UIColor colorWithHexString:@"#323232"];
    NSAttributedString *bValue = [[NSAttributedString alloc] initWithString:value attributes:@{NSFontAttributeName: FONTSIZE(14), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:bValue];
    
    return mas;
}

+ (CGFloat)getWithCellHeight:(NSInteger)type
{
    CGFloat height = 0;
    if (type == 1)
    {// 预订
        height =136;
    }
    else
    {
        height = 136 - 20 - 4;
    }
    return height;

}


- (void)updateCellData:(id)cellEntity
{
    
    self.orderEntity = cellEntity;
    _orderEntity.status_remark = [UtilityObject dinersWithOrderState:_orderEntity.status];
    
    [self initWithCashImgView];
    
    // 桌号(大厅 | 桌号)
    [self initWithTableNoLabel];
    
    // 订单状态类型
    [self initWithOrderStateLabel];
    
    // 订单号(预订 | 订单号)
    [self initWithOrderNoLabel];
    
    // 姓名
    [self initWithNameLabel];
    
    // 到店时间
    [self initWithArriveDateLabel];
    
    if (_orderEntity.type == 1)
    {
        // 餐桌类型
        [self initWithTableTypeLabel];
        _tableTypeLabel.hidden = NO;
    }
    else
    {
        _tableTypeLabel.hidden = YES;
    }
    
    // 查看订单
    [self initWithBtnLookOrder];

    
    

}

@end















