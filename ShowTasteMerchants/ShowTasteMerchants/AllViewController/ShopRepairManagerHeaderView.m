//
//  ShopRepairManagerHeaderView.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/6.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopRepairManagerHeaderView.h"
#import "LocalCommon.h"
#import "OrderDetailDataEntity.h"
#import "CTCMealOrderDetailsEntity.h"

@interface ShopRepairManagerHeaderView ()
{
    /**
     *  空间、桌号
     */
    UILabel *_locationLabel;
    
    /**
     *  订单编号
     */
    UILabel *_orderNoLabel;
}

@property (nonatomic, strong) CTCMealOrderDetailsEntity *orderEntity;


- (void)initWithLocationLabel;

- (void)initWithOrderNoLabel;


@end

@implementation ShopRepairManagerHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor whiteColor];
    
}

- (void)initWithLocationLabel
{
    if (!_locationLabel)
    {
        CGRect frame = CGRectMake(15, 20, [[UIScreen mainScreen] screenWidth] - 30, 20);
        _locationLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE(24) labelTag:0 alignment:NSTextAlignmentLeft];
    }
    NSMutableString *mutStr = [NSMutableString new];
//    _orderEntity.seat_typ
    [mutStr appendString:objectNull(_orderEntity.seat_type_desc)];
    if ([mutStr length] > 0)
    {
        [mutStr appendFormat:@" | %@", objectNull(_orderEntity.seat_number)];
    }
    else
    {
        [mutStr appendFormat:@"%@", objectNull(_orderEntity.seat_number)];
    }
    _locationLabel.text = mutStr;
}

- (void)initWithOrderNoLabel
{
    if (!_orderNoLabel)
    {
        CGRect frame = _locationLabel.frame;
        frame.origin.y = _locationLabel.bottom + 10;
        frame.size.height = 18;
        _orderNoLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE(13) labelTag:0 alignment:NSTextAlignmentLeft];
    }
    
    _orderNoLabel.text = [NSString stringWithFormat:@"订单编号：%@", _orderEntity.order_id];
}

- (void)updateViewData:(id)entity
{
    self.orderEntity = entity;
    
//    debugLog(@"en=%@", [_orderEntity modelToJSONString]);
    
    [self initWithLocationLabel];
    
    [self initWithOrderNoLabel];
}

@end






