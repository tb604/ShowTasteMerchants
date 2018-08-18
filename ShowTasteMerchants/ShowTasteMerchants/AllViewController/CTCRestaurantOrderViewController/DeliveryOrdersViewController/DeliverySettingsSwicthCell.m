//
//  DeliverySettingsSwicthCell.m
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/17.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DeliverySettingsSwicthCell.h"
#import "LocalCommon.h"
#import "CellCommonDataEntity.h"

@interface DeliverySettingsSwicthCell ()
{
    UIImageView *_thumalImgView;
    
    UILabel *_titleLabel;
    
    UISwitch *_switch;
}
@property (nonatomic, strong) CALayer *bottomeLine;

@property (nonatomic, strong) CellCommonDataEntity *cellEntity;

- (void)initWithThumalImgView;

- (void)initWithTitleLabel;

- (void)initWithSwitch;

@end

@implementation DeliverySettingsSwicthCell

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
    
    CALayer *line = [CALayer drawLine:self.contentView frame:CGRectMake(10+20+10, kDeliverySettingsSwicthCellHeight - 0.5, [[UIScreen mainScreen] screenWidth] - 40, 0.5) lineColor:[UIColor colorWithHexString:@"#e0e0e0"]];
    self.bottomeLine = line;
    
}

- (void)initWithThumalImgView
{
    if (!_thumalImgView)
    {
        CGRect frame = CGRectMake(10, (kDeliverySettingsSwicthCellHeight-20)/2., 20, 20);
        _thumalImgView = [[UIImageView alloc] initWithFrame:frame];
        [self.contentView addSubview:_thumalImgView];
    }
    UIImage *image = [UIImage imageWithContentsOfFileName:_cellEntity.thumalImgName];
    _thumalImgView.image = image;
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        NSString *str = @"莫永梅好嘛";
        float width = [str widthForFont:FONTSIZE_15];
        CGRect frame = CGRectMake(_thumalImgView.right + 10, (kDeliverySettingsSwicthCellHeight-20)/2., width, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    _titleLabel.text = _cellEntity.title;
}

- (void)initWithSwitch
{
    if (!_switch)
    {
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - 10 - 100, 0, 100, 28);
        _switch = [[UISwitch alloc] initWithFrame:frame];
        _switch.right = [[UIScreen mainScreen] screenWidth] - 10;
        _switch.centerY = _titleLabel.centerY;
        [_switch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_switch];
    }
    _switch.on = _cellEntity.isCheck;
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

- (void)hiddenBottomLine:(BOOL)hidden
{
    self.bottomeLine.hidden = hidden;
    
}

- (void)updateCellData:(id)cellEntity
{
    self.cellEntity = cellEntity;
    
    [self initWithThumalImgView];
    
    [self initWithTitleLabel];
    
    [self initWithSwitch];
}

@end
