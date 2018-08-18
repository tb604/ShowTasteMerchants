//
//  MyWalletDetailViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/19.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyWalletDetailViewCell.h"
#import "LocalCommon.h"
#import "MyWalletConsumeEntity.h"

@interface MyWalletDetailViewCell ()
{
    UILabel *_titleLabel;
    
    UILabel *_dateLabel;
    
    UILabel *_moneyLabel;
    
}

@property (nonatomic, strong) MyWalletConsumeEntity *consumeEnt;

- (void)initWithTitleLabel;

- (void)initWithDateLabel;

- (void)initWithMoneyLabel;

@end

@implementation MyWalletDetailViewCell

- (void)initWithVarCell
{
    [super initWithVarCell];
    
}

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        CGRect frame = CGRectMake(15, 8, 100, 15);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE(15) labelTag:0 alignment:NSTextAlignmentLeft];
    }
    _titleLabel.text = _consumeEnt.type_desc;
}

- (void)initWithDateLabel
{
    if (!_dateLabel)
    {
        CGRect frame = CGRectMake(15, 8, [[UIScreen mainScreen] screenWidth] / 2, 15);
        _dateLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE(12) labelTag:0 alignment:NSTextAlignmentLeft];
        _dateLabel.top = _titleLabel.bottom + 4;
    }
//    NSDate *date = [NSDate date];
//    NSString *strDate = [date stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *sdate = [NSDate stringWithDateInOut:_consumeEnt.create_datetime inFormat:@"yyyy-MM-dd HH:mm:ss" outFormat:@"yyyy-MM-dd HH:mm"];
    _dateLabel.text = sdate;
}

- (void)initWithMoneyLabel
{
    if (!_moneyLabel)
    {
        CGRect frame = CGRectMake(0, (kMyWalletDetailViewCellHeight - 20)/2, [[UIScreen mainScreen] screenWidth] / 2 - 30, 20);
        _moneyLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE(18) labelTag:0 alignment:NSTextAlignmentRight];
        _moneyLabel.right = [[UIScreen mainScreen] screenWidth] - 15;
    }
    if (_consumeEnt.category == 1)
    {// 收入
        _moneyLabel.text = [NSString stringWithFormat:@"+%.2f", _consumeEnt.money];
    }
    else if (_consumeEnt.category == 2)
    {// 支出
        _moneyLabel.text = [NSString stringWithFormat:@"-%.2f", _consumeEnt.money];
    }
}

- (void)updateCellData:(id)cellEntity
{
    self.consumeEnt = cellEntity;
    
    [self initWithTitleLabel];
    
    [self initWithDateLabel];
    
    [self initWithMoneyLabel];
}

@end





















