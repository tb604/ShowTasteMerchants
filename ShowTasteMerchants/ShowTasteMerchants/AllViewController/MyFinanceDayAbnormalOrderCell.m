//
//  MyFinanceDayAbnormalOrderCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/7.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyFinanceDayAbnormalOrderCell.h"
#import "LocalCommon.h"

@interface MyFinanceDayAbnormalOrderCell ()
{
    UILabel *_titleLabel;
    
    UIImageView *_thanImgView;
    
    /**
     *  异常订单数量
     */
    UILabel *_abnormalNumLabel;
}

- (void)initWithTitleLabel;

- (void)initWithThanImgView;

- (void)initWithAbnormalNumLabel;

@end

@implementation MyFinanceDayAbnormalOrderCell

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
    
    [CALayer drawLine:self.contentView frame:CGRectMake(0, kMyFinanceDayAbnormalOrderCellHeight, [[UIScreen mainScreen] screenWidth], 0.6) lineColor:[UIColor colorWithHexString:@"#e1e1e1"]];
    
    [self initWithTitleLabel];
    
    [self initWithThanImgView];
    
    [self initWithAbnormalNumLabel];
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        NSString *str = @"异常订单";
        float width = [str widthForFont:FONTSIZE_15];
        CGRect frame = CGRectMake(15, (kMyFinanceDayAbnormalOrderCellHeight - 20)/2, width, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
        _titleLabel.text = str;
    }
}

- (void)initWithThanImgView
{
    if (!_thanImgView)
    {
        UIImage *image = [UIImage imageNamed:@"finance_btn_xiala"];
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - 15 - image.size.width, (kMyFinanceDayAbnormalOrderCellHeight-image.size.height)/2, image.size.width, image.size.height);
        _thanImgView = [[UIImageView alloc] initWithFrame:frame];
        _thanImgView.image = image;
        [self.contentView addSubview:_thanImgView];
    }
}

- (void)initWithAbnormalNumLabel
{
    if (!_abnormalNumLabel)
    {
        CGRect frame = CGRectMake(_titleLabel.right + 10, (kMyFinanceDayAbnormalOrderCellHeight-20)/2, _thanImgView.left - _titleLabel.right - 10 - 10 , 20);
        _abnormalNumLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_16 labelTag:0 alignment:NSTextAlignmentRight];
    }
}

- (void)updateCellData:(id)cellEntity
{
    NSInteger count = [cellEntity integerValue];
    _abnormalNumLabel.text = [NSString stringWithFormat:@"%d单", (int)count];
}

@end
