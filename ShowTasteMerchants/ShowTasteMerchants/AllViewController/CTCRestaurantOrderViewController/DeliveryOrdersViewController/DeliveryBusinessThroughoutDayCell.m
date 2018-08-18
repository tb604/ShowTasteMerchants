//
//  DeliveryBusinessThroughoutDayCell.m
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DeliveryBusinessThroughoutDayCell.h"
#import "LocalCommon.h"
#import "CellCommonDataEntity.h"

@interface DeliveryBusinessThroughoutDayCell ()
{
    UISwitch *_switch;
    UILabel *_titleLabel;
}

@property (nonatomic, strong) CellCommonDataEntity *cellEntity;

- (void)initWithSwitch;

- (void)initWithTitleLabel;

@end

@implementation DeliveryBusinessThroughoutDayCell

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

- (void)initWithSwitch
{
    if (!_switch)
    {
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - 10 - 100, (kDeliveryBusinessThroughoutDayCellHeight-28)/2., 100, 28);
        _switch = [[UISwitch alloc] initWithFrame:frame];
        _switch.right = [[UIScreen mainScreen] screenWidth] - 10;
//        _switch.centerY = _titleLabel.centerY;
        [_switch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_switch];
    }
    _switch.on = _cellEntity.isCheck;
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        CGRect frame = CGRectMake(10, (kDeliveryBusinessThroughoutDayCellHeight-20)/2., _switch.left - 20, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    _titleLabel.text = _cellEntity.title;
}

- (void)switchAction:(id)sender
{
    UISwitch *onSwitch = (UISwitch *)sender;
    //    debugLog(@"on=%d", onSwitch.on);
    _cellEntity.isCheck = onSwitch.on;
    if (self.baseTableViewCellBlock)
    {
        self.baseTableViewCellBlock(_cellEntity);
    }
}

- (void)updateCellData:(id)cellEntity
{
    self.cellEntity = cellEntity;
    
    [self initWithSwitch];
    
    [self initWithTitleLabel];
}

@end
