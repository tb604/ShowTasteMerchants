//
//  MyRestaurantRoomSpaceViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/2.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantRoomSpaceViewCell.h"
#import "LocalCommon.h"
#import "ShopSeatInfoEntity.h"

@interface MyRestaurantRoomSpaceViewCell ()
{
    UILabel *_seatNameLabel;
    
    UILabel *_remarkLabel;
}

@property (nonatomic, strong) ShopSeatInfoEntity *seatEntity;

- (void)initWithSeatNameLabel;

- (void)initWithRemarkLabel;

@end

@implementation MyRestaurantRoomSpaceViewCell

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    
}

- (void)initWithSeatNameLabel
{
    if (!_seatNameLabel)
    {
        CGRect frame = CGRectMake(15, (50-20)/2, [[UIScreen mainScreen] screenWidth] - 30, 30);
        _seatNameLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE(24) labelTag:0 alignment:NSTextAlignmentLeft];
//        _seatNameLabel.backgroundColor = [UIColor lightGrayColor];
    }
    _seatNameLabel.text = _seatEntity.name;
}

- (void)initWithRemarkLabel
{
    if (!_remarkLabel)
    {
        CGRect frame = _seatNameLabel.frame;
        frame.size.height = 20;
        frame.origin.y = _seatNameLabel.bottom + 10;
        _remarkLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE(15) labelTag:0 alignment:NSTextAlignmentLeft];
//        _remarkLabel.backgroundColor = [UIColor lightGrayColor];
    }
    _remarkLabel.text = _seatEntity.remark;
}

- (void)updateCellData:(id)cellEntity
{
    self.seatEntity = cellEntity;
    
    [self initWithSeatNameLabel];
    
    [self initWithRemarkLabel];
}

@end


























