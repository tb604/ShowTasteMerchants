//
//  DeliveryCancelOrderOtherReasonCell.m
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DeliveryCancelOrderOtherReasonCell.h"
#import "LocalCommon.h"
#import "HungryOrderDetailEntity.h"
#import "TYZPlaceholderTextView.h"

@interface DeliveryCancelOrderOtherReasonCell () 
{
    UILabel *_orderIdLabel;
    
}



@property (nonatomic, strong) HungryOrderDetailEntity *orderDetailEntity;


- (void)initWithOrderIdLabel;

- (void)initWithReasonTxtView;

@end

@implementation DeliveryCancelOrderOtherReasonCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    
}

- (void)initWithOrderIdLabel
{
    if (!_orderIdLabel)
    {
        CGRect frame = CGRectMake(10, 0, [[UIScreen mainScreen] screenWidth] - 20, 30);
        _orderIdLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"646464"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    _orderIdLabel.text = [NSString stringWithFormat:@"订单号：%lld", (long long)_orderDetailEntity.order_id];
}

- (void)initWithReasonTxtView
{
    if (!_reasonTxtView)
    {
        CGRect frame = CGRectMake(0, _orderIdLabel.bottom, [[UIScreen mainScreen] screenWidth], kDeliveryCancelOrderOtherReasonCellHeight - _orderIdLabel.height);
        _reasonTxtView = [[TYZPlaceholderTextView alloc] initWithFrame:frame];
        _reasonTxtView.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
//        _reasonTxtView.delegate = self;
        _reasonTxtView.placeholder = @"请输入拒单原因(必填)";
        _reasonTxtView.font = FONTSIZE_15;
        _reasonTxtView.textColor = [UIColor colorWithHexString:@"#323232"];
        _reasonTxtView.returnKeyType = UIReturnKeyDone;
        _reasonTxtView.keyboardType = UIKeyboardAppearanceDefault;
        [self.contentView addSubview:_reasonTxtView];
    }
}

- (void)updateCellData:(id)cellEntity
{
    self.orderDetailEntity = cellEntity;
    
    [self initWithOrderIdLabel];
    
    [self initWithReasonTxtView];
    
}

@end











