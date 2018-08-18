//
//  DeliverySettingsBaseCell.m
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/17.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DeliverySettingsBaseCell.h"
#import "LocalCommon.h"
#import "CellCommonDataEntity.h"

@interface DeliverySettingsBaseCell ()
{
    UIImageView *_thumalImgView;
    
    UILabel *_titleLabel;
    
    UIImageView *_thanImgView;
    
    UILabel *_valueLabel;
    
}
@property (nonatomic, strong) CALayer *bottomeLine;

@property (nonatomic, strong) CellCommonDataEntity *cellEntity;

- (void)initWithThumalImgView;

- (void)initWithTitleLabel;

- (void)initWithThanImgView;

- (void)initWithValueLabel;

@end

@implementation DeliverySettingsBaseCell

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
    
    CALayer *line = [CALayer drawLine:self.contentView frame:CGRectMake(10+20+10, kDeliverySettingsBaseCellHeight - 0.5, [[UIScreen mainScreen] screenWidth] - 40, 0.5) lineColor:[UIColor colorWithHexString:@"#e0e0e0"]];
    self.bottomeLine = line;
    
}

- (void)initWithThumalImgView
{
    if (!_thumalImgView)
    {
        CGRect frame = CGRectMake(10, (kDeliverySettingsBaseCellHeight-20)/2., 20, 20);
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
        CGRect frame = CGRectMake(_thumalImgView.right + 10, (kDeliverySettingsBaseCellHeight-20)/2., width, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    _titleLabel.text = _cellEntity.title;
}

- (void)initWithThanImgView
{
    if (!_thanImgView)
    {
        UIImage *image = [UIImage imageWithContentsOfFileName:@"home_inform_btn_more.png"];
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - 10 - image.size.width, (kDeliverySettingsBaseCellHeight-image.size.height)/2., image.size.width, image.size.height);
        _thanImgView = [[UIImageView alloc] initWithFrame:frame];
        _thanImgView.image = image;
        [self.contentView addSubview:_thanImgView];
    }
}

- (void)initWithValueLabel
{
    if (!_valueLabel)
    {
        CGRect frame = CGRectMake(_titleLabel.right + 10, _titleLabel.origin.y, _thanImgView.left - _titleLabel.right - 20, 20);
        _valueLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentRight];
    }
    
    if (![objectNull(_cellEntity.subTitle) isEqualToString:@""])
    {
        _valueLabel.text = _cellEntity.subTitle;
        _valueLabel.textColor = [UIColor colorWithHexString:@"#323232"];
    }
    else
    {
        NSString *placeholder = objectNull(_cellEntity.placeholder);
        if (![placeholder isEqualToString:@""])
        {
            _valueLabel.text = placeholder;
            _valueLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        }
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
    
    [self initWithThanImgView];
    
    [self initWithValueLabel];
}

@end
