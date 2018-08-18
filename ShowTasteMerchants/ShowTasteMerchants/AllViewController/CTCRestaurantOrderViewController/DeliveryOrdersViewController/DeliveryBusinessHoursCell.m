//
//  DeliveryBusinessHoursCell.m
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DeliveryBusinessHoursCell.h"
#import "LocalCommon.h"
#import "CellCommonDataEntity.h"

@interface DeliveryBusinessHoursCell ()
{
    UILabel *_startTimeLabel;
    
    UILabel *_endTimeLabel;
}

@property (nonatomic, strong) CALayer *line;

@property (nonatomic, strong)CellCommonDataEntity *cellEntity;

- (void)initWithStartTimeLabel;

- (void)initWithEndTimeLabel;

@end

@implementation DeliveryBusinessHoursCell

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
    
    [CALayer drawLine:self.contentView frame:CGRectMake(10, kDeliveryBusinessHoursCellHeight-0.5, [[UIScreen mainScreen] screenWidth] - 20, 0.5) lineColor:[UIColor colorWithHexString:@"#e0e0e0"]];
    
    CALayer *line = [CALayer drawLine:self.contentView frame:CGRectMake(0, (kDeliveryBusinessHoursCellHeight-1)/2., 10, 1) lineColor:[UIColor colorWithHexString:@"#cbcbcb"]];
    line.centerX = [[UIScreen mainScreen] screenWidth] / 2.;
    self.line = line;
    
}

- (void)initWithStartTimeLabel
{
    if (!_startTimeLabel)
    {
        CGRect frame = CGRectMake(10, (kDeliveryBusinessHoursCellHeight-20)/2., _line.left - 20, 20);
        _startTimeLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentCenter];
        _startTimeLabel.userInteractionEnabled = YES;
        __weak typeof(self)weakSelf = self;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
            if (weakSelf.uploadTimeBlock)
            {
                weakSelf.uploadTimeBlock(weakSelf.cellEntity, 1);
            }
        }];
        [_startTimeLabel addGestureRecognizer:tap];
    }
    NSString *str = nil;
    if ([objectNull(_cellEntity.title) isEqualToString:@""])
    {
        str = @"选择开始时间";
    }
    else
    {
        str = _cellEntity.title;
    }
    _startTimeLabel.text = str;
}

- (void)initWithEndTimeLabel
{
    if (!_endTimeLabel)
    {
        CGRect frame = _startTimeLabel.frame;
        frame.origin.x = _line.right + 10;
        _endTimeLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentCenter];
        _endTimeLabel.userInteractionEnabled = YES;
        __weak typeof(self)weakSelf = self;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
            if (weakSelf.uploadTimeBlock)
            {
                weakSelf.uploadTimeBlock(weakSelf.cellEntity, 2);
            }
        }];
        [_endTimeLabel addGestureRecognizer:tap];
    }
    NSString *str = nil;
    if ([objectNull(_cellEntity.subTitle) isEqualToString:@""])
    {
        str = @"选择开始时间";
    }
    else
    {
        str = _cellEntity.subTitle;
    }
    _endTimeLabel.text = str;
}

- (void)updateCellData:(id)cellEntity
{
    self.cellEntity = cellEntity;
    
    [self initWithStartTimeLabel];
    
    [self initWithEndTimeLabel];
}

@end











