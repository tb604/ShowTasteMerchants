//
//  MyRestaurantRoomSpaceEditViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/2.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantRoomSpaceEditViewCell.h"
#import "LocalCommon.h"
#import "ShopSeatInfoEntity.h"

@interface MyRestaurantRoomSpaceEditViewCell ()
{
    UILabel *_seatNameLabel;
    
    UILabel *_seatRemarkLabel;
}
@property (nonatomic, strong) CALayer *line;

@property (nonatomic, strong) ShopSeatInfoEntity *seatEntity;


- (void)initWithSeatNameLabel;

- (void)initWithSeatRemarkLabel;

@end

@implementation MyRestaurantRoomSpaceEditViewCell

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    
    
    CALayer *line = [CALayer drawLine:self.contentView frame:CGRectMake(0, 50, [[UIScreen mainScreen] screenWidth], 0.6) lineColor:[UIColor colorWithHexString:@"#e1e1e1"]];
    self.line = line;
    
    
}


- (void)initWithSeatNameLabel
{
    if (!_seatNameLabel)
    {
        CGRect frame = CGRectMake(15, (_line.top - 20)/2, [[UIScreen mainScreen] screenWidth] - 30, 20);
        _seatNameLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
//        _seatNameLabel.backgroundColor = [UIColor lightGrayColor];
    }
    
    _seatNameLabel.attributedText = [self attributedTextTitle:@"空间名称：" value:objectNull(_seatEntity.name) valueFont:FONTSIZE(18)];
    
    
}

- (void)initWithSeatRemarkLabel
{
    if (!_seatRemarkLabel)
    {
        CGRect frame = CGRectMake(15, (kMyRestaurantRoomSpaceEditViewCellHeight - _line.top - 20)/2 + _line.top, [[UIScreen mainScreen] screenWidth] - 30, 20);
        _seatRemarkLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
//        _seatRemarkLabel.backgroundColor = [UIColor lightGrayColor];
    }
    
    _seatRemarkLabel.attributedText = [self attributedTextTitle:@"预订要求：" value:objectNull(_seatEntity.remark) valueFont:FONTSIZE(15)];
}

- (NSAttributedString *)attributedTextTitle:(NSString *)title value:(NSString *)value valueFont:(UIFont *)valueFont
{
    NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] init];
    UIColor *color = [UIColor colorWithHexString:@"#999999"];
    NSAttributedString *bTitle = [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName: FONTSIZE(13), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:bTitle];
    
    color = [UIColor colorWithHexString:@"#323232"];
    NSAttributedString *bValue = [[NSAttributedString alloc] initWithString:value attributes:@{NSFontAttributeName: valueFont, NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:bValue];
    
    return mas;
}

- (void)updateCellData:(id)cellEntity
{
    self.seatEntity = cellEntity;
    
    [self initWithSeatNameLabel];
    
    [self initWithSeatRemarkLabel];
}

@end















