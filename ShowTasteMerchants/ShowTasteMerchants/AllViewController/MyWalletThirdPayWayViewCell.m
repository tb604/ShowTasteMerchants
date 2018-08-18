//
//  MyWalletThirdPayWayViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyWalletThirdPayWayViewCell.h"
#import "LocalCommon.h"
#import "CellCommonDataEntity.h"

@interface MyWalletThirdPayWayViewCell ()
{
    UIView *_bgView;
    
    UIImageView *_thumalImgView;
    
    UILabel *_titleLabel;
    
    UILabel *_subTitleLabel;
    
}

- (void)initWithBgView;

- (void)initWithThumalImgView;

- (void)initWithTitleLabel;

- (void)initWithSubTitleLabel;


@end

@implementation MyWalletThirdPayWayViewCell

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    self.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    
    [self initWithBgView];
    
    [self initWithThumalImgView];
    
    [self initWithTitleLabel];
    
    [self initWithSubTitleLabel];
    
}

- (void)initWithBgView
{
    if (!_bgView)
    {
        CGRect frame = CGRectMake(15, 15, [[UIScreen mainScreen] screenWidth] - 30, kMyWalletThirdPayWayViewCellHeight - 15);
        _bgView = [[UIView alloc] initWithFrame:frame];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 4;
        _bgView.layer.masksToBounds = YES;
        [self.contentView addSubview:_bgView];
    }
}

- (void)initWithThumalImgView
{
    if (!_thumalImgView)
    {
        UIImage *image = [UIImage imageNamed:@"hall-order_pay_icon_zhifubao"];
        CGRect frame = CGRectMake(15, 15, image.size.width, image.size.height);
        _thumalImgView = [[UIImageView alloc] initWithFrame:frame];
        [_bgView addSubview:_thumalImgView];
    }
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        CGRect frame = CGRectMake(_thumalImgView.right + 10, 0, [[UIScreen mainScreen] screenWidth] / 2, 16);
        _titleLabel = [TYZCreateCommonObject createWithLabel:_bgView labelFrame:frame textColor:[UIColor colorWithHexString:@"323232"] fontSize:FONTSIZE(17) labelTag:0 alignment:NSTextAlignmentLeft];
        _titleLabel.centerY = _thumalImgView.centerY;
    }
}

- (void)initWithSubTitleLabel
{
    if (!_subTitleLabel)
    {
        CGRect frame = CGRectMake(15, _thumalImgView.bottom + 12, [[UIScreen mainScreen] screenWidth] - 30, 16);
        _subTitleLabel = [TYZCreateCommonObject createWithLabel:_bgView labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE(15) labelTag:0 alignment:NSTextAlignmentLeft];
    }
}


- (void)updateCellData:(id)cellEntity
{
    CellCommonDataEntity *commentEnt = cellEntity;
    _thumalImgView.image = [UIImage imageNamed:commentEnt.thumalImgName];
    _titleLabel.text = commentEnt.title;
    _subTitleLabel.text = commentEnt.subTitle;
}

@end






















