//
//  DeliveryBusinessAddHoursCell.m
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DeliveryBusinessAddHoursCell.h"
#import "LocalCommon.h"

@interface DeliveryBusinessAddHoursCell ()
{
    UILabel *_titleLabel;
}

- (void)initWithTitleLabel;

@end

@implementation DeliveryBusinessAddHoursCell

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
    
    [self initWithTitleLabel];
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        CGRect frame = CGRectMake(10,(kDeliveryBusinessAddHoursCellHeight-20)/2., [[UIScreen mainScreen] screenWidth] - 20, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
        _titleLabel.text = @"添加营业时间";
    }
}

@end
