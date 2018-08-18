//
//  MySettingsViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/29.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MySettingsViewCell.h"
#import "LocalCommon.h"
#import "CellCommonDataEntity.h"

@interface MySettingsViewCell ()
{
    CGFloat _titleWidth;
    
    UILabel *_titleLabel;
    
    UILabel *_valueLabel;
    
    UIImageView *_thumalImgView;
}
@property (nonatomic, assign) NSInteger cellType;

@property (nonatomic, strong) CellCommonDataEntity *commonEntity;

- (void)initWithTitleLabel;

- (void)initWithValueLabel;

- (void)initWithThumalImgView;

@end

@implementation MySettingsViewCell

- (void)initWithVarCell
{
    [super initWithVarCell];
    
    NSString *str = @"手机号绑定";
    _titleWidth = [str widthForFont:FONTSIZE_15];
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
        CGRect frame = CGRectMake(15, (kMySettingsViewCellHeight-20)/2, _titleWidth, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    _titleLabel.text = _commonEntity.title;
}

- (void)initWithValueLabel
{
    if (!_valueLabel)
    {
        CGRect frame = CGRectMake(0, (kMySettingsViewCellHeight-20)/2, [[UIScreen mainScreen] screenWidth] - _titleLabel.right - 10 - 15 - 15, 20);
        _valueLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentRight];
        _valueLabel.right = [[UIScreen mainScreen] screenWidth] - 15 - 15;
//        _valueLabel.backgroundColor = [UIColor lightGrayColor];
    }
    _valueLabel.text = _commonEntity.subTitle;
}

- (void)initWithThumalImgView
{
    if (!_thumalImgView)
    {
        
    }
}

- (void)updateCellData:(id)cellEntity cellType:(NSInteger)cellType
{
    self.cellType  = cellType;
    self.commonEntity = cellEntity;
    
    [self initWithTitleLabel];
    
    [self initWithValueLabel];
    
    [self initWithThumalImgView];
}

@end
