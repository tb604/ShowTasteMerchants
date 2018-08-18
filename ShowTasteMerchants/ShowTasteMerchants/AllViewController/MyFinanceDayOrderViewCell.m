//
//  MyFinanceDayOrderViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/7.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyFinanceDayOrderViewCell.h"
#import "LocalCommon.h"

@interface MyFinanceDayOrderViewCell ()
{
    /**
     *  金额
     */
    UILabel *_amountLabel;
    
    UILabel *_nameLabel;
    
    /**
     *  状态
     */
    UILabel *_stateLabel;
    
}

- (void)initWithAmountLabel;

- (void)initWithNameLabel;

- (void)initWithStateLabel;

@end

@implementation MyFinanceDayOrderViewCell

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
    
    self.backgroundView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    
    [CALayer drawLine:self.contentView frame:CGRectMake(15, kMyFinanceDayOrderViewCellHeight, [[UIScreen mainScreen] screenWidth] - 30, 0.6) lineColor:[UIColor colorWithHexString:@"#e1e1e1"]];
    
    [self initWithAmountLabel];
    
    [self initWithNameLabel];
    
    [self initWithStateLabel];
}

- (void)initWithAmountLabel
{
    if (!_amountLabel)
    {
        NSString *str = @"￥1234.12";
        float width = [str widthForFont:FONTSIZE_16];
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - 15 - width, (kMyFinanceDayOrderViewCellHeight-20)/2, width, 20);
        _amountLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_16 labelTag:0 alignment:NSTextAlignmentRight];
    }
}

- (void)initWithNameLabel
{
    if (!_nameLabel)
    {
        CGRect frame = CGRectMake(15, 10, _amountLabel.left - 10 - 15, 20);
        _nameLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
        _nameLabel.text = @"对方是否";
    }
}

- (void)initWithStateLabel
{
    if (!_stateLabel)
    {
        CGRect frame = _nameLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 3;
        _stateLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
        _stateLabel.text = @"异常";
    }
}

- (void)updateCellData:(id)cellEntity
{
    MyFinanceTodayExpListEntity *expOrderEnt = cellEntity;
    
    NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] init];
    UIColor *color = [UIColor colorWithHexString:@"#323232"];
    NSAttributedString *bTitle = [[NSAttributedString alloc] initWithString:objectNull(expOrderEnt.user_name) attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:bTitle];
    
    color = [UIColor colorWithHexString:@"#646464"];
    NSString *str = [NSString stringWithFormat:@"（%@）", expOrderEnt.order_id];
    bTitle = [[NSAttributedString alloc] initWithString:objectNull(str) attributes:@{NSFontAttributeName: FONTSIZE(12), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:bTitle];
    _nameLabel.attributedText = mas;
    
    _amountLabel.text = [NSString stringWithFormat:@"￥%.2f", expOrderEnt.total_amount];
}

@end






















