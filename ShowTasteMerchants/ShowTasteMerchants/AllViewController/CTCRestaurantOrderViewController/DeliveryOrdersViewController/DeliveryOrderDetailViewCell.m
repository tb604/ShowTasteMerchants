//
//  DeliveryOrderDetailViewCell.m
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/18.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DeliveryOrderDetailViewCell.h"
#import "LocalCommon.h"
#import "HungryOrderDetailEntity.h"

@interface DeliveryOrderDetailViewCell ()
{
    /// 下单时间
    UILabel *_placeOrderTimeLabel;
    
    /// 期望时间
    UILabel *_deliverTimeLabel;
    
    /// 商品总计金额
    UILabel *_originalPriceLabel;
    
    /// 立减优惠
    UILabel *_preferentialFeeLabel;
    
    /// 包装费
    UILabel *_packageFeeLabel;
    
    /// 配送费
    UILabel *_deliverFeeLabel;
    
    /// 订单总计
    UILabel *_totalPriceLabel;
}

@property (nonatomic, strong) NSMutableArray *labelList;

@property (nonatomic, strong) HungryOrderDetailEntity *orderDetailEntity;


/**
 *  下单时间
 */
- (void)initWithPlaceOrderTimeLabel;

/**
 *  期望时间
 */
- (void)initWithDeliverTimeLabel;

/**
 *  商品总计金额
 */
- (void)initWithOriginalPriceLabel;

/**
 *  立减优惠
 */
- (void)initWithPreferentialFeeLabel;

/**
 *  包装费
 */
- (void)initWithPackageFeeLabel;

/**
 *  配送费
 */
- (void)initWithDeliverFeeLabel;

/**
 *  订单总计
 */
- (void)initWithTotalPriceLabel;

@end

@implementation DeliveryOrderDetailViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithVarCell
{
    [super initWithVarCell];
    
    _labelList = [NSMutableArray new];
}

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor redColor];
    
}

/**
 *  下单时间
 */
- (void)initWithPlaceOrderTimeLabel
{
    if (!_placeOrderTimeLabel)
    {
        CGRect frame = CGRectMake(10, 8, [[UIScreen mainScreen] screenWidth] - 20, 16);
        _placeOrderTimeLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    NSString *payDate = [NSDate stringWithDateInOut:objectNull(_orderDetailEntity.created_at) inFormat:@"yyyy-MM-dd HH:mm:ss" outFormat:@"yyyy-MM-dd HH:mm"];
    _placeOrderTimeLabel.text = [NSString stringWithFormat:@"下单时间：%@", payDate];
}

/**
 *  期望时间
 */
- (void)initWithDeliverTimeLabel
{
    if (!_deliverTimeLabel)
    {
        CGRect frame = _placeOrderTimeLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _deliverTimeLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    NSString *payDate = [NSDate stringWithDateInOut:objectNull(_orderDetailEntity.deliver_time) inFormat:@"yyyy-MM-dd HH:mm:ss" outFormat:@"yyyy-MM-dd HH:mm"];
    _deliverTimeLabel.text = [NSString stringWithFormat:@"期望时间：%@", payDate];
}

/**
 *  商品总计金额
 */
- (void)initWithOriginalPriceLabel
{
    if (!_originalPriceLabel)
    {
        CGRect frame = _deliverTimeLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _originalPriceLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    _originalPriceLabel.text = [NSString stringWithFormat:@"商品总计：￥%.2f", _orderDetailEntity.original_price];
}

/**
 *  立减优惠
 */
- (void)initWithPreferentialFeeLabel
{
    if (!_preferentialFeeLabel)
    {
        CGRect frame = _originalPriceLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _preferentialFeeLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    _preferentialFeeLabel.text = [NSString stringWithFormat:@"立减优惠：%.2f", 2.0];
}

/**
 *  包装费
 */
- (void)initWithPackageFeeLabel
{
    if (!_packageFeeLabel)
    {
        CGRect frame = _preferentialFeeLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _packageFeeLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    _packageFeeLabel.text = [NSString stringWithFormat:@"包  装 费：%.2f", _orderDetailEntity.package_fee];
}

/**
 *  配送费
 */
- (void)initWithDeliverFeeLabel
{
    if (!_deliverFeeLabel)
    {
        CGRect frame = _packageFeeLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _deliverFeeLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    _deliverFeeLabel.text = [NSString stringWithFormat:@"配  送 费：%.2f", _orderDetailEntity.deliver_fee];
}

/**
 *  订单总计
 */
- (void)initWithTotalPriceLabel
{
    if (!_totalPriceLabel)
    {
        CGRect frame = _deliverFeeLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 4;
        _totalPriceLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    _totalPriceLabel.text = [NSString stringWithFormat:@"订单总计：%.2f", _orderDetailEntity.total_price];
}


- (void)updateCellData:(id)cellEntity
{
    NSArray *list = cellEntity;
    CGRect frame = CGRectMake(10, 0, [[UIScreen mainScreen] screenWidth] - 20, 16);
    
    for (UILabel *label in _labelList)
    {
        label.hidden = YES;
    }
    
    NSInteger count = list.count;
    NSInteger labelcount = _labelList.count;
    for (NSInteger i=0; i<count; i++)
    {
        HungryOrderDetailCategoryExtraEntity *extEnt = list[i];
        if (i != 0)
        {
            frame.origin.y = frame.origin.y + frame.size.height + 4;
        }
        UILabel *label = nil;
        if (i < labelcount)
        {
            label = _labelList[i];
            label.frame = frame;
        }
        else
        {
            label = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
            [_labelList addObject:label];
        }
        label.hidden = NO;
        label.text = [NSString stringWithFormat:@"%@：%.2f", extEnt.name, extEnt.price];
    }
    
}


@end
