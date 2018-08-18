//
//  DeliveryCancelOrderFooterView.m
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DeliveryCancelOrderFooterView.h"
#import "LocalCommon.h"

@interface DeliveryCancelOrderFooterView ()
{
    UILabel *_titleLabel;
}

- (void)initWithTitleLabel;

@end

@implementation DeliveryCancelOrderFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        NSString *str = @"随意取消订单会影响用户体验，并对餐厅声誉造成负面影响，建议操作前，先与用户电话取得联系。";
        float height = [str heightForFont:FONTSIZE_12 width:[[UIScreen mainScreen] screenWidth] - 20];
        CGRect frame = CGRectMake(10, 8, [[UIScreen mainScreen] screenWidth], height);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
        _titleLabel.numberOfLines = 0;
        _titleLabel.text = str;
        
        self.height = kDeliveryCancelOrderFooterViewHeight - 32 + height;
        
    }
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithTitleLabel];
    
}

@end















