//
//  MyFinanceWeekOrderNumViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/7.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyFinanceWeekOrderNumViewCell.h"
#import "LocalCommon.h"

@interface MyFinanceWeekOrderNumViewCell ()
{
    UIImageView *_thanImgView;
    
    /**
     *  日期时段
     */
    UILabel *_dateLabel;
    
    /**
     *  订单数量
     */
    UILabel *_orderNumLabel;
}

- (void)initWithThanImgView;

- (void)initWithDateLabel;

- (void)initWithOrderNumLabel;

@end

@implementation MyFinanceWeekOrderNumViewCell

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
    
    [self initWithThanImgView];
    
    [self initWithDateLabel];
    
    [self initWithOrderNumLabel];
}

- (void)initWithThanImgView
{
    if (!_thanImgView)
    {
        UIImage *image = [UIImage imageNamed:@"finance_btn_tiao"];
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - 15 - image.size.width, 20, image.size.width, image.size.height);
        _thanImgView = [[UIImageView alloc] initWithFrame:frame];
        _thanImgView.image = image;
        [self.contentView addSubview:_thanImgView];
    }
}

- (void)initWithDateLabel
{
    if (!_dateLabel)
    {
        CGRect frame = CGRectMake(15, 0, _thanImgView.left - 15 - 15, 20);
        _dateLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE(24) labelTag:0 alignment:NSTextAlignmentLeft];
        _dateLabel.centerY = _thanImgView.centerY;
    }
}

- (void)initWithOrderNumLabel
{
    if (!_orderNumLabel)
    {
        CGRect frame = _dateLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 15;
        _orderNumLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE(15) labelTag:0 alignment:NSTextAlignmentLeft];
    }
}

- (void)updateCellData:(id)cellEntity
{
    
    //
    _dateLabel.text = @"08/22~08/28";
    
    // 订单数量
    _orderNumLabel.text = [NSString stringWithFormat:@"共%d单", 234];
    
}

@end




















